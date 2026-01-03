import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final String icon;
  final List<Widget>? actions;

  const HomeAppBar({
    super.key,
    required this.title,
    required this.icon,
    this.actions,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          SvgIcon(icon: icon, width: 18),
          SizedBox(width: 6),
          Text(title),
        ],
      ),
      actions: actions,
    );
  }
}
