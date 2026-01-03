import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class FinancialSummary extends StatelessWidget {
  final Money balance;
  final Money income;
  final Money expenses;

  const FinancialSummary({
    super.key,
    required this.balance,
    required this.expenses,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [context.colors.primary, context.colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr!.total_balance,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    balance.format(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (_) => WalletCubit()..loadWallets(),
                      child: WalletScreen(),
                    ),
                  ),
                ),
                icon: SvgIcon(icon: AppIcons.wallets, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DashboardFinancialSummaryTypeTile(
                type: TransactionType.income,
                icon: Icons.arrow_downward_outlined,
                total: income,
              ),
              DashboardFinancialSummaryTypeTile(
                type: TransactionType.expenses,
                icon: Icons.arrow_upward_outlined,
                total: expenses,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardFinancialSummaryTypeTile extends StatelessWidget {
  final TransactionType type;
  final IconData icon;
  final Money total;

  const DashboardFinancialSummaryTypeTile({
    super.key,
    required this.type,
    required this.icon,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 27,
          height: 27,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: type.color, size: 16),
        ),
        SizedBox(width: 6),
        Column(
          children: [
            Text(
              type.toTrans(context),
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
            Text(
              total.format(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
