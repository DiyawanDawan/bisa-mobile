import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/utils/pro_subscription.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../bloc/order_cubit.dart';
import '../utils/order_status_i18n.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

class SalesAnalyticsPage extends StatefulWidget {
  const SalesAnalyticsPage({super.key});

  @override
  State<SalesAnalyticsPage> createState() => _SalesAnalyticsPageState();
}

class _SalesAnalyticsPageState extends State<SalesAnalyticsPage> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final stats = await sl<OrderCubit>().getSalesStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'orders.analytics_load_failed'.tr();
          _isLoading = false;
        });
      }
    }
  }

  bool _isPro(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    return user != null && !requiresPro(user);
  }

  void _exportCsv() {
    if (_stats == null) return;
    final revenue = _stats!['totalRevenue'];
    final orders = _stats!['totalOrders'];
    final qty = _stats!['totalQuantity'];
    final lines = [
      'metric,value',
      'totalRevenue,$revenue',
      'totalOrders,$orders',
      'totalQuantity,$qty',
    ];
    final top = (_stats!['topProducts'] as List?) ?? [];
    for (final raw in top) {
      final p = raw as Map<String, dynamic>;
      lines.add(
        'topProduct,${p['name']},${p['revenue']},${p['quantitySold']}',
      );
    }
    Clipboard.setData(ClipboardData(text: lines.join('\n')));
    showSuccessSnackBar(context, 'orders.analytics_export_copied');
  }

  @override
  Widget build(BuildContext context) {
    final isPro = _isPro(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'orders.analytics_title'.tr(),
        backgroundColor: AppColors.surface,
        actions: [
          if (isPro && _stats != null)
            IconButton(
              icon: Icon(LucideIcons.download, size: 20.sp),
              tooltip: 'orders.analytics_export'.tr(),
              onPressed: _exportCsv,
            ),
        ],
      ),
      body: _buildBody(isPro),
    );
  }

  Widget _buildBody(bool isPro) {
    if (_isLoading) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: ShimmerListPlaceholder(
          itemCount: 6,
          itemHeight: 88.h,
        ),
      );
    }
    if (_errorMessage != null) {
      return _buildErrorState();
    }
    if (_stats == null) {
      return _buildEmptyState();
    }
    return RefreshIndicator(
      onRefresh: _loadStats,
      color: AppColors.primary,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodBanner(isPro: isPro),
            SizedBox(height: AppSpacing.md12),
            _buildActionAlerts(),
            SizedBox(height: AppSpacing.md12),
            _buildSummaryCards(),
            SizedBox(height: AppSpacing.md12),
            _buildProSection(
              isPro: isPro,
              child: _buildInsightsRow(),
            ),
            SizedBox(height: AppSpacing.md),
            _buildRecommendations(),
            SizedBox(height: AppSpacing.md),
            _buildProSection(
              isPro: isPro,
              child: _buildEngagementLink(context),
            ),
            SizedBox(height: AppSpacing.md),
            _buildSectionTitle('orders.analytics_top_products'.tr()),
            SizedBox(height: AppSpacing.sm),
            _buildTopProducts(),
            SizedBox(height: AppSpacing.md),
            _buildProSection(
              isPro: isPro,
              title: 'orders.analytics_trend_7d'.tr(),
              child: _buildRecentSalesChart(),
            ),
            SizedBox(height: AppSpacing.md),
            _buildSectionTitle('orders.analytics_status_distribution'.tr()),
            SizedBox(height: AppSpacing.sm),
            _buildStatusDistribution(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.chartColumn, size: 64.sp, color: AppColors.grey300),
            SizedBox(height: AppSpacing.md),
            Text(
              'orders.analytics_no_data'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.circleAlert, size: 48.sp, color: AppColors.error),
            SizedBox(height: AppSpacing.md12),
            Text(
              _errorMessage ?? 'orders.analytics_load_failed'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
            SizedBox(height: AppSpacing.lg),
            CustomButton(text: 'orders.retry'.tr(), width: 160.w, onPressed: _loadStats),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic>? get _period => _stats?['period'] as Map<String, dynamic>?;
  Map<String, dynamic>? get _insights => _stats?['insights'] as Map<String, dynamic>?;

  Widget _buildProUpsellCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.lock, color: AppColors.primary, size: 20.sp),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Text(
              'orders.analytics_pro_section_locked'.tr(),
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/iot-subscription'),
            child: Text('market.upgrade_pro'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildProSection({
    required bool isPro,
    required Widget child,
    String? title,
  }) {
    if (isPro) {
      if (title != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(title),
            SizedBox(height: AppSpacing.sm),
            child,
          ],
        );
      }
      return child;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          _buildSectionTitle(title),
          SizedBox(height: AppSpacing.sm),
        ],
        _buildProUpsellCard(),
      ],
    );
  }

  Widget _buildPeriodBanner({required bool isPro}) {
    final period = _period;
    if (period == null) return const SizedBox.shrink();

    final thisMonth = period['thisMonth'] as Map<String, dynamic>? ?? {};
    final revenue = ((_stats?['totalRevenue'] ?? 0) as num).toDouble();
    final revenueGrowth = ((period['revenueGrowth'] ?? 0) as num).toInt();
    final ordersGrowth = ((period['ordersGrowth'] ?? 0) as num).toInt();
    final thisMonthRevenue = ((thisMonth['revenue'] ?? 0) as num).toDouble();
    final thisMonthOrders = ((thisMonth['orders'] ?? 0) as num).toInt();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.tile),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orders.analytics_month_performance'.tr(),
            style: TextStyle(color: AppColors.textOnPrimary.withValues(alpha: 0.7), fontSize: 11.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            formatMoneyIdr(thisMonthRevenue),
            style: TextStyle(
              color: AppColors.surface,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'orders.analytics_month_summary'.tr(namedArgs: {
              'orders': '$thisMonthOrders',
              'revenue': formatMoneyIdr(revenue),
            }),
            style: TextStyle(color: AppColors.textOnPrimary.withValues(alpha: 0.7), fontSize: 10.sp),
          ),
          if (isPro) ...[
            SizedBox(height: AppSpacing.sm10),
            Row(
              children: [
                _growthChip('orders.analytics_growth_revenue'.tr(), revenueGrowth),
                SizedBox(width: AppSpacing.sm),
                _growthChip('orders.analytics_growth_orders'.tr(), ordersGrowth),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _growthChip(String label, int growth) {
    final isUp = growth >= 0;
    final color = isUp ? AppColors.success : AppColors.error;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? LucideIcons.trendingUp : LucideIcons.trendingDown,
            size: 12.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            'orders.analytics_growth_chip'.tr(namedArgs: {
              'label': label,
              'sign': isUp ? '+' : '',
              'growth': '$growth',
            }),
            style: TextStyle(color: AppColors.textOnPrimary, fontSize: 10.sp, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  void _handleActionRoute(String route) {
    switch (route) {
      case '/orders':
        MainShellScope.maybeOf(context)?.selectTab(3);
        if (context.canPop()) context.pop();
        return;
      case '/negotiations':
        MainShellScope.maybeOf(context)?.selectTab(1);
        if (context.canPop()) context.pop();
        return;
      default:
        context.push(route);
    }
  }

  Widget _buildActionAlerts() {
    final insights = _insights;
    if (insights == null) return const SizedBox.shrink();

    final pending = ((insights['pendingOrders'] ?? 0) as num).toInt();
    final negotiations = ((insights['activeNegotiations'] ?? 0) as num).toInt();
    if (pending == 0 && negotiations == 0) return const SizedBox.shrink();

    return Row(
      children: [
        if (pending > 0)
          Expanded(
            child: _alertTile(
              icon: LucideIcons.shoppingBag,
              label: 'orders.analytics_active_orders'.tr(
                namedArgs: {'count': '$pending'},
              ),
              color: AppColors.warning,
              onTap: () => _handleActionRoute('/orders'),
            ),
          ),
        if (pending > 0 && negotiations > 0) SizedBox(width: AppSpacing.sm),
        if (negotiations > 0)
          Expanded(
            child: _alertTile(
              icon: LucideIcons.messageCircle,
              label: 'orders.analytics_negotiations'.tr(
                namedArgs: {'count': '$negotiations'},
              ),
              color: AppColors.info,
              onTap: () => _handleActionRoute('/negotiations'),
            ),
          ),
      ],
    );
  }

  Widget _alertTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm10),
          child: Row(
            children: [
              Icon(icon, size: 16.sp, color: color),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 14.sp, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final revenue = ((_stats?['totalRevenue'] ?? 0) as num).toDouble();
    final orders = ((_stats?['totalOrders'] ?? 0) as num).toInt();
    final quantity = ((_stats?['totalQuantity'] ?? 0) as num).toDouble();
    final aov = ((_insights?['averageOrderValue'] ?? 0) as num).toDouble();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.w,
      crossAxisSpacing: AppSpacing.sm10,
      childAspectRatio: 1.65,
      children: [
        _buildStatCard('orders.analytics_total_revenue'.tr(), formatMoneyIdr(revenue), LucideIcons.wallet, AppColors.primary),
        _buildStatCard('orders.analytics_total_orders'.tr(), orders.toString(), LucideIcons.shoppingBag, AppColors.info),
        _buildStatCard('orders.analytics_items_sold'.tr(), quantity.toStringAsFixed(0), LucideIcons.package, AppColors.success),
        _buildStatCard(
          'orders.analytics_avg_order'.tr(),
          aov > 0 ? formatMoneyIdr(aov) : (orders > 0 ? formatMoneyIdr(revenue / orders) : 'Rp0'),
          LucideIcons.trendingUp,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildInsightsRow() {
    final insights = _insights;
    if (insights == null) return const SizedBox.shrink();

    final likes = ((insights['totalLikes'] ?? 0) as num).toInt();
    final inCart = ((insights['totalInCart'] ?? 0) as num).toInt();
    final conversion = ((insights['conversionRate'] ?? 0) as num).toInt();
    final cancellation = ((insights['cancellationRate'] ?? 0) as num).toInt();

    return Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'orders.analytics_funnel_title'.tr(),
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: AppSpacing.sm10),
          Row(
            children: [
              Expanded(child: _insightMini('orders.analytics_funnel_likes'.tr(), likes.toString(), LucideIcons.heart, AppColors.error)),
              Expanded(child: _insightMini('orders.analytics_funnel_cart'.tr(), inCart.toString(), LucideIcons.shoppingCart, AppColors.primary)),
              Expanded(child: _insightMini('orders.analytics_funnel_conversion'.tr(), '$conversion%', LucideIcons.percent, AppColors.success)),
              Expanded(child: _insightMini('orders.analytics_funnel_cancel'.tr(), '$cancellation%', LucideIcons.circleX, AppColors.warning)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _insightMini(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 16.sp, color: color),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
        Text(label, style: TextStyle(fontSize: 9.sp, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildRecommendations() {
    final recommendations = (_stats?['recommendations'] as List?) ?? [];
    if (recommendations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('orders.analytics_recommendations'.tr()),
        SizedBox(height: AppSpacing.sm),
        ...recommendations.map((raw) {
          final item = raw as Map<String, dynamic>;
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: _RecommendationCard(
              type: (item['type'] ?? 'info').toString(),
              title: (item['title'] ?? '').toString(),
              message: (item['message'] ?? '').toString(),
              actionLabel: item['actionLabel']?.toString(),
              onAction: item['actionRoute'] != null
                  ? () => _handleActionRoute(item['actionRoute'].toString())
                  : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEngagementLink(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: () => context.push('/product-engagement'),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.section),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm10),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.heart, color: AppColors.error, size: 20.sp),
              ),
              SizedBox(width: AppSpacing.md12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'orders.analytics_engagement_title'.tr(),
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'orders.analytics_engagement_subtitle'.tr(),
                      style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
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

  Widget _buildTopProducts() {
    final topProducts = (_stats?['topProducts'] as List?) ?? [];
    if (topProducts.isEmpty) {
      return _emptyCard('orders.analytics_no_products_sold'.tr());
    }

    return Column(
      children: topProducts.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value as Map<String, dynamic>;
        final name = (item['name'] ?? '-').toString();
        final revenue = ((item['revenue'] ?? 0) as num).toDouble();
        final qty = ((item['quantitySold'] ?? 0) as num).toDouble();
        final thumb = item['thumbnailUrl']?.toString();
        final productId = item['productId']?.toString();

        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm),
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              onTap: productId != null ? () => context.push('/product-manage/$productId') : null,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: Container(
                padding: EdgeInsets.all(AppSpacing.sm10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.grey100),
                ),
                child: Row(
                  children: [
                    _rankBadge(index + 1),
                    SizedBox(width: AppSpacing.sm10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                      child: thumb != null && thumb.isNotEmpty
                          ? BisaNetworkImage(imageUrl: thumb, width: 44.w, height: 44.w, fit: BoxFit.cover)
                          : Container(
                              width: 44.w,
                              height: 44.w,
                              color: AppColors.grey100,
                              child: Icon(LucideIcons.package, color: AppColors.grey400, size: 18.sp),
                            ),
                    ),
                    SizedBox(width: AppSpacing.sm10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'orders.analytics_sold_count'.tr(namedArgs: {
                              'qty': qty.toStringAsFixed(0),
                              'revenue': formatMoneyIdr(revenue),
                            }),
                            style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _rankBadge(int rank) {
    final color = rank == 1
        ? AppColors.warning
        : rank == 2
            ? AppColors.textSecondary
            : AppColors.grey400;
    return Container(
      width: 22.w,
      height: 22.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
      child: Text(
        '$rank',
        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w900, color: color),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 18.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDistribution() {
    final distribution = (_stats?['statusDistribution'] as List?) ?? [];
    if (distribution.isEmpty) {
      return _emptyCard('orders.analytics_no_data'.tr());
    }

    final total = distribution.fold<int>(
      0,
      (sum, item) => sum + ((item as Map)['count'] as num? ?? 0).toInt(),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(
        children: distribution.map((raw) {
          final item = raw as Map<String, dynamic>;
          final rawStatus = (item['status'] ?? 'Unknown').toString();
          final statusLabel = _statusLabel(rawStatus);
          final count = ((item['count'] ?? 0) as num).toInt();
          final pct = total > 0 ? (count / total) : 0.0;
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(color: _getStatusColor(rawStatus), shape: BoxShape.circle),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(statusLabel, style: TextStyle(fontSize: 12.sp))),
                    Text(
                      '$count (${(pct * 100).toStringAsFixed(0)}%)',
                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 4.h,
                    backgroundColor: AppColors.grey100,
                    color: _getStatusColor(rawStatus),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentSalesChart() {
    final recentSales = (_stats?['recentSales'] as List?) ?? [];
    if (recentSales.isEmpty) {
      return _emptyCard('orders.analytics_no_data'.tr());
    }

    final amounts = recentSales
        .map((e) => ((e as Map<String, dynamic>)['amount'] ?? 0) as num)
        .toList();
    final maxAmount = amounts.fold<double>(0, (m, v) => v.toDouble() > m ? v.toDouble() : m);
    final chartMax = maxAmount <= 0 ? 1.0 : maxAmount * 1.2;

    final spots = recentSales.asMap().entries.map((entry) {
      final sale = entry.value as Map<String, dynamic>;
      return FlSpot(entry.key.toDouble(), ((sale['amount'] ?? 0) as num).toDouble());
    }).toList();

    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 12.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 140.h,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: chartMax,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: chartMax / 4,
                  getDrawingHorizontalLine: (_) => FlLine(color: AppColors.grey100, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22.h,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= recentSales.length) {
                          return const SizedBox.shrink();
                        }
                        final label =
                            ((recentSales[index] as Map)['label'] ?? '').toString();
                        return Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            label,
                            style: TextStyle(fontSize: 9.sp, color: AppColors.textHint),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                        radius: 3,
                        color: AppColors.primary,
                        strokeWidth: 1,
                        strokeColor: AppColors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(message, style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
    );
  }

  String _statusLabel(String status) => orderStatusLabel(status);

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return AppColors.success;
      case 'SHIPPED':
      case 'CONFIRMED':
        return AppColors.info;
      case 'PENDING':
      case 'PROCESSING':
        return AppColors.warning;
      case 'CANCELLED':
      case 'DISPUTED':
        return AppColors.error;
      default:
        return AppColors.grey400;
    }
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String type;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  Color get _accent {
    switch (type) {
      case 'warning':
        return AppColors.warning;
      case 'success':
        return AppColors.success;
      case 'action':
        return AppColors.primary;
      default:
        return AppColors.info;
    }
  }

  IconData get _icon {
    switch (type) {
      case 'warning':
        return LucideIcons.triangleAlert;
      case 'success':
        return LucideIcons.circleCheck;
      case 'action':
        return LucideIcons.zap;
      default:
        return LucideIcons.lightbulb;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: _accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_icon, size: 18.sp, color: _accent),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      message,
                      style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: _accent,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel!,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
