import 'dart:ui';

import 'package:zenthory/zenthory.dart';

class CategorySummaryModel {
  final int id;
  final String name;
  final String icon;
  final String color;
  final Money total;

  CategorySummaryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.total,
  });

  Color get nativeColor => Color(int.parse("0XFF$color"));
}
