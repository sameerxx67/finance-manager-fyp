import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          context.read<TransactionCubit>().state is TransactionLoaded) {
        final state =
            context.read<TransactionCubit>().state as TransactionLoaded;
        if (state.hasMore) {
          context.read<TransactionCubit>().loadMoreTransactions();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(
              context,
              context.tr!.transactions,
              context.tr!.transaction,
            ),
            message: state.type.message(
              context,
              context.tr!.transactions,
              context.tr!.transaction,
            ),
          );
        } else if (state is TransactionSuccess) {
          context.read<SharedCubit>().showSnackBar(
            message: state.type.message(context, context.tr!.transaction),
          );
        }
      },
      buildWhen: (previous, current) => [
        TransactionLoaded,
        TransactionLoading,
        TransactionError,
      ].any((type) => current.runtimeType == type),
      builder: (context, state) {
        return Scaffold(
          appBar: HomeAppBar(
            icon: AppIcons.transaction,
            title: context.tr!.transactions,
            actions: [
              if (state is TransactionLoaded)
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
          extendBodyBehindAppBar:
              (state is TransactionLoaded && state.transactions.isNotEmpty)
              ? false
              : true,
          body: Builder(
            builder: (context) {
              if (state is TransactionLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TransactionLoaded &&
                  state.transactions.isNotEmpty) {
                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<TransactionCubit>().loadTransactions(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(AppDimensions.padding),
                    itemCount: state.transactions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.transactions.length) {
                        return state.hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Center(
                                  child: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.7,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      }
                      return TransactionTile(
                        transaction: state.transactions[index],
                        onPressedEdit: (TransactionModel transaction) =>
                            _goToTransactionForm(
                              context: context,
                              transaction: transaction,
                            ),
                        onPressedDelete: (TransactionModel transaction) =>
                            _deleteTransaction(
                              context: context,
                              transaction: transaction,
                            ),
                        onPressedShowDetails: (TransactionModel transaction) =>
                            _showDetails(context, state, transaction.id),
                      );
                    },
                  ),
                );
              }
              return PlaceholderView(
                icon: AppIcons.transaction,
                title: context.tr!.transaction_empty_screen_title,
                subtitle: context.tr!.transaction_empty_screen_description,
              );
            },
          ),
        );
      },
    );
  }

  void _goToTransactionForm({
    required BuildContext context,
    TransactionModel? transaction,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) =>
              TransactionFormCubit()
                ..init(type: transaction!.type, transaction: transaction),
          child: TransactionFormScreen(transaction: transaction),
        ),
      ),
    );
    if (context.mounted && result != null && result['refresh'] == true) {
      context.read<TransactionCubit>().loadTransactions();
    }
  }

  void _deleteTransaction({
    required BuildContext context,
    required TransactionModel transaction,
  }) {
    context.read<SharedCubit>().showDialog(
      type: AlertDialogType.confirm,
      title: context.tr!.delete_resource(context.tr!.transaction),
      message: context.tr!.confirm_delete_transaction_message,
      icon: AppIcons.transaction,
      callbackConfirm: () =>
          context.read<TransactionCubit>().deleteTransaction(transaction),
    );
  }

  void _openFilter(BuildContext context, TransactionLoaded state) {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => BlocProvider.value(
        value: context.read<TransactionCubit>(),
        child: TransactionFilterModalBottomSheet(
          category: state.category,
          contact: state.contact,
          type: state.type,
          walletId: state.walletId,
          wallets: state.wallets,
          tags: state.tags,
          tagIds: state.tagIds,
          dateRange: state.dateRange,
          onChange:
              ({
                CategoryModel? category,
                ContactModel? contact,
                DateTimeRange<DateTime>? dateRange,
                TransactionType? type,
                int? walletId,
                List<int>? tagIds,
              }) {
                context.read<TransactionCubit>().loadTransactions(
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

  void _showDetails(BuildContext context, TransactionLoaded state, int id) {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => BlocProvider(
        create: (_) => TransactionShowCubit()..get(id),
        child: TransactionShowDetailsModalBottomSheet(
          refresh: () => context.read<TransactionCubit>().loadTransactions(
            category: state.category,
            contact: state.contact,
            dateRange: state.dateRange,
            type: state.type,
            walletId: state.walletId,
            tagIds: state.tagIds,
          ),
        ),
      ),
      backgroundColor: context.colors.background,
    );
  }
}
