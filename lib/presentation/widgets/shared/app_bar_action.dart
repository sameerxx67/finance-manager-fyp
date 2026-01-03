import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';

class AppBarAction extends StatelessWidget {
  final GestureTapCallback? onTap;
  final IconData icon;

  const AppBarAction({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: context.colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: context.colors.primary, size: 25),
      ),
    );
  }
}
