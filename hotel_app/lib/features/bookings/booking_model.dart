import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, checkedIn, completed, cancelled }

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
  final DateTime? createdAt; // 🚀 Новое поле для сортировки заявок

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
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'userId': userId,
      'guestName': guestName,
      'guestEmail': guestEmail,
      'checkIn': Timestamp.fromDate(checkIn),
      'checkOut': Timestamp.fromDate(checkOut),
      'status': status.name,
      'totalPrice': totalPrice,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
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
      createdAt: map['createdAt'] != null ? (map['createdAt'] as Timestamp).toDate() : null,
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
    DateTime? createdAt,
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
      createdAt: createdAt ?? this.createdAt,
    );
  }
}