enum RoomStatus { available, cleaning, maintenance }

class Room {
  final String id;
  final String name;
  final String typeId;
  final double price;
  final RoomStatus status;
  final String? image;
  final List<String> services;
  final bool isArchived;

  Room({
    required this.id,
    required this.name,
    required this.typeId,
    required this.price,
    required this.status,
    this.image,
    required this.services,
    this.isArchived = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'typeId': typeId,
      'price': price,
      'status': status.name,
      'image': image,
      'services': services,
      'isArchived': isArchived,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      typeId: map['typeId'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      status: RoomStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RoomStatus.available,
      ),
      image: map['image'],
      services: List<String>.from(map['services'] ?? []),
      isArchived: map['isArchived'] ?? false,
    );
  }

  Room copyWith({
    String? id,
    String? name,
    String? typeId,
    double? price,
    RoomStatus? status,
    String? image,
    List<String>? services,
    bool? isArchived,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      typeId: typeId ?? this.typeId,
      price: price ?? this.price,
      status: status ?? this.status,
      image: image ?? this.image,
      services: services ?? this.services,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
