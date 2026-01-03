part of 'shared_cubit.dart';

@immutable
sealed class SharedState extends Equatable {
  const SharedState();
}

final class SharedInitial extends SharedState {
  final Locale locale;
  final ThemeMode themeMode;

  const SharedInitial({required this.locale, required this.themeMode});

  @override
  List<Object?> get props => [locale.languageCode, themeMode];
}

final class ShowModalBottomSheet extends SharedState {
  final WidgetBuilder builder;
  final DateTime timestamp;
  final Color? backgroundColor;

  ShowModalBottomSheet({required this.builder, this.backgroundColor})
    : timestamp = DateTime.now();

  @override
  List<Object?> get props => [builder, timestamp];
}

final class ShowDialog extends SharedState {
  final AlertDialogType type;
  final String title;
  final String message;
  final String? icon;
  final DateTime timestamp;
  final VoidCallback? callbackConfirm;

  ShowDialog({
    required this.type,
    required this.title,
    required this.message,
    this.icon,
    this.callbackConfirm,
  }) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [type, title, callbackConfirm, message, timestamp];
}

final class ShowSnackBar extends SharedState {
  final String message;
  final DateTime timestamp;
  final Duration? duration;

  ShowSnackBar({required this.message, this.duration})
    : timestamp = DateTime.now();

  @override
  List<Object?> get props => [message, duration, timestamp];
}
