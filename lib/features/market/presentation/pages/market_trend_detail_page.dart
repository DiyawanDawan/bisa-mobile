import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_text_styles.dart';
import 'package:mobile_bisa/features/market/core/market_price_format.dart';
import 'package:mobile_bisa/features/market/core/market_trend_metrics.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_percent_badge.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_supply_demand_card.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';
import 'package:mobile_bisa/features/market/domain/repositories/market_repository.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/bisa_filter_chip.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class MarketTrendDetailPage extends StatefulWidget {
  final MarketTrendModel trend;

  const MarketTrendDetailPage({super.key, required this.trend});

  @override
  State<MarketTrendDetailPage> createState() => _MarketTrendDetailPageState();
}

class _MarketTrendDetailPageState extends State<MarketTrendDetailPage> {
  MarketTrendModel? _prediction;
  bool _loadingPrediction = false;
  String? _predictionError;
  MarketChartRange _range = MarketChartRange.all;

  MarketTrendModel get _displayTrend => _prediction ?? widget.trend;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPrediction();
    });
  }

  Future<void> _loadPrediction() async {
    setState(() {
      _loadingPrediction = true;
      _predictionError = null;
    });

    final result = await sl<MarketRepository>().getPrediction(widget.trend.id);
    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _loadingPrediction = false;
        _predictionError = failure.message;
      }),
      (prediction) => setState(() {
        _loadingPrediction = false;
        _prediction = prediction.copyWith(
          id: prediction.id.isEmpty ? widget.trend.id : prediction.id,
          category: prediction.category.isEmpty
              ? widget.trend.category
              : prediction.category,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'market.detail_title_prediction'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: _loadingPrediction
          ? SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md12),
              child: ShimmerListPlaceholder(
                itemCount: 4,
                itemHeight: 100.h,
              ),
            )
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final trend = _displayTrend;
    final change = MarketTrendMetrics.percentChange(trend);
    final trendColor = MarketTrendMetrics.trendColorFromChange(change);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        AppSpacing.md12,
        AppSpacing.pageGutter,
        AppSpacing.md12 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_predictionError != null) ...[
            _buildErrorBanner(_predictionError!),
            SizedBox(height: AppSpacing.sectionGap),
          ],
          _buildInfoSection(trendColor, trend, change),
          if (trend.historyData.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sectionGap),
            _buildChartSection(trendColor, trend),
          ],
          SizedBox(height: AppSpacing.sectionGap),
          _buildDataTable(trend),
          SizedBox(height: AppSpacing.sectionGap),
          _buildInsightSection(trend),
          if (trend.supplyDemand != null) ...[
            SizedBox(height: AppSpacing.sectionGap),
            Text(
              'market.sd_section_title'.tr(),
              style: AppTextStyles.sectionTitle(),
            ),
            SizedBox(height: AppSpacing.compact),
            MarketSupplyDemandCard(data: trend.supplyDemand!),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleAlert, color: AppColors.error, size: 18.sp),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message.localizedFailure,
              style: AppTextStyles.caption(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: _loadPrediction,
            child: Text('market.retry'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    Color trendColor,
    MarketTrendModel trend,
    double change,
  ) {
    final isUp = trend.trendType == 'UP';
    final isStable = trend.trendType == 'STABLE';
    final trendIcon = isUp
        ? LucideIcons.trendingUp
        : (isStable ? LucideIcons.minus : LucideIcons.trendingDown);
    final trendLabel = isUp
        ? 'market.trend_up'.tr()
        : (isStable ? 'market.trend_stable'.tr() : 'market.trend_down'.tr());
    final hasProjection =
        trend.projectedData != null && trend.projectedData!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm10,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: trendColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(trendIcon, color: trendColor, size: 14.sp),
              SizedBox(width: AppSpacing.xs),
              Text(
                '${trend.category} · $trendLabel',
                style: AppTextStyles.chip(color: trendColor),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.compact),
        Text(
          trend.label,
          style: AppTextStyles.sheetTitle().copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: AppSpacing.compact),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                trend.currentValue,
                style: AppTextStyles.price(fontWeight: FontWeight.w900)
                    .copyWith(fontSize: 24.sp),
              ),
            ),
            MarketPercentBadge(percentChange: change),
          ],
        ),
        SizedBox(height: AppSpacing.sectionGap),
        Row(
          children: [
            _buildStatCard(
              'market.stat_current_price'.tr(),
              trend.currentValue,
              AppColors.primary,
              LucideIcons.tag,
            ),
            SizedBox(width: AppSpacing.sm),
            _buildStatCard(
              'market.stat_prediction_3mo'.tr(),
              hasProjection
                  ? formatMarketPriceLikeCurrent(
                      trend.projectedData!.last.y,
                      trend.currentValue,
                    )
                  : 'market.prediction_not_available'.tr(),
              AppColors.secondary,
              LucideIcons.bot,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14.sp, color: AppColors.textSecondary),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption(),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(Color trendColor, MarketTrendModel trend) {
    final showProjection =
        trend.projectedData != null && trend.projectedData!.isNotEmpty;
    final history = MarketTrendMetrics.sliceHistory(
      trend.historyData,
      _range,
    );

    return Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            showProjection
                ? 'market.chart_title_projection'.tr()
                : 'market.chart_title_historical'.tr(),
            style: AppTextStyles.sectionTitle(),
          ),
          SizedBox(height: AppSpacing.compact),
          SizedBox(
            height: 200.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: AppColors.grey100,
                      strokeWidth: 1,
                    ),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: history
                        .asMap()
                        .entries
                        .map(
                          (e) => FlSpot(e.key.toDouble(), e.value.y.toDouble()),
                        )
                        .toList(),
                    isCurved: true,
                    color: trendColor,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          trendColor.withValues(alpha: 0.2),
                          trendColor.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                  if (showProjection)
                    LineChartBarData(
                      spots: [
                        FlSpot(
                          (history.length - 1).toDouble(),
                          history.last.y.toDouble(),
                        ),
                        ...trend.projectedData!
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                (history.length + e.key).toDouble(),
                                e.value.y.toDouble(),
                              ),
                            ),
                      ],
                      isCurved: true,
                      color: AppColors.secondary,
                      barWidth: 2.5,
                      dashArray: [5, 5],
                      dotData: const FlDotData(show: false),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.compact),
          Row(
            children: [
              BisaFilterChip(
                label: 'market.range_1m'.tr(),
                isSelected: _range == MarketChartRange.oneMonth,
                onTap: () =>
                    setState(() => _range = MarketChartRange.oneMonth),
              ),
              SizedBox(width: AppSpacing.sm),
              BisaFilterChip(
                label: 'market.range_3m'.tr(),
                isSelected: _range == MarketChartRange.threeMonths,
                onTap: () =>
                    setState(() => _range = MarketChartRange.threeMonths),
              ),
              SizedBox(width: AppSpacing.sm),
              BisaFilterChip(
                label: 'market.range_all'.tr(),
                isSelected: _range == MarketChartRange.all,
                onTap: () => setState(() => _range = MarketChartRange.all),
              ),
            ],
          ),
          if (showProjection) ...[
            SizedBox(height: AppSpacing.compact),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _chartLegend(trendColor, 'market.chart_historical'.tr()),
                SizedBox(width: AppSpacing.md),
                _chartLegend(
                  AppColors.secondary,
                  'market.chart_projection'.tr(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _chartLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: AppSpacing.xs6),
        Text(label, style: AppTextStyles.caption()),
      ],
    );
  }

  Widget _buildDataTable(MarketTrendModel trend) {
    if (trend.historyData.isEmpty) {
      return Container(
        padding: EdgeInsets.all(AppSpacing.md12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Center(
          child: Text(
            'market.no_historical_data'.tr(),
            style: AppTextStyles.bodySecondary(),
          ),
        ),
      );
    }

    final displayData = trend.historyData.length > 6
        ? trend.historyData.sublist(trend.historyData.length - 6)
        : trend.historyData;

    return Container(
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
              AppSpacing.compact,
            ),
            child: Text(
              'market.latest_historical'.tr(),
              style: AppTextStyles.sectionTitle(),
            ),
          ),
          ...displayData.asMap().entries.map((entry) {
            final i = entry.key;
            final point = entry.value;
            final isLast = i == displayData.length - 1;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md12,
                    vertical: AppSpacing.sm10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(point.x, style: AppTextStyles.bodySecondary()),
                      Text(
                        formatMarketPriceLikeCurrent(
                          point.y,
                          trend.currentValue,
                        ),
                        style: AppTextStyles.body(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    color: AppColors.grey100,
                    indent: AppSpacing.md12,
                    endIndent: AppSpacing.md12,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInsightSection(MarketTrendModel trend) {
    final sourceLabel = _dataSourceLabel(trend.dataSources);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.bot, color: AppColors.primary, size: 20.sp),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'BISA AI Insight',
                  style: AppTextStyles.sectionTitle(color: AppColors.primary),
                ),
              ),
              if (sourceLabel != null) _buildDataSourceChip(sourceLabel),
            ],
          ),
          SizedBox(height: AppSpacing.compact),
          Text(
            trend.insight ?? 'market.ai_insight_processing'.tr(),
            style: AppTextStyles.bodySecondary(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String? _dataSourceLabel(List<String> dataSources) {
    if (dataSources.isEmpty) return null;
    if (dataSources.contains('bisa_orders')) {
      return 'market.data_source_live'.tr();
    }
    if (dataSources.contains('bisa_listings')) {
      return 'market.data_source_blended'.tr();
    }
    if (dataSources.contains('historical_seed') ||
        dataSources.contains('benchmark_seed')) {
      return 'market.data_source_reference'.tr();
    }
    return null;
  }

  Widget _buildDataSourceChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro(color: AppColors.primary),
      ),
    );
  }
}
