import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/data/database/tables/tags_table.dart';
import 'package:zenthory/data/database/tables/transaction_tags_table.dart';
import 'package:zenthory/data/database/tables/transactions_table.dart';
import 'package:zenthory/zenthory.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, Tags, TransactionTags])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<int> insertTransaction(TransactionModel transaction) async {
    final int id = await into(
      transactions,
    ).insert(transaction.toInsertCompanion());
    await syncTransactionTags(transactionId: id, tagIds: transaction.tagIds);
    return id;
  }

  Future<bool> updateTransaction(TransactionModel transaction) async {
    final bool isUpdated = await update(
      transactions,
    ).replace(transaction.toEntity());
    await syncTransactionTags(
      transactionId: transaction.id,
      tagIds: transaction.tagIds,
    );
    return isUpdated;
  }

  Future<int> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.id.equals(id))).go();

  Future<List<TransactionModel>> pagination({
    CategoryModel? category,
    ContactModel? contact,
    DateTimeRange<DateTime>? dateRange,
    TransactionType? type,
    int? walletId,
    List<int>? tagIds,
    int offset = 0,
    int limit = AppStrings.paginationLimit,
  }) async {
    final condition = <Expression<bool>>[];

    condition.add(wallets.isLocked.equals(false));

    if (category != null) {
      condition.add(
        transactions.categoryId.equals(category.id) |
            categories.categoryId.equals(category.id),
      );
    }

    if (type != null) {
      condition.add(transactions.type.equalsValue(type));
    }

    if (walletId != null) {
      condition.add(transactions.walletId.equals(walletId));
    }

    if (contact != null) {
      condition.add(transactions.contactId.equals(contact.id));
    }

    if (dateRange != null) {
      condition.add(
        transactions.date.isBetweenValues(dateRange.start, dateRange.end),
      );
    }

    final joins = [
      leftOuterJoin(wallets, wallets.id.equalsExp(transactions.walletId)),
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      leftOuterJoin(contacts, contacts.id.equalsExp(transactions.contactId)),
    ];

    if (tagIds != null && tagIds.isNotEmpty) {
      joins.add(
        innerJoin(
          transactionTags,
          transactionTags.transactionId.equalsExp(transactions.id),
        ),
      );
      joins.add(innerJoin(tags, tags.id.equalsExp(transactionTags.tagId)));

      condition.add(transactionTags.tagId.isIn(tagIds));
    }

    final txIds =
        (await (select(transactions).join(joins)
                  ..where(condition.reduce((a, b) => a & b))
                  ..orderBy([OrderingTerm.desc(transactions.date)])
                  ..limit(limit, offset: offset))
                .get())
            .map((row) => row.readTable(transactions).id);

    if (tagIds == null || tagIds.isEmpty) {
      joins.addAll([
        leftOuterJoin(
          transactionTags,
          transactionTags.transactionId.equalsExp(transactions.id),
        ),
        leftOuterJoin(tags, tags.id.equalsExp(transactionTags.tagId)),
      ]);
    }

    final query = select(transactions).join(joins)
      ..where(condition.reduce((a, b) => a & b))
      ..orderBy([OrderingTerm.desc(transactions.date)])
      ..where(transactions.id.isIn(txIds));

    final rows = await query.get();

    // Group transactions by ID and collect tags
    final Map<int, TransactionModel> txMap = {};
    final Map<int, List<TagModel>> txTags = {};
    for (final row in rows) {
      final tx = row.readTable(transactions);
      final wallet = row.readTableOrNull(wallets);
      final cat = row.readTableOrNull(categories);
      final tag = row.readTableOrNull(tags);
      final contact = row.readTableOrNull(contacts);

      if (!txMap.containsKey(tx.id)) {
        txMap[tx.id] = TransactionModel(
          id: tx.id,
          amount: tx.amount,
          type: tx.type,
          walletId: tx.walletId,
          wallet: wallet != null ? WalletModel.fromEntity(wallet) : null,
          categoryId: tx.categoryId,
          category: cat != null ? CategoryModel.fromEntity(cat) : null,
          tags: [],
          date: tx.date,
          note: tx.note,
          startDate: tx.startDate,
          endDate: tx.endDate,
          contactId: tx.contactId,
          contact: contact != null ? ContactModel.fromEntity(contact) : null,
          currency: tx.currency,
          currencyRate: tx.currencyRate,
          noImpactOnBalance: tx.noImpactOnBalance,
          createdAt: tx.createdAt,
          updatedAt: tx.updatedAt,
        );
        txTags[tx.id] = [];
      }

      if (tag != null && tag.id != 0) {
        txTags[tx.id]!.add(TagModel.fromEntity(tag));
      }
    }

    for (final entry in txTags.entries) {
      txMap[entry.key] = txMap[entry.key]!.copyWith(
        tags: entry.value,
        tagIds: entry.value.map((TagModel tag) => tag.id).toList(),
      );
    }

    return txMap.values.toList();
  }

  Future<List<TransactionModel>> getRecentTransactions({int limit = 5}) async {
    return await pagination(limit: limit);
  }

  Future<bool> hasTransactions() async {
    final countExp = transactions.id.count();
    return ((await (selectOnly(
              transactions,
            )..addColumns([countExp])).getSingle()).read(countExp) ??
            0) >
        0;
  }

  Future<List<TransactionModel>> getBetween(
    DateTime start,
    DateTime end,
  ) async {
    final query =
        select(transactions).join([
          leftOuterJoin(wallets, wallets.id.equalsExp(transactions.walletId)),
        ])..where(
          transactions.date.isBetweenValues(start, end) &
              wallets.isLocked.equals(false),
        );

    final rows = await query.get();

    return rows
        .map((row) => TransactionModel.fromEntity(row.readTable(transactions)))
        .toList();
  }

  Future<
    ({double income, double expenses, double debtsPaid, double debtsReceived})
  >
  getTotals({
    int? categoryId,
    int? contactId, // TODO: contact id
    int? walletId,
    TransactionType? type,
    DateTimeRange<DateTime>? dateRange,
    List<int>? tagIds,
    bool includeDebts = false,
  }) async {
    final whereClauses = <String>[];
    final variables = <Variable>[];

    if (categoryId != null) {
      whereClauses.add('(t.category_id = ? OR c.category_id = ?)');
      variables.add(Variable.withInt(categoryId));
      variables.add(Variable.withInt(categoryId));
    }

    if (walletId != null) {
      whereClauses.add('t.wallet_id = ?');
      variables.add(Variable.withInt(walletId));
    }

    if (contactId != null) {
      whereClauses.add('t.contact_id = ?');
      variables.add(Variable.withInt(contactId));
    }

    if (type != null) {
      whereClauses.add('t.type = ?');
      variables.add(Variable.withString(type.name));
    }

    if (dateRange != null) {
      whereClauses.add('t.date BETWEEN ? AND ?');
      variables.add(Variable.withDateTime(dateRange.start));
      variables.add(Variable.withDateTime(dateRange.end));
    }

    whereClauses.add('w.is_locked = false');

    // Add tag filtering if tagIds are provided
    String tagJoin = '';
    if (tagIds != null && tagIds.isNotEmpty) {
      tagJoin = '''
    INNER JOIN transaction_tags tt ON t.id = tt.transaction_id
    INNER JOIN tags tg ON tt.tag_id = tg.id
    ''';
      whereClauses.add(
        'tt.tag_id IN (${List.filled(tagIds.length, '?').join(', ')})',
      );
      variables.addAll(tagIds.map((id) => Variable.withInt(id)));
    }

    final selectFields = [
      "SUM(CASE WHEN t.type = 'income' THEN t.amount * COALESCE(t.currency_rate, 1) ELSE 0 END) AS total_income",
      "SUM(CASE WHEN t.type = 'expenses' THEN t.amount * COALESCE(t.currency_rate, 1) ELSE 0 END) AS total_expenses",
    ];

    if (includeDebts) {
      selectFields.addAll([
        '''
      SUM(CASE 
        WHEN t.type = 'debts' AND (
          c.identifier = 'paying_debts_and_installments' OR
          EXISTS (
            SELECT 1 FROM categories parent
            WHERE parent.id = c.category_id AND parent.identifier = 'paying_debts_and_installments'
          )
        )
        THEN t.amount * COALESCE(t.currency_rate, 1) 
        ELSE 0 
      END) AS total_debts_paid
      ''',
        '''
      SUM(CASE 
        WHEN t.type = 'debts' AND (
          c.identifier = 'receiving_debts_and_installments' OR
          EXISTS (
            SELECT 1 FROM categories parent
            WHERE parent.id = c.category_id AND parent.identifier = 'receiving_debts_and_installments'
          )
        )
        THEN t.amount * COALESCE(t.currency_rate, 1) 
        ELSE 0 
      END) AS total_debts_received
      ''',
      ]);
    }

    final query =
        '''
    SELECT
      ${selectFields.join(',\n')}
    FROM transactions t
    LEFT JOIN wallets w ON t.wallet_id = w.id
    LEFT JOIN categories c ON t.category_id = c.id
    $tagJoin
    ${whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : ''}
  ''';

    final result = await customSelect(query, variables: variables).getSingle();

    return (
      income: result.read<double?>('total_income') ?? 0.0,
      expenses: result.read<double?>('total_expenses') ?? 0.0,
      debtsPaid: result.read<double?>('total_debts_paid') ?? 0.0,
      debtsReceived: result.read<double?>('total_debts_received') ?? 0.0,
    );
  }

  Future<List<MonthlySummaryModel>> getMonthlyIncomeVsExpenses({
    int? categoryId,
    int? contactId, // TODO: Handler contact id
    int? walletId,
    DateTimeRange? dateRange,
    TransactionType? type,
    List<int>? tagIds,
  }) async {
    final now = DateTime.now();

    final range =
        dateRange ??
        DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year, 12, 31, 23, 59, 59),
        );

    final variables = <Variable>[
      Variable.withDateTime(range.start),
      Variable.withDateTime(range.end),
    ];

    final whereClauses = <String>[
      't.date BETWEEN ? AND ?',
      'w.is_locked = false',
    ];

    if (categoryId != null) {
      whereClauses.add('(t.category_id = ? OR c.category_id = ?)');
      variables.add(Variable.withInt(categoryId));
      variables.add(Variable.withInt(categoryId));
    }

    if (walletId != null) {
      whereClauses.add('t.wallet_id = ?');
      variables.add(Variable.withInt(walletId));
    }

    if (contactId != null) {
      whereClauses.add('t.contact_id = ?');
      variables.add(Variable.withInt(contactId));
    }

    if (type != null) {
      whereClauses.add('t.type = ?');
      variables.add(Variable.withString(type.name));
    }

    String joinTags = '';
    if (tagIds != null && tagIds.isNotEmpty) {
      joinTags = '''
      INNER JOIN transaction_tags tt ON tt.transaction_id = t.id
      INNER JOIN tags tg ON tg.id = tt.tag_id
    ''';

      whereClauses.add(
        'tt.tag_id IN (${List.filled(tagIds.length, '?').join(', ')})',
      );
      variables.addAll(tagIds.map((id) => Variable.withInt(id)));
    }

    final whereSql = whereClauses.join(' AND ');

    final query =
        customSelect('''
    SELECT 
      STRFTIME('%Y-%m', t.date, 'unixepoch') AS label,
      SUM(CASE WHEN t.type = 'income' THEN t.amount * COALESCE(t.currency_rate, 1) ELSE 0 END) AS income,
      SUM(CASE WHEN t.type = 'expenses' THEN t.amount * COALESCE(t.currency_rate, 1) ELSE 0 END) AS expenses
    FROM transactions t
    LEFT JOIN wallets w ON w.id = t.wallet_id
    LEFT JOIN categories c ON t.category_id = c.id
    $joinTags
    WHERE $whereSql
    GROUP BY label
    ORDER BY MIN(t.date)
    ''', variables: variables).map(
          (row) => MonthlySummaryModel(
            label: row.read<String?>('label') ?? '',
            income: row.read<double?>('income') ?? 0.0,
            expenses: row.read<double?>('expenses') ?? 0.0,
          ),
        );

    return query.get();
  }

  Future<void> insertAll(List<TransactionModel> data) async {
    await batch((batch) {
      batch.insertAll(
        transactions,
        data.map((tx) => tx.toInsertCompanion()).toList(),
      );
    });
  }

  Future<void> syncTransactionTags({
    required int transactionId,
    required List<int> tagIds,
  }) async {
    await db.transaction(() async {
      await (delete(
        db.transactionTags,
      )..where((t) => t.transactionId.equals(transactionId))).go();
      if (tagIds.isNotEmpty) {
        await db.batch((batch) {
          batch.insertAll(
            db.transactionTags,
            tagIds.map((tagId) {
              return TransactionTagsCompanion.insert(
                transactionId: transactionId,
                tagId: tagId,
              );
            }).toList(),
          );
        });
      }
    });
  }

  Future<TransactionModel?> find(int id) async {
    final joins = [
      leftOuterJoin(wallets, wallets.id.equalsExp(transactions.walletId)),
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      ),
      leftOuterJoin(contacts, contacts.id.equalsExp(transactions.contactId)),
      leftOuterJoin(
        transactionTags,
        transactionTags.transactionId.equalsExp(transactions.id),
      ),
      leftOuterJoin(tags, tags.id.equalsExp(transactionTags.tagId)),
    ];

    final query = select(transactions).join(joins)
      ..where(transactions.id.equals(id));

    final rows = await query.get();

    if (rows.isEmpty) return null;

    // Group tags for the transaction
    final List<TagModel> tagList = [];
    TransactionModel? txModel;

    for (final row in rows) {
      final tx = row.readTable(transactions);
      final wallet = row.readTableOrNull(wallets);
      final cat = row.readTableOrNull(categories);
      final contact = row.readTableOrNull(contacts);
      final tag = row.readTableOrNull(tags);

      txModel ??= TransactionModel(
        id: tx.id,
        amount: tx.amount,
        type: tx.type,
        walletId: tx.walletId,
        wallet: wallet != null ? WalletModel.fromEntity(wallet) : null,
        categoryId: tx.categoryId,
        category: cat != null ? CategoryModel.fromEntity(cat) : null,
        tags: [],
        date: tx.date,
        note: tx.note,
        startDate: tx.startDate,
        endDate: tx.endDate,
        contactId: tx.contactId,
        contact: contact != null ? ContactModel.fromEntity(contact) : null,
        currency: tx.currency,
        currencyRate: tx.currencyRate,
        noImpactOnBalance: tx.noImpactOnBalance,
        createdAt: tx.createdAt,
        updatedAt: tx.updatedAt,
      );

      if (tag != null && tag.id != 0) {
        tagList.add(TagModel.fromEntity(tag));
      }
    }

    return txModel?.copyWith(
      tags: tagList,
      tagIds: tagList.map((t) => t.id).toList(),
    );
  }
}
