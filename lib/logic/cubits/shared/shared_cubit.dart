import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zenthory/zenthory.dart';

part 'shared_state.dart';

class SharedCubit extends Cubit<SharedState> {
  final SharedPreferencesService preferencesService =
      SharedPreferencesService();
  final LocalAuthentication auth = LocalAuthentication();

  SharedCubit(Locale locale, ThemeMode themeMode)
    : super(SharedInitial(locale: locale, themeMode: themeMode));

  String getLanguageNativeName(String locale) {
    switch (locale) {
      case "en":
        return "English";
      default:
        return "عربي";
    }
  }

  void updateLocale(Locale locale) async {
    await preferencesService.saveLanguageCode(locale.languageCode);
    emit(
      SharedInitial(
        locale: locale,
        themeMode: await preferencesService.getThemeMode(),
      ),
    );
  }

  void updateThemeMode(ThemeMode themeMode) async {
    await preferencesService.saveThemeMode(themeMode.name);
    emit(
      SharedInitial(
        locale: await preferencesService.getLocale(),
        themeMode: themeMode,
      ),
    );
  }

  void showModalBottomSheet(WidgetBuilder builder, {Color? backgroundColor}) {
    emit(
      ShowModalBottomSheet(builder: builder, backgroundColor: backgroundColor),
    );
  }

  String formatRange(DateTime start, DateTime end) {
    return "${DateFormat.yMMMd().format(start)} → ${DateFormat.yMMMd().format(end)}";
  }

  String formatDateTime(DateTime date) {
    return "${DateFormat("yMMMd").format(date)} ${DateFormat('h:mm a').format(date)}";
  }

  String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  String formatDate(DateTime date) {
    return DateFormat("yMMMd").format(date);
  }

  void authenticateIfAvailable(
    String localizedReason,
    Function callback,
  ) async {
    if (await auth.canCheckBiometrics || await auth.isDeviceSupported()) {
      try {
        if (await auth.authenticate(
          localizedReason: localizedReason,
          options: const AuthenticationOptions(useErrorDialogs: true),
        )) {
          callback();
        }
      } catch (_) {}
    } else {
      callback();
    }
  }

  void showDialog({
    required AlertDialogType type,
    required String title,
    required String message,
    VoidCallback? callbackConfirm,
    String? icon,
  }) {
    emit(
      ShowDialog(
        type: type,
        title: title,
        message: message,
        icon: icon,
        callbackConfirm: callbackConfirm,
      ),
    );
  }

  void showSnackBar({required String message, Duration? duration}) {
    emit(ShowSnackBar(message: message, duration: duration));
  }
}
