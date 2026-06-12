import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/reviews/reviews_repository.dart';
import 'package:hotel_app/features/reviews/review_model.dart';
import 'package:intl/intl.dart';
import 'package:hotel_app/features/news/widgets/news_carousel.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
import 'package:hotel_app/core/widgets/locale_selector.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTimeRange? _searchDates;
  String? _selectedType;

  List<Room> _filterRooms(List<Room> allRooms, List<Booking> allBookings) {
    return allRooms.where((room) {
      if (_selectedType != null && room.typeId != _selectedType) {
        return false;
      }
      if (_searchDates != null) {
        final roomBookings = allBookings.where((b) =>
        b.roomId == room.id &&
            (b.status == BookingStatus.pending || b.status == BookingStatus.confirmed));

        for (var booking in roomBookings) {
          if (_searchDates!.start.isBefore(booking.checkOut) &&
              _searchDates!.end.isAfter(booking.checkIn)) {
            return false;
          }
        }
      }
      return true;
    }).toList();
  }

  Future<void> _selectDates() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _searchDates,
    );
    if (picked != null) {
      setState(() => _searchDates = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roomsAsync = ref.watch(roomsStreamProvider);
    final bookingsAsync = ref.watch(bookingsStreamProvider);
    final roomTypesAsync = ref.watch(roomTypesStreamProvider);
    final reviewsAsync = ref.watch(allReviewsStreamProvider);
    final authState = ref.watch(authStateChangesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manas Hotel', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          const LocaleSelectorButton(),
          authState.when(
            data: (user) => IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.go('/profile'),
              tooltip: user != null ? l10n.navProfile : l10n.navLogin,
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: NewsCarousel(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: FilledButton.icon(
                onPressed: () => context.push('/profile/active_stay'),
                icon: const Icon(Icons.room_service),
                label: Text(l10n.homeOrderServices),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),

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
                    children: [
                      InkWell(
                        onTap: _selectDates,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.colorScheme.outlineVariant),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 20, color: theme.colorScheme.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _searchDates == null
                                      ? l10n.homeSearchDates
                                      : '${DateFormat('dd.MM').format(_searchDates!.start)} — ${DateFormat('dd.MM').format(_searchDates!.end)}',
                                  style: TextStyle(
                                    color: _searchDates == null ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (_searchDates != null)
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () => setState(() => _searchDates = null),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      roomTypesAsync.when(
                        data: (types) => DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            prefixIcon: const Icon(Icons.king_bed_outlined),
                            hintText: l10n.homeRoomType,
                          ),
                          items: [
                            DropdownMenuItem(value: null, child: Text(l10n.homeAllTypes)),
                            ...types.map((type) => DropdownMenuItem(value: type, child: Text(type))),
                          ],
                          onChanged: (val) => setState(() => _selectedType = val),
                        ),
                        loading: () => const LinearProgressIndicator(),
                        error: (_, __) => Text(l10n.errorGeneric('')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          roomsAsync.when(
            data: (rooms) => bookingsAsync.when(
              data: (bookings) {
                final filteredRooms = _filterRooms(rooms, bookings);
                if (filteredRooms.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.search_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(l10n.homeNoRooms, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return reviewsAsync.when(
                  data: (reviews) => SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        mainAxisExtent: 320,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final room = filteredRooms[index];
                          final roomReviews = reviews.where((r) => r.roomId == room.id).toList();
                          return _RoomCard(room: room, reviews: roomReviews);
                        },
                        childCount: filteredRooms.length,
                      ),
                    ),
                  ),
                  loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                  error: (err, _) => SliverToBoxAdapter(child: Center(child: Text(l10n.errorGeneric(err.toString())))),
                );
              },
              loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
              error: (err, _) => SliverToBoxAdapter(child: Center(child: Text(l10n.errorGeneric(err.toString())))),
            ),
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
            error: (err, _) => SliverToBoxAdapter(child: Center(child: Text(l10n.errorGeneric(err.toString())))),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;
  final List<Review> reviews;
  const _RoomCard({required this.room, required this.reviews});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Расчет среднего рейтинга
    String ratingText = l10n.homeNew;
    if (reviews.isNotEmpty) {
      final avg = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
      ratingText = avg.toStringAsFixed(1);
    }

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: () => context.push('/room/${room.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: theme.colorScheme.surfaceVariant,
                child: room.image != null
                    ? Image.network(room.image!, fit: BoxFit.cover)
                    : Icon(Icons.hotel, size: 48, color: theme.colorScheme.primary.withOpacity(0.5)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('№ ${room.name}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text('\$${room.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(room.typeId, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.orange[700]),
                      const SizedBox(width: 4),
                      Text(
                        ratingText,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      if (reviews.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text('(${reviews.length})', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
