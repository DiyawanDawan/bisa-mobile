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
import 'package:mobile_bisa/features/market/presentation/widgets/market_section_header.dart';

class MarketMoversSection extends StatelessWidget {
  final List<MarketTrendModel> trends;
  final VoidCallback? onSeeAll;

  const MarketMoversSection({
    super.key,
    required this.trends,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final gainers = MarketTrendMetrics.gainers(trends);
    final losers = MarketTrendMetrics.losers(trends);

    if (gainers.isEmpty && losers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (gainers.isNotEmpty) ...[
          MarketSectionHeader(
            title: 'market.gainers'.tr(),
            onSeeAll: onSeeAll,
          ),
          SizedBox(height: AppSpacing.compact),
          _MoverList(trends: gainers),
        ],
        if (gainers.isNotEmpty && losers.isNotEmpty)
          SizedBox(height: AppSpacing.sectionGap),
        if (losers.isNotEmpty) ...[
          MarketSectionHeader(
            title: 'market.losers'.tr(),
            onSeeAll: onSeeAll,
          ),
          SizedBox(height: AppSpacing.compact),
          _MoverList(trends: losers),
        ],
      ],
    );
  }
}

class _MoverList extends StatelessWidget {
  final List<MarketTrendModel> trends;

  const _MoverList({required this.trends});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        children: [
          for (var i = 0; i < trends.length; i++) ...[
            _MoverRow(trend: trends[i]),
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

class _MoverRow extends StatelessWidget {
  final MarketTrendModel trend;

  const _MoverRow({required this.trend});

  @override
  Widget build(BuildContext context) {
    final change = MarketTrendMetrics.percentChange(trend);
    final color = MarketTrendMetrics.trendColorFromChange(change);

    return InkWell(
      onTap: () => context.push('/market-detail/${trend.id}', extra: trend),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md12,
          vertical: AppSpacing.sm10,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                MarketTrendMetrics.categoryIcon(trend.category),
                color: color,
                size: 18.sp,
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
            SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  trend.currentValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySm(fontWeight: FontWeight.w800),
                ),
                MarketPercentBadge(percentChange: change, compact: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
