import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class DashboardWeeklyChart extends StatelessWidget {
  final List<WeeklyChartDataModel> chartData;

  const DashboardWeeklyChart({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    final double maxY = chartData.isNotEmpty
        ? chartData
                  .map((e) => e.income > e.expenses ? e.income : e.expenses)
                  .reduce(max) +
              10
        : 10;
    final textColor = appDarkColors.textPrimary;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: appDarkColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chartData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  SvgIcon(icon: AppIcons.dashboardChart, color: textColor),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr!.dashboard_analytics_title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        context.tr!.dashboard_analytics_subtitle,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          SizedBox(
            height: 150,
            child: chartData.isNotEmpty
                ? BarChart(
                    BarChartData(
                      maxY: maxY,
                      alignment: BarChartAlignment.spaceAround,
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              Money.inDefaultCurrency(rod.toY).format(),
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      barGroups: List.generate(chartData.length, (index) {
                        final day = chartData[index];
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: day.income,
                              color: TransactionType.income.color,
                            ),
                            BarChartRodData(
                              toY: day.expenses,
                              color: TransactionType.expenses.color,
                            ),
                          ],
                        );
                      }),
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 44,
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                              meta: meta,
                              child: Text(
                                meta.formattedValue,
                                style: TextStyle(color: textColor),
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) => Text(
                              chartData[value.toInt()].toTransDay(context),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgIcon(
                          icon: AppIcons.chartEmptyDate,
                          color: textColor,
                          width: 30,
                        ),
                        SizedBox(height: 10),
                        Text(
                          context.tr!.weekly_chart_empty_title,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.tr!.weekly_chart_empty_description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
