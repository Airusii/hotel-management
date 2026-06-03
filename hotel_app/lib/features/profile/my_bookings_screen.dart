import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateChangesProvider).value;
    final roomsAsync = ref.watch(roomsStreamProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy');

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Пожалуйста, войдите в систему')),
      );
    }

    // Используем специализированный провайдер — только брони текущего пользователя
    final bookingsAsync = ref.watch(userBookingsProvider(currentUser.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои бронирования'),
        centerTitle: true,
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Ошибка загрузки: $err')),
        data: (bookings) {
          if (currentUser == null) {
            return const Center(child: Text('Пожалуйста, войдите в систему'));
          }

          // Шаг 3: Фильтрация для текущего пользователя и сортировка по убыванию даты
          final myBookings = bookings
              .where((b) => b.userId == currentUser.uid)
              .toList()
            ..sort((a, b) => b.checkIn.compareTo(a.checkIn));

          // Состояние, если список пуст
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
                    'У вас пока нет бронирований',
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
            error: (err, _) => const Center(child: Text('Ошибка загрузки данных о номерах')),
            data: (rooms) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: myBookings.length,
                itemBuilder: (context, index) {
                  final booking = myBookings[index];

                  // Поиск комнаты для получения названия
                  final room = rooms.firstWhere(
                        (r) => r.id == booking.roomId,
                    orElse: () => Room(
                      id: '',
                      name: 'Номер удален',
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
                          // Шаг 4: Заголовок и статус
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Номер: ${room.name}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildStatusChip(booking.status),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Даты проживания
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

                          // Имя гостя
                          Text(
                            'На имя: ${booking.guestName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),

                          // 🚀 ДОБАВЛЕН БЛОК КНОПКИ ЭКСПРЕСС-ВЫЕЗДА
                          if (booking.status == BookingStatus.checkedIn) ...[
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: () => _confirmCheckOut(context, ref, booking, room.name),
                                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                                label: const Text('Экспресс-выезд', style: TextStyle(color: Colors.red)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                          // 🚀 КОНЕЦ БЛОКА

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),

                          // Итоговая сумма
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

  // 🚀 ДОБАВЛЕН МЕТОД ПОДТВЕРЖДЕНИЯ ВЫЕЗДА
  void _confirmCheckOut(BuildContext context, WidgetRef ref, Booking booking, String roomName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выезд из номера'),
        content: Text('Вы действительно хотите завершить проживание в номере $roomName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
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
            child: const Text('Подтвердить выезд'),
          ),
        ],
      ),
    );
  }
  // 🚀 КОНЕЦ МЕТОДА

  Widget _buildStatusChip(BookingStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.5)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}