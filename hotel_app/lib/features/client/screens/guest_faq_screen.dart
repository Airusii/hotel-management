import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/faq/faq_repository.dart';

class GuestFaqScreen extends ConsumerWidget {
  const GuestFaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqAsync = ref.watch(publicFaqProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Частые вопросы'),
        centerTitle: true,
      ),
      body: faqAsync.when(
        data: (faqs) {
          if (faqs.isEmpty) {
            return const Center(child: Text('Здесь пока нет ответов на вопросы.'));
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
                      child: Text(faq.answer ?? "Ответ скоро появится..."),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка загрузки: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAskDialog(context, ref),
        icon: const Icon(Icons.help_outline),
        label: const Text('Задать вопрос'),
      ),
    );
  }

  void _showAskDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    final user = ref.read(authStateChangesProvider).value;

    // 🚀 ПРАВКА 1: Захватываем мессенджер основного экрана заранее
    final messenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      // 🚀 ПРАВКА 2: Переименовали контекст диалога в dialogContext
      builder: (dialogContext) => AlertDialog(
        title: const Text('Задать вопрос'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Введите ваш вопрос...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Отмена')),
          FilledButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await ref.read(faqRepositoryProvider).askQuestion(
                  question: controller.text.trim(),
                  userId: user?.uid,
                  userName: user?.displayName ?? "Гость",
                );

                // Закрываем диалог
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }

                // Показываем уведомление через сохраненный мессенджер
                messenger.showSnackBar(
                  const SnackBar(content: Text('Вопрос отправлен! Мы ответим в ближайшее время.')),
                );
              }
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }
}
