import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/market/core/market_price_format.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_supply_demand_card.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';
import 'package:mobile_bisa/features/market/domain/repositories/market_repository.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
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
          category:
              prediction.category.isEmpty ? widget.trend.category : prediction.category,
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
              padding: EdgeInsets.all(20.w),
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
    final trendColor = _trendColor(trend.trendType);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20.w,
        20.h,
        20.w,
        20.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_predictionError != null) ...[
            _buildErrorBanner(_predictionError!),
            SizedBox(height: 16.h),
          ],
          _buildInfoSection(trendColor, trend),
          SizedBox(height: 24.h),
          if (trend.historyData.isNotEmpty) ...[
            _buildChartSection(trendColor, trend),
            SizedBox(height: 24.h),
          ],
          _buildDataTable(trend),
          SizedBox(height: 24.h),
          _buildInsightSection(trend),
          if (trend.supplyDemand != null) ...[
            SizedBox(height: 16.h),
            Text(
              'market.sd_section_title'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            MarketSupplyDemandCard(data: trend.supplyDemand!),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleAlert, color: AppColors.error, size: 18.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message.localizedFailure,
              style: TextStyle(fontSize: 12.sp, color: AppColors.error),
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

  Widget _buildInfoSection(Color trendColor, MarketTrendModel trend) {
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
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: trendColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(trendIcon, color: trendColor, size: 14.sp),
              SizedBox(width: 4.w),
              Text(
                '${trend.category} · $trendLabel',
                style: TextStyle(
                  color: trendColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          trend.label,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            _buildStatCard(
              'market.stat_current_price'.tr(),
              trend.currentValue,
              AppColors.primary,
              LucideIcons.tag,
            ),
            SizedBox(width: 12.w),
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
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14.sp, color: AppColors.textSecondary),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: color,
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

    return Container(
      height: 260.h,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            showProjection
                ? 'market.chart_title_projection'.tr()
                : 'market.chart_title_historical'.tr(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.grey100,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (trend.historyData.length / 4).ceilToDouble(),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < trend.historyData.length) {
                          return Text(
                            trend.historyData[index].x.substring(0, 4),
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: trend.historyData
                        .asMap()
                        .entries
                        .map(
                          (e) => FlSpot(e.key.toDouble(), e.value.y.toDouble()),
                        )
                        .toList(),
                    isCurved: true,
                    color: trendColor,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          trendColor.withValues(alpha: 0.2),
                          trendColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  if (showProjection)
                    LineChartBarData(
                      spots: [
                        FlSpot(
                          (trend.historyData.length - 1).toDouble(),
                          trend.historyData.last.y.toDouble(),
                        ),
                        ...trend.projectedData!
                            .asMap()
                            .entries
                            .map(
                              (e) => FlSpot(
                                (trend.historyData.length + e.key).toDouble(),
                                e.value.y.toDouble(),
                              ),
                            ),
                      ],
                      isCurved: true,
                      color: AppColors.secondary,
                      barWidth: 3,
                      dashArray: [5, 5],
                      dotData: FlDotData(show: false),
                    ),
                ],
              ),
            ),
          ),
          if (showProjection) ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _chartLegend(trendColor, 'market.chart_historical'.tr()),
                SizedBox(width: 20.w),
                _chartLegend(AppColors.secondary, 'market.chart_projection'.tr()),
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
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildDataTable(MarketTrendModel trend) {
    if (trend.historyData.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Center(
          child: Text(
            'market.no_historical_data'.tr(),
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
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
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              'market.latest_historical'.tr(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
          ),
          ...displayData.asMap().entries.map((entry) {
            final i = entry.key;
            final point = entry.value;
            final isLast = i == displayData.length - 1;
            return Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        point.x,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                        ),
                      ),
                      Text(
                        formatMarketPriceLikeCurrent(point.y, trend.currentValue),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    color: AppColors.grey100,
                    indent: 16.w,
                    endIndent: 16.w,
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
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.bot, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'BISA AI Insight',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (sourceLabel != null) _buildDataSourceChip(sourceLabel),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            trend.insight ??
                'market.ai_insight_processing'.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Color _trendColor(String trendType) {
    if (trendType == 'UP') return AppColors.success;
    if (trendType == 'STABLE') return AppColors.warning;
    return AppColors.error;
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
