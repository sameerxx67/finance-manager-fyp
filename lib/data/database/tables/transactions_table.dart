import 'package:drift/drift.dart';
import 'package:zenthory/data/database/tables/export.dart';
import 'package:zenthory/zenthory.dart';

class TransactionTypeConverter extends TypeConverter<TransactionType, String> {
  const TransactionTypeConverter();

  @override
  TransactionType fromSql(String fromDb) =>
      TransactionType.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(TransactionType value) => value.name;
}

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real()();

  TextColumn get type => text().map(const TransactionTypeConverter())();

  IntColumn get walletId =>
      integer().references(Wallets, #id, onDelete: KeyAction.cascade)();

  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get date => dateTime()();

  TextColumn get note => text().nullable().withLength(min: 0, max: 255)();

  TextColumn get currency =>
      text().withLength(min: 1, max: 10).withDefault(const Constant('USD'))();

  RealColumn get currencyRate => real().withDefault(const Constant(1.0))();

  BoolColumn get noImpactOnBalance =>
      boolean().withDefault(const Constant(false))();

  IntColumn get contactId => integer().nullable().references(
    Contacts,
    #id,
    onDelete: KeyAction.cascade,
  )();

  DateTimeColumn get startDate => dateTime().nullable()();

  DateTimeColumn get endDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
