import 'package:flutter/cupertino.dart';

class CustomDropdownMenuOption {
  final dynamic id;
  final String name;
  final String? subtitle;
  final String? trailingText;
  final String? icon;
  final Color? color;
  final IconData? iconData;

  CustomDropdownMenuOption({
    required this.id,
    required this.name,
    this.subtitle,
    this.trailingText,
    this.icon,
    this.color,
    this.iconData,
  });
}
