import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zenthory/zenthory.dart';

class TransactionTile extends StatelessWidget {
  final TransactionGroupedByDateModel transaction;
  final Function(TransactionModel transaction) onPressedEdit;
  final Function(TransactionModel transaction) onPressedDelete;
  final Function(TransactionModel transaction) onPressedShowDetails;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onPressedDelete,
    required this.onPressedEdit,
    required this.onPressedShowDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.read<SharedCubit>().formatDate(transaction.date),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.colors.textSecondary,
              ),
            ),
            FutureBuilder<Money>(
              future: transaction.total,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    width: 12,
                    height: 12,
                    child: const CircularProgressIndicator(strokeWidth: 1.7),
                  );
                }
                return Text(
                  snapshot.data!.format(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textSecondary,
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView.separated(
            itemCount: transaction.transactions.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              final TransactionModel tx = transaction.transactions[index];
              return ListTile(
                dense: true,
                leading: tx.category != null
                    ? Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: tx.category?.nativeColor.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgIcon(
                            icon: tx.category!.icon,
                            color: tx.category?.nativeColor,
                            width: 18,
                          ),
                        ),
                      )
                    : null,

                title: Text(
                  "${tx.category?.name}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    Text(
                      tx.amountMoney.format(),
                      style: TextStyle(
                        color: tx.type.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (Money.defaultCurrency != tx.currency)
                      FutureBuilder<Money>(
                        future: tx.amountMoney.convertToDefaultCurrency(
                          currencyRate: tx.currencyRate,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
                          }
                          return Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: SvgIcon(
                                  icon: AppIcons.exchange,
                                  width: 12,
                                  color: context.colors.textSecondary,
                                ),
                              ),
                              Text(
                                snapshot.data!.format(),
                                style: TextStyle(
                                  color: tx.type.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
                onTap: () => _openMenuActions(context, tx),
                trailing: Text(DateFormat.jm().format(tx.date)),
              );
            },

            separatorBuilder: (BuildContext context, int index) =>
                ListViewSeparatorDivider(),
          ),
        ),
      ],
    );
  }

  void _openMenuActions(BuildContext context, TransactionModel tx) {
    context.read<SharedCubit>().showModalBottomSheet(
      (context) => ActionsModalBottomSheet(
        actions: [
          ActionModalBottomSheet(
            icon: AppIcons.transaction,
            title: context.tr!.show_details,
            onTap: () => onPressedShowDetails(tx),
          ),
          ActionModalBottomSheet(
            icon: AppIcons.edit,
            title: context.tr!.edit_resource(context.tr!.transaction),
            iconColor: context.colors.success,
            onTap: () => onPressedEdit(tx),
          ),
          ActionModalBottomSheet(
            icon: AppIcons.delete,
            title: context.tr!.delete_resource(context.tr!.transaction),
            iconColor: context.colors.error,
            onTap: () => onPressedDelete(tx),
          ),
        ],
      ),
    );
  }
}
