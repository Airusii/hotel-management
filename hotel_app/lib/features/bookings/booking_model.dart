import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
/// Жизненный цикл брони: pending → confirmed → checkedIn → checkedOut
/// cancelled — отмена на любом этапе до заселения
/// completed — устаревшее значение, сохранено для совместимости с базой
enum BookingStatus { pending, confirmed, checkedIn, checkedOut, completed, cancelled }

extension BookingStatusX on BookingStatus {
  String getLocalizedLabel(AppLocalizations l10n) {
    switch (this) {
      case BookingStatus.pending:
        return 'Билдирме';
      case BookingStatus.confirmed:
        return 'Ырасталды';
      case BookingStatus.checkedIn:
        return 'Конду';
      case BookingStatus.checkedOut:
      case BookingStatus.completed:
        return 'Чыкты';
      case BookingStatus.cancelled:
        return 'Жоктолду';
    }
  }

  // Оставляем label для обратной совместимости или логов (на англ/рус по умолчанию)
  String get label {
    switch (this) {
      case BookingStatus.pending: return 'Заявка';
      case BookingStatus.confirmed: return 'Подтверждено';
      case BookingStatus.checkedIn: return 'Заехал';
      case BookingStatus.checkedOut:
      case BookingStatus.completed: return 'Выехал';
      case BookingStatus.cancelled: return 'Отменено';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return const Color(0xFFFF9800); // orange
      case BookingStatus.confirmed:
        return const Color(0xFF4CAF50); // green
      case BookingStatus.checkedIn:
        return const Color(0xFF2196F3); // blue
      case BookingStatus.checkedOut:
      case BookingStatus.completed:
        return const Color(0xFF9E9E9E); // grey
      case BookingStatus.cancelled:
        return const Color(0xFFF44336); // red
    }
  }
}

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
  final DateTime? createdAt;

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