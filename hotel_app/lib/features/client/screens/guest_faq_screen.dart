import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/faq/faq_repository.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class GuestFaqScreen extends ConsumerWidget {
  const GuestFaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final faqAsync = ref.watch(publicFaqProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.faqTitle),
        centerTitle: true,
      ),
      body: faqAsync.when(
        data: (faqs) {
          if (faqs.isEmpty) {
            return Center(child: Text(l10n.faqEmpty));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              final faq = faqs[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ExpansionTile(
                  title: Text(faq.question, style: const TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(faq.answer ?? l10n.faqAnswerSoon),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.faqErrorLoading(err.toString()))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAskDialog(context, ref),
        icon: const Icon(Icons.help_outline),
        label: Text(l10n.faqAskQuestion),
      ),
    );
  }

  void _showAskDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final user = ref.read(authStateChangesProvider).value;
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.faqAskDialogTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.faqAskHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.faqCancel)),
          FilledButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref.read(faqRepositoryProvider).askQuestion(
                  question: controller.text.trim(),
                  userId: user?.uid,
                  userName: user?.displayName ?? l10n.faqGuest,
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.faqSent)),
                );
              }
            },
            child: Text(l10n.faqSend),
          ),
        ],
      ),
    );
  }
}
