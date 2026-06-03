import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';
import 'package:mobile_bisa/features/market/presentation/bloc/market_cubit.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class MarketDeepAnalyticsPage extends StatefulWidget {
  const MarketDeepAnalyticsPage({super.key});

  @override
  State<MarketDeepAnalyticsPage> createState() =>
      _MarketDeepAnalyticsPageState();
}

class _MarketDeepAnalyticsPageState extends State<MarketDeepAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MarketCubit>()..getMarketTrends(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const BisaAppBar(
          title: 'Analitik Mendalam',
          backgroundColor: AppColors.surface,
        ),
        body: BlocBuilder<MarketCubit, MarketState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => Padding(
                padding: EdgeInsets.all(20.w),
                child: const ShimmerListPlaceholder(),
              ),
              error: (message) => _buildError(context, message),
              loaded: (trends) => RefreshIndicator(
                onRefresh: () async =>
                    context.read<MarketCubit>().getMarketTrends(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroCard(trends.length),
                      SizedBox(height: 24.h),
                      Text(
                        'Prediksi AI per Komoditas',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ...trends.map(_buildTrendCard),
                    ],
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroCard(int count) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'PRO',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(LucideIcons.sparkles, color: AppColors.warning, size: 18.sp),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Analitik Pasar Mendalam',
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Prediksi harga 3 bulan, proyeksi AI, dan insight bisnis untuk $count komoditas biomassa.',
            style: TextStyle(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(MarketTrendModel trend) {
    final trendColor = _trendColor(trend.trendType);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => context.push('/market-detail/${trend.id}', extra: trend),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: trendColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  LucideIcons.bot,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trend.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      trend.category,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Lihat prediksi & insight AI →',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (trend.historyData.isNotEmpty)
                SizedBox(
                  width: 56.w,
                  height: 28.h,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: trend.historyData
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
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.circleAlert,
              size: 48.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => context.read<MarketCubit>().getMarketTrends(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Color _trendColor(String trendType) {
    if (trendType == 'UP') return AppColors.success;
    if (trendType == 'STABLE') return AppColors.warning;
    return AppColors.error;
  }
}
