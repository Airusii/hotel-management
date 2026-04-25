import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'booking_model.dart';
import 'package:hotel_app/features/bookings/booking_model.dart';
import 'package:hotel_app/features/tasks/task_model.dart';

final bookingsRepositoryProvider = Provider((ref) => BookingsRepository());

class BookingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Booking>> getBookings() {
    return _firestore
        .collection('bookings')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addBooking(Booking booking) async {
    await _firestore.collection('bookings').add(booking.toMap());
  }

  Future<void> updateBooking(Booking booking) async {
    await _firestore.collection('bookings').doc(booking.id).update(booking.toMap());
  }

  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }

  /// Метод выселения гостя с автоматическим созданием задачи на уборку
  Future<void> checkOutGuest({
    required String bookingId,
    required String roomId,
    required String roomName,
  }) async {
    final batch = _firestore.batch();

    // 1. Обновляем статус брони
    final bookingRef = _firestore.collection('bookings').doc(bookingId);
    batch.update(bookingRef, {'status': BookingStatus.completed.name});

    // 2. Обновляем статус комнаты (требует уборки)
    final roomRef = _firestore.collection('rooms').doc(roomId);
    batch.update(roomRef, {'status': 'cleaning'});

    // 3. Создаем задачу для персонала
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

final bookingsStreamProvider = StreamProvider<List<Booking>>((ref) {
  return FirebaseFirestore.instance
      .collection('bookings')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => Booking.fromMap(doc.data(), doc.id))
      .toList());
});
