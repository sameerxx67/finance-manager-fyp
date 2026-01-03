import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';
import 'package:zenthory/presentation/presentation.dart';

class PlaceholderViewAction extends StatelessWidget {
  final String title;
  final String icon;
  final GestureTapCallback? onTap;

  const PlaceholderViewAction({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgIcon(icon: icon, color: Colors.white),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
