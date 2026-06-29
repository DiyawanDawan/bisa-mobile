import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/iot_dashboard_entity.dart';

/// Kartu kompak: suhu/kelembaban utama + statistik sesi dalam satu blok.
class IotCurrentConditionsPanel extends StatelessWidget {
  const IotCurrentConditionsPanel({
    super.key,
    required this.lastReading,
    required this.stats,
    required this.uptimePercent,
    required this.readingsLabel,
  });

  final IotLastReading? lastReading;
  final IotSummaryStats stats;
  final double uptimePercent;
  final String readingsLabel;

  @override
  Widget build(BuildContext context) {
    final temp = lastReading?.temperature;
    final hum = lastReading?.humidity;
    final hasCo2 = stats.avgCo2 > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'iot.current_conditions'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              readingsLabel,
              style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _HeroMetric(
                      icon: LucideIcons.thermometer,
                      color: AppColors.error,
                      value: temp != null ? '${temp.toStringAsFixed(1)}°C' : '—',
                      label: 'iot.metric_temperature'.tr(),
                    ),
                  ),
                  _divider(),
                  Expanded(
                    child: _HeroMetric(
                      icon: LucideIcons.droplets,
                      color: AppColors.ocean,
                      value: hum != null ? '${hum.toStringAsFixed(1)}%' : '—',
                      label: 'iot.metric_humidity'.tr(),
                    ),
                  ),
                  _divider(),
                  Expanded(
                    child: _HeroMetric(
                      icon: LucideIcons.signal,
                      color: AppColors.success,
                      value: '${uptimePercent.toStringAsFixed(0)}%',
                      label: 'iot.metric_uptime'.tr(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Divider(height: 1, color: AppColors.grey100),
              ),
              Row(
                children: [
                  Expanded(
                    child: _StatCell(
                      label: 'iot.metric_min_temp'.tr(),
                      value: '${stats.minTemp.toStringAsFixed(1)}°C',
                    ),
                  ),
                  Expanded(
                    child: _StatCell(
                      label: 'iot.metric_avg'.tr(),
                      value: '${stats.avgTemp.toStringAsFixed(1)}°C',
                    ),
                  ),
                  Expanded(
                    child: _StatCell(
                      label: 'iot.metric_max_temp'.tr(),
                      value: '${stats.maxTemp.toStringAsFixed(1)}°C',
                    ),
                  ),
                  if (hasCo2)
                    Expanded(
                      child: _StatCell(
                        label: 'iot.metric_co2_avg'.tr(),
                        value: '${stats.avgCo2.toStringAsFixed(0)}',
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36.h,
        color: AppColors.grey100,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
      );
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 14.sp, color: color),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 9.sp, color: AppColors.textHint),
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 9.sp, color: AppColors.textHint),
        ),
      ],
    );
  }
}
