import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> init() async {

    if (kIsWeb || (defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS)) {
      if (kDebugMode) {
        print('Уведомления отключены: платформа не поддерживается (ПК/Web).');
      }
      return; // Прерываем функцию, чтобы не было ошибки!
    }

    // Шаг 1: Запрос разрешений
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('User granted permission');
      }

      // 🚀 ИСПРАВЛЕНИЕ 1: Слушаем статус авторизации
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user != null) {
          String? token = await _messaging.getToken();
          if (token != null) {
            await _saveTokenToFirestore(user.uid, token);
          }
        }
      });

      // 🚀 ИСПРАВЛЕНИЕ 2: Защита от смены токена в фоне
      _messaging.onTokenRefresh.listen((String newToken) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _saveTokenToFirestore(user.uid, newToken);
        }
      });
    }

    // Обработка уведомлений в открытом приложении
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }
    });

    // Обработка нажатия на уведомление
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Message clicked!');
      }
    });
  }

  // 🚀 ИСПРАВЛЕНИЕ 3: Сохранение с merge: true
  Future<void> _saveTokenToFirestore(String uid, String token) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'fcmToken': token,
      }, SetOptions(merge: true));

      if (kDebugMode) print('Token saved for user: $uid');
    } catch (e) {
      if (kDebugMode) print('Error saving token: $e');
    }
  }

  /// Отправка уведомления конкретному пользователю
  Future<void> sendPushNotification(String userId, String title, String body) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      String? token = (userDoc.data() as Map<String, dynamic>?)?['fcmToken'];

      if (token != null) {
        if (kDebugMode) {
          print('Sending notification to $userId: $title');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notification: $e');
      }
    }
  }

  /// Уведомление для всех сотрудников
  Future<void> notifyEmployees(String title, String body) async {
    final employees = await _firestore.collection('users').where('role', isEqualTo: 'employee').get();
    for (var doc in employees.docs) {
      await sendPushNotification(doc.id, title, body);
    }
  }

  /// Уведомление для админа
  Future<void> notifyAdmin(String title, String body) async {
    final admins = await _firestore.collection('users').where('role', isEqualTo: 'admin').get();
    for (var doc in admins.docs) {
      await sendPushNotification(doc.id, title, body);
    }
  }
}