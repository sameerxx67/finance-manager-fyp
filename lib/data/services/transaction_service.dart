import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenthory/core/core.dart';
import 'package:zenthory/data/data.dart';

class TransactionService {
  static final TransactionService _instance = TransactionService._internal();

  factory TransactionService() => _instance;

  TransactionService._internal();

  final TransactionDao _dao = TransactionDao(AppDatabase.instance);
  final CategoryService _categoryService = CategoryService();
  final WalletService _walletService = WalletService();

  Future<int> create(TransactionModel model) async {
    final transactionId = await _dao.insertTransaction(model);
    if (!model.noImpactOnBalance) {
      await _walletService.recalculateWalletBalance(id: model.walletId);
    }
    return transactionId;
  }

  Future<void> delete(TransactionModel transaction) async {
    await _dao.deleteTransaction(transaction.id);
    if (!transaction.noImpactOnBalance) {
      await _walletService.recalculateWalletBalance(id: transaction.walletId);
    }
  }

  Future<List<TransactionModel>> getTransactionPagination({
    CategoryModel? category,
    ContactModel? contact,
    DateTimeRange<DateTime>? dateRange,
    TransactionType? type,
    int? walletId,
    List<int>? tagIds,
    int offset = 0,
  }) async => (await _dao.pagination(
    offset: offset,
    category: category,
    contact: contact,
    dateRange: dateRange,
    type: type,
    walletId: walletId,
    tagIds: tagIds,
  ));

  Future<List<TransactionModel>> getRecentTransactions() async =>
      (await _dao.getRecentTransactions());

  Future<TransactionModel?> find(int id) async => (await _dao.find(id));

  Future<({Money income, Money expenses, Money debtsPaid, Money debtsReceived})>
  getTotals({
    int? categoryId,
    int? contactId,
    int? walletId,
    TransactionType? type,
    DateTimeRange<DateTime>? dateRange,
    List<int>? tagIds,
    bool includeDebts = false,
  }) async {
    final result = await _dao.getTotals(
      categoryId: categoryId,
      contactId: contactId,
      walletId: walletId,
      type: type,
      dateRange: dateRange,
      tagIds: tagIds,
      includeDebts: includeDebts,
    );
    return (
      income: Money.inDefaultCurrency(result.income),
      expenses: Money.inDefaultCurrency(result.expenses),
      debtsPaid: Money.inDefaultCurrency(result.debtsPaid),
      debtsReceived: Money.inDefaultCurrency(result.debtsReceived),
    );
  }

