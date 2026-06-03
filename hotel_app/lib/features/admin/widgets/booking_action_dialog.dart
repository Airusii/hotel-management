import 'package:flutter/material.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/booking_service.dart';

/// Диалог для действий над бронью из шахматки / списка броней.
/// Статусная цепочка: pending → confirmed → checkedIn → checkedOut
class BookingActionDialog extends StatefulWidget {
  final Booking booking;
  const BookingActionDialog({super.key, required this.booking});

  @override
  State<BookingActionDialog> createState() => _BookingActionDialogState();
}

class _BookingActionDialogState extends State<BookingActionDialog> {
  bool _isLoading = false;
  final _bookingService = BookingService();

  String get _statusDescription {
    switch (widget.booking.status) {
      case BookingStatus.pending:
        return 'Заявка ожидает подтверждения. Подтвердите или отклоните.';
      case BookingStatus.confirmed:
        return 'Бронь подтверждена. Гость прибыл? Нажмите «Заселить».';
      case BookingStatus.checkedIn:
        return 'Гость проживает. Оформите выезд, чтобы отправить номер на уборку.';
      case BookingStatus.checkedOut:
      case BookingStatus.completed:
        return 'Гость выехал. Действия недоступны.';
      case BookingStatus.cancelled:
        return 'Бронь отменена.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.booking.status;
    final canAct = status == BookingStatus.pending ||
        status == BookingStatus.confirmed ||
        status == BookingStatus.checkedIn;

    return AlertDialog(
      title: Text(widget.booking.guestName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusChip(status: status),
          const SizedBox(height: 12),
          Text(_statusDescription),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрыть'),
        ),
        if (!canAct) const SizedBox.shrink(),

        // pending → cancelled
        if (status == BookingStatus.pending)
          TextButton(
            onPressed: _isLoading ? null : () => _act(() async {
              await _bookingService.cancelBooking(widget.booking.id);
            }),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Отклонить'),
          ),

        // pending → confirmed
        if (status == BookingStatus.pending)
          FilledButton(
            onPressed: _isLoading ? null : () => _act(() async {
              await _bookingService.confirmBooking(widget.booking.id);
            }),
            child: _isLoading ? _loader() : const Text('Подтвердить'),
          ),

        // confirmed → checkedIn
        if (status == BookingStatus.confirmed)
          FilledButton(
            onPressed: _isLoading ? null : () => _act(() async {
              await _bookingService.checkInGuest(widget.booking.id);
            }),
            child: _isLoading ? _loader() : const Text('Заселить'),
          ),

        // checkedIn → checkedOut
        if (status == BookingStatus.checkedIn)
          FilledButton(
            onPressed: _isLoading ? null : () => _act(() async {
              await _bookingService.checkOutGuest(
                  widget.booking.id, widget.booking.roomId);
            }),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: _isLoading ? _loader() : const Text('Оформить выезд'),
          ),
      ],
    );
  }

  Future<void> _act(Future<void> Function() action) async {
    setState(() => _isLoading = true);
    try {
      await action();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _loader() => const SizedBox(
      width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2));
}

class _StatusChip extends StatelessWidget {
  final BookingStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withOpacity(0.5)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
            color: status.color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
