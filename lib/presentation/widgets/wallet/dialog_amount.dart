import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class WalletDialogAmount extends StatefulWidget {
  final WalletModel wallet;
  final bool isAdd;

  const WalletDialogAmount({
    super.key,
    this.isAdd = false,
    required this.wallet,
  });

  @override
  State<WalletDialogAmount> createState() => _WalletDialogAmountState();
}

class _WalletDialogAmountState extends State<WalletDialogAmount> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return AlertDialog(
      contentPadding: const EdgeInsets.only(
        left: AppDimensions.padding,
        right: AppDimensions.padding,
        top: AppDimensions.padding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: isRtl ? Radius.circular(25) : Radius.circular(2),
          topRight: !isRtl ? Radius.circular(25) : Radius.circular(2),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isAdd
                  ? context.tr!.add_balance
                  : context.tr!.withdraw_balance,
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            CustomTextFormField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              paddingBottom: 0,
              label: context.tr!.amount,
              controller: _amountController,
              hintText: context.tr!.hint_text_transaction_amount(
                widget.wallet.currency,
              ),
              autofocus: true,
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.zero,
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: AppDimensions.padding),
          child: Row(
            children: [
              Expanded(
                child: FullElevatedButton(
                  width: null,
                  height: 55,
                  label: context.tr!.cancel,
                  borderRadius: BorderRadius.only(
                    bottomLeft: !isRtl ? Radius.circular(25) : Radius.zero,
                    bottomRight: isRtl ? Radius.circular(25) : Radius.zero,
                  ),
                  isGrayColor: true,
                  fontSize: 13,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Expanded(
                child: FullElevatedButton(
                  width: null,
                  height: 55,
                  label: widget.isAdd ? context.tr!.add : context.tr!.withdraw,
                  borderRadius: BorderRadius.only(
                    bottomLeft: isRtl ? Radius.circular(25) : Radius.zero,
                    bottomRight: isRtl ? Radius.zero : Radius.circular(25),
                  ),
                  onPressed: () {
                    final double? amount = double.tryParse(
                      _amountController.text,
                    );
                    if (amount != null && amount > 0) {
                      if (widget.isAdd) {
                        context.read<WalletCubit>().addBalance(
                          wallet: widget.wallet,
                          amount: amount,
                          successMessage:
                              context.tr!.balance_added_successfully,
                        );
                      } else {
                        context.read<WalletCubit>().withdrawBalance(
                          wallet: widget.wallet,
                          amount: amount,
                          successMessage: context.tr!.withdrawal_successfully,
                        );
                      }
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