  List<TransactionGroupedByDateModel> groupTransactionsByDate(
    List<TransactionModel> transactions,
  ) {
    final Map<String, List<TransactionModel>> groupedMap = {};

    for (final tx in transactions) {
      final key = DateFormat('yyyy-MM-dd').format(tx.date);
      groupedMap.putIfAbsent(key, () => []).add(tx);
    }

    final List<TransactionGroupedByDateModel> result = groupedMap.entries.map((
      entry,
    ) {
      final date = DateTime.parse(entry.key);
      return TransactionGroupedByDateModel(
        date: date,
        transactions: entry.value,
      );
    }).toList();

    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  Future<bool> hasTransaction() async {
    return (await _dao.hasTransactions());
  }

  Future<List<WeeklyChartDataModel>> getWeeklyChartData() async {
    final startOfWeek = DateTimeUtils.startOfWeek();
    final endOfWeek = DateTimeUtils.endOfWeek();

    final transactions = await _dao.getBetween(startOfWeek, endOfWeek);

    final Map<String, WeeklyChartDataModel> data = {
      for (int i = 0; i < 7; i++)
        DateFormat.E().format(
          startOfWeek.add(Duration(days: i)),
        ): WeeklyChartDataModel(
          day: DateFormat.E().format(startOfWeek.add(Duration(days: i))),
          income: 0,
          expenses: 0,
        ),
    };

    for (final tx in transactions) {
      final day = DateFormat.E().format(tx.date);
      final amount = (await tx.amountMoney.convertToDefaultCurrency()).amount;

      if (tx.type == TransactionType.income) {
        data[day]!.income += amount;
      } else if (tx.type == TransactionType.expenses) {
        data[day]!.expenses += amount;
      }
    }

    return data.values.toList();
  }

  Future<List<MonthlySummaryModel>> getMonthlyIncomeVsExpenses({
    int? categoryId,
    int? contactId,
    int? walletId,
    DateTimeRange? dateRange,
    TransactionType? type,
    List<int>? tagIds,
  }) async => _dao.getMonthlyIncomeVsExpenses(
    categoryId: categoryId,
    contactId: contactId,
    walletId: walletId,
    dateRange: dateRange,
    type: type,
    tagIds: tagIds,
  );

  Future<void> insertAll(List<TransactionModel> data) async =>
      _dao.insertAll(data);

  Future<void> createAddBalanceTransaction({
    required WalletModel wallet,
    required double amount,
  }) async {
    final DateTime now = DateTime.now();
    await create(
      TransactionModel(
        id: 0,
        amount: amount,
        type: TransactionType.income,
        walletId: wallet.id,
        categoryId: (await _categoryService.findByIdentifier(
          "add_balance",
        ))!.id,
        date: now,
        currency: wallet.currency,
        currencyRate: await CurrencyRateUtils.forCurrency(wallet.currency),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> createWithdrawBalanceTransaction({
    required WalletModel wallet,
    required double amount,
  }) async {
    final DateTime now = DateTime.now();
    await create(
      TransactionModel(
        id: 0,
        amount: amount,
        type: TransactionType.expenses,
        walletId: wallet.id,
        categoryId: (await _categoryService.findByIdentifier(
          "withdraw_balance",
        ))!.id,
        date: now,
        currency: wallet.currency,
        currencyRate: await CurrencyRateUtils.forCurrency(wallet.currency),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<bool> update(TransactionModel model, TransactionModel oldModel) async {
    final bool isUpdated = await _dao.updateTransaction(model);

    if ((oldModel.noImpactOnBalance && model.noImpactOnBalance) ||
        (oldModel.amount == model.amount &&
            oldModel.walletId == model.walletId)) {
      return isUpdated;
    }

    final WalletModel? oldWallet = await _walletService.find(oldModel.walletId);
    WalletModel? newWallet = model.walletId == oldModel.walletId
        ? oldWallet
        : await _walletService.find(model.walletId);

    if (oldWallet == null || newWallet == null) return isUpdated;

    Future<double> getSignedAmount(TransactionModel tx) async {
      if (tx.noImpactOnBalance) return 0.0;

      if (tx.type == TransactionType.income) return tx.amount;

      if (tx.type == TransactionType.expenses) return -tx.amount;

      if (tx.type == TransactionType.debts) {
        final category =
            tx.category ?? await _categoryService.find(tx.categoryId);

        final identifier =
            category?.identifier ??
            (category?.categoryId != null
                ? (await _categoryService.find(
                    category!.categoryId!,
                  ))?.identifier
                : null);

        if (identifier == 'receiving_debts_and_installments') {
          return tx.amount;
        } else if (identifier == 'paying_debts_and_installments') {
          return -tx.amount;
        }
      }

      return 0.0;
    }

    final oldAmount = await getSignedAmount(oldModel);
    final newAmount = await getSignedAmount(model);

    if (oldAmount != 0.0) {
      final updated = oldWallet.balance - oldAmount;
      await _walletService.updateBalance(oldWallet.id, updated);
      if (model.walletId == oldModel.walletId) {
        newWallet = newWallet.copyWith(balance: updated);
      }
    }

    if (newAmount != 0.0) {
      final updated = newWallet.balance + newAmount;
      await _walletService.updateBalance(newWallet.id, updated);
    }

    return isUpdated;
  }
}
