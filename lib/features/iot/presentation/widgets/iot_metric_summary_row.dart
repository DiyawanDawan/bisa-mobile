import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
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
                label: 'iot.metric_min_temp'.tr(),
                value: '${stats.minTemp.toStringAsFixed(1)}°C',
                icon: LucideIcons.thermometer,
                color: AppColors.ocean,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MetricTile(
                label: 'iot.metric_avg'.tr(),
                value: '${stats.avgTemp.toStringAsFixed(1)}°C',
                icon: LucideIcons.activity,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MetricTile(
                label: 'iot.metric_max_temp'.tr(),
                value: '${stats.maxTemp.toStringAsFixed(1)}°C',
                icon: LucideIcons.flame,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        if (stats.maxHum > 0 || stats.avgHum > 0) ...[
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'iot.metric_humidity_avg'.tr(),
                  value: '${stats.avgHum.toStringAsFixed(1)}%',
                  icon: LucideIcons.droplets,
                  color: AppColors.ocean,
                ),
              ),
              if (stats.avgCo2 > 0) ...[
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricTile(
                    label: 'iot.metric_co2_avg'.tr(),
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
          SizedBox(height: AppSpacing.sm),
          _MetricTile(
            label: 'iot.metric_uptime'.tr(),
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
      padding: EdgeInsets.all(AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
