import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final BudgetService service = BudgetService();
  final WalletService walletService = WalletService();
  final CategoryService categoryService = CategoryService();

  BudgetCubit() : super(BudgetLoading());

  Future<void> loadBudgets() async {
    try {
      emit(BudgetLoaded(await service.fetchAll(relations: ['category'])));
    } catch (e) {
      emit(BudgetError(ErrorType.failedToLoad));
    }
  }

  void deleteBudget(int id) async {
    try {
      await service.delete(id);
      await loadBudgets();
      emit(BudgetSuccess(SuccessType.deleted));
    } catch (e) {
      emit(BudgetError(ErrorType.failedToDelete));
    }
  }

  Future<void> formInit({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? walletId,
  }) async {
    emit(
      BudgetFormInitial(
        wallets: await walletService.fetchAll(isLocked: false),
        categories: (await categoryService.getGrouped(
          type: TransactionType.expenses,
        )),
        startDate: startDate ?? DateTime.now(),
        endDate:
            endDate ??
            DateTime.now().add(
              const Duration(days: AppStrings.defaultBudgetDurationDays),
            ),
        categoryId: categoryId,
        walletId: walletId,
      ),
    );
  }

  void setData({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? walletId,
    String? note,
  }) {
    if (state is BudgetFormInitial) {
      emit(
        (state as BudgetFormInitial).copyWith(
          startDate: startDate,
          endDate: endDate,
          categoryId: categoryId,
          walletId: walletId,
          note: note,
        ),
      );
    }
  }

  Future<bool> submit(
    Map<String, String> errorMessages,
    BudgetModel? budget,
    String? name,
    double? amount,
    String? note,
  ) async {
    final form = state as BudgetFormInitial;
    bool isSubmitted = false;

    if (await _validationForm(
      form,
      errorMessages,
      budget?.id ?? 0,
      name,
      amount,
      note,
    )) {
      emit(form.copyWith(processing: true));
      final now = DateTime.now();

      final model = BudgetModel(
        id: budget?.id ?? 0,
        name: name!,
        startDate: form.startDate,
        endDate: form.endDate,
        categoryId: form.categoryId!,
        walletId: form.walletId,
        amount: amount!,
        note: note,
        createdAt: budget?.createdAt ?? now,
        updatedAt: now,
      );

      if (budget == null) {
        isSubmitted = await _addBudget(model);
      } else {
        isSubmitted = await _updateBudget(model);
      }

      emit(form.reset());
    }

    return isSubmitted;
  }

  Future<bool> _addBudget(BudgetModel model) async {
    try {
      await service.create(model);
      await loadBudgets();
      emit(BudgetSuccess(SuccessType.created));
      return true;
    } catch (_) {
      emit(BudgetError(ErrorType.failedToAdd));
      return false;
    }
  }

  Future<bool> _updateBudget(BudgetModel model) async {
    try {
      await service.update(model);
      await loadBudgets();
      emit(BudgetSuccess(SuccessType.updated));
      return true;
    } catch (_) {
      emit(BudgetError(ErrorType.failedToUpdate));
      return false;
    }
  }

  Future<bool> _validationForm(
    BudgetFormInitial form,
    Map<String, String> errorMessages,
    int id,
    String? name,
    double? amount,
    String? note,
  ) async {
    final Map<String, String> errors = {};

    if (name == null || name.trim().isEmpty) {
      errors['name'] = errorMessages['name_is_required']!;
    } else if (name.length < 2 || name.length > 50) {
      errors['name'] =
          errorMessages['name_should_be_between_min_to_max_characters']!;
    }

    if (note != null && note.length > 200) {
      errors['note'] = errorMessages['note_must_not_exceed_number_characters']!;
    }

    if (form.categoryId == null || form.categoryId! < 1) {
      errors['category'] = errorMessages['category_is_required']!;
    }

    if (amount == null) {
      errors['amount'] = errorMessages['amount_is_required']!;
    } else if (amount < 0) {
      errors['amount'] = errorMessages['amount_must_be_greater_than']!;
    }

    if (form.endDate.isBefore(form.startDate)) {
      errors['date'] = errorMessages['end_date_must_be_after_start_date']!;
    }

    if (errors.isNotEmpty) {
      emit(form.copyWith(errors: errors));
      return false;
    }

    return true;
  }
}
