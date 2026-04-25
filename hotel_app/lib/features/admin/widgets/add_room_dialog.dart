import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/services/services_provider.dart';

class AddRoomDialog extends ConsumerStatefulWidget {
  const AddRoomDialog({super.key});

  @override
  ConsumerState<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends ConsumerState<AddRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  
  String? _selectedTypeId;
  final List<String> _selectedServiceIds = [];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedTypeId != null) {
      final room = Room(
        id: '',
        name: _nameController.text.trim(),
        typeId: _selectedTypeId!,
        price: double.parse(_priceController.text),
        status: RoomStatus.available,
        services: _selectedServiceIds,
      );

      await ref.read(roomsRepositoryProvider).addRoom(room);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomTypesAsync = ref.watch(roomTypesStreamProvider);
    final servicesAsync = ref.watch(servicesStreamProvider);

    return AlertDialog(
      title: const Text('Добавить номер'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Название/Номер'),
                validator: (val) => val!.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              roomTypesAsync.when(
                data: (types) => DropdownButtonFormField<String>(
                  value: _selectedTypeId,
                  hint: const Text('Выберите тип номера'),
                  items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => setState(() => _selectedTypeId = val),
                  validator: (val) => val == null ? 'Выберите тип' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Ошибка загрузки типов'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Цена за ночь'),
                keyboardType: TextInputType.number,
                validator: (val) => (double.tryParse(val ?? '') ?? 0) <= 0 ? 'Введите цену' : null,
              ),
              const SizedBox(height: 24),
              const Text('Доступные услуги:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              servicesAsync.when(
                data: (services) => Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: services.map((service) {
                    final isSelected = _selectedServiceIds.contains(service.id);
                    return FilterChip(
                      label: Text(service.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedServiceIds.add(service.id);
                          } else {
                            _selectedServiceIds.remove(service.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, __) => Text('Ошибка: $err'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
        ElevatedButton(onPressed: _submit, child: const Text('Создать')),
      ],
    );
  }
}
