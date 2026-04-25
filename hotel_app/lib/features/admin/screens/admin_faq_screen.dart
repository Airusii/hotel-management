import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/faq/faq_model.dart';
import 'package:hotel_app/features/faq/faq_repository.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AdminFaqScreen extends ConsumerWidget {
  const AdminFaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqAsync = ref.watch(adminFaqProvider);
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Управление FAQ'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Все вопросы'),
              Tab(text: 'Без ответа'),
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
          error: (err, _) => Center(child: Text('Ошибка: $err')),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFaqDialog(context, ref),
          child: const Icon(Icons.add_comment),
        ),
      ),
    );
  }

  void _showAddFaqDialog(BuildContext context, WidgetRef ref) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    bool isPublic = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Создать FAQ'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: questionController,
                  decoration: const InputDecoration(labelText: 'Вопрос'),
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
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
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
              child: const Text('Создать'),
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
    if (faqs.isEmpty) return const Center(child: Text('Список пуст'));

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
              'От: ${faq.userName ?? "Админ"} • ${DateFormat('dd.MM.yyyy').format(faq.createdAt)}',
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
              Text('Вопрос: ${faq.question}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: answerController,
                decoration: const InputDecoration(hintText: 'Ваш ответ...', border: OutlineInputBorder()),
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
                  child: const Text('Сохранить ответ'),
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

