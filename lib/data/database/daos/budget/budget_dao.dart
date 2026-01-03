import 'package:drift/drift.dart';
import 'package:zenthory/data/database/tables/budgets_table.dart';
import 'package:zenthory/zenthory.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [Budgets])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Future<List<BudgetModel>> getAll({List<String> relations = const []}) async {
    final budgetRows = await _fetchBudgetRows(relations);
    final mainCategoryIds = _extractMainCategoryIds(budgetRows);
    final categoryGroupMap = await _fetchSubCategoryMap(mainCategoryIds);
    final allTransactions = (await _fetchTransactions(categoryGroupMap));

    return await _mapBudgetsWithTransactions(
      budgetRows: budgetRows,
      categoryGroupMap: categoryGroupMap,
      allTransactions: allTransactions,
    );
  }

  Future<int> insertBudget(BudgetsCompanion data) => into(budgets).insert(data);

  Future<bool> updateBudget(Budget data) => update(budgets).replace(data);

  Future<int> deleteBudget(int id) =>
      (delete(budgets)..where((b) => b.id.equals(id))).go();

  Future<List<TypedResult>> _fetchBudgetRows(List<String> relations) async {
    return await (select(budgets).join([
      if (relations.contains('category'))
        leftOuterJoin(categories, categories.id.equalsExp(budgets.categoryId)),
      if (relations.contains('wallet'))
        leftOuterJoin(wallets, wallets.id.equalsExp(budgets.walletId)),
    ])..orderBy([OrderingTerm.desc(budgets.createdAt)])).get();
  }

  Set<int> _extractMainCategoryIds(List<TypedResult> budgetRows) {
    return budgetRows.map((row) => row.readTable(budgets).categoryId).toSet();
  }

  Future<Map<int, List<int>>> _fetchSubCategoryMap(
    Set<int> mainCategoryIds,
  ) async {
    final subCategories = await (select(
      categories,
    )..where((tbl) => tbl.categoryId.isIn(mainCategoryIds.toList()))).get();

    final Map<int, List<int>> map = {
      for (var id in mainCategoryIds) id: [id],
    };

    for (final sub in subCategories) {
      final parentId = sub.categoryId;
      if (parentId != null) {
        map[parentId]?.add(sub.id);
      }
    }

    return map;
  }

  Future<List<Transaction>> _fetchTransactions(
    Map<int, List<int>> categoryGroupMap,
  ) {
    final allCategoryIds = categoryGroupMap.values
        .expand((ids) => ids)
        .toSet()
        .toList();

    final query =
        select(db.transactions).join([
          leftOuterJoin(
            wallets,
            wallets.id.equalsExp(db.transactions.walletId),
          ),
        ])..where(
          db.transactions.categoryId.isIn(allCategoryIds) &
              db.transactions.type.equalsValue(TransactionType.expenses) &
              wallets.isLocked.equals(false),
        );

    return query.map((row) => row.readTable(db.transactions)).get();
  }

  Future<List<BudgetModel>> _mapBudgetsWithTransactions({
    required List<TypedResult> budgetRows,
    required Map<int, List<int>> categoryGroupMap,
    required List<Transaction> allTransactions,
  }) async {
    final List<BudgetModel> result = [];

    for (final row in budgetRows) {
      final budget = row.readTable(budgets);
      final category = row.readTableOrNull(categories);
      final wallet = row.readTableOrNull(wallets);

      final validCategoryIds =
          categoryGroupMap[budget.categoryId] ?? [budget.categoryId];

      final matchingTxns = allTransactions.where(
        (t) =>
            validCategoryIds.contains(t.categoryId) &&
            t.date.isAfter(
              budget.startDate.subtract(const Duration(days: 1)),
            ) &&
            t.date.isBefore(budget.endDate.add(const Duration(days: 1))) &&
            (budget.walletId == null || t.walletId == budget.walletId),
      );

      double totalSpent = 0.0;

      for (final t in matchingTxns) {
        final converted = await Money(
          t.amount,
          t.currency,
        ).convertToDefaultCurrency(currencyRate: t.currencyRate);
        totalSpent += converted.amount;
      }

      result.add(
        BudgetModel(
          id: budget.id,
          name: budget.name,
          startDate: budget.startDate,
          endDate: budget.endDate,
          categoryId: budget.categoryId,
          category: category == null
              ? null
              : CategoryModel.fromEntity(category),
          walletId: budget.walletId,
          wallet: wallet == null ? null : WalletModel.fromEntity(wallet),
          amount: budget.amount,
          spent: totalSpent,
          note: budget.note,
          createdAt: budget.createdAt,
          updatedAt: budget.updatedAt,
        ),
      );
    }

    return result;
  }

  Future<void> insertAll(List<BudgetModel> data) async {
    await batch((batch) {
      batch.insertAll(
        budgets,
        data.map((tx) => tx.toInsertCompanion()).toList(),
      );
    });
  }
}
