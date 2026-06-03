import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/iot_dashboard_entity.dart';

/// Mini sparkline untuk kartu perangkat di dashboard fleet.
class IotSparkline extends StatelessWidget {
  const IotSparkline({
    super.key,
    required this.points,
    this.color = AppColors.primary,
  });

  final List<IotSeriesPoint> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return SizedBox(
        height: 28.h,
        child: Center(
          child: Container(
            width: 40.w,
            height: 2.h,
            color: AppColors.grey200,
          ),
        ),
      );
    }

    final spots = points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList();

    return SizedBox(
      height: 32.h,
      width: 72.w,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: color,
              barWidth: 1.5,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
