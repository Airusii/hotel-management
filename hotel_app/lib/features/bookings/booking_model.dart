import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, checkedIn, checkedOut, cancelled, completed }

class Booking {
  final String id;
  final String roomId;
  final String userId;
  final String guestName;
  final String? guestEmail;
  final DateTime checkIn;
  final DateTime checkOut;
  final BookingStatus status;
  final double totalPrice;

  Booking({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.guestName,
    this.guestEmail,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomId': roomId,
      'userId': userId,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'checkIn': Timestamp.fromDate(checkIn),
      'checkOut': Timestamp.fromDate(checkOut),
      'status': status.name,
      'totalPrice': totalPrice,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: id,
      roomId: map['roomId'] ?? '',
      userId: map['userId'] ?? '',
      guestName: map['guestName'] ?? 'Без имени',
      guestEmail: map['guestEmail'],
      checkIn: (map['checkIn'] as Timestamp).toDate(),
      checkOut: (map['checkOut'] as Timestamp).toDate(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookingStatus.pending,
      ),
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
    );
  }

  Booking copyWith({
    String? id,
    String? roomId,
    String? userId,
    String? guestName,
    String? guestEmail,
    DateTime? checkIn,
    DateTime? checkOut,
    BookingStatus? status,
    double? totalPrice,
  }) {
    return Booking(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      guestName: guestName ?? this.guestName,
      guestEmail: guestEmail ?? this.guestEmail,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
