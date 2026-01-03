part of 'category_cubit.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryLoading extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryLoaded extends CategoryState {
  final TransactionType selectedType;
  final List<CategoryModel> categories;

  const CategoryLoaded({required this.categories, required this.selectedType});

  @override
  List<Object> get props => [categories, selectedType];
}

class CategoryError extends CategoryState {
  final ErrorType type;

  const CategoryError(this.type);

  @override
  List<Object> get props => [type];
}

class CategorySuccess extends CategoryState {
  final SuccessType type;

  const CategorySuccess(this.type);

  @override
  List<Object> get props => [type];
}

final class CategoryFormInitial extends CategoryState {
  final String color;
  final String icon;
  final List<CategoryModel> rootCategories;
  final int? categoryId;
  final TransactionType? type;
  final bool processing;
  final Map<String, String> errors;

  const CategoryFormInitial({
    required this.color,
    required this.icon,
    this.categoryId,
    this.type,
    required this.rootCategories,
    this.processing = false,
    this.errors = const {},
  });

  CategoryFormInitial copyWith({
    String? color,
    int? categoryId,
    TransactionType? type,
    String? icon,
    bool? processing,
    List<CategoryModel>? rootCategories,
    Map<String, String>? errors,
  }) {
    return CategoryFormInitial(
      color: color ?? this.color,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      rootCategories: rootCategories ?? this.rootCategories,
      categoryId: rootCategories != null
          ? null
          : (categoryId ?? this.categoryId),
      processing: processing ?? this.processing,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
    color,
    icon,
    type,
    errors,
    categoryId,
    rootCategories,
    processing,
  ];
}
