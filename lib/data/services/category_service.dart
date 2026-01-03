import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._internal();

  factory CategoryService() => _instance;

  CategoryService._internal();

  final CategoryDao _dao = CategoryDao(AppDatabase.instance);
  final WalletService _walletService = WalletService();

  Future<List<CategoryModel>> fetchAll({
    TransactionType? type,
    int? excludeId,
    bool onlyRoot = false,
  }) async => (await _dao.getAll(
    type: type,
    onlyRoot: onlyRoot,
    excludeId: excludeId,
  )).map(CategoryModel.fromEntity).toList();

  Future<List<CategoryModel>> getGrouped({TransactionType? type}) async =>
      await _dao.getGrouped(type: type);

  Future<int> create(CategoryModel model) =>
      _dao.insertCategory(model.toInsertCompanion());

  Future<void> update(CategoryModel model) async =>
      await _dao.updateCategory(model.toEntity());

  Future<void> delete(CategoryModel category) async {
    await _dao.deleteCategory(category.id);
    await _walletService.recalculateWalletsBalance();
  }

  Future<CategoryModel?> find(int id) async {
    final Category? category = await _dao.find(id);
    return category == null ? null : CategoryModel.fromEntity(category);
  }

  Future<CategoryModel?> findByIdentifier(String identifier) async {
    final Category? category = await _dao.findByIdentifier(identifier);
    return category == null ? null : CategoryModel.fromEntity(category);
  }

  Future<bool> nameExists(
    String name, {
    int? excludeId,
    TransactionType? type,
  }) => _dao.existsByName(name, excludeId: excludeId, type: type);

  Future<CategoryModel?> findByName(
    String name, {
    int? excludeId,
    TransactionType? type,
  }) async {
    final Category? category = await _dao.findByName(
      name,
      excludeId: excludeId,
      type: type,
    );
    return category != null ? CategoryModel.fromEntity(category) : null;
  }

  Future<List<CategorySummaryModel>> getTopCategories({
    required TransactionType type,
    int? categoryId,
    int? contactId,
    int? walletId,
    DateTimeRange<DateTime>? dateRange,
    List<int>? tagIds,
    int limit = 5,
  }) async {
    return _dao.getTopCategories(
      type: type,
      categoryId: categoryId,
      contactId: contactId,
      walletId: walletId,
      dateRange: dateRange,
      limit: limit,
      tagIds: tagIds,
    );
  }
}
