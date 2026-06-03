import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../domain/entities/product_engagement_entity.dart';
import '../../domain/repositories/marketplace_repository.dart';

class ProductEngagementPage extends StatefulWidget {
  const ProductEngagementPage({super.key});

  @override
  State<ProductEngagementPage> createState() => _ProductEngagementPageState();
}

class _ProductEngagementPageState extends State<ProductEngagementPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  ProductEngagementData? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await sl<MarketplaceRepository>().getSupplierProductEngagement();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.message;
      }),
      (data) => setState(() {
        _loading = false;
        _data = data;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'Minat Produk',
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Disukai'),
            Tab(text: 'Di Keranjang'),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return ShimmerListPlaceholder(
        itemCount: 5,
        itemHeight: 88.h,
        scrollable: true,
        padding: EdgeInsets.all(16.w),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.circleAlert, size: 48.sp, color: AppColors.error),
              SizedBox(height: 12.h),
              Text(_error!, textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              CustomButton(text: 'Coba Lagi', onPressed: _load),
            ],
          ),
        ),
      );
    }

    final data = _data!;
    return RefreshIndicator(
      onRefresh: _load,
      child: Column(
        children: [
          _buildSummary(data.summary),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(
                  data.topLiked,
                  emptyTitle: 'Belum ada produk disukai',
                  emptySubtitle: 'Produk yang di-like pembeli akan muncul di sini',
                  metricLabel: 'disukai',
                  metricIcon: LucideIcons.heart,
                  metricColor: AppColors.error,
                ),
                _buildList(
                  data.topInCart,
                  emptyTitle: 'Belum ada produk di keranjang',
                  emptySubtitle: 'Produk yang ditambahkan ke keranjang pembeli akan muncul di sini',
                  metricLabel: 'di keranjang',
                  metricIcon: LucideIcons.shoppingCart,
                  metricColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(ProductEngagementSummary summary) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryTile(
              'Total Suka',
              '${summary.totalLikes}',
              LucideIcons.heart,
              AppColors.error,
            ),
          ),
          Container(width: 1, height: 36.h, color: AppColors.grey100),
          Expanded(
            child: _summaryTile(
              'Di Keranjang',
              '${summary.totalInCart}',
              LucideIcons.shoppingCart,
              AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18.sp, color: color),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildList(
    List<ProductEngagementItem> items, {
    required String emptyTitle,
    required String emptySubtitle,
    required String metricLabel,
    required IconData metricIcon,
    required Color metricColor,
  }) {
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 48.h),
          Icon(LucideIcons.chartBar, size: 48.sp, color: AppColors.grey300),
          SizedBox(height: 12.h),
          Text(
            emptyTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15.sp,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              emptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final item = items[index];
        final count = metricLabel == 'disukai' ? item.likeCount : item.cartCount;
        return _EngagementTile(
          item: item,
          count: count,
          metricLabel: metricLabel,
          metricIcon: metricIcon,
          metricColor: metricColor,
          onTap: () => context.push('/product-manage/${item.productId}'),
        );
      },
    );
  }
}

class _EngagementTile extends StatelessWidget {
  const _EngagementTile({
    required this.item,
    required this.count,
    required this.metricLabel,
    required this.metricIcon,
    required this.metricColor,
    required this.onTap,
  });

  final ProductEngagementItem item;
  final int count;
  final String metricLabel;
  final IconData metricIcon;
  final Color metricColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty
                    ? BisaNetworkImage(
                        imageUrl: item.thumbnailUrl!,
                        width: 56.w,
                        height: 56.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 56.w,
                        height: 56.w,
                        color: AppColors.grey100,
                        child: Icon(LucideIcons.package, color: AppColors.grey400),
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.pricePerUnit.toRupiah,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Terjual ${item.totalSold}',
                      style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(metricIcon, size: 16.sp, color: metricColor),
                  SizedBox(height: 2.h),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: metricColor,
                    ),
                  ),
                  Text(
                    metricLabel,
                    style: TextStyle(fontSize: 9.sp, color: AppColors.textHint),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
