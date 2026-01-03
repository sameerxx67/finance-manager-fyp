import 'dart:convert';

import 'package:http/http.dart' as http;

class CurrencyRateApiService {
  static const _baseUrl =
      'https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies';

  static Future<Map<String, double>> fetchRates(String baseCurrency) async {
    final url = Uri.parse('$_baseUrl/${baseCurrency.toLowerCase()}.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final rates = data[baseCurrency.toLowerCase()];
      if (rates is Map) {
        return rates.map(
          (key, value) =>
              MapEntry(key.toUpperCase(), (value as num).toDouble()),
        );
      }
    }

    return {};
  }
}
