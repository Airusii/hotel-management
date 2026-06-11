import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/l10n/app_localizations.dart';

class AddBookingDialog extends ConsumerStatefulWidget {
  const AddBookingDialog({super.key});

  @override
  ConsumerState<AddBookingDialog> createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends ConsumerState<AddBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  // final _guestIdController = TextEditingController(); // Commented out as requested
  String _guestName = '';
  String? _selectedRoomId;
  String? _selectedGuestId;
  // Stores UID of the selected user
  DateTimeRange? _selectedDates;
  bool _isLoading = false;
  double _calculatedPrice = 0.0;

  @override
  void dispose() {
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
    final l10n = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate() && _selectedRoomId != null && _selectedDates != null) {
      setState(() => _isLoading = true);

      try {
        final newBooking = Booking(
          id: '',
          roomId: _selectedRoomId!,
          // Use selected user ID or generate a temporary one if guest is "walk-in"
          userId: _selectedGuestId ?? 'guest_${DateTime.now().millisecondsSinceEpoch}',
          guestName: _guestName.trim().isEmpty
              ? l10n.adminBookingNoName
              : _guestName.trim(),
          checkIn: _selectedDates!.start,
          checkOut: _selectedDates!.end,
          status: BookingStatus.confirmed, // Admin bookings are confirmed immediately
          totalPrice: _calculatedPrice,
        );

        await ref.read(bookingsRepositoryProvider).addBooking(newBooking);

        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.adminBookingError(e.toString()))),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.adminBookingFillFields)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roomsAsync = ref.watch(roomsStreamProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.adminBookingDialogTitle),
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
                      ? l10n.adminBookingSelectDates
                      : '${_selectedDates!.start.day}.${_selectedDates!.start.month} - ${_selectedDates!.end.day}.${_selectedDates!.end.month}'),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(l10n.error),
              ),
              const SizedBox(height: 16),
              roomsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (rooms) => DropdownButtonFormField<String>(
                  value: _selectedRoomId,
                  decoration: InputDecoration(
                    labelText: l10n.adminBookingRoom, 
                    border: const OutlineInputBorder()
                  ),
                  items: rooms.map((r) => DropdownMenuItem(value: r.id, child: Text('№ ${r.name}'))).toList(),
                  onChanged: (val) {
                    setState(() => _selectedRoomId = val);
                    _calculateTotal(rooms);
                  },
                  validator: (val) => val == null ? l10n.adminBookingRequired : null,
                ),
              ),
              const SizedBox(height: 16),
              
              // SEARCH GUEST BY NAME
              Autocomplete<Map<String, dynamic>>(
                displayStringForOption: (option) => option['name'],
                optionsBuilder: (textEditingValue) async {
                  final query = textEditingValue.text.trim();

                  // Оптимизация: не ищем, если введено меньше 2 символов
                  if (query.length < 2) {
                    return const [];
                  }

                  try {
                    final snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .where('name', isGreaterThanOrEqualTo: query)
                        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
                        .limit(5)
                        .get();

                    return snapshot.docs.map((doc) => {
                      'id': doc.id,
                      'name': doc.data()['name'] ?? '',
                    }).toList();
                  } catch (e) {
                    // В случае ошибки с сетью не крашим UI, а возвращаем пустой список
                    return const [];
                  }
                },
                onSelected: (selection) {
                  setState(() {
                    _selectedGuestId = selection['id'];
                    _guestName = selection['name'];
                  });
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: l10n.adminBookingGuestName,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_search),
                    ),
                    onChanged: (val) {
                      // Просто обновляем локальную переменную
                      _guestName = val;

                      // Если текст изменился вручную после выбора, сбрасываем ID
                      if (_selectedGuestId != null) {
                        _selectedGuestId = null;
                      }
                    },
                    onFieldSubmitted: (val) => onFieldSubmitted(),
                    validator: (val) => (val == null || val.trim().isEmpty) ? l10n.adminBookingRequired : null,
                  );
                },
              ),

              /* 
              // UID field is now commented out
              const SizedBox(height: 16),
              TextFormField(
                controller: _guestIdController,
                decoration: const InputDecoration(labelText: 'UID Гостя', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Обязательное поле' : null,
              ),
              */

              const SizedBox(height: 24),
              if (_selectedDates != null && _selectedRoomId != null)
                Text(
                  l10n.adminBookingTotal(_calculatedPrice.toStringAsFixed(2)),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, 
                    color: theme.colorScheme.primary
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context), 
          child: Text(l10n.adminBookingCancel)
        ),
        FilledButton(
          onPressed: _isLoading ? null : _submitBooking,
          child: _isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
              : Text(l10n.adminBookingSave),
        ),
      ],
    );
  }
}
