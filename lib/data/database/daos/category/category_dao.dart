import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/data/database/tables/categories_table.dart';
import 'package:zenthory/zenthory.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<List<Category>> getAll({
    TransactionType? type,
    int? excludeId,
    bool onlyRoot = false,
  }) {
    final query = select(categories)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    if (type != null) {
      query.where((t) => t.type.equals(type.name));
    }

    if (onlyRoot) {
      query.where((t) => t.categoryId.isNull());
    }

    if (excludeId != null) {
      query.where((t) => t.id.isNotIn([excludeId]));
    }

    return query.get();
  }

  Future<List<CategoryModel>> getGrouped({TransactionType? type}) async {
    final query = select(categories)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    if (type != null) {
      query.where((t) => t.type.equals(type.name));
    }

    final Map<int?, List<CategoryModel>> groupedByParent = {};

    for (final model
        in (await query.get()).map(CategoryModel.fromEntity).toList()) {
      groupedByParent.putIfAbsent(model.categoryId, () => []).add(model);
    }

    void attachSubcategories(CategoryModel category) {
      final children = groupedByParent[category.id] ?? [];
      category.categories = children;
      for (final child in children) {
        attachSubcategories(child);
      }
    }

    final List<CategoryModel> rootCategories = groupedByParent[null] ?? [];
    for (final root in rootCategories) {
      attachSubcategories(root);
    }

    return rootCategories;
  }

  Future<int> insertCategory(CategoriesCompanion entry) =>
      into(categories).insert(entry);

  Future<bool> updateCategory(Category entry) =>
      update(categories).replace(entry);

  Future<int> deleteCategory(int id) =>
      (delete(categories)..where((t) => t.id.equals(id))).go();

  Future<Category?> find(int id) =>
      (select(categories)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Category?> findByIdentifier(String identifier) => (select(
    categories,
  )..where((t) => t.identifier.equals(identifier))).getSingleOrNull();

  Future<bool> existsByName(
    String name, {
    int? excludeId,
    TransactionType? type,
  }) async {
    final query = select(categories)
      ..where((t) {
        final nameCondition = t.name.equals(name.trim());
        final excludeIdCondition = excludeId != null
            ? t.id.isNotIn([excludeId])
            : const Constant(true);
        final typeCondition = type != null
            ? t.type.equals(type.name)
            : const Constant(true);
        return nameCondition & excludeIdCondition & typeCondition;
      });

    return await query.getSingleOrNull() != null;
  }

  Future<Category?> findByName(
    String name, {
    int? excludeId,
    TransactionType? type,
  }) async {
    final query = select(categories)
      ..where((t) {
        final nameCondition = t.name.equals(name.trim());
        final excludeIdCondition = excludeId != null
            ? t.id.isNotIn([excludeId])
            : const Constant(true);
        final typeCondition = type != null
            ? t.type.equals(type.name)
            : const Constant(true);
        return nameCondition & excludeIdCondition & typeCondition;
      });

    return await query.getSingleOrNull();
  }

  Future<List<CategorySummaryModel>> getTopCategories({
    required TransactionType type,
    int? categoryId,
    int? contactId, //TODO: ContactId
    int? walletId,
    DateTimeRange<DateTime>? dateRange,
    List<int>? tagIds,
    int limit = 5,
  }) async {
    final variables = <Variable>[Variable<String>(type.name)];

    final whereClauses = <String>[
      't.type = ?',
      '(w.is_locked IS NULL OR w.is_locked = false)',
    ];

    if (dateRange != null) {
      whereClauses.add('t.date BETWEEN ? AND ?');
      variables.add(Variable<DateTime>(dateRange.start));
      variables.add(Variable<DateTime>(dateRange.end));
    }

    if (walletId != null) {
      whereClauses.add('t.wallet_id = ?');
      variables.add(Variable<int>(walletId));
    }

    if (contactId != null) {
      whereClauses.add('t.contact_id = ?');
      variables.add(Variable<int>(contactId));
    }

    if (categoryId != null) {
      whereClauses.add('t.category_id = ?');
      variables.add(Variable<int>(categoryId));
    }

    String tagJoin = '';
    if (tagIds != null && tagIds.isNotEmpty) {
      tagJoin = '''
      INNER JOIN transaction_tags tt ON tt.transaction_id = t.id
      INNER JOIN tags tg ON tg.id = tt.tag_id
    ''';
      whereClauses.add(
        'tt.tag_id IN (${List.filled(tagIds.length, '?').join(', ')})',
      );
      variables.addAll(tagIds.map((id) => Variable<int>(id)));
    }

    variables.add(Variable<int>(limit));
    final whereSql = whereClauses.join(' AND ');

    final query =
        customSelect('''
    SELECT c.id, c.name, c.color, c.icon, SUM(t.amount * COALESCE(t.currency_rate, 1)) as total
    FROM transactions t
    INNER JOIN categories c ON c.id = t.category_id
    LEFT JOIN wallets w ON w.id = t.wallet_id
    $tagJoin
    WHERE $whereSql
    GROUP BY c.id
    ORDER BY total DESC
    LIMIT ?
    ''', variables: variables).map(
          (row) => CategorySummaryModel(
            id: row.read<int>('id'),
            name: row.read<String>('name'),
            icon: row.read<String>('icon'),
            color: row.read<String>('color'),
            total: Money.inDefaultCurrency(row.read<double>('total')),
          ),
        );

    return query.get();
  }
}
