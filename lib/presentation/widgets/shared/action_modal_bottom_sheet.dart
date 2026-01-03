import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class ActionModalBottomSheet extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;
  final String? icon;
  final Color? iconColor;

  const ActionModalBottomSheet({
    super.key,
    required this.title,
    this.icon,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null
          ? SvgIcon(
              icon: icon!,
              color: (iconColor ?? context.colors.textPrimary),
              width: 20,
            )
          : null,
      onTap: onTap != null
          ? () {
              Navigator.pop(context);
              onTap!();
            }
          : null,

      title: Text(
        title,
        style: TextStyle(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
