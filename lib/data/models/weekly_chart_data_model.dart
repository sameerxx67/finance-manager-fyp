import 'package:flutter/cupertino.dart';
import 'package:zenthory/core/core.dart';

class WeeklyChartDataModel {
  final String day;
  double income;
  double expenses;

  WeeklyChartDataModel({
    required this.day,
    required this.income,
    required this.expenses,
  });

  String toTransDay(BuildContext context) {
    switch (day) {
      case "Mon":
        return context.tr!.mon;
      case "Tue":
        return context.tr!.tue;
      case "Wed":
        return context.tr!.wed;
      case "Thu":
        return context.tr!.thu;
      case "Fri":
        return context.tr!.fri;
      case "Sat":
        return context.tr!.sat;
      case "Sun":
        return context.tr!.sun;
      default:
        return "";
    }
  }
}
