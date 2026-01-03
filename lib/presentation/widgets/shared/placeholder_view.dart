import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

final class PlaceholderView extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const PlaceholderView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actions = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgIcon(
            icon: icon,
            width: MediaQuery.of(context).size.width * 0.25,
            color: context.colors.textSecondary,
          ),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            textAlign: TextAlign.center,
            subtitle,
            style: TextStyle(color: context.colors.textSecondary, fontSize: 15),
          ),
          SizedBox(height: 4),
          Column(children: actions),
        ],
      ),
    );
  }
}
