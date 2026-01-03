import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class TagSummaryTile extends StatelessWidget {
  final TagSummaryModel tag;

  const TagSummaryTile({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.surface,
      padding: EdgeInsets.symmetric(vertical: 7),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: tag.nativeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    tag.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              Text(
                tag.totalAmountMoney.format(),
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tag.incomeAmountMoney.format(),
                  style: TextStyle(
                    color: TransactionType.income.color,
                    fontSize: 11,
                  ),
                ),
                Text(
                  tag.expenseAmountMoney.format(),
                  style: TextStyle(
                    color: TransactionType.expenses.color,
                    fontSize: 11,
                  ),
                ),
                Text(
                  tag.debtAmountMoney.format(),
                  style: TextStyle(
                    color: TransactionType.debts.color,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
