import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zenthory/data/database/tables/export.dart';
import 'package:zenthory/data/seeders/zenthory_seeder.dart';
import 'package:zenthory/zenthory.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Tags,
    Categories,
    Wallets,
    Budgets,
    Transactions,
    CurrencyRates,
    TransactionTags,
    Contacts,
  ],
  daos: [
    TagDao,
    CategoryDao,
    WalletDao,
    BudgetDao,
    TransactionDao,
    CurrencyRateDao,
    ContactDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();

  static AppDatabase get instance => _instance;

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'zenthory',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await ZenthorySeeder().seed();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      await m.createAll();
      if (from == 1) {
        m.addColumn(transactions, transactions.contactId);
        m.addColumn(transactions, transactions.startDate);
        m.addColumn(transactions, transactions.endDate);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> truncate() async {
    await delete(categories).go();
    await delete(wallets).go();
    await delete(budgets).go();
    await delete(tags).go();
    await delete(transactions).go();
    await delete(transactionTags).go();
    await delete(currencyRates).go();
    await delete(contacts).go();

    for (final table in [
      'tags',
      'categories',
      'wallets',
      'budgets',
      'transactions',
      'transaction_tags',
      'currency_rates',
      'contacts',
    ]) {
      await customStatement(
        "DELETE FROM sqlite_sequence WHERE name = '$table';",
      );
    }
  }
}
