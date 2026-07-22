import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_radius.dart';
import 'package:mobile_bisa/core/constants/app_spacing.dart';
import 'package:mobile_bisa/core/constants/app_text_styles.dart';
import 'package:mobile_bisa/features/market/core/market_trend_metrics.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_percent_badge.dart';

/// TradingView-style major indices horizontal cards.
class MarketIndexCarousel extends StatelessWidget {
  final List<MarketTrendModel> trends;

  const MarketIndexCarousel({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 108.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trends.length,
        separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final trend = trends[index];
          final change = MarketTrendMetrics.percentChange(trend);
          final color = MarketTrendMetrics.trendColorFromChange(change);

          return GestureDetector(
            onTap: () => context.push(
              '/market-detail/${trend.id}',
              extra: trend,
            ),
            child: Container(
              width: 0.56.sw,
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.grey100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      MarketTrendMetrics.categoryIcon(trend.category),
                      color: color,
                      size: 16.sp,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trend.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs / 2),
                        Text(
                          trend.currentValue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySm(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        MarketPercentBadge(
                          percentChange: change,
                          compact: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
