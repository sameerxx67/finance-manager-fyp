import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class ListViewSeparatorDivider extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double height;

  const ListViewSeparatorDivider({super.key, this.padding, this.height = 0.4});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          EdgeInsets.only(
            left: context.isRtl ? 0 : 15,
            right: context.isRtl ? 15 : 0,
          ),
      child: Divider(
        height: height,
        color: context.colors.divider.withValues(alpha: 0.5),
      ),
    );
  }
}
