import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class FullElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final BorderRadiusGeometry borderRadius;
  final double? height;
  final bool isGrayColor;
  final Color? color;
  final double? width;
  final double? fontSize;

  const FullElevatedButton({
    super.key,
    required this.label,
    this.isGrayColor = false,
    this.onPressed,
    this.height,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.width = double.infinity,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isGrayColor
              ? Color(0XFFEDEDED)
              : color ?? context.colors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isGrayColor ? Colors.black : Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
