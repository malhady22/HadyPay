import 'package:flutter/material.dart';

enum AppLanguage { english, arabic }

/// Holds app-wide, user-controllable preferences: theme mode and language.
/// Demo-only — no persistence layer, resets on app restart by design
/// (keeps this MVP dependency-free).
class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  AppLanguage _language = AppLanguage.english;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  AppLanguage get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;

  String get languageLabel =>
      _language == AppLanguage.english ? 'English' : 'العربية';

  void toggleDarkMode(bool value) {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }

  void setNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void setBiometric(bool value) {
    _biometricEnabled = value;
    notifyListeners();
  }
}
