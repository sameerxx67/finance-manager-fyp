import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class UpdateCurrencyRateModalBottomSheet extends StatefulWidget {
  final CurrencyRateModel rate;
  final String defaultCurrency;
  final Function(double rate, bool isLocked)? onSave;

  const UpdateCurrencyRateModalBottomSheet({
    super.key,
    required this.rate,
    required this.defaultCurrency,
    this.onSave,
  });

  @override
  State<UpdateCurrencyRateModalBottomSheet> createState() =>
      _UpdateCurrencyRateModalBottomSheetState();
}

class _UpdateCurrencyRateModalBottomSheetState
    extends State<UpdateCurrencyRateModalBottomSheet> {
  final TextEditingController _rateController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      _focusNode.requestFocus();
    });
    _rateController.text = widget.rate.rate.toString();
    isLocked = widget.rate.isLocked;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ModalBottomSheet(
        padding: EdgeInsets.only(
          left: AppDimensions.padding,
          top: AppDimensions.padding,
          right: AppDimensions.padding,
          bottom: AppDimensions.padding / 2,
        ),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${context.tr!.update_resource(context.tr!.currency_rate)} (${widget.rate.code})",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            context.tr!.update_resource(
              context.tr!.currency_rates_update_description,
            ),
            style: TextStyle(fontSize: 13, color: context.colors.textSecondary),
          ),
          SizedBox(height: 15),
          CustomTextFormField(
            label: context.tr!.rate_title_input(
              widget.rate.code,
              widget.defaultCurrency,
            ),
            controller: _rateController,
            focusNode: _focusNode,
            hintText: context.tr!.hint_text_rate(widget.rate.code),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr!.stop_automatic_currency_rate_adjustment,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: isLocked,
                  onChanged: (bool value) {
                    setState(() {
                      isLocked = value;
                    });
                  },
                ),
              ),
            ],
          ),
          FormBottomNavigationBar(
            padding: EdgeInsets.symmetric(vertical: 15),
            okButtonText: context.tr!.save,
            okButtonOnPressed: () {
              if (widget.onSave != null) {
                widget.onSave!(
                  double.tryParse(_rateController.text) ?? 1,
                  isLocked,
                );
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
