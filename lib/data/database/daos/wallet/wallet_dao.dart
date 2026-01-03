import 'package:drift/drift.dart';
import 'package:zenthory/data/data.dart';
import 'package:zenthory/data/database/tables/wallets_table.dart';

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(super.db);

  Future<List<Wallet>> getAll({bool? isLocked, bool? isHidden}) {
    final query = select(wallets)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);

    if (isLocked != null) {
      query.where((t) => t.isLocked.equals(isLocked));
    }

    if (isHidden != null) {
      query.where((t) => t.isHidden.equals(isHidden));
    }

    return query.get();
  }

  Future<bool> existsByName(String name, {int? excludeId}) async {
    final query = select(wallets)..where((t) => t.name.equals(name.trim()));
    if (excludeId != null) {
      query.where((t) => t.id.isNotIn([excludeId]));
    }
    return await query.getSingleOrNull() != null;
  }

  Future<int> insertWallet(WalletsCompanion wallet) =>
      into(wallets).insert(wallet);

  Future<bool> updateWallet(Wallet wallet) => update(wallets).replace(wallet);

  Future<void> insertAll(List<WalletModel> data) async {
    await batch((batch) {
      batch.insertAll(
        wallets,
        data.map((tx) => tx.toInsertCompanion()).toList(),
      );
    });
  }

  Future<double> recalculateWalletBalance(int id) async {
    final result = await customSelect(
      '''
    SELECT 
      SUM(
        CASE 
          WHEN t.no_impact_on_balance = 1 THEN 0
          WHEN t.type = 'income' THEN t.amount
          WHEN t.type = 'expenses' THEN -t.amount
          WHEN t.type = 'debts' AND (
            c.identifier = 'receiving_debts_and_installments' OR 
            p.identifier = 'receiving_debts_and_installments'
          ) THEN t.amount
          WHEN t.type = 'debts' AND (
            c.identifier = 'paying_debts_and_installments' OR 
            p.identifier = 'paying_debts_and_installments'
          ) THEN -t.amount
          ELSE 0
        END
      ) AS balance
    FROM transactions t
    LEFT JOIN categories c ON c.id = t.category_id
    LEFT JOIN categories p ON p.id = c.category_id
    WHERE t.wallet_id = ?
    ''',
      variables: [Variable.withInt(id)],
    ).getSingle();

    return result.read<double?>('balance') ?? 0.0;
  }

  Future<Wallet?> find(int id) =>
      (select(wallets)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> updateBalance(int walletId, double newBalance) {
    return (update(wallets)..where((w) => w.id.equals(walletId))).write(
      WalletsCompanion(balance: Value(newBalance)),
    );
  }
}
