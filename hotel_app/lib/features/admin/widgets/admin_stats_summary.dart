import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';

class AdminStatsSummary extends ConsumerWidget {
  const AdminStatsSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(roomsStreamProvider);
    final bookingsAsync = ref.watch(bookingsStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              title: 'Доступно',
              value: roomsAsync.when(
                data: (rooms) {
                  final bookings = bookingsAsync.value ?? [];
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  
                  final occupiedRoomIds = bookings
                      .where((b) => b.status != BookingStatus.cancelled)
                      .where((b) => (today.isAtSameMomentAs(b.checkIn) || today.isAfter(b.checkIn)) && today.isBefore(b.checkOut))
                      .map((b) => b.roomId)
                      .toSet();
                  
                  return (rooms.length - occupiedRoomIds.length).toString();
                },
                loading: () => '...',
                error: (_, __) => '0',
              ),
              icon: Icons.meeting_room,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              title: 'Ожидают',
              value: bookingsAsync.when(
                data: (bookings) => bookings.where((b) => b.status == BookingStatus.pending).length.toString(),
                loading: () => '...',
                error: (_, __) => '0',
              ),
              icon: Icons.hourglass_empty,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              title: 'Доход',
              value: bookingsAsync.when(
                data: (bookings) {
                  final total = bookings
                      .where((b) => b.status == BookingStatus.confirmed)
                      .fold(0.0, (sum, b) => sum + b.totalPrice);
                  return '\$${total.toStringAsFixed(0)}';
                },
                loading: () => '...',
                error: (_, __) => '0',
              ),
              icon: Icons.attach_money,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
