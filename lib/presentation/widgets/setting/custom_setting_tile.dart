import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CustomSettingTile extends StatelessWidget {
  final String title;
  final String icon;
  final Color? iconColor;
  final GestureTapCallback? onTap;

  const CustomSettingTile({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.273,
        margin: EdgeInsets.only(
          bottom: 10,
          left: context.isRtl ? 0 : 10,
          right: context.isRtl ? 10 : 0,
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: 30,
              height: 30,
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: (iconColor ?? context.colors.secondary).withValues(
                  alpha: 0.15,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgIcon(icon: icon, color: context.colors.secondary),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
