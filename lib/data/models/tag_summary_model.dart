import 'dart:ui';

import 'package:zenthory/core/core.dart';

class TagSummaryModel {
  final String name;
  final String color;
  final int incomeCount;
  final int expenseCount;
  final int debtCount;
  final double incomeAmount;
  final double expenseAmount;
  final double debtAmount;

  TagSummaryModel({
    required this.name,
    required this.color,
    required this.incomeCount,
    required this.expenseCount,
    required this.debtCount,
    required this.incomeAmount,
    required this.expenseAmount,
    required this.debtAmount,
  });

  Money get totalAmountMoney =>
      Money.inDefaultCurrency(incomeAmount + expenseAmount + debtAmount);

  Money get incomeAmountMoney => Money.inDefaultCurrency(incomeAmount);

  Money get expenseAmountMoney => Money.inDefaultCurrency(expenseAmount);

  Money get debtAmountMoney => Money.inDefaultCurrency(debtAmount);

  int get transactionCount => incomeCount + expenseCount + debtCount;

  Color get nativeColor => Color(int.parse("0XFF$color"));
}
