import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale';
  Locale _locale = const Locale('tr');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'tr';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  static const List<Locale> supportedLocales = [
    Locale('tr', ''), // Türkçe
    Locale('en', ''), // English
    Locale('ru', ''), // Русский
    Locale('hi', ''), // हिंदी
    Locale('zh', ''), // 中文
  ];

  static const Map<String, String> languageNames = {
    'tr': 'Türkçe',
    'en': 'English',
    'ru': 'Русский',
    'hi': 'हिंदी',
    'zh': '中文',
  };
}
