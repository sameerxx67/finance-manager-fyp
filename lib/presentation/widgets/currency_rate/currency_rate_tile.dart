import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';
import 'package:zenthory/data/data.dart';
import 'package:zenthory/presentation/presentation.dart';

class CurrencyRateTile extends StatelessWidget {
  final CurrencyRateModel rate;
  final Function(CurrencyRateModel rate)? onTap;

  const CurrencyRateTile({super.key, required this.rate, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      tileColor: context.colors.surface,
      onTap: onTap != null ? () => onTap!(rate) : null,
      leading: rate.currency != null ? _flagWidget() : null,
      title: Text(
        "${rate.currency!.name} (${rate.code})",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(rate.rateMoney.format()),
      trailing: SvgIcon(
        icon: AppIcons.edit,
        width: 15,
        color: context.colors.textSecondary,
      ),
    );
  }

  Widget _flagWidget() {
    if (rate.currency!.flag == null) {
      return Image.asset(
        'lib/src/res/no_flag.png',
        package: 'currency_picker',
        width: 27,
      );
    }

    if (rate.currency!.isFlagImage) {
      return Image.asset(
        "lib/src/res/${rate.currency!.flag}",
        package: 'currency_picker',
        width: 27,
      );
    }

    return Text(
      CurrencyUtils.currencyToEmoji(rate.currency!),
      style: TextStyle(fontSize: 25),
    );
  }
}
