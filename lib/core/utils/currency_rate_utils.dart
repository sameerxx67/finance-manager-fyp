import 'package:zenthory/data/data.dart';

class CurrencyRateUtils {
  static final CurrencyRateService _currencyRateService = CurrencyRateService();
  static Map<String, double> _rates = {};

  static Future<double> forCurrency(String currency) async {
    if (_rates.isEmpty) {
      _rates = await _currencyRateService.getRatesAsMap();
    }
    return _rates[currency] ?? 1;
  }

  static Future<void> refresh() async {
    _rates = await _currencyRateService.getRatesAsMap();
  }
}
