import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/guest_placeholder.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../commerce/presentation/bloc/commerce_cubit.dart';
import '../../../negotiation/domain/entities/negotiation_entity.dart';
import '../../../negotiation/presentation/bloc/negotiation_cubit.dart';
import '../../../negotiation/presentation/utils/negotiation_status_ui.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/bloc/order_cubit.dart';
import '../../domain/entities/purchased_product_item.dart';
import '../widgets/product_card.dart';

/// Halaman "Produk Saya" untuk buyer — agregasi produk yang dibeli,
/// sedang dinegosiasi, dan disimpan di wishlist.
class BuyerProductsPage extends StatefulWidget {
  const BuyerProductsPage({super.key});

  @override
  State<BuyerProductsPage> createState() => _BuyerProductsPageState();
}

class _BuyerProductsPageState extends State<BuyerProductsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<CommerceCubit>().loadWishlist();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'marketplace.buyer_products_title'.tr(),
          backgroundColor: AppColors.surface,
        ),
        body: GuestPlaceholder(
          title: 'marketplace.buyer_limited_access'.tr(),
          subtitle: 'marketplace.buyer_login_hint'.tr(),
          icon: LucideIcons.package,
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<OrderCubit>()..getMyPurchases()),
        BlocProvider(create: (_) => sl<NegotiationCubit>()..getMyOffers()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'marketplace.buyer_products_title'.tr(),
          backgroundColor: AppColors.surface,
          showShadow: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: Container(
              color: AppColors.surface,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textHint,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2.5,
                labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'marketplace.tab_purchased'.tr()),
                  Tab(text: 'marketplace.tab_negotiation'.tr()),
                  Tab(text: 'marketplace.tab_wishlist'.tr()),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPurchasedTab(),
            _buildNegotiationTab(),
            _buildWishlistTab(),
          ],
        ),
      ),
    );
  }

  // ── Tab 1: Produk Dibeli ──────────────────────────────────────────────────

  Widget _buildPurchasedTab() {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSpacing.md),
            child: const ShimmerListPlaceholder(itemCount: 4, itemHeight: 96),
          ),
          error: (message) => _errorState(
            message,
            () => context.read<OrderCubit>().getMyPurchases(),
          ),
          loaded: (orders) {
            final purchased = _flattenPurchasedProducts(orders);
            if (purchased.isEmpty) {
              return _emptyState(
                LucideIcons.shoppingBag,
                'marketplace.no_purchased'.tr(),
                'marketplace.no_purchased_hint'.tr(),
              );
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<OrderCubit>().getMyPurchases(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
                itemCount: purchased.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm10),
                itemBuilder: (context, index) =>
                    _purchasedProductTile(context, purchased[index]),
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  List<PurchasedProductItem> _flattenPurchasedProducts(List<OrderEntity> orders) {
    final map = <String, PurchasedProductItem>{};
    final paidOrders = orders.where(
      (o) => const {'PAID', 'SHIPPED', 'COMPLETED'}.contains(o.status.toUpperCase()),
    );

    for (final order in paidOrders) {
      for (final item in order.items) {
        final existing = map[item.productId];
        if (existing == null || order.createdAt.isAfter(existing.lastOrderDate)) {
          map[item.productId] = PurchasedProductItem(
            productId: item.productId,
            productName: item.productName,
            thumbnailUrl: item.thumbnailUrl,
            totalQuantity: item.quantity,
            lastOrderDate: order.createdAt,
            lastOrderId: order.id,
          );
        }
      }
    }

    final list = map.values.toList()
      ..sort((a, b) => b.lastOrderDate.compareTo(a.lastOrderDate));
    return list;
  }

  Widget _purchasedProductTile(BuildContext context, PurchasedProductItem item) {
    return InkWell(
      onTap: () => context.push('/product/${item.productId}'),
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.grey100),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: hasResolvableMediaUrl(item.thumbnailUrl)
                  ? BisaNetworkImage(
                      imageUrl: item.thumbnailUrl!,
                      width: 72.w,
                      height: 72.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _thumbPlaceholder(),
                    )
                  : _thumbPlaceholder(),
            ),
            SizedBox(width: AppSpacing.md12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'marketplace.last_purchased'.tr(namedArgs: {
                      'time': item.lastOrderDate.timeAgo,
                    }),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'marketplace.qty_label_short'.tr(namedArgs: {
                      'qty': '${item.totalQuantity.toInt()}',
                    }),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(LucideIcons.receipt, size: 18.sp, color: AppColors.textHint),
              onPressed: () => context.push('/order/${item.lastOrderId}'),
              tooltip: 'marketplace.view_order'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab 2: Negosiasi Aktif ──────────────────────────────────────────────────

  Widget _buildNegotiationTab() {
    return BlocBuilder<NegotiationCubit, NegotiationState>(
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSpacing.md),
            child: const ShimmerListPlaceholder(itemCount: 4, itemHeight: 96),
          ),
          error: (message) => _errorState(
            message,
            () => context.read<NegotiationCubit>().getMyOffers(),
          ),
          loaded: (negotiations) {
            if (negotiations.isEmpty) {
              return _emptyState(
                LucideIcons.handshake,
                'marketplace.no_negotiations'.tr(),
                'marketplace.no_negotiations_hint'.tr(),
              );
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<NegotiationCubit>().getMyOffers(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
                itemCount: negotiations.length,
                separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm10),
                itemBuilder: (context, index) =>
                    _negotiationCard(negotiations[index]),
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _negotiationCard(NegotiationEntity n) {
    final statusColor = _negotiationStatusColor(n.status);
    return InkWell(
      onTap: () => NegotiationStatusDisplay.openFromList(context, n),
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.grey100),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: hasResolvableMediaUrl(n.product.thumbnailUrl)
                  ? BisaNetworkImage(
                      imageUrl: n.product.thumbnailUrl!,
                      width: 72.w,
                      height: 72.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _thumbPlaceholder(),
                    )
                  : _thumbPlaceholder(),
            ),
            SizedBox(width: AppSpacing.md12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.product.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      BisaAvatar(
                        imageUrl: n.seller.avatarUrl,
                        radius: AppRadius.button,
                        fallbackIcon: LucideIcons.store,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          n.seller.companyName ?? n.seller.name,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        formatMoneyDisplay(n.pricePerUnit),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '/ ${n.product.unit}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          _negotiationStatusLabel(n.status),
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 18.sp,
              color: AppColors.grey300,
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab 3: Wishlist ──────────────────────────────────────────────────────

  Widget _buildWishlistTab() {
    return BlocBuilder<CommerceCubit, CommerceState>(
      builder: (context, state) {
        if (state.isLoading && state.wishlistProducts == null) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ShimmerProductGridPlaceholder(itemCount: 4),
          );
        }
        final products = state.wishlistProducts ?? [];
        if (products.isEmpty) {
          return _emptyState(
            LucideIcons.heart,
            'marketplace.no_wishlist'.tr(),
            'marketplace.no_wishlist_hint'.tr(),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<CommerceCubit>().loadWishlist(),
          child: MasonryGridView.count(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md12,
            itemCount: products.length,
            itemBuilder: (context, index) =>
                ProductCard(product: products[index]),
          ),
        );
      },
    );
  }

  // ── Shared helpers ──────────────────────────────────────────────────────

  Widget _thumbPlaceholder() => Container(
        width: 72.w,
        height: 72.w,
        color: AppColors.grey100,
        child: Icon(LucideIcons.image, color: AppColors.grey400),
      );

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 60.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 64.r, color: AppColors.grey200),
                SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorState(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.triangleAlert, size: 48.r, color: AppColors.error),
            SizedBox(height: AppSpacing.md12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.md12),
            TextButton(onPressed: onRetry, child: Text('marketplace.try_again'.tr())),
          ],
        ),
      ),
    );
  }

  Color _negotiationStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN_NEGOTIATION':
        return AppColors.info;
      case 'OFFER_ACCEPTED':
      case 'CONTRACT_CREATED':
        return AppColors.success;
      case 'OFFER_REJECTED':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  String _negotiationStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN_NEGOTIATION':
        return 'marketplace.nego_status_active'.tr();
      case 'OFFER_ACCEPTED':
        return 'marketplace.nego_status_accepted'.tr();
      case 'OFFER_REJECTED':
        return 'marketplace.nego_status_rejected'.tr();
      case 'CONTRACT_CREATED':
        return 'marketplace.nego_status_done'.tr();
      default:
        return status;
    }
  }
}
