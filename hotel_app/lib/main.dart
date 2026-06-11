import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_app/core/router/app_router.dart';
import 'package:hotel_app/core/theme/app_theme.dart';
import 'package:hotel_app/core/theme/theme_provider.dart';
import 'package:hotel_app/firebase_options.dart';
import 'package:hotel_app/core/services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hotel_app/l10n/app_localizations.dart';
import 'package:hotel_app/core/providers/locale_provider.dart';

void main() async {
  // 1. Инициализация движка Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Безопасный запуск Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('🚨 Ошибка Firebase: $e');
  }

  // 3. Безопасный запуск уведомлений
  try {
    await NotificationService().init();
  } catch (e) {
    debugPrint('🚨 Ошибка Уведомлений (FCM): $e');
  }

  // Запуск самого приложения
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Hotel Management System',
      debugShowCheckedModeBanner: false,

      // Настройка локализации
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales, // импортировано из locale_provider.dart

      // Тема и навигация
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
