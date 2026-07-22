import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_radius.dart';
import 'package:mobile_bisa/core/constants/app_spacing.dart';
import 'package:mobile_bisa/core/constants/app_text_styles.dart';
import 'package:mobile_bisa/features/market/core/market_trend_metrics.dart';

/// CMC-style filled pill (default) or TV-style tinted badge.
class MarketPercentBadge extends StatelessWidget {
  final double percentChange;
  final bool compact;
  final bool filled;

  const MarketPercentBadge({
    super.key,
    required this.percentChange,
    this.compact = false,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = MarketTrendMetrics.trendColorFromChange(percentChange);
    final isUp = percentChange > 0.05;
    final isDown = percentChange < -0.05;
    final label = MarketTrendMetrics.formatPercent(percentChange);

    if (filled) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6.w : 8.w,
          vertical: compact ? 3.h : 4.h,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(compact ? 4.r : 6.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.chip(
            color: AppColors.textOnPrimary,
            fontSize: compact ? 10.sp : 11.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs6 : AppSpacing.sm,
        vertical: compact ? 2.h : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUp || isDown)
            Icon(
              isUp ? LucideIcons.trendingUp : LucideIcons.trendingDown,
              color: color,
              size: compact ? 9.sp : 10.sp,
            ),
          if (isUp || isDown) SizedBox(width: AppSpacing.xs / 2),
          Text(
            label,
            style: AppTextStyles.chip(
              color: color,
              fontSize: compact ? 10.sp : 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}
