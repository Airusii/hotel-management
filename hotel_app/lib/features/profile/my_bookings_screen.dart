import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:intl/intl.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final currentUser = ref.watch(authStateChangesProvider).value;
    final roomsAsync = ref.watch(roomsStreamProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMd(locale);

    if (currentUser == null) {
      return Scaffold(
        body: Center(child: Text(l10n.navLogin)),
      );
    }

    final bookingsAsync = ref.watch(userBookingsProvider(currentUser.uid));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myBookingsTitle),
        centerTitle: true,
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.errorGeneric(err.toString()))),
        data: (bookings) {
          final myBookings = bookings
              .where((b) => b.userId == currentUser.uid)
              .toList()
            ..sort((a, b) => b.checkIn.compareTo(a.checkIn));

          if (myBookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.luggage_outlined,
                    size: 80,
                    color: theme.colorScheme.outline.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.myBookingsEmpty,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return roomsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text(l10n.errorGeneric('Rooms'))),
            data: (rooms) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: myBookings.length,
                itemBuilder: (context, index) {
                  final booking = myBookings[index];

                  final room = rooms.firstWhere(
                        (r) => r.id == booking.roomId,
                    orElse: () => Room(
                      id: '',
                      name: '?',
                      typeId: '',
                      price: 0,
                      status: RoomStatus.available,
                      services: [],
                    ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${l10n.homeRoomType}: ${room.name}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildStatusChip(context, booking.status),
                            ],
                          ),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                '${dateFormat.format(booking.checkIn)} — ${dateFormat.format(booking.checkOut)}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          Text(
                            '${l10n.myBookingsGuestName}: ${booking.guestName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),

                          if (booking.status == BookingStatus.checkedIn) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _confirmCheckOut(context, ref, booking, room.name, l10n),
                                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                                label: Text(l10n.myBookingsExpressCheckout, style: const TextStyle(color: Colors.red)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '\$${booking.totalPrice.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
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

  void _confirmCheckOut(BuildContext context, WidgetRef ref, Booking booking, String roomName, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.myBookingsCheckoutDialogTitle),
        content: Text('${l10n.myBookingsCheckoutDialogBody}? ($roomName)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.errorGeneric('Cancel')),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(bookingsRepositoryProvider).checkOutGuest(
                bookingId: booking.id,
                roomId: booking.roomId,
                roomName: roomName,
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.bookingActionConfirmed),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, BookingStatus status) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.5)),
      ),
      child: Text(
        status.getLocalizedLabel(l10n),
        style: TextStyle(
          color: status.color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
