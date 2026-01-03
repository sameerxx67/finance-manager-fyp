import 'package:zenthory/zenthory.dart';

class TransactionGroupedByDateModel {
  final DateTime date;
  final List<TransactionModel> transactions;

  TransactionGroupedByDateModel({
    required this.date,
    required this.transactions,
  });

  int get count => transactions.length;

  Future<Money> get total async {
    Money totalAmount = Money.inDefaultCurrency(0);
    for (final tx in transactions) {
      totalAmount = totalAmount.add(
        (await tx.amountMoney.convertToDefaultCurrency(
          currencyRate: tx.currencyRate,
        )),
      );
    }
    return totalAmount;
  }
}
