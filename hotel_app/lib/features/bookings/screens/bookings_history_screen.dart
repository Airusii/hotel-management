import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Аяктаган (completed) броньдорду алып келүүчү провайдер
final completedBookingsProvider = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .where('status', isEqualTo: 'completed') // Сорттоо шарты
  // .orderBy('checkIn', descending: true) // Эгер датасы боюнча сорттоо керек болсо ушул саптын комментарийин ал
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
    return {
      'id': doc.id,
      ...doc.data(),
    };
  }).toList());
});

class BookingsHistoryScreen extends ConsumerWidget {
  const BookingsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(completedBookingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Брондоолордун тарыхы'),
      ),
      body: bookingsAsync.when(
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
                'Аяктаган брондоолор жок',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];

              // Firestore-дон келген маалыматтарды алуу
              final guestName = booking['guestName'] ?? 'Аты жок';
              final roomId = booking['roomId'] ?? '-';
              final price = booking['totalPrice']?.toString() ?? '0';

              // Даталарды кыргызча форматтоо
              String dateRange = 'Күнү белгисиз';
              if (booking['checkIn'] != null && booking['checkOut'] != null) {
                final checkIn = (booking['checkIn'] as Timestamp).toDate();
                final checkOut = (booking['checkOut'] as Timestamp).toDate();

                // Датаны "Күн.Ай.Жыл" форматында чыгаруу
                final formatIn = '${checkIn.day.toString().padLeft(2, '0')}.${checkIn.month.toString().padLeft(2, '0')}.${checkIn.year}';
                final formatOut = '${checkOut.day.toString().padLeft(2, '0')}.${checkOut.month.toString().padLeft(2, '0')}.${checkOut.year}';
                dateRange = '$formatIn - $formatOut';
              }

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green.withOpacity(0.1),
                        child: const Icon(Icons.check_circle_outline, color: Colors.green),
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
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                              fontSize: 16,
                              color: theme.colorScheme.primary,
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