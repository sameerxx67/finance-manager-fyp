part of 'report_cubit.dart';

sealed class ReportState extends Equatable {
  const ReportState();
}

class ReportLoading extends ReportState {
  @override
  List<Object> get props => [];
}

class ReportLoaded extends ReportState {
  final CategoryModel? category;
  final ContactModel? contact;
  final TransactionType? type;
  final int? walletId;
  final DateTimeRange? dateRange;
  final List<WalletModel> wallets;
  final List<int>? tagIds;
  final List<TagModel> tags;
  final Money totalIncome;
  final Money totalExpenses;
  final Money netBalance;
  final Money debtsPaid;
  final Money debtsReceived;
  final List<MonthlySummaryModel> monthlySummaryData;
  final List<CategorySummaryModel> topIncomeCategories;
  final List<CategorySummaryModel> topExpensesCategories;
  final List<TagSummaryModel> topTags;

  const ReportLoaded({
    this.wallets = const [],
    this.category,
    this.contact,
    this.type,
    this.walletId,
    this.dateRange,
    this.tagIds,
    required this.tags,
    required this.topTags,
    required this.netBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.debtsPaid,
    required this.debtsReceived,
    required this.monthlySummaryData,
    required this.topIncomeCategories,
    required this.topExpensesCategories,
  });

  @override
  List<Object?> get props => [
    category,
    contact,
    type,
    walletId,
    dateRange,
    wallets,
    netBalance,
    totalIncome,
    totalExpenses,
    debtsPaid,
    debtsReceived,
    monthlySummaryData,
    topIncomeCategories,
    topExpensesCategories,
    tagIds,
    tags,
    topTags,
  ];
}

class ReportError extends ReportState {
  final ErrorType type;

  const ReportError(this.type);

  @override
  List<Object> get props => [type];
}
