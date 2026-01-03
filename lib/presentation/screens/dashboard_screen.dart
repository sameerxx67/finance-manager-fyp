import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class DashboardScreen extends StatelessWidget {
  final GestureTapCallback? goToTransactions;
  final GestureTapCallback refresh;

  const DashboardScreen({
    super.key,
    this.goToTransactions,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state is DashboardError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(
              context,
              context.tr!.dashboard,
              context.tr!.dashboard,
            ),
            message: state.type.message(
              context,
              context.tr!.dashboard,
              context.tr!.dashboard,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(AppImages.logo, width: 50),
                Text(context.tr!.app_name),
              ],
            ),
          ),
          body: state is DashboardLoaded
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(AppDimensions.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FinancialSummary(
                        balance: state.totalBalance,
                        expenses: state.totalExpenses,
                        income: state.totalIncome,
                      ),
                      DashboardWeeklyChart(
                        chartData: context.isRtl
                            ? state.weeklyChartData.reversed.toList()
                            : state.weeklyChartData,
                      ),
                      RecentTransactions(
                        transactions: state.recentTransactions,
                        viewAll: goToTransactions,
                        refresh: refresh,
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
