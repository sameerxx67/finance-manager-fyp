import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class ActionsModalBottomSheet extends StatelessWidget {
  final List<ActionModalBottomSheet> actions;

  const ActionsModalBottomSheet({super.key, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      padding: EdgeInsets.zero,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: actions,
    );
  }
}
