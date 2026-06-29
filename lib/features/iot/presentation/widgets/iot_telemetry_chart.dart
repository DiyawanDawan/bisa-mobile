import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/iot_dashboard_entity.dart';

class IotTelemetryChart extends StatelessWidget {
  const IotTelemetryChart({
    super.key,
    required this.temperatureSeries,
    this.humiditySeries = const [],
    this.co2Series = const [],
    this.thresholdMin,
    this.thresholdMax,
    this.isLoading = false,
  });

  final List<IotSeriesPoint> temperatureSeries;
  final List<IotSeriesPoint> humiditySeries;
  final List<IotSeriesPoint> co2Series;
  final double? thresholdMin;
  final double? thresholdMax;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 220.h,
        alignment: Alignment.center,
        decoration: _boxDecoration,
        child: const CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (temperatureSeries.isEmpty) {
      return Container(
        height: 220.h,
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: _boxDecoration,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.chartLine, size: 40.sp, color: AppColors.grey300),
            SizedBox(height: AppSpacing.sm10),
            Text(
              'iot.chart_empty_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 4.h),
            Text(
              'iot.chart_empty_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

    final tempSpots = _toSpots(temperatureSeries);
    final yBounds = _yBounds(tempSpots, thresholdMin, thresholdMax);

    final bars = <LineChartBarData>[
      LineChartBarData(
        spots: tempSpots,
        isCurved: true,
        color: AppColors.error,
        barWidth: 2.5,
        dotData: FlDotData(show: tempSpots.length <= 24),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.error.withValues(alpha: 0.15),
              AppColors.error.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    ];

    if (humiditySeries.length >= 2) {
      bars.add(
        LineChartBarData(
          spots: _toSpots(humiditySeries),
          isCurved: true,
          color: AppColors.ocean,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      );
    }

    return Container(
      height: 240.h,
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 16.w, 8.h),
      decoration: _boxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'iot.chart_title'.tr(),
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              _legend('iot.metric_temperature'.tr(), AppColors.error),
              if (humiditySeries.isNotEmpty) ...[
                SizedBox(width: AppSpacing.md12),
                _legend('iot.metric_humidity'.tr(), AppColors.ocean),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: yBounds.$1,
                maxY: yBounds.$2,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.grey100,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36.w,
                      getTitlesWidget: (v, _) => Text(
                        v.toInt().toString(),
                        style: TextStyle(fontSize: 9.sp, color: AppColors.textHint),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (tempSpots.length / 4).clamp(1, 999).toDouble(),
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= temperatureSeries.length) {
                          return const SizedBox.shrink();
                        }
                        final t = temperatureSeries[i].recordedAt;
                        return Text(
                          '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 8.sp, color: AppColors.textHint),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    if (thresholdMin != null)
                      HorizontalLine(
                        y: thresholdMin!,
                        color: AppColors.ocean.withValues(alpha: 0.6),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          labelResolver: (_) => 'Min',
                          style: TextStyle(fontSize: 9.sp, color: AppColors.ocean),
                        ),
                      ),
                    if (thresholdMax != null)
                      HorizontalLine(
                        y: thresholdMax!,
                        color: AppColors.error.withValues(alpha: 0.7),
                        strokeWidth: 1,
                        dashArray: [4, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          labelResolver: (_) => 'Max',
                          style: TextStyle(fontSize: 9.sp, color: AppColors.error),
                        ),
                      ),
                  ],
                ),
                lineBarsData: bars,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration get _boxDecoration => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
      );

  List<FlSpot> _toSpots(List<IotSeriesPoint> points) {
    return points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList();
  }

  (double, double) _yBounds(
    List<FlSpot> spots,
    double? tMin,
    double? tMax,
  ) {
    var minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    var maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (tMin != null) minY = minY < tMin ? minY : tMin;
    if (tMax != null) maxY = maxY > tMax ? maxY : tMax;
    final pad = (maxY - minY) * 0.1 + 1;
    return (minY - pad, maxY + pad);
  }

  Widget _legend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: AppSpacing.sm10, height: 3.h, color: color),
        SizedBox(width: 4.w),
        Text(label, style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
      ],
    );
  }
}
