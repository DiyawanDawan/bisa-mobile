import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';

/// Free vs Pro feature comparison (FB-18).
class ProTierMatrix extends StatelessWidget {
  const ProTierMatrix({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = <_TierRow>[
      _TierRow('pro.matrix_iot_title'.tr(), false, true),
      _TierRow('pro.matrix_ai_chat_title'.tr(), false, true),
      _TierRow('pro.matrix_analytics_title'.tr(), 'pro.matrix_limited'.tr(), 'pro.matrix_full'.tr()),
      _TierRow('pro.matrix_predict_title'.tr(), 'pro.matrix_quota_free'.tr(), 'pro.matrix_unlimited'.tr()),
      _TierRow('pro.matrix_gis_title'.tr(), true, true),
      _TierRow('pro.matrix_marketplace_title'.tr(), true, true),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _headerRow(),
          for (int i = 0; i < rows.length; i++) _dataRow(rows[i], i.isOdd),
        ],
      ),
    );
  }

  Widget _headerRow() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.06),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md12,
        vertical: AppSpacing.md12,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'pro.matrix_feature'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'pro.matrix_free'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'pro.matrix_pro'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dataRow(_TierRow row, bool shaded) {
    return Container(
      color: shaded ? AppColors.grey50 : AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md12,
        vertical: AppSpacing.sm10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              row.label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(child: _cellValue(row.free)),
          Expanded(child: _cellValue(row.pro, highlight: true)),
        ],
      ),
    );
  }

  Widget _cellValue(dynamic value, {bool highlight = false}) {
    if (value is bool) {
      return Icon(
        value ? LucideIcons.check : LucideIcons.x,
        size: 16.sp,
        color: value
            ? (highlight ? AppColors.primary : AppColors.success)
            : AppColors.grey300,
      );
    }
    return Text(
      value.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
        color: highlight ? AppColors.primary : AppColors.textSecondary,
        height: 1.3,
      ),
    );
  }
}

class _TierRow {
  const _TierRow(this.label, this.free, this.pro);
  final String label;
  final dynamic free;
  final dynamic pro;
}
