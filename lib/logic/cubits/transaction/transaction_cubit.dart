import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionService service = TransactionService();
  final WalletService _walletService = WalletService();
  final TagService _tagService = TagService();

  TransactionCubit() : super(TransactionLoading());

  Future<void> loadTransactions({
    CategoryModel? category,
    ContactModel? contact,
    DateTimeRange<DateTime>? dateRange,
    TransactionType? type,
    int? walletId,
    List<int>? tagIds,
  }) async {
    try {
      final List<TransactionModel> transactions = await service
          .getTransactionPagination(
            category: category,
            dateRange: dateRange,
            type: type,
            walletId: walletId,
            tagIds: tagIds,
            contact: contact,
          );
      emit(
        TransactionLoaded(
          transactions: service.groupTransactionsByDate(transactions),
          offset: transactions.length,
          hasMore: transactions.length > AppStrings.paginationLimit - 1,
          wallets: await _walletService.fetchAll(isLocked: false),
          category: category,
          contact: contact,
          dateRange: dateRange,
          type: type,
          walletId: walletId,
          tags: await _tagService.fetchAll(),
          tagIds: tagIds,
        ),
      );
    } catch (e) {
      emit(TransactionError(ErrorType.failedToLoad));
    }
  }

  Future<void> loadMoreTransactions() async {
    if (state is TransactionLoaded) {
      TransactionLoaded transactionLoadedState = (state as TransactionLoaded);
      if (!transactionLoadedState.hasMore) return;

      final list = await service.getTransactionPagination(
        offset: transactionLoadedState.offset,
        category: transactionLoadedState.category,
        dateRange: transactionLoadedState.dateRange,
        type: transactionLoadedState.type,
        walletId: transactionLoadedState.walletId,
      );

      if (list.isEmpty) {
        emit(transactionLoadedState.copyWith(hasMore: false));
        return;
      }

      final newGroups = service.groupTransactionsByDate(list);

      final List<TransactionGroupedByDateModel> groupedTransactions =
          transactionLoadedState.transactions;
      for (final group in newGroups) {
        final existingGroup = groupedTransactions.firstWhere(
          (g) => g.date == group.date,
          orElse: () =>
              TransactionGroupedByDateModel(date: group.date, transactions: []),
        );

        if (existingGroup.transactions.isEmpty) {
          groupedTransactions.add(group);
        } else {
          existingGroup.transactions.addAll(group.transactions);
        }
      }

      groupedTransactions.sort((a, b) => b.date.compareTo(a.date));
      emit(
        transactionLoadedState.copyWith(
          transactions: groupedTransactions,
          offset: list.length + transactionLoadedState.offset,
          hasMore: list.length > AppStrings.paginationLimit - 1,
        ),
      );
    }
  }

  void deleteTransaction(TransactionModel transaction) async {
    try {
      await service.delete(transaction);
      await loadTransactions();
      emit(TransactionSuccess(SuccessType.deleted));
    } catch (e) {
      emit(TransactionError(ErrorType.failedToDelete));
    }
  }
}
