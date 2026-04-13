import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Manages loading and retrieving localized strings from JSON asset files.
/// Supports English ('en') and Arabic ('ar') locales.
class LocalizationService extends ChangeNotifier {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  Locale _locale = const Locale('en');
  Map<String, dynamic> _translations = {};

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  /// Call this once at app startup to load the default language.
  Future<void> init() async {
    await _loadTranslations(_locale.languageCode);
  }

  /// Toggle between English and Arabic.
  Future<void> toggleLanguage() async {
    _locale = isArabic ? const Locale('en') : const Locale('ar');
    await _loadTranslations(_locale.languageCode);
    notifyListeners();
  }

  Future<void> _loadTranslations(String langCode) async {
    final jsonString = await rootBundle
        .loadString('assets/translations/$langCode.json');
    _translations = json.decode(jsonString) as Map<String, dynamic>;
  }

  /// Resolve a dot-separated key, e.g. "login.sign_in".
  String translate(String key) {
    final parts = key.split('.');
    dynamic value = _translations;
    for (final part in parts) {
      if (value is Map<String, dynamic>) {
        value = value[part];
      } else {
        return key; // key not found → return raw key
      }
    }
    return value?.toString() ?? key;
  }
}
