import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/faq/faq_model.dart';
import 'package:hotel_app/features/faq/faq_repository.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class AdminFaqScreen extends ConsumerWidget {
  const AdminFaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final faqAsync = ref.watch(adminFaqProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.adminFaqTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.adminFaqAllQuestions),
              Tab(text: l10n.adminFaqUnanswered),
            ],
          ),
        ),
        body: faqAsync.when(
          data: (faqs) => TabBarView(
            children: [
              _FaqList(faqs: faqs),
              _FaqList(faqs: faqs.where((f) => f.answer == null).toList()),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text(l10n.adminFaqErrorLoading(err.toString()))),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFaqDialog(context, ref),
          child: const Icon(Icons.add_comment),
        ),
      ),
    );
  }

  void _showAddFaqDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    bool isPublic = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.adminFaqCreateTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: InputDecoration(labelText: l10n.faqTitle),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: answerController,
                  decoration: const InputDecoration(labelText: 'Ответ'),
                  maxLines: 3,
                ),
                CheckboxListTile(
                  title: const Text('Сделать публичным'),
                  value: isPublic,
                  onChanged: (val) => setState(() => isPublic = val ?? true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () async {
                if (questionController.text.isNotEmpty) {
                  final faq = FaqModel(
                    id: '',
                    question: questionController.text,
                    answer: answerController.text.isEmpty ? null : answerController.text,
                    isPublic: isPublic,
                    createdAt: DateTime.now(),
                  );
                  await FirebaseFirestore.instance.collection('faq').add(faq.toMap());
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqList extends ConsumerWidget {
  final List<FaqModel> faqs;
  const _FaqList({required this.faqs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    if (faqs.isEmpty) return Center(child: Text(l10n.faqEmpty));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(faq.question, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              '${l10n.faqGuest}: ${faq.userName ?? "Admin"} • ${DateFormat.yMd(locale).format(faq.createdAt)}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: faq.answer == null 
                ? const Icon(Icons.pending_actions, color: Colors.orange)
                : Icon(Icons.check_circle_outline, color: faq.isPublic ? Colors.green : Colors.grey),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (faq.answer != null) ...[
                      const Text('Ответ:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(faq.answer!),
                      const Divider(height: 24),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _showAnswerDialog(context, ref, faq),
                          icon: const Icon(Icons.edit),
                          label: Text(faq.answer == null ? 'Ответить' : 'Редактировать'),
                        ),
                        IconButton(
                          onPressed: () => ref.read(faqRepositoryProvider).deleteFaq(faq.id),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAnswerDialog(BuildContext context, WidgetRef ref, FaqModel faq) {
    final l10n = AppLocalizations.of(context)!;
    final answerController = TextEditingController(text: faq.answer);
    bool isPublic = faq.isPublic;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${l10n.faqTitle}: ${faq.question}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: answerController,
                decoration: InputDecoration(hintText: l10n.faqAskHint, border: const OutlineInputBorder()),
                maxLines: 4,
              ),
              CheckboxListTile(
                title: const Text('Опубликовать в общем списке'),
                value: isPublic,
                onChanged: (val) => setState(() => isPublic = val ?? true),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await ref.read(faqRepositoryProvider).answerQuestion(
                      faq.id, 
                      answerController.text.trim(), 
                      isPublic,
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(l10n.save),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
