part of 'budget_cubit.dart';

sealed class BudgetState extends Equatable {
  const BudgetState();
}

class BudgetLoading extends BudgetState {
  @override
  List<Object> get props => [];
}

class BudgetLoaded extends BudgetState {
  final List<BudgetModel> budgets;

  const BudgetLoaded(this.budgets);

  @override
  List<Object?> get props => [budgets];
}

class BudgetError extends BudgetState {
  final ErrorType type;

  const BudgetError(this.type);

  @override
  List<Object?> get props => [type];
}

class BudgetSuccess extends BudgetState {
  final SuccessType type;

  const BudgetSuccess(this.type);

  @override
  List<Object?> get props => [type];
}

class BudgetFormInitial extends BudgetState {
  final List<WalletModel> wallets;
  final List<CategoryModel> categories;
  final DateTime startDate;
  final DateTime endDate;
  final int? categoryId;
  final int? walletId;
  final bool processing;
  final Map<String, String> errors;

  const BudgetFormInitial({
    required this.startDate,
    required this.endDate,
    required this.wallets,
    required this.categories,
    this.categoryId,
    this.walletId,
    this.processing = false,
    this.errors = const {},
  });

  BudgetFormInitial copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? categoryId,
    int? walletId,
    String? note,
    bool? processing,
    Map<String, String>? errors,
  }) {
    return BudgetFormInitial(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: categoryId ?? this.categoryId,
      walletId: walletId ?? this.walletId,
      processing: processing ?? this.processing,
      errors: errors ?? this.errors,
      categories: categories,
      wallets: wallets,
    );
  }

  BudgetFormInitial reset() {
    return BudgetFormInitial(
      startDate: startDate,
      endDate: endDate,
      categoryId: null,
      walletId: null,
      processing: false,
      errors: {},
      categories: [],
      wallets: [],
    );
  }

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    categoryId,
    walletId,
    wallets,
    categories,
    processing,
    errors,
  ];
}
