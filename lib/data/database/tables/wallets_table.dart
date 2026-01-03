import 'package:drift/drift.dart';
import 'package:zenthory/zenthory.dart';

class WalletTypeConverter extends TypeConverter<WalletType, String> {
  const WalletTypeConverter();

  @override
  WalletType fromSql(String fromDb) {
    return WalletType.values.firstWhere((e) => e.name == fromDb);
  }

  @override
  String toSql(WalletType value) => value.name;
}

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  TextColumn get type => text().map(const WalletTypeConverter())();

  RealColumn get balance => real().withDefault(const Constant(0.0))();

  TextColumn get currency => text().withLength(min: 1, max: 10)();

  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();

  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
