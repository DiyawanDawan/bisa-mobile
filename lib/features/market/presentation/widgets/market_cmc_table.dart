import 'package:easy_localization/easy_localization.dart';
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
import 'package:mobile_bisa/features/market/presentation/widgets/market_sparkline.dart';

class MarketCmcTable extends StatelessWidget {
  final List<MarketTrendModel> trends;

  const MarketCmcTable({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        children: [
          _TableHeader(),
          const Divider(height: 1, color: AppColors.grey100),
          for (var i = 0; i < trends.length; i++) ...[
            _TrendRow(rank: i + 1, trend: trends[i]),
            if (i < trends.length - 1)
              Divider(
                height: 1,
                color: AppColors.grey100,
                indent: AppSpacing.md12,
                endIndent: AppSpacing.md12,
              ),
          ],
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md12,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              '#',
              style: AppTextStyles.micro(color: AppColors.textHint),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'market.col_name'.tr(),
              style: AppTextStyles.micro(color: AppColors.textHint),
            ),
          ),
          SizedBox(
            width: 52.w,
            child: Text(
              'market.col_chart'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.micro(color: AppColors.textHint),
            ),
          ),
          SizedBox(
            width: 72.w,
            child: Text(
              'market.col_price'.tr(),
              textAlign: TextAlign.end,
              style: AppTextStyles.micro(color: AppColors.textHint),
            ),
          ),
          SizedBox(width: 52.w),
        ],
      ),
    );
  }
}

class _TrendRow extends StatelessWidget {
  final int rank;
  final MarketTrendModel trend;

  const _TrendRow({required this.rank, required this.trend});

  @override
  Widget build(BuildContext context) {
    final change = MarketTrendMetrics.percentChange(trend);
    final color = MarketTrendMetrics.trendColorFromChange(change);

    return InkWell(
      onTap: () => context.push('/market-detail/${trend.id}', extra: trend),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: AppSpacing.controlHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md12,
            vertical: AppSpacing.sm10,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20.w,
                child: Text(
                  '$rank',
                  style: AppTextStyles.caption(
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.r),
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
                      style: AppTextStyles.body(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      trend.category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption(),
                    ),
                  ],
                ),
              ),
              if (trend.historyData.isNotEmpty)
                SizedBox(
                  width: 52.w,
                  child: Center(
                    child: MarketSparkline(trend: trend, width: 48.w),
                  ),
                )
              else
                SizedBox(width: 52.w),
              SizedBox(
                width: 72.w,
                child: Text(
                  trend.currentValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.bodySm(fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(width: AppSpacing.xs6),
              SizedBox(
                width: 46.w,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: MarketPercentBadge(
                    percentChange: change,
                    compact: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
