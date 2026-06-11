import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final theme = Theme.of(context);
    
    // Фейковые данные уведомлений (теперь локализованные)
    final List<Map<String, dynamic>> notifications = [
      {
        'title': l10n.notificationBookingConfirmed,
        'body': l10n.notificationBookingConfirmedBody,
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'icon': Icons.check_circle_outline,
      },
      {
        'title': l10n.notificationCleaningDone,
        'body': l10n.notificationCleaningDoneBody,
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
        'icon': Icons.cleaning_services_outlined,
      },
      {
        'title': l10n.notificationWelcome,
        'body': l10n.notificationWelcomeBody,
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
                  l10n.notificationsTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.notificationsClose),
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
                    Text(l10n.notificationsEmpty),
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
                            DateFormat.MMMd(locale).add_Hm().format(note['time']),
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
