import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryService service = CategoryService();

  CategoryCubit() : super(CategoryLoading());

  Future<void> loadCategories({
    required TransactionType type,
    bool loading = false,
  }) async {
    try {
      if (loading) {
        emit(CategoryLoading());
      }
      emit(
        CategoryLoaded(
          categories: await service.getGrouped(type: type),
          selectedType: type,
        ),
      );
    } catch (e) {
      emit(CategoryError(ErrorType.failedToLoad));
    }
  }

  void deleteCategory(CategoryModel category) async {
    try {
      await service.delete(category);
      await loadCategories(type: category.type);
      emit(CategorySuccess(SuccessType.deleted));
    } catch (e) {
      emit(CategoryError(ErrorType.failedToDelete));
    }
  }

  Future<void> formInit({
    String? color,
    String? icon,
    int? categoryId,
    int? excludeId,
    TransactionType? type,
  }) async => emit(
    CategoryFormInitial(
      color: color ?? AppStrings.defaultColorPicked,
      icon: icon ?? AppIcons.defaultIconPicked,
      type: type,
      categoryId: categoryId,
      rootCategories: await service.fetchAll(
        onlyRoot: true,
        type: type,
        excludeId: excludeId,
      ),
    ),
  );

  Future<void> setData({
    String? color,
    String? icon,
    int? categoryId,
    int? excludeId,
    TransactionType? type,
    Map<String, String>? errors,
    bool loadCategories = false,
  }) async {
    if (state is CategoryFormInitial) {
      emit(
        (state as CategoryFormInitial).copyWith(
          color: color,
          icon: icon,
          type: type,
          categoryId: categoryId,
          errors: errors,
          rootCategories: loadCategories
              ? await service.fetchAll(
                  onlyRoot: true,
                  type: type,
                  excludeId: excludeId,
                )
              : null,
        ),
      );
    }
  }

  Future<bool> submit(
    Map<String, String> errorMessages,
    CategoryModel? category,
    String? name,
  ) async {
    final CategoryFormInitial form = (state as CategoryFormInitial);
    bool isSubmitted = false;
    if (await _validationForm(
      form,
      errorMessages,
      category == null ? 0 : category.id,
      name,
    )) {
      emit(form.copyWith(processing: true));
      final now = DateTime.now();

      final model = CategoryModel(
        id: category?.id ?? 0,
        name: name!,
        type: form.type!,
        icon: form.icon,
        color: form.color,
        categoryId: form.categoryId,
        createdAt: category?.createdAt ?? now,
        updatedAt: now,
      );

      isSubmitted = await (category == null
          ? _addCategory(model)
          : _updateCategory(model));

      emit(form.copyWith(processing: false, errors: {}));
    }
    return isSubmitted;
  }

  Future<bool> _addCategory(CategoryModel category) async {
    try {
      await service.create(category);
      await loadCategories(type: category.type);
      emit(CategorySuccess(SuccessType.created));
      return true;
    } catch (e) {
      emit(CategoryError(ErrorType.failedToAdd));
      return false;
    }
  }

  Future<bool> _updateCategory(CategoryModel category) async {
    try {
      await service.update(category);
      await loadCategories(type: category.type);
      emit(CategorySuccess(SuccessType.updated));
      return true;
    } catch (e) {
      emit(CategoryError(ErrorType.failedToUpdate));
      return false;
    }
  }

  Future<bool> _validationForm(
    CategoryFormInitial form,
    Map<String, String> errorMessages,
    int id,
    String? name,
  ) async {
    Map<String, String> errors = {};

    if (name == null || name.trim().isEmpty) {
      errors['name'] = errorMessages['name_is_required']!;
    } else if (name.length < 2 || name.length > 50) {
      errors['name'] =
          errorMessages['name_should_be_between_min_to_max_characters']!;
    } else if (await service.nameExists(name, type: form.type, excludeId: id)) {
      errors['name'] = errorMessages['this_name_is_already_used']!;
    }

    if (form.type == TransactionType.debts && form.categoryId == null) {
      errors['category_id'] = errorMessages['main_category_is_required']!;
    }

    if (errors.isNotEmpty) {
      emit(form.copyWith(errors: errors));
      return false;
    } else {
      return true;
    }
  }
}
