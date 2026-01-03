import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zenthory/zenthory.dart';

class RecentTransactions extends StatelessWidget {
  final List<TransactionModel> transactions;
  final GestureTapCallback? viewAll;
  final GestureTapCallback refresh;

  const RecentTransactions({
    super.key,
    required this.transactions,
    required this.refresh,
    this.viewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr!.recent_transactions,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            GestureDetector(
              onTap: viewAll,
              child: Text(
                context.tr!.view_all,
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        ...transactions.map(
          (TransactionModel transaction) =>
              RecentTransactionTile(transaction: transaction, refresh: refresh),
        ),
      ],
    );
  }
}

class RecentTransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final GestureTapCallback refresh;

  const RecentTransactionTile({
    super.key,
    required this.refresh,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        onTap: () => _showDetails(context, transaction.id),
        leading: transaction.category != null
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: transaction.category?.nativeColor.withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: SvgIcon(
                    icon: transaction.category!.icon,
                    color: transaction.category?.nativeColor,
                    width: 18,
                  ),
                ),
              )
            : null,
        title: Text(
          "${transaction.category?.name}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text(
              transaction.amountMoney.format(),
              style: TextStyle(
                color: transaction.type.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (Money.defaultCurrency != transaction.currency)
              FutureBuilder<Money>(
                future: transaction.amountMoney.convertToDefaultCurrency(
                  currencyRate: transaction.currencyRate,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: SvgIcon(
                          icon: AppIcons.exchange,
                          width: 12,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        snapshot.data!.format(),
                        style: TextStyle(
                          color: transaction.type.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.read<SharedCubit>().formatDate(transaction.date)),
            Text(DateFormat.jm().format(transaction.date)),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, int id) {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => BlocProvider(
        create: (_) => TransactionShowCubit()..get(id),
        child: TransactionShowDetailsModalBottomSheet(refresh: refresh),
      ),
      backgroundColor: context.colors.background,
    );
  }
}
