import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';
import 'package:zenthory/presentation/presentation.dart';

class DebtsSummary extends StatelessWidget {
  final Money paid;
  final Money received;

  const DebtsSummary({super.key, required this.paid, required this.received});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTile(
            title: context.tr!.debts_received,
            amount: received,
            icon: AppIcons.debtsReceived,
            color: Color(0XFF45aaf2),
          ),
          SizedBox(width: 12),
          _buildTile(
            title: context.tr!.debts_paid,
            amount: paid,
            icon: AppIcons.debtsPaid,
            color: Color(0XFFfc5c65),
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required String title,
    required Money amount,
    required String icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 33,
              height: 33,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.5),
                color: Colors.white,
              ),
              child: SvgIcon(icon: icon, color: color),
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  amount.format(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
