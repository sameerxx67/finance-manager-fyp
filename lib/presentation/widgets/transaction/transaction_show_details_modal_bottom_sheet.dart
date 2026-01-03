import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zenthory/zenthory.dart';

class TransactionShowDetailsModalBottomSheet extends StatelessWidget {
  final GestureTapCallback refresh;

  const TransactionShowDetailsModalBottomSheet({
    super.key,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ModalBottomSheet(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.padding / 2,
          horizontal: AppDimensions.padding,
        ),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocConsumer<TransactionShowCubit, TransactionShowState>(
            listener: (context, state) {
              if (state is TransactionShowError) {
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
              } else if (state is TransactionShowSuccess) {
                context.read<SharedCubit>().showSnackBar(
                  message: state.type.message(context, context.tr!.transaction),
                );
              }
            },
            buildWhen: (previous, current) => [
              TransactionShowLoaded,
              TransactionShowLoading,
              TransactionShowError,
            ].any((type) => current.runtimeType == type),
            builder: (context, state) {
              if (state is TransactionShowLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is TransactionShowLoaded) {
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgIcon(
                                icon: AppIcons.transaction,
                                width: 18,
                                color: context.colors.textPrimary,
                              ),
                              SizedBox(width: 5),
                              Text(
                                context.tr!.transaction_details,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => _edit(
                                  context: context,
                                  transaction: state.transaction,
                                ),
                                icon: SvgIcon(
                                  icon: AppIcons.edit,
                                  color: context.colors.success,
                                  width: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _delete(
                                  context: context,
                                  transaction: state.transaction,
                                ),
                                icon: SvgIcon(
                                  icon: AppIcons.delete,
                                  color: context.colors.error,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      _buildCategory(context, state.transaction),
                      if (state.transaction.wallet != null)
                        _buildWallet(context, state.transaction.wallet!),
                      if (state.transaction.contact != null)
                        _buildContact(context, state.transaction.contact!),
                      if (state.transaction.startDate != null &&
                          state.transaction.endDate != null)
                        _buildStartAndEndDate(
                          context,
                          state.transaction.startDate!,
                          state.transaction.endDate!,
                        ),
                      if (state.transaction.tags != null &&
                          state.transaction.tags!.isNotEmpty)
                        _buildTags(context, state.transaction.tags!),
                      if (state.transaction.note != null)
                        _buildNote(context, state.transaction.note!),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWallet(BuildContext context, WalletModel wallet) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(wallet.type.image),
          fit: BoxFit.cover,
        ),
        color: wallet.type.color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    wallet.name.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 10),
                  SvgIcon(
                    icon: wallet.type.icon,
                    color: Colors.white,
                    width: 19,
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wallet.balanceMoney.format(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                  decoration: wallet.isHidden
                      ? TextDecoration.lineThrough
                      : null,
                  decorationColor: Colors.white,
                ),
              ),
              Text(
                context.tr!.current_balance,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, TransactionModel transaction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
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
                    width: 22,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${transaction.category?.name}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
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
                          future: transaction.amountMoney
                              .convertToDefaultCurrency(
                                currencyRate: transaction.currencyRate,
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
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.read<SharedCubit>().formatDate(transaction.date),
                style: TextStyle(color: context.colors.textSecondary),
              ),
              Text(
                DateFormat.jm().format(transaction.date),
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNote(BuildContext context, String note) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${context.tr!.note}: ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // SizedBox(height: 5),
          Text(note, style: TextStyle(color: context.colors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context, ContactModel contact) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: contact.nativeColor,
            radius: 18,
            child: Text(
              contact.name[0].toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                // fontSize: 15,
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact.name, style: TextStyle(fontWeight: FontWeight.bold)),
              if (contact.note != null)
                Text(
                  contact.note!,
                  style: TextStyle(color: context.colors.textSecondary),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartAndEndDate(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${context.tr!.start_date}: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: 5),
              Text(
                context.read<SharedCubit>().formatDate(startDate),
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${context.tr!.end_date}: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: 5),
              Text(
                context.read<SharedCubit>().formatDate(endDate),
                style: TextStyle(color: context.colors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTags(BuildContext context, List<TagModel> tags) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${context.tr!.tags} : ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Wrap(
            children: tags
                .map(
                  (TagModel tag) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: EdgeInsets.only(
                      left: context.isRtl ? 6 : 0,
                      right: context.isRtl ? 0 : 6,
                      bottom: 7,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tag.name,
                      style: TextStyle(
                        color: context.colors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _edit({
    required BuildContext context,
    required TransactionModel transaction,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) =>
              TransactionFormCubit()
                ..init(type: transaction.type, transaction: transaction),
          child: TransactionFormScreen(transaction: transaction),
        ),
      ),
    );
    if (context.mounted && result != null && result['refresh'] == true) {
      context.read<TransactionShowCubit>().get(transaction.id);
      refresh();
    }
  }

  void _delete({
    required BuildContext context,
    required TransactionModel transaction,
  }) {
    context.read<SharedCubit>().showDialog(
      type: AlertDialogType.confirm,
      title: context.tr!.delete_resource(context.tr!.transaction),
      message: context.tr!.confirm_delete_transaction_message,
      icon: AppIcons.transaction,
      callbackConfirm: () {
        context.read<TransactionShowCubit>().delete(transaction);
        refresh();
        Navigator.pop(context);
      },
    );
  }
}
