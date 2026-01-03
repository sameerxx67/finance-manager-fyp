import 'package:drift/drift.dart';
import 'package:zenthory/data/database/tables/export.dart';

class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  IntColumn get walletId => integer().nullable().references(
    Wallets,
    #id,
    onDelete: KeyAction.cascade,
  )();

  RealColumn get amount => real().withDefault(const Constant(0.0))();

  TextColumn get note => text().nullable().withLength(min: 0, max: 255)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
