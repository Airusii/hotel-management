import 'package:flutter/material.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/booking_service.dart';

class BookingActionDialog extends StatefulWidget {
  final Booking booking;
  const BookingActionDialog({super.key, required this.booking});

  @override
  State<BookingActionDialog> createState() => _BookingActionDialogState();
}

class _BookingActionDialogState extends State<BookingActionDialog> {
  bool _isLoading = false;
  final _bookingService = BookingService();

  @override
  Widget build(BuildContext context) {
    final status = widget.booking.status;

    return AlertDialog(
      title: Text('Действие: ${widget.booking.guestName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == BookingStatus.confirmed)
            const Text('Гость прибыл? Нажмите заселить, чтобы активировать бронь.'),
          if (status == BookingStatus.checkedIn)
            const Text('Гость выезжает? Оформите выезд, чтобы отправить номер на уборку.'),
          if (status != BookingStatus.confirmed && status != BookingStatus.checkedIn)
            const Text('Для данной брони нет доступных быстрых действий.'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        if (status == BookingStatus.confirmed)
          FilledButton(
            onPressed: _isLoading ? null : () async {
              setState(() => _isLoading = true);
              await _bookingService.checkInGuest(widget.booking.id);
              if (mounted) Navigator.pop(context);
            },
            child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Заселить гостя'),
          ),
        if (status == BookingStatus.checkedIn)
          FilledButton(
            onPressed: _isLoading ? null : () async {
              setState(() => _isLoading = true);
              await _bookingService.checkOutGuest(widget.booking.id, widget.booking.roomId);
              if (mounted) Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Оформить выезд'),
          ),
      ],
    );
  }
}
