import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/features/rooms/room_model.dart';
import 'package:hotel_app/features/rooms/rooms_repository.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/bookings/bookings_repository.dart';
import 'package:hotel_app/features/auth/auth_provider.dart';
import 'package:hotel_app/features/reviews/review_model.dart';
import 'package:hotel_app/features/reviews/reviews_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
class RoomDetailsScreen extends ConsumerStatefulWidget {
  final String roomId;
  const RoomDetailsScreen({super.key, required this.roomId});

  @override
  ConsumerState<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends ConsumerState<RoomDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final PageController _pageController = PageController();
  
  DateTimeRange? _selectedDates;
  bool _isSubmitting = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _autoFillUserData();
  }

  Future<void> _autoFillUserData() async {
    final user = ref.read(authStateChangesProvider).value;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          setState(() {
            _nameController.text = data['name'] ?? '';
            _emailController.text = data['email'] ?? '';
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool _isDaySelectable(DateTime day, List<Booking> allBookings) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    
    final roomBookings = allBookings.where((b) => 
      b.roomId == widget.roomId && 
      (b.status == BookingStatus.pending || b.status == BookingStatus.confirmed)
    );

    for (var booking in roomBookings) {
      final start = DateTime(booking.checkIn.year, booking.checkIn.month, booking.checkIn.day);
      final end = DateTime(booking.checkOut.year, booking.checkOut.month, booking.checkOut.day);
      
      if ((normalizedDay.isAtSameMomentAs(start) || normalizedDay.isAfter(start)) && 
          (normalizedDay.isAtSameMomentAs(end) || normalizedDay.isBefore(end))) {
        return false;
      }
    }
    return true;
  }

  Future<void> _selectDates(List<Booking> allBookings) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _selectedDates,
      selectableDayPredicate: (day, start, end) => _isDaySelectable(day, allBookings),
    );
    if (picked != null) {
      bool hasConflict = false;
      for (int i = 0; i <= picked.end.difference(picked.start).inDays; i++) {
        if (!_isDaySelectable(picked.start.add(Duration(days: i)), allBookings)) {
          hasConflict = true;
          break;
        }
      }

      if (hasConflict) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.roomDetailsDatesOccupied), backgroundColor: Colors.red),
          );
        }
      } else {
        setState(() => _selectedDates = picked);
      }
    }
  }

  Future<void> _bookRoom(Room room, List<Booking> allBookings) async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate() || _selectedDates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginFillFields)),
      );
      return;
    }

    bool hasConflict = false;
    for (int i = 0; i <= _selectedDates!.end.difference(_selectedDates!.start).inDays; i++) {
      if (!_isDaySelectable(_selectedDates!.start.add(Duration(days: i)), allBookings)) {
        hasConflict = true;
        break;
      }
    }

    if (hasConflict) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.roomDetailsDatesUnavailable), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(authStateChangesProvider).value;
      final nights = _selectedDates!.end.difference(_selectedDates!.start).inDays;
      final totalPrice = nights * room.price;

      final booking = Booking(
        id: '',
        roomId: room.id,
        userId: user?.uid ?? 'guest_${DateTime.now().millisecondsSinceEpoch}',
        guestName: _nameController.text.trim(),
        guestEmail: _emailController.text.trim(),
        checkIn: _selectedDates!.start,
        checkOut: _selectedDates!.end,
        status: BookingStatus.pending,
        totalPrice: totalPrice,
      );

      await ref.read(bookingsRepositoryProvider).addBooking(booking);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.bookingActionConfirmed)),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showFullScreenImage(List<String> allImages, int initialIndex) {
    showDialog(
      context: context,
      builder: (context) => _FullScreenImageViewer(
        images: allImages,
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final roomsAsync = ref.watch(roomsStreamProvider);
    final bookingsAsync = ref.watch(bookingsStreamProvider);
    final reviewsAsync = ref.watch(roomReviewsStreamProvider(widget.roomId));
    final theme = Theme.of(context);

    return Scaffold(
      body: roomsAsync.when(
        data: (rooms) {
          final room = rooms.firstWhere((r) => r.id == widget.roomId);
          final List<String> allImages = [
            if (room.image != null) room.image!,
            ...room.images,
          ];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: allImages.isEmpty
                      ? Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(Icons.hotel, size: 100, color: theme.colorScheme.primary.withOpacity(0.5)),
                        )
                      : Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: allImages.length,
                              onPageChanged: (index) {
                                setState(() => _currentImageIndex = index);
                              },
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => _showFullScreenImage(allImages, index),
                                  child: Image.network(
                                    allImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                );
                              },
                            ),
                            if (allImages.length > 1)
                              Positioned(
                                bottom: 16,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: allImages.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () => _pageController.animateToPage(
                                        entry.key,
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      ),
                                      child: Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(
                                            _currentImageIndex == entry.key ? 0.9 : 0.4,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '№ ${room.name} — ${room.typeId}',
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '\$${room.price.toStringAsFixed(0)}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(l10n.roomDetailsPerNight, style: theme.textTheme.bodySmall),
                      const SizedBox(height: 24),
                      Text(
                        l10n.roomDetailsDescription,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.roomDetailsDescriptionText,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.roomDetailsAmenities,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _AmenityTag(icon: Icons.wifi, label: 'Free Wi-Fi'),
                          _AmenityTag(icon: Icons.ac_unit, label: 'Кондиционер'),
                          _AmenityTag(icon: Icons.tv, label: 'Smart TV'),
                          _AmenityTag(icon: Icons.coffee_maker, label: 'Кофемашина'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: theme.colorScheme.outlineVariant),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Бронирование',
                                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                bookingsAsync.when(
                                  data: (bookings) => OutlinedButton.icon(
                                    onPressed: () => _selectDates(bookings),
                                    icon: const Icon(Icons.calendar_today),
                                    label: Text(
                                      _selectedDates == null
                                          ? l10n.homeSearchDates
                                          : '${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(_selectedDates!.start)} - ${DateFormat.MMMd(Localizations.localeOf(context).toString()).format(_selectedDates!.end)}',
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  loading: () => const Center(child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: CircularProgressIndicator(),
                                  )),
                                  error: (_, __) => Text(l10n.errorGeneric('Calendar')),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Имя гостя',
                                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                    prefixIcon: const Icon(Icons.person_outline),
                                  ),
                                  validator: (v) => v!.isEmpty ? l10n.loginFillFields : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) => v!.isEmpty ? l10n.loginFillFields : null,
                                ),
                                const SizedBox(height: 24),
                                if (_selectedDates != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(l10n.roomDetailsTotalNights(_selectedDates!.end.difference(_selectedDates!.start).inDays), style: theme.textTheme.titleMedium),
                                        Text(
                                          '\$${(_selectedDates!.end.difference(_selectedDates!.start).inDays * room.price).toStringAsFixed(0)}',
                                          style: theme.textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                FilledButton(
                                  onPressed: _isSubmitting 
                                    ? null 
                                    : () => _bookRoom(room, bookingsAsync.value ?? []),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : Text(l10n.roomDetailsBookButton, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _ReviewsSection(reviewsAsync: reviewsAsync),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(l10n.errorGeneric(err.toString()))),
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final AsyncValue<List<Review>> reviewsAsync;
  const _ReviewsSection({required this.reviewsAsync});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.roomDetailsReviews,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        reviewsAsync.when(
          data: (reviews) {
            if (reviews.isEmpty) {
              return Text(l10n.roomDetailsNoReviews);
            }
            final avgRating = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      avgRating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text('(${reviews.length})', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 20),
                ...reviews.take(5).map((review) => _ReviewItem(review: review)),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, _) => Text(l10n.errorGeneric(err.toString())),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _FullScreenImageViewer extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const _FullScreenImageViewer({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        itemCount: images.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          return Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                images[index],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final Review review;
  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                DateFormat.yMd(locale).format(review.createdAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          Row(
            children: List.generate(5, (index) => Icon(
              index < review.rating ? Icons.star : Icons.star_border,
              size: 16,
              color: Colors.orange,
            )),
          ),
          const SizedBox(height: 8),
          Text(review.comment, style: theme.textTheme.bodyMedium),
          const Divider(height: 32),
        ],
      ),
    );
  }
}

class _AmenityTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AmenityTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
