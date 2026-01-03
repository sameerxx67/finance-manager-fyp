import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CustomTab extends StatelessWidget {
  final String title;
  final String icon;
  final bool isActive;

  const CustomTab({
    super.key,
    required this.title,
    required this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            icon: icon,
            width: 20,
            color: isActive
                ? context.colors.primary
                : context.colors.textPrimary,
          ),
          SizedBox(width: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
