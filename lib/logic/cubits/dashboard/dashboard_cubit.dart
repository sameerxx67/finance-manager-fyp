import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final WalletService _walletService = WalletService();
  final TransactionService _transactionService = TransactionService();

  DashboardCubit() : super(DashboardLoading());

  Future<void> loadData() async {
    try {
      final totals = await _transactionService.getTotals();
      emit(
        DashboardLoaded(
          totalBalance: await _getTotalBalance(),
          totalIncome: totals.income,
          totalExpenses: totals.expenses,
          weeklyChartData: await _transactionService.getWeeklyChartData(),
          recentTransactions: await _transactionService.getRecentTransactions(),
        ),
      );
    } catch (e) {
      emit(DashboardError(ErrorType.failedToLoad));
    }
  }

  Future<Money> _getTotalBalance() async {
    final wallets = await _walletService.fetchAll(
      isLocked: false,
      isHidden: false,
    );

    double totalBalanceAmount = 0;
    for (final wallet in wallets) {
      final converted = await wallet.balanceMoney.convertToDefaultCurrency();
      totalBalanceAmount += converted.amount;
    }

    return Money.inDefaultCurrency(totalBalanceAmount);
  }
}
