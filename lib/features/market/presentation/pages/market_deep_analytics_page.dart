import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/market/data/models/market_supply_demand_model.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';
import 'package:mobile_bisa/features/market/domain/repositories/market_repository.dart';
import 'package:mobile_bisa/features/market/presentation/bloc/market_cubit.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_supply_demand_card.dart';
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
  MarketSupplyDemandOverviewModel? _supplyDemand;
  bool _loadingSd = true;

  @override
  void initState() {
    super.initState();
    _loadSupplyDemand();
  }

  Future<void> _loadSupplyDemand() async {
    setState(() => _loadingSd = true);
    final result = await sl<MarketRepository>().getSupplyDemandOverview();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loadingSd = false),
      (data) => setState(() {
        _supplyDemand = data;
        _loadingSd = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MarketCubit>()..getMarketTrends(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'market.deep_analytics_title'.tr(),
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
                onRefresh: () async {
                  await context.read<MarketCubit>().getMarketTrends();
                  await _loadSupplyDemand();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroCard(trends.length, _supplyDemand),
                      SizedBox(height: 24.h),
                      Text(
                        'market.sd_section_title'.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      if (_loadingSd)
                        const ShimmerListPlaceholder(itemCount: 2, itemHeight: 120)
                      else if (_supplyDemand != null)
                        ..._supplyDemand!.commodities.map(
                          (c) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: MarketSupplyDemandCard(data: c),
                          ),
                        )
                      else
                        Text(
                          'market.sd_load_failed'.tr(),
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
                        ),
                      SizedBox(height: 24.h),
                      Text(
                        'market.deep_ai_by_commodity'.tr(),
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

  Widget _buildHeroCard(int count, MarketSupplyDemandOverviewModel? sd) {
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
            'market.deep_hero_title'.tr(),
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'market.deep_hero_subtitle'.tr(namedArgs: {'count': '$count'}),
            style: TextStyle(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
          if (sd != null) ...[
            SizedBox(height: 12.h),
            Text(
              'market.sd_hero_totals'.tr(namedArgs: {
                'products': '${sd.totalProductCount}',
                'supply': _formatTon(sd.totalStockTon),
                'demand': _formatTon(sd.totalDemandTon90d),
              }),
              style: TextStyle(
                color: AppColors.textOnPrimary.withValues(alpha: 0.95),
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
          ],
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
                      'market.deep_view_prediction_cta'.tr(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: AppColors.grey400, size: 20.sp),
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
            Icon(LucideIcons.circleAlert, color: AppColors.error, size: 40.sp),
            SizedBox(height: 12.h),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => context.read<MarketCubit>().getMarketTrends(),
              child: Text('market.retry'.tr()),
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

  String _formatTon(double ton) {
    return NumberFormat('#,##0.0', 'id_ID').format(ton);
  }
}
