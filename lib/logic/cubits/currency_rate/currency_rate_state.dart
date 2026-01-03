part of 'currency_rate_cubit.dart';

sealed class CurrencyRateState extends Equatable {
  const CurrencyRateState();
}

class CurrencyRateLoading extends CurrencyRateState {
  @override
  List<Object> get props => [];
}

class CurrencyRateLoaded extends CurrencyRateState {
  final List<CurrencyRateModel> rates;
  final String defaultCurrency;
  final bool refresh;

  const CurrencyRateLoaded({
    required this.rates,
    required this.defaultCurrency,
    this.refresh = false,
  });

  CurrencyRateLoaded copyWith({
    List<CurrencyRateModel>? rates,
    String? defaultCurrency,
    bool? refresh,
  }) {
    return CurrencyRateLoaded(
      rates: rates ?? this.rates,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      refresh: refresh ?? this.refresh,
    );
  }

  @override
  List<Object?> get props => [rates, defaultCurrency, refresh];
}

class CurrencyRateError extends CurrencyRateState {
  final ErrorType type;

  const CurrencyRateError(this.type);

  @override
  List<Object?> get props => [type];
}

class CurrencyRateSuccess extends CurrencyRateState {
  final SuccessType type;

  const CurrencyRateSuccess(this.type);

  @override
  List<Object?> get props => [type];
}
