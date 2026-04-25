import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/services/service_model.dart';
import 'package:hotel_app/features/services/services_repository.dart';

class AddServiceDialog extends ConsumerStatefulWidget {
  const AddServiceDialog({super.key});

  @override
  ConsumerState<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends ConsumerState<AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _type = 'Food';
  double _price = 0;
  String _selectedIcon = 'restaurant';

  final Map<String, IconData> _icons = {
    'restaurant': Icons.restaurant,
    'pool': Icons.pool,
    'spa': Icons.spa,
    'wifi': Icons.wifi,
    'local_laundry_service': Icons.local_laundry_service,
    'local_parking': Icons.local_parking,
    'room_service': Icons.room_service,
    'fitness_center': Icons.fitness_center,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Hotel Service'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Service Name'),
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
                onSaved: (val) => _name = val ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIcon,
                decoration: const InputDecoration(labelText: 'Icon'),
                items: _icons.entries.map((e) {
                  return DropdownMenuItem(
                    value: e.key,
                    child: Row(
                      children: [
                        Icon(e.value),
                        const SizedBox(width: 8),
                        Text(e.key),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedIcon = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Type (e.g. Wellness, Food)'),
                onSaved: (val) => _type = val ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Base Price'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _price = double.tryParse(val ?? '0') ?? 0,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await ref.read(servicesRepositoryProvider).addService(HotelService(
                    id: '',
                    name: _name,
                    icon: _selectedIcon,
                    type: _type,
                    basePrice: _price,
                  ));
              if (mounted) Navigator.pop(context);
            }
          },
          child: const Text('Add Service'),
        ),
      ],
    );
  }
}
