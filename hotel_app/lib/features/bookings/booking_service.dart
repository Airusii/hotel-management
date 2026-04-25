import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Подтверждение бронирования
  Future<void> confirmBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'confirmed',
      });
    } catch (e) {
      if (kDebugMode) print('Error confirming: $e');
      rethrow;
    }
  }

  /// Заселение гостя (Check-in)
  Future<void> checkInGuest(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'checkedIn',
      });
    } catch (e) {
      if (kDebugMode) print('Error check-in: $e');
      rethrow;
    }
  }

  /// Выселение гостя (Check-out)
  /// Также меняет статус номера на 'needs_cleaning'
  Future<void> checkOutGuest(String bookingId, String roomId) async {
    final batch = _firestore.batch();

    // 1. Обновляем статус брони
    final bookingRef = _firestore.collection('bookings').doc(bookingId);
    batch.update(bookingRef, {'status': 'checkedOut'});

    // 2. Обновляем статус номера
    final roomRef = _firestore.collection('rooms').doc(roomId);
    batch.update(roomRef, {'status': 'cleaning'}); // Используем существующий статус 'cleaning' из модели Room

    try {
      await batch.commit();
    } catch (e) {
      if (kDebugMode) print('Error check-out: $e');
      rethrow;
    }
  }
}
