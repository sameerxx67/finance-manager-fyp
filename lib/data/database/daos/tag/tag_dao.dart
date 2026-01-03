import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/data/database/tables/tags_table.dart';
import 'package:zenthory/zenthory.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  Future<List<Tag>> getAll() =>
      (select(tags)..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
          .get();

  Future<bool> existsByName(String name, {int? excludeId}) async {
    final query = select(tags)..where((t) => t.name.equals(name.trim()));
    if (excludeId != null) {
      query.where((t) => t.id.isNotIn([excludeId]));
    }
    return await query.getSingleOrNull() != null;
  }

  Future<int> insertTag(TagsCompanion tag) => into(tags).insert(tag);

  Future<bool> updateTag(Tag tag) => update(tags).replace(tag);

  Future<int> deleteTag(int id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();

  Future<void> insertAll(List<TagModel> data) async {
    await batch((batch) {
      batch.insertAll(tags, data.map((tx) => tx.toInsertCompanion()).toList());
    });
  }

  Future<List<TagSummaryModel>> getTopTags({
    int? categoryId,
    int? contactId, // TODO: Contact Id
    int? walletId,
    DateTimeRange? dateRange,
    TransactionType? type,
    List<int>? tagIds,
    int limit = 5,
  }) async {
    final variables = <Variable>[];
    final whereClauses = <String>[
      '(w.is_locked IS NULL OR w.is_locked = false)',
    ];

    if (type != null) {
      whereClauses.add('t.type = ?');
      variables.add(Variable<String>(type.name));
    }

    if (walletId != null) {
      whereClauses.add('t.wallet_id = ?');
      variables.add(Variable<int>(walletId));
    }

    if (contactId != null) {
      whereClauses.add('t.contact_id = ?');
      variables.add(Variable<int>(contactId));
    }

    if (dateRange != null) {
      whereClauses.add('t.date BETWEEN ? AND ?');
      variables.add(Variable<DateTime>(dateRange.start));
      variables.add(Variable<DateTime>(dateRange.end));
    }

    if (categoryId != null) {
      whereClauses.add(
        '(t.category_id = ? OR EXISTS (SELECT 1 FROM categories c2 WHERE c2.id = t.category_id AND c2.category_id = ?))',
      );
      variables.add(Variable<int>(categoryId));
      variables.add(Variable<int>(categoryId));
    }

    if (tagIds != null && tagIds.isNotEmpty) {
      final tagPlaceholders = List.filled(tagIds.length, '?').join(', ');
      whereClauses.add('tt.tag_id IN ($tagPlaceholders)');
      variables.addAll(tagIds.map((id) => Variable<int>(id)));
    }

    variables.add(Variable<int>(limit));
    final whereSql = whereClauses.join(' AND ');

    final query =
        customSelect('''
    SELECT 
      tg.id, 
      tg.name, 
      tg.color,
      
      COUNT(CASE WHEN t.type = 'income' THEN 1 END) AS count_income,
      COUNT(CASE WHEN t.type = 'expenses' THEN 1 END) AS count_expenses,
      COUNT(CASE WHEN t.type = 'debts' THEN 1 END) AS count_debts,

      SUM(CASE WHEN t.type = 'income' THEN t.amount * COALESCE(t.currency_rate, 1) ELSE 0 END) AS total_income,
      SUM(CASE WHEN t.type = 'expenses' THEN t.amount * COALESCE(t.currency_rate, 1) ELSE 0 END) AS total_expenses,
      SUM(CASE WHEN t.type = 'debts' THEN t.amount * COALESCE(t.currency_rate, 1) ELSE 0 END) AS total_debts

    FROM transaction_tags tt
    INNER JOIN tags tg ON tg.id = tt.tag_id
    INNER JOIN transactions t ON t.id = tt.transaction_id
    LEFT JOIN wallets w ON w.id = t.wallet_id
    WHERE $whereSql
    GROUP BY tg.id
    ORDER BY total_income + total_expenses + total_debts DESC
    LIMIT ?
    ''', variables: variables).map(
          (row) => TagSummaryModel(
            name: row.read<String>('name'),
            color: row.read<String>('color'),
            incomeCount: row.read<int>('count_income'),
            expenseCount: row.read<int>('count_expenses'),
            debtCount: row.read<int>('count_debts'),
            incomeAmount: row.read<double>('total_income'),
            expenseAmount: row.read<double>('total_expenses'),
            debtAmount: row.read<double>('total_debts'),
          ),
        );

    return query.get();
  }
}
