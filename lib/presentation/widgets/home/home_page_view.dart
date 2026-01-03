import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class HomePageView extends StatelessWidget {
  final GestureTapCallback? goToTransactions;
  final GestureTapCallback refresh;
  final int activeIndex;

  const HomePageView({
    super.key,
    required this.activeIndex,
    required this.refresh,
    this.goToTransactions,
  });

  @override
  Widget build(BuildContext context) {
    switch (activeIndex) {
      case 0:
        return BlocProvider(
          create: (_) => DashboardCubit()..loadData(),
          child: DashboardScreen(
            goToTransactions: goToTransactions,
            refresh: refresh,
          ),
        );
      case 1:
        return BlocProvider(
          create: (_) => TransactionCubit()..loadTransactions(),
          child: TransactionScreen(),
        );
      case 2:
        return BlocProvider(
          create: (_) => ReportCubit()..loadData(),
          child: ReportScreen(),
        );
      case 3:
        return BlocProvider(
          create: (_) => SettingCubit()..init(),
          child: SettingScreen(),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
