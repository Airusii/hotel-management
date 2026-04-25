class HotelService {
  final String id;
  final String name;
  final String icon;
  final String type;
  final double basePrice;
  final bool isArchived;

  HotelService({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.basePrice,
    this.isArchived = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type,
      'basePrice': basePrice,
      'isArchived': isArchived,
    };
  }

  factory HotelService.fromMap(Map<String, dynamic> map, String id) {
    return HotelService(
      id: id,
      name: map['name'] ?? '',
      icon: map['icon'] ?? 'help_outline',
      type: map['type'] ?? '',
      basePrice: (map['basePrice'] ?? 0.0).toDouble(),
      isArchived: map['isArchived'] ?? false,
    );
  }

  HotelService copyWith({
    String? id,
    String? name,
    String? icon,
    String? type,
    double? basePrice,
    bool? isArchived,
  }) {
    return HotelService(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      basePrice: basePrice ?? this.basePrice,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
