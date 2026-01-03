import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'currency_rate_state.dart';

class CurrencyRateCubit extends Cubit<CurrencyRateState> {
  final CurrencyRateService service = CurrencyRateService();
  final SharedPreferencesService preferencesService =
      SharedPreferencesService();

  CurrencyRateCubit() : super(CurrencyRateLoading());

  Future<void> loadRates() async {
    try {
      emit(
        CurrencyRateLoaded(
          rates: await service.fetchAll(),
          defaultCurrency: await preferencesService.getCurrency(),
        ),
      );
    } catch (e) {
      emit(CurrencyRateError(ErrorType.failedToLoad));
    }
  }

  Future<void> updateRate(
    CurrencyRateModel model,
    double newRate,
    bool isLocked,
  ) async {
    try {
      await service.save(model.copyWith(rate: newRate, isLocked: isLocked));
      await CurrencyRateUtils.refresh();
      emit(CurrencyRateSuccess(SuccessType.updated));
      await loadRates();
    } catch (e) {
      emit(CurrencyRateError(ErrorType.failedToUpdate));
    }
  }

  Future<void> refresh() async {
    if (state is CurrencyRateLoaded) {
      try {
        final CurrencyRateLoaded currencyRateLoaded =
            state as CurrencyRateLoaded;
        emit(currencyRateLoaded.copyWith(refresh: true));
        await service.updateAllCurrencyRates();
        emit(CurrencyRateSuccess(SuccessType.updated));
        await loadRates();
      } catch (e) {
        emit(CurrencyRateError(ErrorType.failedToUpdate));
      }
    }
  }
}
