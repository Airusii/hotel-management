import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/bookings/booking_service.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:intl/intl.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class AdminRequestsScreen extends ConsumerWidget {
  const AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final pendingBookingsAsync = ref.watch(pendingBookingsProvider);
    final roomsAsync = ref.watch(roomsStreamProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMd(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminRequestsTitle),
        centerTitle: true,
      ),
      body: pendingBookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(l10n.adminRequestsErrorLoading, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  l10n.adminRequestsIndexHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(l10n.adminRequestsDetails(err.toString()),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ),
        data: (pendingRequests) {
          if (pendingRequests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 80, color: theme.colorScheme.outline.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    l10n.adminRequestsEmpty,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            );
          }

          return roomsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text(l10n.adminRequestsError(err.toString()))),
            data: (rooms) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendingRequests.length,
                itemBuilder: (context, index) {
                  final booking = pendingRequests[index];
                  final room = rooms.firstWhere(
                    (r) => r.id == booking.roomId,
                    orElse: () => rooms.isNotEmpty ? rooms.first : throw StateError('No rooms'),
                  );

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Заголовок: имя гостя + цена
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  booking.guestName,
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '\$${booking.totalPrice.toStringAsFixed(0)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Статус
                          const SizedBox(height: 8),
                          _StatusChip(status: booking.status),
                          const SizedBox(height: 12),
                          // Даты
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: theme.colorScheme.outline),
                              const SizedBox(width: 8),
                              Text(
                                '${dateFormat.format(booking.checkIn)} — ${dateFormat.format(booking.checkOut)}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Номер
                          Row(
                            children: [
                              Icon(Icons.door_front_door_outlined,
                                  size: 16, color: theme.colorScheme.outline),
                              const SizedBox(width: 8),
                              Text(l10n.adminRequestsRoomLabel(room.name, room.typeId)),
                            ],
                          ),
                          // Email если есть
                          if (booking.guestEmail != null &&
                              booking.guestEmail!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.email_outlined,
                                    size: 16, color: theme.colorScheme.outline),
                                const SizedBox(width: 8),
                                Text(booking.guestEmail!,
                                    style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),
                          // Кнопки действий
                          Row(
                            children: [
                              // ОТКЛОНИТЬ
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      _handleCancel(context, booking.id, l10n),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  icon: const Icon(Icons.close, size: 18),
                                  label: Text(l10n.adminRequestsRejectButton),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // ПОДТВЕРДИТЬ
                              Expanded(
                                flex: 2,
                                child: FilledButton.icon(
                                  onPressed: () =>
                                      _handleConfirm(context, booking.id, l10n),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: Text(l10n.adminRequestsConfirm),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleConfirm(BuildContext context, String bookingId, AppLocalizations l10n) async {
    try {
      await BookingService().confirmBooking(bookingId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${l10n.adminCalendarBookingConfirmed}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.adminRequestsError(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleCancel(BuildContext context, String bookingId, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminRequestsRejectTitle),
        content: Text(l10n.adminRequestsRejectBody),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.adminRequestsBack)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.adminRequestsRejectButton),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await BookingService().cancelBooking(bookingId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.adminRequestsRejected),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.adminRequestsError(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.5)),
      ),
      child: Text(
        status.getLocalizedLabel(l10n),
        style: TextStyle(color: status.color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
