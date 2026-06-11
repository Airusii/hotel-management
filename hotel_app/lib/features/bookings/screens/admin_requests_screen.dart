import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Күтүп жаткан (pending) броньдорду алып келүүчү провайдер
final pendingBookingsProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .where('status', isEqualTo: 'pending') // Жаңы/күтүлүп жаткан заявкалар
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
    return {
      'id': doc.id,
      ...doc.data(),
    };
  }).toList());
});

class AdminRequestsScreen extends ConsumerWidget {
  const AdminRequestsScreen({super.key});

  // Статусту өзгөртүү функциясы (Ырастоо же Жокко чыгаруу үчүн)
  Future<void> _updateBookingStatus(BuildContext context, String bookingId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': newStatus});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newStatus == 'confirmed' ? 'Бронь ырасталды' : 'Бронь жокко чыгарылды'),
            backgroundColor: newStatus == 'confirmed' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ката кетти: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingBookingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Жаңы табыштамалар'),
      ),
      body: pendingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Ката кетти: $error',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                'Азырынча жаңы табыштамалар жок',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              final bookingId = booking['id'];
              final guestName = booking['guestName'] ?? 'Аты жок';
              final roomId = booking['roomId'] ?? '-';
              final price = booking['totalPrice']?.toString() ?? '0';

              String dateRange = 'Күнү белгисиз';
              if (booking['checkIn'] != null && booking['checkOut'] != null) {
                final checkIn = (booking['checkIn'] as Timestamp).toDate();
                final checkOut = (booking['checkOut'] as Timestamp).toDate();

                final formatIn = '${checkIn.day.toString().padLeft(2, '0')}.${checkIn.month.toString().padLeft(2, '0')}.${checkIn.year}';
                final formatOut = '${checkOut.day.toString().padLeft(2, '0')}.${checkOut.month.toString().padLeft(2, '0')}.${checkOut.year}';
                dateRange = '$formatIn - $formatOut';
              }

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.orange.withOpacity(0.1),
                            child: const Icon(Icons.pending_actions, color: Colors.orange),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Конок: $guestName',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Бөлмө: №$roomId',
                                  style: TextStyle(color: theme.colorScheme.secondary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Мөөнөтү: $dateRange',
                                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Жалпы сумма:',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                '$price \$',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      // Баскычтар блогу (Кнопки)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _updateBookingStatus(context, bookingId, 'cancelled'),
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text('Жокко чыгаруу', style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: () => _updateBookingStatus(context, bookingId, 'confirmed'),
                            icon: const Icon(Icons.check),
                            label: const Text('Ырастоо'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
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
      ),
    );
  }
}