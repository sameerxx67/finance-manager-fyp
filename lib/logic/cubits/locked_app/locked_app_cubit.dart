import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

part 'locked_app_state.dart';

class LockedAppCubit extends Cubit<LockedAppState> {
  final LocalAuthentication auth = LocalAuthentication();

  LockedAppCubit() : super(LockedAppInitial());

  void unlock(String localizedReason) async {
    try {
      if (await auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(useErrorDialogs: true),
      )) {
        emit(UnlockedApp());
      }
    } catch (_) {}
  }
}
