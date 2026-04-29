import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_model.dart';
import 'package:hotel_app/features/tasks/task_model.dart'; // Оставляем твой импорт для задач

final bookingsRepositoryProvider = Provider((ref) => BookingsRepository());

// 🚀 Провайдер всех броней (оставляем твой старый)
final bookingsStreamProvider = StreamProvider<List<Booking>>((ref) {
  return ref.read(bookingsRepositoryProvider).getBookings();
});

// 🚀 НОВЫЙ: Провайдер ТОЛЬКО новых заявок (pending) для Админа
final pendingBookingsProvider = StreamProvider.autoDispose<List<Booking>>((ref) {
  return ref.read(bookingsRepositoryProvider).getPendingBookings();
});

// 🚀 НОВЫЙ: Провайдер броней конкретного гостя
final userBookingsProvider = StreamProvider.autoDispose.family<List<Booking>, String>((ref, userId) {
  return ref.read(bookingsRepositoryProvider).getUserBookings(userId);
});

class BookingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Booking>> getBookings() {
    return _firestore.collection('bookings').snapshots().map(
            (snapshot) => snapshot.docs.map((doc) => Booking.fromMap(doc.data(), doc.id)).toList());
  }

  // 🚀 НОВЫЙ: Получить заявки на рассмотрении
  Stream<List<Booking>> getPendingBookings() {
    return _firestore
        .collection('bookings')
        .where('status', isEqualTo: BookingStatus.pending.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Booking.fromMap(doc.data(), doc.id)).toList());
  }

  // 🚀 НОВЫЙ: Получить брони конкретного пользователя
  Stream<List<Booking>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Booking.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addBooking(Booking booking) async {
    await _firestore.collection('bookings').add(booking.toMap());
  }

  Future<void> updateBooking(Booking booking) async {
    await _firestore.collection('bookings').doc(booking.id).update(booking.toMap());
  }

  // 🚀 НОВЫЙ: Быстрое изменение статуса брони
  Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    await _firestore.collection('bookings').doc(bookingId).update({'status': newStatus.name});
  }

  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }

  /// Метод выселения гостя с автоматическим созданием задачи на уборку (Твой идеальный код)
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