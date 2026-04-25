import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/reviews/review_model.dart';
import 'package:hotel_app/features/reviews/reviews_repository.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateChangesProvider).value;
    final bookingsAsync = ref.watch(bookingsStreamProvider);
    final roomsAsync = ref.watch(roomsStreamProvider);
    final reviewsAsync = ref.watch(allReviewsStreamProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy');

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

          final myBookings = bookings
              .where((b) => b.userId == currentUser.uid)
              .toList()
            ..sort((a, b) => b.checkIn.compareTo(a.checkIn));

          if (myBookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.luggage_outlined, size: 80, color: theme.colorScheme.outline.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'У вас пока нет бронирований',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            );
          }

          return roomsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => const Center(child: Text('Ошибка загрузки комнат')),
            data: (rooms) {
              return reviewsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => const Center(child: Text('Ошибка загрузки отзывов')),
                data: (reviews) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: myBookings.length,
                    itemBuilder: (context, index) {
                      final booking = myBookings[index];
                      final room = rooms.firstWhere(
                            (r) => r.id == booking.roomId,
                        orElse: () => Room(id: '', name: 'Удален', typeId: '', price: 0, status: RoomStatus.available, services: []),
                      );

                      final hasReview = reviews.any((r) => r.bookingId == booking.id);

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
                                    'Номер: ${room.name}',
                                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  _buildStatusChip(booking.status),
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
                              const SizedBox(height: 16),

                              // 🚀 НОВАЯ ЛОГИКА КНОПОК

                              // Если гость сейчас проживает - показываем кнопку услуг
                              if (booking.status == BookingStatus.checkedIn)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FilledButton.tonalIcon(
                                      onPressed: () => context.push('/home/services'),
                                      icon: const Icon(Icons.room_service),
                                      label: const Text('Заказать услуги в номер'),
                                    ),
                                  ),
                                ),

                              // Если выехал (completed или checkedOut) - просим отзыв
                              if (booking.status == BookingStatus.completed || booking.status == BookingStatus.checkedOut)
                                SizedBox(
                                  width: double.infinity,
                                  child: hasReview
                                      ? OutlinedButton.icon(
                                    onPressed: null,
                                    icon: const Icon(Icons.check),
                                    label: const Text('Отзыв оставлен'),
                                  )
                                      : FilledButton.icon(
                                    onPressed: () => _showReviewSheet(context, ref, booking),
                                    icon: const Icon(Icons.star_outline),
                                    label: const Text('Оставить отзыв'),
                                  ),
                                ),

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
          );
        },
      ),
    );
  }

  void _showReviewSheet(BuildContext context, WidgetRef ref, Booking booking) {
    double rating = 5;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Оцените ваше проживание', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 40,
                    ),
                    onPressed: () => setModalState(() => rating = index + 1.0),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Расскажите о ваших впечатлениях...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: () async {
                    final review = Review(
                      id: '',
                      bookingId: booking.id,
                      roomId: booking.roomId,
                      userId: booking.userId,
                      userName: booking.guestName,
                      rating: rating,
                      comment: commentController.text.trim(),
                      createdAt: DateTime.now(),
                    );
                    await ref.read(reviewsRepositoryProvider).addReview(review);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Отправить'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 ИСПРАВЛЕННЫЙ ПЕРЕКЛЮЧАТЕЛЬ СТАТУСОВ
  Widget _buildStatusChip(BookingStatus status) {
    Color color;
    String label;
    switch (status) {
      case BookingStatus.pending:
        color = Colors.orange;
        label = 'Ожидает';
        break;
      case BookingStatus.confirmed:
        color = Colors.blue;
        label = 'Подтверждено';
        break;
      case BookingStatus.checkedIn: // Добавили новый статус
        color = Colors.green;
        label = 'Проживает';
        break;
      case BookingStatus.checkedOut: // Добавили новый статус
      case BookingStatus.completed: // Объединили с completed для обратной совместимости
        color = Colors.grey;
        label = 'Выехал';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        label = 'Отменено';
        break;
    // На всякий случай добавим default, чтобы избежать подобных ошибок в будущем
      default:
        color = Colors.grey;
        label = 'Неизвестно';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}