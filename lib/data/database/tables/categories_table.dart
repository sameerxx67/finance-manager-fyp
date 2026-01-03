import 'package:drift/drift.dart';
import 'package:zenthory/zenthory.dart';

class CategoryTypeConverter extends TypeConverter<TransactionType, String> {
  const CategoryTypeConverter();

  @override
  TransactionType fromSql(String fromDb) {
    return TransactionType.values.firstWhere((e) => e.name == fromDb);
  }

  @override
  String toSql(TransactionType value) => value.name;
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get identifier => text().nullable().withLength(min: 1, max: 50)();

  IntColumn get categoryId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  TextColumn get description =>
      text().nullable().withLength(min: 1, max: 255)();

  TextColumn get type => text().map(const CategoryTypeConverter())();

  TextColumn get icon => text().withLength(min: 1, max: 100)();

  TextColumn get color =>
      text().withDefault(Constant('#1ca0d9')).withLength(min: 1, max: 10)();

  BoolColumn get builtIn => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
