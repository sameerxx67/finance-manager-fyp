import 'package:currency_picker/currency_picker.dart';
import 'package:zenthory/zenthory.dart';

class CurrencyRateService {
  CurrencyRateService._internal();

  static final CurrencyRateService _instance = CurrencyRateService._internal();

  factory CurrencyRateService() => _instance;

  final CurrencyRateDao _dao = CurrencyRateDao(AppDatabase.instance);
  final SharedPreferencesService _preferencesService =
      SharedPreferencesService();
  final CurrencyService _currencyService = CurrencyService();

  Future<List<CurrencyRateModel>> fetchAll() async {
    final rows = await _dao.getAll();
    return rows
        .map(
          (CurrencyRate currencyRate) => CurrencyRateModel.fromEntity(
            currencyRate,
          ).copyWith(currency: _currencyService.findByCode(currencyRate.code)),
        )
        .toList();
  }

  Future<void> save(CurrencyRateModel model) async {
    await _dao.insertOrUpdateRate(model.toCompanion());
  }

  Future<void> updateAllCurrencyRates({
    String? currency,
    bool force = false,
  }) async {
    Map<String, double> rates = await CurrencyRateApiService.fetchRates(
      currency ?? await _preferencesService.getCurrency(),
    );
    for (var currency in _currencyService.getAll()) {
      await _dao.updateRates(
        model: CurrencyRateModel(
          code: currency.code.toUpperCase(),
          rate: rates[currency.code.toUpperCase()] ?? 1,
          updatedAt: DateTime.now(),
        ),
        force: force,
      );
    }
    await CurrencyRateUtils.refresh();
  }

  Future<Map<String, double>> getRatesAsMap() async {
    final rates = await _dao.getAll();
    return {for (final rate in rates) rate.code.toUpperCase(): rate.rate};
  }
}
