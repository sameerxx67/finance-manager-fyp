import 'package:zenthory/zenthory.dart';

class BudgetService {
  static final BudgetService _instance = BudgetService._internal();

  factory BudgetService() => _instance;

  BudgetService._internal();

  final BudgetDao _dao = BudgetDao(AppDatabase.instance);

  Future<List<BudgetModel>> fetchAll({
    List<String> relations = const [],
  }) async => await _dao.getAll(relations: relations);

  Future<int> create(BudgetModel model) =>
      _dao.insertBudget(model.toInsertCompanion());

  Future<void> update(BudgetModel model) async =>
      await _dao.updateBudget(model.toEntity());

  Future<void> delete(int id) async => await _dao.deleteBudget(id);

  Future<void> insertAll(List<BudgetModel> data) async => _dao.insertAll(data);
}
