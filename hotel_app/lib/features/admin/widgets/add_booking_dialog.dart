import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';

class AddBookingDialog extends ConsumerStatefulWidget {
  const AddBookingDialog({super.key});

  @override
  ConsumerState<AddBookingDialog> createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends ConsumerState<AddBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _guestIdController = TextEditingController();

  String? _selectedRoomId;
  DateTimeRange? _selectedDates;
  bool _isLoading = false;
  double _calculatedPrice = 0.0;

  @override
  void dispose() {
    _guestIdController.dispose();
    super.dispose();
  }

  void _calculateTotal(List<Room> rooms) {
    if (_selectedDates == null || _selectedRoomId == null) {
      setState(() => _calculatedPrice = 0.0);
      return;
    }

    final durationNights = _selectedDates!.end.difference(_selectedDates!.start).inDays;
    final selectedRoom = rooms.firstWhere((r) => r.id == _selectedRoomId);
    
    final total = durationNights * selectedRoom.price;

    setState(() => _calculatedPrice = total);
  }

  // Красивый системный выбор дат (От и До)
  Future<void> _pickDates(List<Room> rooms) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 30)),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _selectedDates,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDates = picked);
      _calculateTotal(rooms);
    }
  }

  // Отправка в Firestore
  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate() && _selectedRoomId != null && _selectedDates != null) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance.collection('bookings').add({
          'roomId': _selectedRoomId,
          'userId': _guestIdController.text.trim(),
          'checkIn': Timestamp.fromDate(_selectedDates!.start),
          'checkOut': Timestamp.fromDate(_selectedDates!.end),
          'status': 'confirmed',
          'totalPrice': _calculatedPrice,
        });

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля и выберите даты')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomsAsync = ref.watch(roomsStreamProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Новое бронирование'),
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
                      ? 'Выберите даты заезда и выезда'
                      : '${_selectedDates!.start.day}.${_selectedDates!.start.month} - ${_selectedDates!.end.day}.${_selectedDates!.end.month}'),
                ),
                loading: () => const OutlinedButton(onPressed: null, child: Text('Загрузка...')),
                error: (_, __) => const OutlinedButton(onPressed: null, child: Text('Ошибка')),
              ),
              const SizedBox(height: 16),
              roomsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Ошибка загрузки комнат'),
                data: (rooms) => DropdownButtonFormField<String>(
                  value: _selectedRoomId,
                  decoration: const InputDecoration(
                    labelText: 'Номер',
                    border: OutlineInputBorder(),
                  ),
                  items: rooms.map((room) => DropdownMenuItem(
                    value: room.id,
                    child: Text('№ ${room.name} (${room.typeId})'),
                  )).toList(),
                  onChanged: (val) {
                    setState(() => _selectedRoomId = val);
                    _calculateTotal(rooms);
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _guestIdController,
                decoration: const InputDecoration(
                  labelText: 'ID Гостя (или Имя)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) => val!.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 24),
              
              // Отображение итоговой стоимости
              if (_selectedDates != null && _selectedRoomId != null)
                roomsAsync.when(
                  data: (rooms) {
                    final room = rooms.firstWhere((r) => r.id == _selectedRoomId);
                    final nights = _selectedDates!.end.difference(_selectedDates!.start).inDays;
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.payments_outlined, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Итого: \$${_calculatedPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                '($nights ночей по \$${room.price.toStringAsFixed(2)})',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submitBooking,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Забронировать'),
        ),
      ],
    );
  }
}
