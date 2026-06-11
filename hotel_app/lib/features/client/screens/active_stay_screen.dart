import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/services/service_model.dart';
import 'package:hotel_app/features/services/services_provider.dart';
import 'package:hotel_app/features/tasks/task_model.dart';
import 'package:hotel_app/features/tasks/tasks_repository.dart';
import 'package:intl/intl.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class ActiveStayScreen extends ConsumerWidget {
  const ActiveStayScreen({super.key});

  Future<void> _orderService(
    BuildContext context,
    WidgetRef ref,
    HotelService service,
    String roomId,
    String roomName,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final newTask = Task(
        id: '', // Firestore сгенерирует ID
        title: l10n.activeStayOrderTitle(service.name),
        description: l10n.activeStayOrderDesc(roomName),
        roomId: roomId,
        status: TaskStatus.pending,
        createdAt: DateTime.now(),
      );

      // Сохраняем задачу для персонала
      await ref.read(tasksRepositoryProvider).addTask(newTask);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 12),
                Text(l10n.activeStayOrderAccepted),
              ],
            ),
            content: Text(l10n.activeStayOrderDelivery(service.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.activeStayOrderOk),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.activeStayOrderError(e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final currentUser = ref.watch(authStateChangesProvider).value;
    final bookingsAsync = ref.watch(bookingsStreamProvider);
    final roomsAsync = ref.watch(roomsStreamProvider);
    final servicesAsync = ref.watch(servicesStreamProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMd(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activeStayTitle),
        centerTitle: true,
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.errorLoadingData(err.toString()))),
        data: (bookings) {
          if (currentUser == null) return Center(child: Text(l10n.activeStayLoginRequired));

          final activeBooking = bookings.where((b) =>
            b.userId == currentUser.uid && b.status == BookingStatus.checkedIn
          ).firstOrNull;

          if (activeBooking == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hotel_class_outlined, size: 80, color: theme.colorScheme.outline.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    l10n.activeStayNoActive,
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      l10n.activeStayNoActiveDesc,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          return roomsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text(l10n.activeStayErrorRooms)),
            data: (rooms) {
              final room = rooms.firstWhere(
                (r) => r.id == activeBooking.roomId,
                orElse: () => throw Exception(l10n.activeStayRoomNotFound),
              );

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: theme.colorScheme.outlineVariant),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: theme.colorScheme.primaryContainer,
                                    child: Icon(Icons.meeting_room, color: theme.colorScheme.onPrimaryContainer),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(l10n.activeStayRoomLabel(room.name), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                        Text(room.typeId, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 32),
                              _buildInfoRow(context, Icons.calendar_today, l10n.activeStayCheckout, dateFormat.format(activeBooking.checkOut)),
                              const SizedBox(height: 12),
                              _buildInfoRow(context, Icons.wifi, 'Wi-Fi Password:', 'manas_guest_2026'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(l10n.activeStayRoomServices, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  servicesAsync.when(
                    loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                    error: (err, _) => SliverToBoxAdapter(child: Center(child: Text(l10n.servicesErrorLoading(err.toString())))),
                    data: (services) {
                      final availableServices = services.where((s) => !s.isArchived).toList();

                      if (availableServices.isEmpty) {
                        return SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: Text(l10n.activeStayNoServices)));
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final service = availableServices[index];
                              return _buildServiceCard(context, ref, service, activeBooking.roomId, room.name);
                            },
                            childCount: availableServices.length,
                          ),
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    WidgetRef ref,
    HotelService service,
    String roomId,
    String roomName,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _orderService(context, ref, service, roomId, roomName),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getIcon(service.icon), size: 40, color: theme.colorScheme.primary),
              const Spacer(),
              Text(
                service.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '\$${service.basePrice.toStringAsFixed(0)}',
                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'restaurant':
      case 'food':
        return Icons.restaurant;
      case 'cleaning':
      case 'mop':
        return Icons.cleaning_services;
      case 'spa':
        return Icons.spa;
      case 'local_taxi':
        return Icons.local_taxi;
      default:
        return Icons.room_service;
    }
  }
}
