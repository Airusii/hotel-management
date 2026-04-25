import 'package:hotel_app/features/auth/auth_repository.dart';

class AppUser {
  final String id;
  final String name;
  final String nickname;
  final String email;
  final UserRole role;
  final String? photoUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.nickname,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'email': email,
      'role': role.name,
      'photoUrl': photoUrl,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      id: id,
      name: map['name'] ?? '',
      nickname: map['nickname'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.client,
      ),
      photoUrl: map['photoUrl'],
    );
  }
}
