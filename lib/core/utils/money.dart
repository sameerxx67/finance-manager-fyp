import 'dart:math';

import 'package:intl/intl.dart';
import 'package:zenthory/core/core.dart';

class Money {
  final double _amount;
  final String _currency;
  static late String defaultCurrency;

  Money(this._amount, this._currency);

  static set setDefaultCurrency(String currency) {
    defaultCurrency = currency;
  }

  factory Money.inDefaultCurrency(double amount) {
    return Money(amount, defaultCurrency);
  }

  double get amount => _amount;

  String get currency => _currency;

  bool get isZero => _amount == 0;

  Money add(Money addend) {
    return Money(_amount + addend._amount, _currency);
  }

  Money subtract(Money subtrahend) {
    return Money(_amount - subtrahend._amount, _currency);
  }

  Money multiply(double multiplier) {
    return Money(_amount * multiplier, _currency);
  }

  Money divide(double divisor) {
    return Money(_amount / divisor, _currency);
  }

  bool lessThan(Money other) {
    return _amount < other._amount;
  }

  bool lessThanOrEqual(Money other) {
    return _amount <= other._amount;
  }

  bool greaterThan(Money other) {
    return _amount > other._amount;
  }

  bool greaterThanOrEqual(Money other) {
    return _amount >= other._amount;
  }

  Money round({int? precision}) {
    precision ??= 2;
    double factor = pow(10, precision).toDouble();
    return Money((_amount * factor).round() / factor, _currency);
  }

  Money ceil() {
    return Money(_amount.ceilToDouble(), _currency);
  }

  Money floor() {
    return Money(_amount.floorToDouble(), _currency);
  }

  String format({String? currency, String locale = 'en'}) {
    final usedCurrency = currency ?? _currency;
    final formatter = NumberFormat.currency(
      locale: locale,
      name: usedCurrency,
      decimalDigits: 2,
      customPattern: '¤ #,##0.00',
    );
    return formatter.format(_amount);
  }

  Future<Money> convertToDefaultCurrency({double? currencyRate}) async {
    return Money(
      _amount /
          (currencyRate ?? (await CurrencyRateUtils.forCurrency(_currency))),
      defaultCurrency,
    );
  }

  Map<String, dynamic> toJson() => {
    'amount': _amount,
    'formatted': format(),
    'currency': _currency,
  };

  @override
  String toString() => _amount.toString();
}
