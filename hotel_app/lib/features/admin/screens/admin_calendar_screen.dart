import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/tasks/tasks_repository.dart';
import 'package:hotel_app/features/tasks/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/add_booking_dialog.dart';

class AdminCalendarScreen extends ConsumerStatefulWidget {
  const AdminCalendarScreen({super.key});

  @override
  ConsumerState<AdminCalendarScreen> createState() => _AdminCalendarScreenState();
}

class _AdminCalendarScreenState extends ConsumerState<AdminCalendarScreen> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  final double _cellWidth = 70.0;
  final double _cellHeight = 60.0;
  final double _roomNameWidth = 120.0;

  late List<DateTime> _dates;
  late DateTime _startDate;

  Booking? _selectedBooking;
  
  // СОСТОЯНИЕ: Фокус на шахматке или деталях
  bool _isCalendarFocused = true;
  
  // Состояние загрузки для оформления выезда
  bool _isCheckOutLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _startDate = today.subtract(const Duration(days: 3));
    _dates = List.generate(30, (index) => _startDate.add(Duration(days: index)));
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roomsAsync = ref.watch(roomsStreamProvider);
    final bookingsAsync = ref.watch(bookingsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Шахматка (Live)'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddBookingDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Бронь'),
      ),
      body: roomsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Ошибка загрузки номеров: $err')),
        data: (rooms) {
          return bookingsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Ошибка загрузки броней: $err')),
            data: (bookings) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight - 1.0;
                  final topHeight = _isCalendarFocused ? availableHeight * 0.7 : availableHeight * 0.4;
                  final bottomHeight = availableHeight - topHeight;

                  return Column(
                    children: [
                      // ВЕРХНЯЯ ЧАСТЬ: ШАХМАТКА
                      Listener(
                        behavior: HitTestBehavior.translucent,
                        onPointerDown: (_) {
                          if (!_isCalendarFocused) {
                            setState(() => _isCalendarFocused = true);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          height: topHeight,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                            ),
                            child: Scrollbar(
                              controller: _verticalController,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                controller: _verticalController,
                                scrollDirection: Axis.vertical,
                                child: Scrollbar(
                                  controller: _horizontalController,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: _horizontalController,
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildHeaderRow(theme),
                                        ...rooms.map((room) => _buildRoomRow(room, bookings, theme)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      // НИЖНЯЯ ЧАСТЬ: ДЕТАЛИ
                      Listener(
                        behavior: HitTestBehavior.translucent,
                        onPointerDown: (_) {
                          if (_isCalendarFocused && _selectedBooking != null) {
                            setState(() => _isCalendarFocused = false);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOutCubic,
                          height: bottomHeight,
                          child: _buildDetailsPanel(theme, rooms),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeaderRow(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: _roomNameWidth,
          height: _cellHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          alignment: Alignment.center,
          child: const Text('Номера \\ Даты', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
        ..._dates.map((date) {
          final isToday = date.day == DateTime.now().day && date.month == DateTime.now().month;
          return Container(
            width: _cellWidth,
            height: _cellHeight,
            decoration: BoxDecoration(
              color: isToday ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Center(
              child: Text(
                '${date.day}.${date.month}',
                style: TextStyle(fontWeight: FontWeight.bold, color: isToday ? theme.colorScheme.primary : null),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRoomRow(Room room, List<Booking> allBookings, ThemeData theme) {
    // Фильтруем: берем только эту комнату И убираем те, где статус 'completed'
    final roomBookings = allBookings.where((b) =>
    b.roomId == room.id &&
        b.status.name != 'completed' &&
        b.status.name != 'cancelled' // Скрываем отмененные
    ).toList();

    return Row(
      children: [
        Container(
          width: _roomNameWidth,
          height: _cellHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('№ ${room.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(room.typeId, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        SizedBox(
          width: _dates.length * _cellWidth,
          height: _cellHeight,
          child: Stack(
            children: [
              Row(
                children: _dates.map((date) => Container(
                  width: _cellWidth,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                )).toList(),
              ),
              ...roomBookings.map((booking) {
                return _BookingBarWidget(
                  booking: booking,
                  startDate: _startDate,
                  cellWidth: _cellWidth,
                  onTap: () {
                    setState(() {
                      _selectedBooking = booking;
                      _isCalendarFocused = false;
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ─── ПАНЕЛЬ ДЕТАЛЕЙ (ОТРИСОВКА ВНИЗУ) ───────────────────────────
  Widget _buildDetailsPanel(ThemeData theme, List<Room> rooms) {
    if (_selectedBooking == null) {
      return Container(
        color: theme.colorScheme.surfaceContainerLowest,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app_outlined, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'Выберите бронь на шахматке,\nчтобы увидеть подробности',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    final b = _selectedBooking!;
    final isConfirmed = b.status == BookingStatus.confirmed;

    return Container(
      color: theme.colorScheme.surface,
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: isConfirmed ? theme.colorScheme.primaryContainer : theme.colorScheme.tertiaryContainer,
                  child: Icon(
                    isConfirmed ? Icons.check_circle : Icons.hourglass_empty,
                    color: isConfirmed ? theme.colorScheme.primary : theme.colorScheme.tertiary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(isConfirmed ? 'Подтверждено' : 'Ожидает'),
                  backgroundColor: isConfirmed ? theme.colorScheme.primaryContainer : theme.colorScheme.tertiaryContainer,
                  side: BorderSide.none,
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Гость: ${b.guestName}',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    children: [
                      _InfoItem(icon: Icons.login, label: 'Заезд', value: '${b.checkIn.day}.${b.checkIn.month}.${b.checkIn.year}'),
                      _InfoItem(icon: Icons.logout, label: 'Выезд', value: '${b.checkOut.day}.${b.checkOut.month}.${b.checkOut.year}'),
                      _InfoItem(icon: Icons.payments_outlined, label: 'Сумма', value: '\$${b.totalPrice}', isHighlight: true),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // Кнопки для брони "В ожидании"
                      if (b.status == BookingStatus.pending) ...[
                        FilledButton.icon(
                          onPressed: () => _updateBookingStatus(b.id, 'confirmed'),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Подтвердить'),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _updateBookingStatus(b.id, 'cancelled'),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Отменить'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                            side: BorderSide(color: theme.colorScheme.error),
                          ),
                        ),
                      ],

                      // Кнопка для "Подтвержденной" брони
                      if (b.status == BookingStatus.confirmed)
                        FilledButton.icon(
                          onPressed: _isCheckOutLoading ? null : () => _handleCheckOut(b, rooms),
                          icon: _isCheckOutLoading
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.logout, size: 18),
                          label: const Text('Оформить выезд'),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.tertiary,
                            foregroundColor: theme.colorScheme.onTertiary,
                          ),
                        ),

                      // Общие кнопки
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Редактировать'),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          foregroundColor: theme.colorScheme.onSurface,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.receipt_long, size: 18),
                        label: const Text('Счет'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCheckOut(Booking booking, List<Room> rooms) async {
    final room = rooms.firstWhere((r) => r.id == booking.roomId);

    setState(() => _isCheckOutLoading = true);

    try {
      // 1. Обновляем статус брони напрямую в Firestore
      await FirebaseFirestore.instance.collection('bookings').doc(booking.id).update({
        'status': 'completed',
      });

      // 2. Создаем задачу на уборку
      final cleaningTask = Task(
        id: '', // Пустая строка - Firebase сам сгенерирует ID
        title: 'Уборка после выезда: № ${room.name}',
        description: 'Гость выехал. Требуется полная уборка номера, замена белья и проверка мини-бара.',
        roomId: booking.roomId,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      );

      // Отправляем задачу горничным
      await ref.read(tasksRepositoryProvider).addTask(cleaningTask);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Выезд оформлен. Задача на уборку отправлена.'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _selectedBooking = null;
          _isCalendarFocused = true; // Сворачиваем панель деталей
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при оформлении выезда: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckOutLoading = false);
      }
    }
  }
  Future<void> _updateBookingStatus(String bookingId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
        'status': newStatus,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newStatus == 'confirmed' ? 'Бронь подтверждена!' : 'Бронь отменена.'),
            backgroundColor: newStatus == 'confirmed' ? Colors.green : Colors.orange,
          ),
        );
        setState(() {
          _selectedBooking = null;
          _isCalendarFocused = true; // Закрываем панель
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка обновления: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlight;

  const _InfoItem({required this.icon, required this.label, required this.value, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                color: isHighlight ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BookingBarWidget extends ConsumerWidget {
  final Booking booking;
  final DateTime startDate;
  final double cellWidth;
  final VoidCallback onTap;

  const _BookingBarWidget({
    required this.booking,
    required this.startDate,
    required this.cellWidth,
    required this.onTap,
  });

  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isConfirmed = booking.status == BookingStatus.confirmed;

    final int startOffsetDays = _daysBetween(startDate, booking.checkIn);
    final double leftPosition = startOffsetDays < 0 ? 0 : (startOffsetDays + 0.5) * cellWidth;
    final int durationNights = _daysBetween(booking.checkIn, booking.checkOut);
    final double barWidth = startOffsetDays < 0 ? (durationNights + startOffsetDays) * cellWidth : durationNights * cellWidth;

    // Формируем имя с фоллбэком
    final String displayName = booking.guestName.isNotEmpty
        ? booking.guestName
        : 'Гость ${booking.userId.length > 4 ? booking.userId.substring(0, 4) : booking.userId}';

    return Positioned(
      left: leftPosition,
      width: barWidth,
      top: 8,
      bottom: 8,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isConfirmed ? theme.colorScheme.primary : theme.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: theme.colorScheme.surface, width: 1.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.centerLeft,
            child: Text(
              displayName,
              style: TextStyle(
                color: isConfirmed ? theme.colorScheme.onPrimary : theme.colorScheme.onTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
