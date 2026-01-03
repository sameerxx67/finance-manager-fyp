import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zenthory/data/data.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocalAuthentication auth = LocalAuthentication();
  final SharedPreferencesService preferencesService =
      SharedPreferencesService();
  final CurrencyRateService currencyRateService = CurrencyRateService();

  HomeCubit() : super(HomeInitial(activeIndex: 0));

  void onPageChanged({required int index, bool force = false}) {
    emit(
      HomeInitial(activeIndex: index, timestamp: force ? DateTime.now() : null),
    );
  }

  void updateAllCurrencyRates() {
    currencyRateService.updateAllCurrencyRates();
  }

  void redirectToLockScreenIfRequired() async {
    final bool enabledAppLock = await preferencesService.getLockAppStatus();
    if (enabledAppLock &&
        (await auth.canCheckBiometrics || await auth.isDeviceSupported())) {
      emit(LockedApp(true));
    }
  }

  void unLocked() {
    emit(LockedApp(false));
  }
}
