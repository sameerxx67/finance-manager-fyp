import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class TransactionTypeDropdownMenu extends StatelessWidget {
  final TransactionType? type;
  final bool hiddenLabel;
  final String? errorText;
  final Function(TransactionType type) onSelect;

  const TransactionTypeDropdownMenu({
    super.key,
    required this.type,
    required this.onSelect,
    this.errorText,
    this.hiddenLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownMenu(
      label: context.tr!.type,
      // hiddenLabel: hiddenLabel,
      errorText: errorText,
      options: [
        CustomDropdownMenuOption(
          id: TransactionType.income,
          name: context.tr!.income,
          icon: TransactionType.income.icon,
          color: TransactionType.income.color,
        ),
        CustomDropdownMenuOption(
          id: TransactionType.expenses,
          name: context.tr!.expenses,
          icon: TransactionType.expenses.icon,
          color: TransactionType.expenses.color,
        ),
        CustomDropdownMenuOption(
          id: TransactionType.debts,
          name: context.tr!.debts,
          icon: TransactionType.debts.icon,
          color: TransactionType.debts.color,
        ),
      ],
      selectedId: type,
      // hintText: context.tr!.select_type,
      onSelect: (id) => onSelect(id),
    );
  }
}
