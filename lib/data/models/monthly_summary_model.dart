import 'package:zenthory/zenthory.dart';

class MonthlySummaryModel {
  final String label;
  final double income;
  final double expenses;

  MonthlySummaryModel({
    required this.label,
    required this.income,
    required this.expenses,
  });

  Money get incomeMoney => Money.inDefaultCurrency(income);

  Money get expensesMoney => Money.inDefaultCurrency(expenses);
}
