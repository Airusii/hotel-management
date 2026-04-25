import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:intl/intl.dart';

class AdminMainStatsScreen extends ConsumerWidget {
  const AdminMainStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsStreamProvider);
    final theme = Theme.of(context);
    final now = DateTime.now();

    return Scaffold(
      body: SafeArea(
        child: bookingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Ошибка загрузки данных: $err')),
          data: (bookings) {
            // --- ЛОГИКА ВЫЧИСЛЕНИЙ ---
            
            // 1. Новые заявки (pending)
            final pendingCount = bookings.where((b) => b.status == BookingStatus.pending).length;

            // 2. Выручка за текущий месяц (confirmed или completed)
            final monthlyRevenue = bookings.where((b) {
              final isValidStatus = b.status == BookingStatus.confirmed || b.status == BookingStatus.completed;
              final isCurrentMonth = b.checkIn.month == now.month && b.checkIn.year == now.year;
              return isValidStatus && isCurrentMonth;
            }).fold<double>(0, (sum, b) => sum + b.totalPrice);

            // 3. Предстоящие заезды (следующие 7 дней)
            final nextWeek = now.add(const Duration(days: 7));
            final upcomingCheckIns = bookings.where((b) {
              return b.status == BookingStatus.confirmed &&
                  b.checkIn.isAfter(now) &&
                  b.checkIn.isBefore(nextWeek);
            }).length;

            // 4. Всего броней
            final totalBookings = bookings.length;

            // --- ВЕРСТКА ---
            return RefreshIndicator(
              onRefresh: () async => ref.refresh(bookingsStreamProvider),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Обзор отеля',
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // Сетка KPI карточек
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children: [
                        _KpiCard(
                          title: 'Новые заявки',
                          value: pendingCount.toString(),
                          icon: Icons.notifications_active_outlined,
                          iconColor: Colors.orange,
                        ),
                        _KpiCard(
                          title: 'Выручка (мес)',
                          value: '\$${monthlyRevenue.toStringAsFixed(0)}',
                          icon: Icons.payments_outlined,
                          iconColor: Colors.green,
                        ),
                        _KpiCard(
                          title: 'Заезды (нед)',
                          value: upcomingCheckIns.toString(),
                          icon: Icons.calendar_month_outlined,
                          iconColor: Colors.blue,
                        ),
                        _KpiCard(
                          title: 'Всего броней',
                          value: totalBookings.toString(),
                          icon: Icons.folder_open_outlined,
                          iconColor: Colors.grey,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    Text(
                      'Последняя активность',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Простой горизонтальный список последних броней
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: bookings.take(7).length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final b = bookings[index];
                          return Container(
                            width: 200,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.colorScheme.outlineVariant),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  b.guestName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd MMM').format(b.checkIn),
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${b.totalPrice.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
