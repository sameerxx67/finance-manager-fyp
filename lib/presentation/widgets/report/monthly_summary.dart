import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class MonthlySummary extends StatelessWidget {
  final List<MonthlySummaryModel> data;

  const MonthlySummary({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final hasData = data.isEmpty
        ? false
        : (data.fold<double>(
                0.0,
                (sum, item) => sum + (item.income + item.expenses),
              ) >
              0);
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: appDarkColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgIcon(
                icon: AppIcons.monthlySummary,
                width: 22,
                color: context.colors.primary,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr!.monthly_summary_title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appDarkColors.textPrimary,
                      ),
                    ),
                    Text(
                      context.tr!.monthly_summary_subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: appDarkColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (!hasData)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                context.tr!.no_data_available,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: appDarkColors.textPrimary,
                ),
              ),
            ),
          if (hasData) _buildLineChart(context),
        ],
      ),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    final titles = [context.tr!.income, context.tr!.expenses];
    return SizedBox(
      height: 170,
      child: LineChart(
        LineChartData(
          maxY: _getMaxY(),
          minY: 0,
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    "${titles[spot.barIndex]} ${Money.inDefaultCurrency(spot.y).format()}",
                    TextStyle(color: Colors.white, fontSize: 12),
                  );
                }).toList();
              },
            ),
            handleBuiltInTouches: true,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30,
                getTitlesWidget: (value, _) {
                  final index = value.toInt();
                  return index < data.length
                      ? Transform.rotate(
                          angle: -0.5,
                          child: Text(
                            data[index].label,
                            style: TextStyle(
                              fontSize: 10,
                              color: appDarkColors.textPrimary,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    meta.formattedValue,
                    style: TextStyle(color: appDarkColors.textPrimary),
                  ),
                ),
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            _buildLine(
              data.map((e) => e.income).toList(),
              TransactionType.income.color,
            ),
            _buildLine(
              data.map((e) => e.expenses).toList(),
              TransactionType.expenses.color,
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildLine(List<double> values, Color color) {
    return LineChartBarData(
      spots: values
          .asMap()
          .map((i, v) => MapEntry(i, FlSpot(i.toDouble(), v)))
          .values
          .toList(),
      isCurved: true,
      barWidth: 2,
      color: color,
      // dotData: FlDotData(show: false),
    );
  }

  double _getMaxY() {
    final allValues = data.expand((e) => [e.income, e.expenses]);
    final maxValue = allValues.fold(0.0, (max, val) => val > max ? val : max);
    return (maxValue * 1.2).ceilToDouble(); // add 20% padding
  }
}
