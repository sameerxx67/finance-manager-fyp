import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';

class ContainerForm extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final double? paddingHorizontal;
  final double? paddingVertical;

  const ContainerForm({
    super.key,
    this.margin,
    this.paddingHorizontal,
    this.paddingVertical,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal ?? AppDimensions.padding,
        vertical: paddingVertical ?? AppDimensions.padding / 2,
      ),
      color: context.colors.surface,
      child: child,
    );
  }
}
