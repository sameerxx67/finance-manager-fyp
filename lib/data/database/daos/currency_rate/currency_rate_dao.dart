import 'package:drift/drift.dart';
import 'package:zenthory/data/data.dart';
import 'package:zenthory/data/database/tables/currency_rates_table.dart';

part 'currency_rate_dao.g.dart';

@DriftAccessor(tables: [CurrencyRates])
class CurrencyRateDao extends DatabaseAccessor<AppDatabase>
    with _$CurrencyRateDaoMixin {
  CurrencyRateDao(super.db);

  Future<void> updateRates({
    required CurrencyRateModel model,
    bool force = false,
  }) async {
    if (!force) {
      final existing = await getByCode(model.code);
      if (existing != null && existing.isLocked) return;
    }

    await into(currencyRates).insertOnConflictUpdate(model.toCompanion());
  }

  Future<void> insertOrUpdateRate(CurrencyRatesCompanion currencyRate) async {
    await into(currencyRates).insertOnConflictUpdate(currencyRate);
  }

  Future<List<CurrencyRate>> getAll() => select(currencyRates).get();

  Future<CurrencyRate?> getByCode(String code) => (select(
    currencyRates,
  )..where((t) => t.code.equals(code))).getSingleOrNull();
}
