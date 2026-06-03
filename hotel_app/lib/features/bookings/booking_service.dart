import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// pending → confirmed
  Future<void> confirmBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.confirmed.name,
      });
    } catch (e) {
      if (kDebugMode) print('Error confirming: $e');
      rethrow;
    }
  }

  /// confirmed → checkedIn
  Future<void> checkInGuest(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.checkedIn.name,
      });
    } catch (e) {
      if (kDebugMode) print('Error check-in: $e');
      rethrow;
    }
  }

  /// checkedIn → checkedOut + номер на уборку
  Future<void> checkOutGuest(String bookingId, String roomId) async {
    final batch = _firestore.batch();

    final bookingRef = _firestore.collection('bookings').doc(bookingId);
    batch.update(bookingRef, {'status': BookingStatus.checkedOut.name});

    final roomRef = _firestore.collection('rooms').doc(roomId);
    batch.update(roomRef, {'status': 'cleaning'});

    try {
      await batch.commit();
    } catch (e) {
      if (kDebugMode) print('Error check-out: $e');
      rethrow;
    }
  }

  /// Отклонение заявки (pending → cancelled)
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.cancelled.name,
      });
    } catch (e) {
      if (kDebugMode) print('Error cancelling: $e');
      rethrow;
    }
  }
}
