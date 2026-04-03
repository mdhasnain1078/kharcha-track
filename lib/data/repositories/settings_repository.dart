import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _themeKey = 'theme_mode';
  static const _currencyKey = 'currency_symbol';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  // ─── Theme ─────────────────────────────────────────────────────────

  ThemeMode getThemeMode() {
    final value = _prefs.getString(_themeKey);
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.light:
        value = 'light';
        break;
      default:
        value = 'system';
    }
    await _prefs.setString(_themeKey, value);
  }

  // ─── Currency ──────────────────────────────────────────────────────

  String getCurrencySymbol() {
    return _prefs.getString(_currencyKey) ?? '₹';
  }

  Future<void> setCurrencySymbol(String symbol) async {
    await _prefs.setString(_currencyKey, symbol);
  }

  // ─── Security ──────────────────────────────────────────────────────

  bool getBiometricsEnabled() {
    return _prefs.getBool('use_biometrics') ?? false;
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _prefs.setBool('use_biometrics', enabled);
  }
}
