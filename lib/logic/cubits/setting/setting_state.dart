part of 'setting_cubit.dart';

sealed class SettingState extends Equatable {
  const SettingState();
}

class SettingLoading extends SettingState {
  @override
  List<Object> get props => [];
}

final class SettingInitial extends SettingState {
  final Locale locale;
  final ThemeMode themeMode;
  final String currency;
  final bool enableScreenshot;
  final bool appLocked;
  final bool canAuthenticate;
  final PackageInfo? packageInfo;
  final bool currencyProcessing;
  final bool hasTransaction;

  const SettingInitial({
    required this.locale,
    required this.themeMode,
    required this.currency,
    required this.enableScreenshot,
    required this.appLocked,
    required this.canAuthenticate,
    this.currencyProcessing = false,
    this.hasTransaction = false,
    this.packageInfo,
  });

  @override
  List<Object> get props => [
    locale.languageCode,
    themeMode.name,
    currency,
    enableScreenshot,
    appLocked,
    canAuthenticate,
    currencyProcessing,
    hasTransaction,
  ];

  SettingInitial copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    String? currency,
    bool? enableScreenshot,
    bool? appLocked,
    bool? canAuthenticate,
    PackageInfo? packageInfo,
    bool? currencyProcessing,
    bool? hasTransaction,
  }) {
    return SettingInitial(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      enableScreenshot: enableScreenshot ?? this.enableScreenshot,
      appLocked: appLocked ?? this.appLocked,
      canAuthenticate: canAuthenticate ?? this.canAuthenticate,
      packageInfo: packageInfo ?? this.packageInfo,
      currencyProcessing: currencyProcessing ?? this.currencyProcessing,
      hasTransaction: hasTransaction ?? this.hasTransaction,
    );
  }
}
