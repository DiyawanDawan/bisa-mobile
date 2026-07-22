import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_text_styles.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/features/market/core/market_trend_metrics.dart';
import 'package:mobile_bisa/features/market/data/models/market_trend_model.dart';
import 'package:mobile_bisa/features/market/presentation/bloc/market_cubit.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_category_pills.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_cmc_table.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_featured_chart.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_index_carousel.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_movers_section.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_overview_kpis.dart';
import 'package:mobile_bisa/features/market/presentation/widgets/market_section_header.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class MarketInsightPage extends StatefulWidget {
  const MarketInsightPage({super.key});

  @override
  State<MarketInsightPage> createState() => _MarketInsightPageState();
}

class _MarketInsightPageState extends State<MarketInsightPage> {
  String? _selectedCategory;
  final _listKey = GlobalKey();

  bool _isSupplier(BuildContext context) {
    return context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.role == 'SUPPLIER',
          orElse: () => false,
        );
  }

  List<MarketTrendModel> _filtered(List<MarketTrendModel> trends) {
    return MarketTrendMetrics.filterByCategory(trends, _selectedCategory);
  }

  void _scrollToList() {
    final ctx = _listKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MarketCubit>()..getMarketTrends(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'market.insight_title'.tr(),
          backgroundColor: AppColors.surface,
        ),
        body: BlocBuilder<MarketCubit, MarketState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => Padding(
                padding: AppSpacing.screenPaddingHorizontal,
                child: const ShimmerListPlaceholder(),
              ),
              error: (message) => Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.circleAlert,
                        size: 48.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: AppSpacing.md12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md12),
                      TextButton(
                        onPressed: () =>
                            context.read<MarketCubit>().getMarketTrends(),
                        child: Text('market.retry'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
              loaded: (trends) {
                final filtered = _filtered(trends);
                final featured = MarketTrendMetrics.featuredTrend(filtered);
                final categories = MarketTrendMetrics.categories(trends);

                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<MarketCubit>().getMarketTrends(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.pageGutter,
                          AppSpacing.md12,
                          AppSpacing.pageGutter,
                          AppSpacing.md12 + MediaQuery.paddingOf(context).bottom,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            _buildPageHeader(),
                            SizedBox(height: AppSpacing.sectionGap),
                            MarketOverviewKpis(trends: filtered),
                            if (_isSupplier(context)) ...[
                              SizedBox(height: AppSpacing.sectionGap),
                              _buildProDeepAnalyticsCard(context),
                            ],
                            SizedBox(height: AppSpacing.sectionGap),
                            MarketCategoryPills(
                              categories: categories,
                              selectedCategory: _selectedCategory,
                              onSelected: (cat) =>
                                  setState(() => _selectedCategory = cat),
                            ),
                            if (filtered.isEmpty) ...[
                              SizedBox(height: AppSpacing.sectionGap),
                              _buildEmptyFilterState(),
                            ] else ...[
                            if (featured != null) ...[
                              SizedBox(height: AppSpacing.sectionGap),
                              MarketFeaturedChart(trend: featured),
                            ],
                            SizedBox(height: AppSpacing.sectionGap),
                            MarketSectionHeader(
                              title: 'market.major_commodities'.tr(),
                            ),
                            SizedBox(height: AppSpacing.compact),
                            MarketIndexCarousel(trends: filtered),
                            SizedBox(height: AppSpacing.sectionGap),
                            MarketMoversSection(
                              trends: filtered,
                              onSeeAll: _scrollToList,
                            ),
                            SizedBox(height: AppSpacing.sectionGap),
                            KeyedSubtree(
                              key: _listKey,
                              child: MarketSectionHeader(
                                title: 'market.section_today_prices'.tr(),
                              ),
                            ),
                            SizedBox(height: AppSpacing.compact),
                            MarketCmcTable(trends: filtered),
                            ],
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              },
              orElse: () => const SizedBox(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'market.page_subtitle'.tr(),
          style: AppTextStyles.caption(color: AppColors.primary),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'market.hero_title'.tr().replaceAll('\n', ' '),
          style: AppTextStyles.pageTitle(),
        ),
      ],
    );
  }

  Widget _buildEmptyFilterState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        children: [
          Text(
            'market.empty_filter'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary(),
          ),
          SizedBox(height: AppSpacing.compact),
          TextButton(
            onPressed: () => setState(() => _selectedCategory = null),
            child: Text('market.reset_filter'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildProDeepAnalyticsCard(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/market-deep-analytics'),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.warning, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                LucideIcons.sparkles,
                color: AppColors.textOnPrimary,
                size: 22.sp,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'market.pro_card_title'.tr(),
                    style: AppTextStyles.body(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs / 2),
                  Text(
                    'market.deep_analytics_card_subtitle'.tr(),
                    style: AppTextStyles.caption(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.9),
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
}
