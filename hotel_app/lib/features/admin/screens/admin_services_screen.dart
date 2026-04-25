import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/widgets/add_service_dialog.dart';
import 'package:hotel_app/features/services/services_provider.dart';
import 'package:hotel_app/features/services/services_repository.dart';

class AdminServicesScreen extends ConsumerWidget {
  const AdminServicesScreen({super.key});

  static const Map<String, IconData> _iconMap = {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const AddServiceDialog(),
            ),
          ),
        ],
      ),
      body: servicesAsync.when(
        data: (services) => ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(
                    _iconMap[service.icon] ?? Icons.help_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: Text(service.name),
                subtitle: Text('${service.type} • \$${service.basePrice}'),
                trailing: IconButton(
                  icon: const Icon(Icons.archive_outlined),
                  onPressed: () => ref.read(servicesRepositoryProvider).archiveService(service.id),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddServiceDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
