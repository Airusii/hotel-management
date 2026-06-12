import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/services/service_model.dart';
import 'package:hotel_app/features/services/services_provider.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ActiveStayScreen extends ConsumerStatefulWidget {
  const ActiveStayScreen({super.key});

  @override
  ConsumerState<ActiveStayScreen> createState() => _ActiveStayScreenState();
}

class _ActiveStayScreenState extends ConsumerState<ActiveStayScreen> {
  String? _selectedBookingId;
  bool _isOrdering = false;

  bool _isSelectableStay(Booking booking) {
    return booking.status == BookingStatus.confirmed ||
        booking.status == BookingStatus.checkedIn;
  }

  List<Booking> _userStays(List<Booking> bookings, String userId) {
    final stays = bookings
        .where((booking) => booking.userId == userId && _isSelectableStay(booking))
        .toList();

    stays.sort((a, b) {
      if (a.status == BookingStatus.checkedIn && b.status != BookingStatus.checkedIn) {
        return -1;
      }
      if (b.status == BookingStatus.checkedIn && a.status != BookingStatus.checkedIn) {
        return 1;
      }
      return a.checkIn.compareTo(b.checkIn);
    });

    return stays;
  }

  Future<void> _orderService({
    required BuildContext context,
    required WidgetRef ref,
    required HotelService service,
    required Booking booking,
    required String roomName,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isOrdering = true);

    try {
      await ref.read(bookingsRepositoryProvider).orderServiceForBooking(
        bookingId: booking.id,
        service: service,
        roomId: booking.roomId,
        taskTitle: l10n.activeStayOrderTitle(service.name),
        taskDescription: l10n.activeStayOrderDesc(roomName),
      );

      if (!context.mounted) return;

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(child: Text(l10n.activeStayOrderAccepted)),
            ],
          ),
          content: Text(l10n.activeStayOrderDelivery(service.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.activeStayOrderOk),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.activeStayOrderError(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isOrdering = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final currentUser = ref.watch(authStateChangesProvider).value;
    final bookingsAsync = ref.watch(bookingsStreamProvider);
    final roomsAsync = ref.watch(roomsStreamProvider);
    final servicesAsync = ref.watch(servicesStreamProvider);
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.activeStayTitle),
        centerTitle: true,
      ),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.errorLoadingData(err.toString()))),
        data: (bookings) {
          if (currentUser == null) {
            return Center(child: Text(l10n.activeStayLoginRequired));
          }

          final stays = _userStays(bookings, currentUser.uid);
          if (stays.isEmpty) {
            return _EmptyStayMessage(theme: theme, l10n: l10n);
          }

          _selectedBookingId ??= stays.first.id;
          if (!stays.any((booking) => booking.id == _selectedBookingId)) {
            _selectedBookingId = stays.first.id;
          }

          final selectedBooking = stays.firstWhere(
            (booking) => booking.id == _selectedBookingId,
            orElse: () => stays.first,
          );

          return roomsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text(l10n.activeStayErrorRooms)),
            data: (rooms) {
              final room = rooms.firstWhere(
                (room) => room.id == selectedBooking.roomId,
                orElse: () => throw Exception(l10n.activeStayRoomNotFound),
              );

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButtonFormField<String>(
                        value: selectedBooking.id,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.activeStaySelectStay,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.meeting_room_outlined),
                        ),
                        items: stays.map((booking) {
                          final matchingRooms = rooms.where((room) => room.id == booking.roomId);
                          final stayRoom = matchingRooms.isEmpty ? null : matchingRooms.first;
                          final roomName = stayRoom?.name ?? booking.roomId;
                          final statusLabel = booking.status == BookingStatus.checkedIn
                              ? l10n.activeStayStatusActive
                              : l10n.activeStayStatusUpcoming;
                          return DropdownMenuItem(
                            value: booking.id,
                            child: Text(
                              '№ $roomName · $statusLabel · ${dateFormat.format(booking.checkIn)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedBookingId = value),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _StayDetailsCard(
                      booking: selectedBooking,
                      roomName: room.name,
                      roomType: room.typeId,
                      dateFormat: dateFormat,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        l10n.activeStayRoomServices,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  servicesAsync.when(
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, _) => SliverToBoxAdapter(
                      child: Center(child: Text(l10n.servicesErrorLoading(err.toString()))),
                    ),
                    data: (services) {
                      final roomServiceIds = room.services;
                      final availableServices = services.where((service) => 
                        !service.isArchived && roomServiceIds.contains(service.id)
                      ).toList();

                      if (availableServices.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(l10n.activeStayNoServices),
                          ),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 240,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 200,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final service = availableServices[index];
                              return _ServiceCard(
                                service: service,
                                isOrdering: _isOrdering,
                                onTap: () => _orderService(
                                  context: context,
                                  ref: ref,
                                  service: service,
                                  booking: selectedBooking,
                                  roomName: room.name,
                                ),
                              );
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
}

class _EmptyStayMessage extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _EmptyStayMessage({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hotel_class_outlined,
            size: 80,
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
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
}

class _StayDetailsCard extends StatelessWidget {
  final Booking booking;
  final String roomName;
  final String roomType;
  final DateFormat dateFormat;

  const _StayDetailsCard({
    required this.booking,
    required this.roomName,
    required this.roomType,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isActive = booking.status == BookingStatus.checkedIn;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: isActive
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.secondaryContainer,
                    child: Icon(
                      isActive ? Icons.bed : Icons.event_available,
                      color: isActive
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.activeStayRoomLabel(roomName),
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          roomType,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(isActive ? l10n.activeStayStatusActive : l10n.activeStayStatusUpcoming),
                    side: BorderSide.none,
                  ),
                ],
              ),
              const Divider(height: 32),
              _InfoRow(
                icon: Icons.login,
                label: l10n.activeStayCheckin,
                value: dateFormat.format(booking.checkIn),
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.logout,
                label: l10n.activeStayCheckout,
                value: dateFormat.format(booking.checkOut),
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.payments_outlined,
                label: l10n.activeStayTotal,
                value: '\$${booking.totalPrice.toStringAsFixed(0)}',
              ),
              if (isActive) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.wifi,
                  label: l10n.activeStayWifi,
                  value: 'manas_guest_2026',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final HotelService service;
  final bool isOrdering;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.isOrdering,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isOrdering ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_serviceIcon(service.icon), size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: Text(
                    service.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Text(
                '\$${service.basePrice.toStringAsFixed(0)}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isOrdering ? null : onTap,
                  child: Text(l10n.servicesOrder),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _serviceIcon(String iconName) {
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
