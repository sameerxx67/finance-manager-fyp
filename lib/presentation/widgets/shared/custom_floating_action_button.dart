import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? iconData;
  final String? icon;
  final ShapeBorder shape;

  const CustomFloatingActionButton({
    super.key,
    this.onPressed,
    this.iconData,
    this.icon,
    this.shape = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [context.colors.primary, context.colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 4)),
        ],
      ),
      child: RawMaterialButton(
        shape: shape,
        onPressed: onPressed,
        child: iconData != null
            ? Icon(iconData, size: 30, color: Colors.white)
            : icon != null
            ? SvgIcon(icon: icon!, color: Colors.white)
            : null,
      ),
    );
  }
}
