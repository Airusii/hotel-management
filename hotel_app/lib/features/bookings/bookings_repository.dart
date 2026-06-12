import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/services/service_model.dart';
import 'booking_model.dart';
import 'package:hotel_app/features/tasks/task_model.dart';

final bookingsRepositoryProvider = Provider((ref) => BookingsRepository());

// Провайдер всех броней
final bookingsStreamProvider = StreamProvider<List<Booking>>((ref) {
  return ref.read(bookingsRepositoryProvider).getBookings();
});

// Провайдер ТОЛЬКО новых заявок (pending) для Админа
final pendingBookingsProvider = StreamProvider.autoDispose<List<Booking>>((ref) {
  return ref.read(bookingsRepositoryProvider).getPendingBookings();
});

// Провайдер броней конкретного гостя
final userBookingsProvider = StreamProvider.autoDispose.family<List<Booking>, String>((ref, userId) {
  return ref.read(bookingsRepositoryProvider).getUserBookings(userId);
});

class BookingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Booking>> getBookings() {
    return _firestore.collection('bookings').snapshots().map(
            (snapshot) => snapshot.docs.map((doc) => Booking.fromMap(doc.data(), doc.id)).toList());
  }

  /// Получить заявки в ожидании (pending)
  /// 🚀 ИСПРАВЛЕНО: Убрана сортировка orderBy на уровне Firestore, чтобы не требовать индекс.
  /// Сортировка выполняется в Dart.
  Stream<List<Booking>> getPendingBookings() {
    return _firestore
        .collection('bookings')
        .where('status', isEqualTo: BookingStatus.pending.name)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) => Booking.fromMap(doc.data(), doc.id)).toList();
          // Сортировка в коде: сначала новые (Desc)
          list.sort((a, b) {
            final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return dateB.compareTo(dateA);
          });
          return list;
        });
  }

  /// Получить брони конкретного пользователя
  /// 🚀 ИСПРАВЛЕНО: Убрана сортировка orderBy на уровне Firestore, чтобы не требовать индекс.
  Stream<List<Booking>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((doc) => Booking.fromMap(doc.data(), doc.id)).toList();
          // Сортировка в коде: сначала новые (Desc)
          list.sort((a, b) {
            final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return dateB.compareTo(dateA);
          });
          return list;
        });
  }

  Future<void> addBooking(Booking booking) async {
    await _firestore.collection('bookings').add(booking.toMap());
  }

  Future<void> updateBooking(Booking booking) async {
    await _firestore.collection('bookings').doc(booking.id).update(booking.toMap());
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    await _firestore.collection('bookings').doc(bookingId).update({'status': newStatus.name});
  }

  Future<void> orderServiceForBooking({
    required String bookingId,
    required HotelService service,
    required String roomId,
    required String taskTitle,
    required String taskDescription,
  }) async {
    final bookingRef = _firestore.collection('bookings').doc(bookingId);
    final taskRef = _firestore.collection('tasks').doc();

    await _firestore.runTransaction((transaction) async {
      transaction.update(bookingRef, {
        'totalPrice': FieldValue.increment(service.basePrice),
      });

      transaction.set(taskRef, {
        'title': taskTitle,
        'description': taskDescription,
        'roomId': roomId,
        'assigneeId': null,
        'status': TaskStatus.pending.name,
        'createdAt': Timestamp.fromDate(DateTime.now()),
        'bookingId': bookingId,
        'serviceId': service.id,
        'serviceName': service.name,
        'servicePrice': service.basePrice,
      });
    });
  }

  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }

  Future<void> checkOutGuest({
    required String bookingId,
    required String roomId,
    required String roomName,
  }) async {
    final batch = _firestore.batch();

    final bookingRef = _firestore.collection('bookings').doc(bookingId);
    batch.update(bookingRef, {'status': BookingStatus.completed.name});

    final roomRef = _firestore.collection('rooms').doc(roomId);
    batch.update(roomRef, {'status': 'cleaning'});

    final taskRef = _firestore.collection('tasks').doc();
    final cleaningTask = {
      'title': 'Уборка после выезда: № $roomName',
      'description': 'Номер $roomName свободен. Требуется полная уборка и подготовка к следующему заезду.',
      'status': TaskStatus.pending.name,
      'roomId': roomId,
      'createdAt': FieldValue.serverTimestamp(),
    };
    batch.set(taskRef, cleaningTask);

    await batch.commit();
  }
}
