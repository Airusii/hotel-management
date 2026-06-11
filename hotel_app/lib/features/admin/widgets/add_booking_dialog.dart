import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';

class AddBookingDialog extends ConsumerStatefulWidget {
  const AddBookingDialog({super.key});

  @override
  ConsumerState<AddBookingDialog> createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends ConsumerState<AddBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _guestIdController = TextEditingController();
  final _guestNameController = TextEditingController(); // Добавили имя

  String? _selectedRoomId;
  DateTimeRange? _selectedDates;
  bool _isLoading = false;
  double _calculatedPrice = 0.0;

  @override
  void dispose() {
    _guestIdController.dispose();
    _guestNameController.dispose();
    super.dispose();
  }

  void _calculateTotal(List<Room> rooms) {
    if (_selectedDates == null || _selectedRoomId == null) {
      setState(() => _calculatedPrice = 0.0);
      return;
    }
    final durationNights = _selectedDates!.end.difference(_selectedDates!.start).inDays;
    final selectedRoom = rooms.firstWhere((r) => r.id == _selectedRoomId);
    final total = (durationNights == 0 ? 1 : durationNights) * selectedRoom.price;
    setState(() => _calculatedPrice = total);
  }

  Future<void> _pickDates(List<Room> rooms) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _selectedDates,
    );
    if (picked != null) {
      setState(() => _selectedDates = picked);
      _calculateTotal(rooms);
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate() && _selectedRoomId != null && _selectedDates != null) {
      setState(() => _isLoading = true);

      try {
        // Брони созданные вручную администратором сразу переходят в confirmed.
        // Брони от клиентов (через приложение) создаются со статусом pending.
        final newBooking = Booking(
          id: '',
          roomId: _selectedRoomId!,
          userId: _guestIdController.text.trim(),
          guestName: _guestNameController.text.trim().isEmpty ? 'Без имени' : _guestNameController.text.trim(),
          checkIn: _selectedDates!.start,
          checkOut: _selectedDates!.end,
          status: BookingStatus.confirmed, // 🚀 Админ сразу подтверждает!
          totalPrice: _calculatedPrice,
        );

        // Отправляем через репозиторий
        await ref.read(bookingsRepositoryProvider).addBooking(newBooking);

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заполните все поля')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(roomsStreamProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Жаны брондоо (Админ)'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              roomsAsync.when(
                data: (rooms) => OutlinedButton.icon(
                  onPressed: () => _pickDates(rooms),
                  icon: const Icon(Icons.date_range),
                  label: Text(_selectedDates == null
                      ? 'Кируу жана чыгуу датасын танданыз'
                      : '${_selectedDates!.start.day}.${_selectedDates!.start.month} - ${_selectedDates!.end.day}.${_selectedDates!.end.month}'),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Ошибка'),
              ),
              const SizedBox(height: 16),
              roomsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (rooms) => DropdownButtonFormField<String>(
                  value: _selectedRoomId,
                  decoration: const InputDecoration(labelText: 'Номер', border: OutlineInputBorder()),
                  items: rooms.map((r) => DropdownMenuItem(value: r.id, child: Text('№ ${r.name}'))).toList(),
                  onChanged: (val) {
                    setState(() => _selectedRoomId = val);
                    _calculateTotal(rooms);
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _guestIdController,
                decoration: const InputDecoration(labelText: 'UID Гостя', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _guestNameController,
                decoration: const InputDecoration(labelText: 'Имя гостя', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              if (_selectedDates != null && _selectedRoomId != null)
                Text('Итого: \$${_calculatedPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isLoading ? null : () => Navigator.pop(context), child: const Text('Отмена')),
        FilledButton(
          onPressed: _isLoading ? null : _submitBooking,
          child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white)) : const Text('Сохранить'),
        ),
      ],
    );
  }
}