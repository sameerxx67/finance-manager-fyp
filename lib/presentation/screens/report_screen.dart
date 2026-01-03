import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(
              context,
              context.tr!.report,
              context.tr!.report,
            ),
            message: state.type.message(
              context,
              context.tr!.report,
              context.tr!.report,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: HomeAppBar(
            icon: AppIcons.report,
            title: context.tr!.report,
            actions: [
              if (state is ReportLoaded)
                IconButton(
                  onPressed: () => _openFilter(context, state),
                  icon: SvgIcon(
                    icon: AppIcons.filters,
                    width: 19,
                    color: context.colors.textPrimary,
                  ),
                ),
            ],
          ),
          extendBodyBehindAppBar: (state is ReportLoaded) ? false : true,
          body: state is ReportLoaded
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(AppDimensions.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReportSummary(context, state),
                      MonthlySummary(data: state.monthlySummaryData),
                      DebtsSummary(
                        paid: state.debtsPaid,
                        received: state.debtsReceived,
                      ),
                      _buildCategoriesSummary(context, state),
                      TagsSummary(tags: state.topTags),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildReportSummary(BuildContext context, ReportLoaded state) {
    return Column(
      children: [
        ReportSummary(
          title: context.tr!.financial_summary,
          icon: AppIcons.financialSummary,
          items: [
            ReportSummaryItemModel(
              title: context.tr!.net_balance,
              amount: state.netBalance,
              color: Color(0XFF2980b9),
              exceptTotal: true,
            ),
            ReportSummaryItemModel(
              title: context.tr!.total_income,
              amount: state.totalIncome,
              color: TransactionType.income.color,
            ),
            ReportSummaryItemModel(
              title: context.tr!.total_expenses,
              amount: state.totalExpenses,
              color: TransactionType.expenses.color,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSummary(BuildContext context, ReportLoaded state) {
    return Column(
      children: [
        CategoriesSummary(
          title: context.tr!.report_categories_income_title,
          subtitle: context.tr!.report_categories_income_subtitle,
          categories: state.topIncomeCategories,
          icon: TransactionType.income.icon,
          color: TransactionType.income.color,
        ),
        CategoriesSummary(
          title: context.tr!.report_categories_expenses_title,
          subtitle: context.tr!.report_categories_expenses_subtitle,
          categories: state.topExpensesCategories,
          icon: TransactionType.expenses.icon,
          color: TransactionType.expenses.color,
        ),
      ],
    );
  }

  void _openFilter(BuildContext context, ReportLoaded state) {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => BlocProvider.value(
        value: context.read<ReportCubit>(),
        child: ReportFilterModalBottomSheet(
          category: state.category,
          type: state.type,
          contact: state.contact,
          walletId: state.walletId,
          wallets: state.wallets,
          dateRange: state.dateRange,
          tags: state.tags,
          tagIds: state.tagIds,
          onChange:
              ({
                CategoryModel? category,
                ContactModel? contact,
                DateTimeRange<DateTime>? dateRange,
                TransactionType? type,
                int? walletId,
                List<int>? tagIds,
              }) {
                context.read<ReportCubit>().loadData(
                  category: category,
                  contact: contact,
                  dateRange: dateRange,
                  type: type,
                  walletId: walletId,
                  tagIds: tagIds,
                );
              },
        ),
      ),
      backgroundColor: context.colors.background,
    );
  }
}
