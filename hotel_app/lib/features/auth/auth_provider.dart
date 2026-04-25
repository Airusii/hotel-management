import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/features/auth/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserRole? role;
  final String? errorMessage;

  AuthState({
    required this.status,
    this.role,
    this.errorMessage,
  });

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
  factory AuthState.loading() => AuthState(status: AuthStatus.loading);
  factory AuthState.authenticated(UserRole role) => AuthState(status: AuthStatus.authenticated, role: role);
  factory AuthState.unauthenticated() => AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.error(String message) => AuthState(status: AuthStatus.error, errorMessage: message);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial()) {
    _init();
  }

  void _init() {
    _repository.authStateChanges.listen((user) async {
      if (user == null) {
        state = AuthState.unauthenticated();
      } else {
        final role = await _repository.getUserRole(user.uid);
        state = AuthState.authenticated(role ?? UserRole.client);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    state = AuthState.loading();
    try {
      final credential = await _repository.signIn(email, password);
      final role = await _repository.getUserRole(credential.user!.uid);
      state = AuthState.authenticated(role ?? UserRole.client);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = AuthState.unauthenticated();
  }
}

/// Провайдер роли пользователя.
/// Слушает состояние авторизации и стримит роль из Firestore в реальном времени.
final userRoleProvider = StreamProvider<String?>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value(null);
      }

      final controller = StreamController<String?>();
      final subscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((snapshot) {
        controller.add(snapshot.data()?['role'] as String?);
      });

      ref.onDispose(() {
        subscription.cancel();
        controller.close();
      });

      return controller.stream;
    },
    loading: () => const Stream.empty(),
    error: (err, stack) => Stream.error(err, stack),
  );
});

final userNameProvider = FutureProvider.family<String, String>((ref, userId) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (doc.exists && doc.data()!.containsKey('name')) {
    return doc.data()!['name'] as String;
  }
  return 'Неизвестный гость';
});

/// Провайдер списка сотрудников (пользователи с ролью 'employee')
final employeesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'employee')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'name': data['name'] ?? 'Без имени',
      };
    }).toList();
  });
});
