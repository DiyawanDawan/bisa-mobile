import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../bloc/order_cubit.dart';
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
    } on ForbiddenFailure catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message.isNotEmpty
              ? e.message
              : 'Analitik penjualan khusus langganan PRO. Upgrade untuk akses penuh.';
          _isLoading = false;
        });
      }
    } on Failure catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message.isNotEmpty
              ? e.message
              : 'gagal_memuat_data_analitik'.tr();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'gagal_memuat_data_analitik'.tr();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Analitik Penjualan',
        backgroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
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
            _buildPeriodBanner(),
            SizedBox(height: 12.h),
            _buildActionAlerts(),
            SizedBox(height: 12.h),
            _buildSummaryCards(),
            SizedBox(height: 12.h),
            _buildInsightsRow(),
            SizedBox(height: 16.h),
            _buildRecommendations(),
            SizedBox(height: 16.h),
            _buildEngagementLink(context),
            SizedBox(height: 16.h),
            _buildSectionTitle('Produk Terlaris'),
            SizedBox(height: 8.h),
            _buildTopProducts(),
            SizedBox(height: 16.h),
            _buildSectionTitle('Tren 7 Hari Terakhir'),
            SizedBox(height: 8.h),
            _buildRecentSalesChart(),
            SizedBox(height: 16.h),
            _buildSectionTitle('Distribusi Status Pesanan'),
            SizedBox(height: 8.h),
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
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.chartColumn, size: 64.sp, color: AppColors.grey300),
            SizedBox(height: 16.h),
            Text(
              'belum_ada_data'.tr(),
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
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.circleAlert, size: 48.sp, color: AppColors.error),
            SizedBox(height: 12.h),
            Text(
              _errorMessage ?? 'gagal_memuat_data_analitik'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
            SizedBox(height: 20.h),
            CustomButton(text: 'coba_lagi'.tr(), width: 160.w, onPressed: _loadStats),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic>? get _period => _stats?['period'] as Map<String, dynamic>?;
  Map<String, dynamic>? get _insights => _stats?['insights'] as Map<String, dynamic>?;

  Widget _buildPeriodBanner() {
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performa Bulan Ini',
            style: TextStyle(color: Colors.white70, fontSize: 11.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            thisMonthRevenue.toRupiah,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '$thisMonthOrders pesanan · Total all-time ${revenue.toRupiah}',
            style: TextStyle(color: Colors.white70, fontSize: 10.sp),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _growthChip('Pendapatan', revenueGrowth),
              SizedBox(width: 8.w),
              _growthChip('Pesanan', ordersGrowth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _growthChip(String label, int growth) {
    final isUp = growth >= 0;
    final color = isUp ? AppColors.success : AppColors.error;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
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
            '$label ${isUp ? '+' : ''}$growth%',
            style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w700),
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
              label: '$pending pesanan aktif',
              color: AppColors.warning,
              onTap: () => _handleActionRoute('/orders'),
            ),
          ),
        if (pending > 0 && negotiations > 0) SizedBox(width: 8.w),
        if (negotiations > 0)
          Expanded(
            child: _alertTile(
              icon: LucideIcons.messageCircle,
              label: '$negotiations negosiasi',
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
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              Icon(icon, size: 16.sp, color: color),
              SizedBox(width: 8.w),
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
      crossAxisSpacing: 10.w,
      childAspectRatio: 1.65,
      children: [
        _buildStatCard('Total Pendapatan', revenue.toRupiah, LucideIcons.wallet, AppColors.primary),
        _buildStatCard('Total Pesanan', orders.toString(), LucideIcons.shoppingBag, AppColors.info),
        _buildStatCard('Item Terjual', quantity.toStringAsFixed(0), LucideIcons.package, AppColors.success),
        _buildStatCard(
          'Rata-rata Order',
          aov > 0 ? aov.toRupiah : (orders > 0 ? (revenue / orders).toRupiah : 'Rp0'),
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Funnel Minat Pembeli',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(child: _insightMini('Suka', likes.toString(), LucideIcons.heart, AppColors.error)),
              Expanded(child: _insightMini('Keranjang', inCart.toString(), LucideIcons.shoppingCart, AppColors.primary)),
              Expanded(child: _insightMini('Konversi', '$conversion%', LucideIcons.percent, AppColors.success)),
              Expanded(child: _insightMini('Batal', '$cancellation%', LucideIcons.circleX, AppColors.warning)),
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
        _buildSectionTitle('Rekomendasi Bisnis'),
        SizedBox(height: 8.h),
        ...recommendations.map((raw) {
          final item = raw as Map<String, dynamic>;
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
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
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () => context.push('/product-engagement'),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.heart, color: AppColors.error, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minat Produk Pembeli',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Lihat produk yang disukai & ditambahkan ke keranjang',
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
      return _emptyCard('Belum ada produk terjual');
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
          padding: EdgeInsets.only(bottom: 8.h),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            child: InkWell(
              onTap: productId != null ? () => context.push('/product-manage/$productId') : null,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.grey100),
                ),
                child: Row(
                  children: [
                    _rankBadge(index + 1),
                    SizedBox(width: 10.w),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: thumb != null && thumb.isNotEmpty
                          ? BisaNetworkImage(imageUrl: thumb, width: 44.w, height: 44.w, fit: BoxFit.cover)
                          : Container(
                              width: 44.w,
                              height: 44.w,
                              color: AppColors.grey100,
                              child: Icon(LucideIcons.package, color: AppColors.grey400, size: 18.sp),
                            ),
                    ),
                    SizedBox(width: 10.w),
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
                            '${qty.toStringAsFixed(0)} terjual · ${revenue.toRupiah}',
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
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
      return _emptyCard('belum_ada_data'.tr());
    }

    final total = distribution.fold<int>(
      0,
      (sum, item) => sum + ((item as Map)['count'] as num? ?? 0).toInt(),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: distribution.map((raw) {
          final item = raw as Map<String, dynamic>;
          final status = _statusLabel((item['status'] ?? 'Unknown').toString());
          final count = ((item['count'] ?? 0) as num).toInt();
          final pct = total > 0 ? (count / total) : 0.0;
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(color: _getStatusColor(status), shape: BoxShape.circle),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(child: Text(status, style: TextStyle(fontSize: 12.sp))),
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
                    color: _getStatusColor(status),
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
      return _emptyCard('belum_ada_data'.tr());
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
                        strokeColor: Colors.white,
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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(message, style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
    );
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Menunggu';
      case 'CONFIRMED':
        return 'Dikonfirmasi';
      case 'PROCESSING':
        return 'Diproses';
      case 'SHIPPED':
        return 'Dikirim';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      case 'DISPUTED':
        return 'Sengketa';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SELESAI':
      case 'COMPLETED':
        return AppColors.success;
      case 'DIKIRIM':
      case 'SHIPPED':
      case 'DIKONFIRMASI':
      case 'CONFIRMED':
        return AppColors.info;
      case 'MENUNGGU':
      case 'PENDING':
      case 'DIPROSES':
      case 'PROCESSING':
        return AppColors.warning;
      case 'DIBATALKAN':
      case 'CANCELLED':
      case 'SENGKETA':
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_icon, size: 18.sp, color: _accent),
              SizedBox(width: 8.w),
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
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: _accent,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
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
