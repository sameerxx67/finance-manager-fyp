import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zenthory/zenthory.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final SharedPreferencesService preferencesService =
      SharedPreferencesService();
  final CurrencyRateService currencyRateService = CurrencyRateService();
  final TransactionService transactionService = TransactionService();

  final LocalAuthentication auth = LocalAuthentication();

  SettingCubit() : super(SettingLoading());

  Future<void> init() async {
    final Map<String, dynamic> settings = await preferencesService
        .getSettings();
    emit(
      SettingInitial(
        locale: settings['language'],
        currency: settings['currency'],
        themeMode: settings['theme_mode'],
        enableScreenshot: settings['enable_screenshot'],
        appLocked: settings['enable_lock_app'],
        canAuthenticate:
            await auth.canCheckBiometrics || await auth.isDeviceSupported(),
        packageInfo: await PackageInfo.fromPlatform(),
        hasTransaction: await hasTransaction(),
      ),
    );
  }

  setThemeMode(ThemeMode mode) {
    emit((state as SettingInitial).copyWith(themeMode: mode));
  }

  setLocale(Locale locale) {
    emit((state as SettingInitial).copyWith(locale: locale));
  }

  void switchAppLock(String localizedReason) async {
    try {
      if (await auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(useErrorDialogs: true),
      )) {
        final SettingInitial settingInitial = (state as SettingInitial);
        await preferencesService.saveEnableLockApp(!settingInitial.appLocked);

        emit(settingInitial.copyWith(appLocked: !settingInitial.appLocked));
      }
    } catch (_) {}
  }

  void switchScreenshot() async {
    final SettingInitial settingInitial = (state as SettingInitial);

    await preferencesService.saveEnableScreenshot(
      !settingInitial.enableScreenshot,
    );

    if (!settingInitial.enableScreenshot) {
      NoScreenshot.instance.screenshotOn();
    } else {
      NoScreenshot.instance.screenshotOff();
    }

    emit(
      settingInitial.copyWith(
        enableScreenshot: !settingInitial.enableScreenshot,
      ),
    );
  }

  String getAppDownloadUrl() {
    return Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=${(state as SettingInitial).packageInfo?.packageName}"
        : 'https://apps.apple.com/app/{appleId}';
  }

  setCurrency(String currency) async {
    SettingInitial settingInitial = state as SettingInitial;

    emit(settingInitial.copyWith(currencyProcessing: true));
    await currencyRateService.updateAllCurrencyRates(
      currency: currency,
      force: true,
    );
    await preferencesService.saveCurrency(currency);
    emit(
      settingInitial.copyWith(currency: currency, currencyProcessing: false),
    );
  }

  Future<bool> hasTransaction() async {
    return await transactionService.hasTransaction();
  }
}
