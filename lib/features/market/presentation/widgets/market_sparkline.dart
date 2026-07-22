import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/features/market/core/market_trend_metrics.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';

class MarketSparkline extends StatelessWidget {
  final MarketTrendModel trend;
  final double height;
  final double? width;

  const MarketSparkline({
    super.key,
    required this.trend,
    this.height = 28,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (trend.historyData.isEmpty) {
      return SizedBox(height: height.h, width: width);
    }

    final color = MarketTrendMetrics.trendColorFromChange(
      MarketTrendMetrics.percentChange(trend),
    );

    return SizedBox(
      height: height.h,
      width: width ?? 56.w,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: trend.historyData
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.y.toDouble()))
                  .toList(),
              isCurved: true,
              color: color,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.15),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
