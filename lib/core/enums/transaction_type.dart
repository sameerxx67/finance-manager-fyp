import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';

enum TransactionType {
  income,
  expenses,
  debts;

  String toTrans(BuildContext context) {
    switch (this) {
      case income:
        return context.tr!.income;
      case expenses:
        return context.tr!.expenses;
      case debts:
        return context.tr!.debts;
    }
  }

  String toDescriptionTrans(BuildContext context) {
    switch (this) {
      case income:
        return context.tr!.add_income_description;
      case expenses:
        return context.tr!.add_expenses_description;
      case debts:
        return context.tr!.add_debts_description;
    }
  }

  Color get color {
    switch (this) {
      case income:
        return Color(0XFF16a085);
      case expenses:
        return Color(0XFFe74c3c);
      case debts:
        return Color(0XFFf39c12);
    }
  }

  String get icon {
    switch (this) {
      case income:
        return AppIcons.income;
      case expenses:
        return AppIcons.expense;
      case debts:
        return AppIcons.debts;
    }
  }
}
