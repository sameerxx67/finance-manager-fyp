import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';
import 'package:zenthory/presentation/presentation.dart';

class HomeFloatingActionButton extends StatelessWidget {
  final GestureTapCallback refresh;

  const HomeFloatingActionButton({super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      onPressed: () => _openMenu(context),
      icon: AppIcons.addTransaction,
    );
  }

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => MenuModalBottomSheet(refresh: refresh),
    );
  }
}
