import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/admin/widgets/add_room_dialog.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/services/services_provider.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class AdminRoomsScreen extends ConsumerWidget {
  const AdminRoomsScreen({super.key});

  static const Map<String, IconData> _serviceIconMap = {
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
    final l10n = AppLocalizations.of(context)!;
    final roomsAsyncValue = ref.watch(roomsStreamProvider);
    final servicesAsyncValue = ref.watch(servicesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminRoomsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddRoomDialog(),
              );
            },
          ),
        ],
      ),
      body: roomsAsyncValue.when(
        data: (rooms) => ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(
                  room.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${room.typeId} - \$${room.price}'),
                    const SizedBox(height: 4),
                    servicesAsyncValue.when(
                      data: (allServices) {
                        final roomServices = allServices.where((s) => room.services.contains(s.id)).toList();
                        if (roomServices.isEmpty) return const SizedBox.shrink();
                        return Row(
                          children: roomServices.map((service) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: Icon(
                                _serviceIconMap[service.icon] ?? Icons.help_outline,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const SizedBox(height: 16),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.archive_outlined),
                  onPressed: () {
                    ref.read(roomsRepositoryProvider).archiveRoom(room.id);
                  },
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.errorGeneric(err.toString()))),
      ),
    );
  }
}
