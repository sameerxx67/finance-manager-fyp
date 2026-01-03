import 'package:drift/drift.dart';

class CurrencyRates extends Table {
  TextColumn get code => text().withLength(min: 3, max: 3)();

  RealColumn get rate => real()();

  BoolColumn get isLocked => boolean().withDefault(Constant(false))();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {code};
}
