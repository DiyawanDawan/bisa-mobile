import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
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

class MarketFeaturedChart extends StatefulWidget {
  final MarketTrendModel trend;

  const MarketFeaturedChart({super.key, required this.trend});

  @override
  State<MarketFeaturedChart> createState() => _MarketFeaturedChartState();
}

class _MarketFeaturedChartState extends State<MarketFeaturedChart> {
  MarketChartRange _range = MarketChartRange.threeMonths;

  @override
  Widget build(BuildContext context) {
    final history = MarketTrendMetrics.sliceHistory(
      widget.trend.historyData,
      _range,
    );
    if (history.isEmpty) return const SizedBox.shrink();

    final change = MarketTrendMetrics.percentChange(widget.trend);
    final trendColor = MarketTrendMetrics.trendColorFromChange(change);
    final values = history.map((e) => e.y.toDouble()).toList();
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.08;

    return GestureDetector(
      onTap: () => context.push(
        '/market-detail/${widget.trend.id}',
        extra: widget.trend,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md12,
                AppSpacing.md12,
                AppSpacing.md12,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'market.breadcrumb'.tr(),
                    style: AppTextStyles.micro(color: AppColors.textHint),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.trend.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.sectionTitle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xs / 2),
                            Text(
                              widget.trend.currentValue,
                              style: AppTextStyles.price(
                                fontWeight: FontWeight.w900,
                              ).copyWith(fontSize: 20.sp),
                            ),
                          ],
                        ),
                      ),
                      MarketPercentBadge(percentChange: change),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200.h,
              child: LineChart(
                LineChartData(
                  minY: minY - padding,
                  maxY: maxY + padding,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: AppColors.grey100,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44.w,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max || value == meta.min) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.only(left: 4.w),
                            child: Text(
                              _formatAxis(value),
                              style: AppTextStyles.micro(
                                color: AppColors.textHint,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: const LineTouchData(enabled: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: history
                          .asMap()
                          .entries
                          .map(
                            (e) => FlSpot(
                              e.key.toDouble(),
                              e.value.y.toDouble(),
                            ),
                          )
                          .toList(),
                      isCurved: true,
                      color: trendColor,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            trendColor.withValues(alpha: 0.25),
                            trendColor.withValues(alpha: 0.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md12,
                0,
                AppSpacing.md12,
                AppSpacing.md12,
              ),
              child: Row(
                children: [
                  _TvRangeTab(
                    label: 'market.range_1m'.tr(),
                    selected: _range == MarketChartRange.oneMonth,
                    onTap: () =>
                        setState(() => _range = MarketChartRange.oneMonth),
                  ),
                  _TvRangeTab(
                    label: 'market.range_3m'.tr(),
                    selected: _range == MarketChartRange.threeMonths,
                    onTap: () =>
                        setState(() => _range = MarketChartRange.threeMonths),
                  ),
                  _TvRangeTab(
                    label: 'market.range_all'.tr(),
                    selected: _range == MarketChartRange.all,
                    onTap: () => setState(() => _range = MarketChartRange.all),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAxis(double value) {
    if (value >= 1_000_000) {
      return '${(value / 1_000_000).toStringAsFixed(1)}jt';
    }
    if (value >= 1_000) {
      return '${(value / 1_000).toStringAsFixed(0)}rb';
    }
    return value.toStringAsFixed(0);
  }
}

class _TvRangeTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TvRangeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.sm),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm10,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.textPrimary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption(
            color: selected ? AppColors.textPrimary : AppColors.textHint,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
