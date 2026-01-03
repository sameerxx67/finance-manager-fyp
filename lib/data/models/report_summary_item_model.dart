import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class ReportSummaryItemModel {
  final String title;
  final Money amount;
  final Color color;
  final String? icon;
  final bool exceptTotal;

  const ReportSummaryItemModel({
    required this.title,
    required this.amount,
    required this.color,
    this.exceptTotal = false,
    this.icon,
  });

  double getPercentage(double total) {
    if (total == 0) return 0;
    return (amount.amount / total) * 100;
  }
}
