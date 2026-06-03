import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';
import 'package:mobile_bisa/features/market/presentation/bloc/market_cubit.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:mobile_bisa/core/utils/pro_subscription.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';

class MarketInsightPage extends StatefulWidget {
  const MarketInsightPage({super.key});

  @override
  State<MarketInsightPage> createState() => _MarketInsightPageState();
}

class _MarketInsightPageState extends State<MarketInsightPage> {
  @override
  void initState() {
    super.initState();
  }

  /// Pro feature gating: Pro (IoT, Analitik Mendalam) khusus Supplier.
  bool _isSupplier(BuildContext context) {
    return context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.role == 'SUPPLIER',
          orElse: () => false,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MarketCubit>()..getMarketTrends(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const BisaAppBar(
          title: 'Market Intelligence',
          backgroundColor: AppColors.surface,
        ),
        body: BlocBuilder<MarketCubit, MarketState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => Padding(
                padding: EdgeInsets.all(20.w),
                child: const ShimmerListPlaceholder(),
              ),
              error: (message) => Center(
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
                        onPressed: () =>
                            context.read<MarketCubit>().getMarketTrends(),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              loaded: (trends) => RefreshIndicator(
                onRefresh: () async =>
                    context.read<MarketCubit>().getMarketTrends(),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroCard(),
                      // Pro upsell card hanya tampil untuk Supplier.
                      // Pembeli (Buyer) tidak diarahkan ke Pro karena
                      // fitur Pro (analitik bisnis) bukan kebutuhan pembeli.
                      if (_isSupplier(context)) ...[
                        SizedBox(height: 16.h),
                        _buildProDeepAnalyticsCard(context),
                      ],
                      SizedBox(height: 24.h),
                      Text(
                        'Harga Pasar Hari Ini',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: AppColors.grey100),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: trends.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: AppColors.grey100,
                            indent: 16.w,
                            endIndent: 16.w,
                          ),
                          itemBuilder: (context, index) =>
                              _buildTrendCard(trends[index]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              orElse: () => const SizedBox(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
            AppColors.primary.withValues(alpha: 0.65),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.trendingUp, color: AppColors.textOnPrimary, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Gratis untuk Semua',
                style: TextStyle(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Pantau Tren Harga\nKomoditas Biomassa',
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'dapatkan_wawasan_pasar_berbasi'.tr(),
            style: TextStyle(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProDeepAnalyticsCard(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    final isPro = user != null && isProActive(user);

    return InkWell(
      onTap: () => context.push('/market-deep-analytics'),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.warning, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(LucideIcons.sparkles, color: AppColors.textOnPrimary, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Analitik Mendalam',
                        style: TextStyle(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textOnPrimary,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'PRO',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    isPro
                        ? 'Prediksi AI, proyeksi harga & insight bisnis'
                        : 'Upgrade PRO untuk prediksi AI & proyeksi harga',
                    style: TextStyle(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: AppColors.textOnPrimary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard(MarketTrendModel trend) {
    final trendColor = _trendColor(trend.trendType);

    return InkWell(
      onTap: () => context.push('/market-detail/${trend.id}', extra: trend),
      child: Container(
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            // Icon section
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: trendColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                _getCategoryIcon(trend.category),
                color: trendColor,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Info section
            Expanded(
              flex: 3,
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
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            // Sparkline section (Mini Chart)
            if (trend.historyData.isNotEmpty)
              Expanded(
                flex: 2,
                child: Container(
                  height: 30.h,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
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
              ),
            // Price section
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    trend.currentValue,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: trendColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trend.trendType == 'UP'
                              ? LucideIcons.trendingUp
                              : LucideIcons.trendingDown,
                          color: trendColor,
                          size: 10.sp,
                        ),
                        SizedBox(width: 2.w),
                        Builder(
                          builder: (context) {
                            String percentage = '0.0%';
                            if (trend.historyData.length >= 2) {
                              final current = trend.historyData.last.y;
                              final previous = trend.historyData[trend.historyData.length - 2].y;
                              if (previous != 0) {
                                final change = ((current - previous) / previous) * 100;
                                percentage = '${change.abs().toStringAsFixed(1)}%';
                              }
                            }
                            return Text(
                              percentage,
                              style: TextStyle(
                                color: trendColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cangkang sawit':
        return LucideIcons.nut;
      case 'kayu':
        return LucideIcons.treePine;
      case 'sekam padi':
        return LucideIcons.wheat;
      default:
        return LucideIcons.leaf;
    }
  }
}
