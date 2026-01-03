import 'package:currency_picker/currency_picker.dart';
import 'package:drift/drift.dart';
import 'package:zenthory/zenthory.dart';

class CurrencyRateModel {
  final String code;
  final double rate;
  final bool isLocked;
  final Currency? currency;
  final DateTime updatedAt;

  CurrencyRateModel({
    required this.code,
    required this.rate,
    this.isLocked = false,
    this.currency,
    required this.updatedAt,
  });

  factory CurrencyRateModel.fromEntity(CurrencyRate entity) {
    return CurrencyRateModel(
      code: entity.code,
      rate: entity.rate,
      isLocked: entity.isLocked,
      updatedAt: entity.updatedAt,
    );
  }

  CurrencyRate toEntity() {
    return CurrencyRate(
      code: code,
      rate: rate,
      isLocked: isLocked,
      updatedAt: updatedAt,
    );
  }

  CurrencyRateModel copyWith({
    String? code,
    double? rate,
    bool? isLocked,
    Currency? currency,
    DateTime? updatedAt,
  }) {
    return CurrencyRateModel(
      code: code ?? this.code,
      rate: rate ?? this.rate,
      isLocked: isLocked ?? this.isLocked,
      currency: currency ?? this.currency,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  CurrencyRatesCompanion toCompanion() {
    return CurrencyRatesCompanion(
      code: Value(code),
      rate: Value(rate),
      isLocked: Value(isLocked),
      updatedAt: Value(updatedAt),
    );
  }

  Money get rateMoney => Money(rate, code);
}
