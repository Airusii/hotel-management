import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Фейковые данные уведомлений
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Бронирование подтверждено',
        'body': 'Ваша бронь номера №302 успешно подтверждена. Ждем вас!',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'icon': Icons.check_circle_outline,
      },
      {
        'title': 'Уборка завершена',
        'body': 'Ваш номер был полностью убран и продезинфицирован.',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
        'icon': Icons.cleaning_services_outlined,
      },
      {
        'title': 'Добро пожаловать!',
        'body': 'Спасибо, что выбрали Manas Hotel. Приятного отдыха!',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'isRead': true,
        'icon': Icons.hotel_outlined,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Уведомления',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Закрыть'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (notifications.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 64, color: theme.colorScheme.outline),
                    const SizedBox(height: 16),
                    const Text('У вас нет новых уведомлений'),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final note = notifications[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: note['isRead'] 
                          ? Colors.transparent 
                          : theme.colorScheme.primaryContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: note['isRead'] 
                            ? theme.colorScheme.surfaceVariant 
                            : theme.colorScheme.primaryContainer,
                        child: Icon(
                          note['icon'],
                          color: note['isRead'] 
                              ? theme.colorScheme.onSurfaceVariant 
                              : theme.colorScheme.onPrimaryContainer,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        note['title'],
                        style: TextStyle(
                          fontWeight: note['isRead'] ? FontWeight.normal : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(note['body']),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd MMM, HH:mm').format(note['time']),
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
