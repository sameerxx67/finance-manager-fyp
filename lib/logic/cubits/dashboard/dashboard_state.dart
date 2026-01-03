part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardLoading extends DashboardState {
  @override
  List<Object> get props => [];
}

class DashboardLoaded extends DashboardState {
  final Money totalBalance;
  final Money totalIncome;
  final Money totalExpenses;
  final List<WeeklyChartDataModel> weeklyChartData;
  final List<TransactionModel> recentTransactions;

  const DashboardLoaded({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.weeklyChartData,
    required this.recentTransactions,
  });

  @override
  List<Object> get props => [
    totalBalance,
    totalIncome,
    totalExpenses,
    weeklyChartData,
    recentTransactions,
  ];
}

class DashboardError extends DashboardState {
  final ErrorType type;

  const DashboardError(this.type);

  @override
  List<Object> get props => [type];
}
