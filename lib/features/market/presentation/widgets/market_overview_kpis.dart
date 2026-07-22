import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_radius.dart';
import 'package:mobile_bisa/core/constants/app_spacing.dart';
import 'package:mobile_bisa/core/constants/app_text_styles.dart';
import 'package:mobile_bisa/features/market/core/market_trend_metrics.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_sparkline.dart';

class MarketOverviewKpis extends StatelessWidget {
  final List<MarketTrendModel> trends;

  const MarketOverviewKpis({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    final up = MarketTrendMetrics.countUp(trends);
    final down = MarketTrendMetrics.countDown(trends);
    final avg = MarketTrendMetrics.averageChange(trends);
    final top = MarketTrendMetrics.topMover(trends);

    return SizedBox(
      height: 72.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _KpiCard(
            label: 'market.kpi_up'.tr(),
            value: '$up',
            sub: 'market.kpi_up_sub'.tr(),
            color: AppColors.success,
          ),
          SizedBox(width: AppSpacing.sm),
          _KpiCard(
            label: 'market.kpi_down'.tr(),
            value: '$down',
            sub: 'market.kpi_down_sub'.tr(),
            color: AppColors.error,
          ),
          SizedBox(width: AppSpacing.sm),
          _KpiCard(
            label: 'market.kpi_avg_change'.tr(),
            value: MarketTrendMetrics.formatPercent(avg),
            sub: 'market.kpi_avg_sub'.tr(),
            color: MarketTrendMetrics.trendColorFromChange(avg),
            sparklineTrend: top,
          ),
          if (top != null) ...[
            SizedBox(width: AppSpacing.sm),
            _KpiCard(
              label: 'market.kpi_top_mover'.tr(),
              value: top.label,
              sub: top.currentValue,
              color: AppColors.primary,
              isWide: true,
              sparklineTrend: top,
            ),
          ],
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  final bool isWide;
  final MarketTrendModel? sparklineTrend;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
    this.isWide = false,
    this.sparklineTrend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWide ? 150.w : 118.w,
      padding: EdgeInsets.all(AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppSpacing.xs / 2),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      sub,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro(color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
              if (sparklineTrend != null &&
                  sparklineTrend!.historyData.isNotEmpty)
                MarketSparkline(
                  trend: sparklineTrend!,
                  width: 40.w,
                  height: 22,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
