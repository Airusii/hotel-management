import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ключ для SharedPreferences
const _localeKey = 'app_locale';

// Все поддерживаемые локали
const supportedLocales = [
  Locale('en'),
  Locale('ru'),
  Locale('ky'),
];

// Отображаемые имена локалей
const localeNames = {
  'en': 'English',
  'ru': 'Русский',
  'ky': 'Кыргызча',
};

// Флаги локалей (эмодзи)
const localeFlags = {
  'en': '🇬🇧',
  'ru': '🇷🇺',
  'ky': '🇰🇬',
};

/// StateNotifier для управления текущей локалью
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ru')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_localeKey);
      if (saved != null && supportedLocales.any((l) => l.languageCode == saved)) {
        state = Locale(saved);
      }
    } catch (_) {
      // Если SharedPreferences недоступен, оставляем дефолтную локаль
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (_) {}
  }
}

/// Провайдер текущей локали
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(),
);
