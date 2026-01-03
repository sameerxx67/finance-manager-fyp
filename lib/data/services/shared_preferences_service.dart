import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenthory/zenthory.dart';

class SharedPreferencesService {
  SharedPreferencesService._internal();

  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();

  factory SharedPreferencesService() => _instance;

  Future<Map<String, dynamic>> getSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> settings = {
      "language_code": prefs.getString(UserPrefsKeys.languageCode.name),
      "theme_mode": prefs.getString(UserPrefsKeys.themeMode.name),
    };
    return {
      "language": settings["language_code"] == null
          ? AppStrings.defaultLocale
          : Locale(settings['language_code']!),
      "theme_mode": settings['theme_mode'] == null
          ? AppStrings.defaultThemeMode
          : ThemeMode.values.byName(settings['theme_mode']!),
      "currency":
          prefs.getString(UserPrefsKeys.currency.name) ??
          AppStrings.defaultCurrency,
      "enable_screenshot":
          prefs.getBool(UserPrefsKeys.enableScreenshot.name) ??
          AppStrings.enableScreenshot,
      "enable_lock_app":
          prefs.getBool(UserPrefsKeys.enableLockApp.name) ??
          AppStrings.enableLockApp,
      "is_demo_data_seeded": isDemoDataSeeded(),
    };
  }

  Future<void> saveLanguageCode(String code) async {
    await (await SharedPreferences.getInstance()).setString(
      UserPrefsKeys.languageCode.name,
      code,
    );
  }

  Future<Locale> getLocale() async {
    final String? languageCode = (await SharedPreferences.getInstance())
        .getString(UserPrefsKeys.languageCode.name);
    return languageCode == null
        ? AppStrings.defaultLocale
        : Locale(languageCode);
  }

  Future<void> saveThemeMode(String themeMode) async {
    await (await SharedPreferences.getInstance()).setString(
      UserPrefsKeys.themeMode.name,
      themeMode,
    );
  }

  Future<ThemeMode> getThemeMode() async {
    final String? themeMode = (await SharedPreferences.getInstance()).getString(
      UserPrefsKeys.themeMode.name,
    );
    return themeMode == null
        ? AppStrings.defaultThemeMode
        : ThemeMode.values.byName(themeMode);
  }

  Future<void> saveCurrency(String currency) async {
    Money.setDefaultCurrency = currency;
    await (await SharedPreferences.getInstance()).setString(
      UserPrefsKeys.currency.name,
      currency,
    );
  }

  Future<String> getCurrency() async {
    return ((await SharedPreferences.getInstance()).getString(
          UserPrefsKeys.currency.name,
        )) ??
        AppStrings.defaultCurrency;
  }

  Future<void> saveEnableScreenshot(bool enable) async {
    await (await SharedPreferences.getInstance()).setBool(
      UserPrefsKeys.enableScreenshot.name,
      enable,
    );
  }

  Future<void> saveEnableLockApp(bool enable) async {
    await (await SharedPreferences.getInstance()).setBool(
      UserPrefsKeys.enableLockApp.name,
      enable,
    );
  }

  Future<bool> getLockAppStatus() async {
    return ((await SharedPreferences.getInstance()).getBool(
          UserPrefsKeys.enableLockApp.name,
        )) ??
        false;
  }

  Future<void> clear() async =>
      await (await SharedPreferences.getInstance()).clear();

  Future<void> setDemoDataSeededAt() async =>
      await (await SharedPreferences.getInstance()).setString(
        UserPrefsKeys.demoDataSeededAt.name,
        DateTime.now().toString(),
      );

  Future<bool> isDemoDataSeeded() async {
    final String? demoDataSeededAt = (await SharedPreferences.getInstance())
        .getString(UserPrefsKeys.demoDataSeededAt.name);

    if (demoDataSeededAt == null) return false;

    final DateTime? seededAt = DateTime.tryParse(demoDataSeededAt);
    if (seededAt == null) return false;

    final Duration diff = DateTime.now().difference(seededAt);
    return diff.inHours < 24;
  }
}
