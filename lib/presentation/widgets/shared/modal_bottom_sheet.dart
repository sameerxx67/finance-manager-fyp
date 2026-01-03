import 'package:flutter/material.dart';

class ModalBottomSheet extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double? heightFactor;

  const ModalBottomSheet({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.heightFactor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: heightFactor,
        child: Padding(
          padding: padding ?? const EdgeInsets.only(top: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          ),
        ),
      ),
    );
  }
}
