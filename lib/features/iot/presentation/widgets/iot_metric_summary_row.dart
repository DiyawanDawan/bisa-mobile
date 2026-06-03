import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/iot_dashboard_entity.dart';

class IotMetricSummaryRow extends StatelessWidget {
  const IotMetricSummaryRow({super.key, required this.stats, this.uptimePercent});

  final IotSummaryStats stats;
  final double? uptimePercent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Min Suhu',
                value: '${stats.minTemp.toStringAsFixed(1)}°C',
                icon: LucideIcons.thermometer,
                color: AppColors.ocean,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _MetricTile(
                label: 'Rata-rata',
                value: '${stats.avgTemp.toStringAsFixed(1)}°C',
                icon: LucideIcons.activity,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _MetricTile(
                label: 'Max Suhu',
                value: '${stats.maxTemp.toStringAsFixed(1)}°C',
                icon: LucideIcons.flame,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        if (stats.maxHum > 0 || stats.avgHum > 0) ...[
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Kelembaban',
                  value: '${stats.avgHum.toStringAsFixed(1)}%',
                  icon: LucideIcons.droplets,
                  color: AppColors.ocean,
                ),
              ),
              if (stats.avgCo2 > 0) ...[
                SizedBox(width: 8.w),
                Expanded(
                  child: _MetricTile(
                    label: 'CO₂ avg',
                    value: '${stats.avgCo2.toStringAsFixed(0)} ppm',
                    icon: LucideIcons.cloud,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ],
          ),
        ],
        if (uptimePercent != null) ...[
          SizedBox(height: 8.h),
          _MetricTile(
            label: 'Uptime estimasi',
            value: '${uptimePercent!.toStringAsFixed(1)}%',
            icon: LucideIcons.signal,
            color: AppColors.success,
          ),
        ],
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
