import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class ReportSummary extends StatelessWidget {
  final String title;
  final String icon;
  final List<ReportSummaryItemModel> items;

  const ReportSummary({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold(
      0.0,
      (sum, item) => sum + (item.exceptTotal ? 0 : item.amount.amount),
    );

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgIcon(icon: icon, width: 18, color: context.colors.primary),
              SizedBox(width: 7),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 15),
          if (total > 0)
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items.map(_summaryTile).toList(),
                ),
                Expanded(
                  child: SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: _buildSections(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (total == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                context.tr!.no_data_available,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return items
        .map(
          (item) => PieChartSectionData(
            color: item.color.withValues(alpha: 0.9),
            value: item.amount.amount,
            radius: 35,
            showTitle: false,
          ),
        )
        .toList();
  }

  Widget _summaryTile(ReportSummaryItemModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 2),
          Text(
            item.amount.format(),
            style: TextStyle(color: item.color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
