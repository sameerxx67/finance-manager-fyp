import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final WalletService _walletService = WalletService();
  final TransactionService _transactionService = TransactionService();
  final CategoryService _categoryService = CategoryService();
  final TagService _tagService = TagService();

  ReportCubit() : super(ReportLoading());

  Future<void> loadData({
    CategoryModel? category,
    ContactModel? contact,
    DateTimeRange<DateTime>? dateRange,
    TransactionType? type,
    int? walletId,
    List<int>? tagIds,
  }) async {
    try {
      final totals = await _transactionService.getTotals(
        categoryId: category?.id,
        walletId: walletId,
        type: type,
        contactId: contact?.id,
        dateRange: dateRange,
        includeDebts: true,
        tagIds: tagIds,
      );

      emit(
        ReportLoaded(
          category: category,
          dateRange: dateRange,
          type: type,
          walletId: walletId,
          tagIds: tagIds,
          contact: contact,
          wallets: await _walletService.fetchAll(isLocked: false),
          tags: await _tagService.fetchAll(),
          topTags: await _tagService.getTopTags(
            categoryId: category?.id,
            walletId: walletId,
            type: type,
            dateRange: dateRange,
            contactId: contact?.id,
            tagIds: tagIds,
          ),
          totalIncome: totals.income,
          totalExpenses: totals.expenses,
          netBalance: totals.income.subtract(totals.expenses),
          debtsPaid: totals.debtsPaid,
          debtsReceived: totals.debtsReceived,
          monthlySummaryData:
              [
                null,
                TransactionType.income,
                TransactionType.expenses,
              ].contains(type)
              ? await _transactionService.getMonthlyIncomeVsExpenses(
                  type: type,
                  categoryId: category?.id,
                  contactId: contact?.id,
                  walletId: walletId,
                  dateRange: dateRange,
                  tagIds: tagIds,
                )
              : [],
          topExpensesCategories:
              type == null || type == TransactionType.expenses
              ? await _categoryService.getTopCategories(
                  type: TransactionType.expenses,
                  categoryId: category?.id,
                  walletId: walletId,
                  contactId: contact?.id,
                  dateRange: dateRange,
                  tagIds: tagIds,
                )
              : [],
          topIncomeCategories: type == null || type == TransactionType.income
              ? await _categoryService.getTopCategories(
                  type: TransactionType.income,
                  categoryId: category?.id,
                  contactId: contact?.id,
                  walletId: walletId,
                  dateRange: dateRange,
                  tagIds: tagIds,
                )
              : [],
        ),
      );
    } catch (e) {
      emit(ReportError(ErrorType.failedToLoad));
    }
  }
}
