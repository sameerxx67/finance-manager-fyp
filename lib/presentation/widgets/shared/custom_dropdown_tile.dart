import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class CustomDropdownTile extends StatelessWidget {
  final GestureTapCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final String? icon;
  final String label;
  final String? errorText;
  final bool hasDivider;

  const CustomDropdownTile({
    super.key,
    required this.label,
    this.hasDivider = false,
    this.errorText,
    this.icon,
    this.color,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? EdgeInsets.only(bottom: 10),
        color: context.colors.surface,
        child: Column(
          children: [
            ListTile(
              leading: Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: (color ?? context.colors.primary).withValues(
                    alpha: 0.15,
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: icon != null
                    ? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: SvgIcon(
                          icon: icon!,
                          color: (color ?? context.colors.primary),
                        ),
                      )
                    : null,
              ),
              title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: errorText != null
                  ? Text(
                      errorText!,
                      style: TextStyle(
                        color: context.colors.error,
                        fontSize: 12,
                      ),
                    )
                  : null,
              trailing: Icon(Icons.keyboard_arrow_down),
            ),
            if (hasDivider)
              Divider(
                height: 0,
                color: context.colors.divider.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
