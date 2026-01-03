import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class HomeTabBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final TransactionType selectedType;
  final Function(TransactionType type) onTabChanged;

  const HomeTabBar({
    super.key,
    required this.onTabChanged,
    required this.selectedType,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void didUpdateWidget(covariant HomeTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedType != widget.selectedType) {
      setState(() {
        _currentIndex = widget.selectedType == TransactionType.income
            ? 0
            : widget.selectedType == TransactionType.expenses
            ? 1
            : 2;
        _tabController.index = _currentIndex;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTabChanged(
      index == 0
          ? TransactionType.income
          : index == 1
          ? TransactionType.expenses
          : TransactionType.debts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      dividerColor: Colors.transparent,
      onTap: (int index) => _handleTabChange(index),
      tabs: [
        CustomTab(
          title: context.tr!.income,
          icon: TransactionType.income.icon,
          isActive: _currentIndex == 0,
        ),
        CustomTab(
          title: context.tr!.expenses,
          icon: TransactionType.expenses.icon,
          isActive: _currentIndex == 1,
        ),
        CustomTab(
          title: context.tr!.debts,
          icon: TransactionType.debts.icon,
          isActive: _currentIndex == 2,
        ),
      ],
    );
  }
}
