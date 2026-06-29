import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/utils/promo_analytics_tracker.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/seller_identity_row.dart';
import '../../domain/entities/product_entity.dart';
import '../../../commerce/presentation/widgets/product_like_button.dart';
import '../../../commerce/presentation/widgets/product_add_to_cart_button.dart';
import '../bloc/compare_cubit.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final double? imageHeight;
  /// Sembunyikan baris toko/lokasi hanya jika UI duplikat (jarang dipakai).
  final bool showSellerInfo;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.imageHeight,
    this.showSellerInfo = true,
  });

  String get _sellerDisplayName =>
      product.seller.companyName ?? product.seller.name;

  void _openSupplierStore(BuildContext context) {
    context.push(
      '/supplier/${product.seller.id}',
      extra: {'name': _sellerDisplayName},
    );
  }

  @override
  Widget build(BuildContext context) {
    int? discountPercentage;
    if (product.originalPrice != null &&
        product.originalPrice! > product.pricePerUnit) {
      discountPercentage =
          ((product.originalPrice! - product.pricePerUnit) /
                  product.originalPrice! *
                  100)
              .round();
    }

    void handleTap() {
      if (product.isPromotionActive) {
        PromoAnalyticsTracker.recordClick(product.id);
      }
      if (onTap != null) {
        onTap!();
      } else {
        context.push('/product/${product.id}');
      }
    }

    final card = GestureDetector(
      onTap: handleTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area with fixed height
            Container(
              height: imageHeight ?? 140.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                color: AppColors.grey100,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  BisaNetworkImage(
                    imageUrl: product.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.grey100,
                      child: Icon(
                        LucideIcons.imageOff,
                        color: AppColors.grey300,
                        size: 36.sp,
                      ),
                    ),
                  ),
                  // Mode badge (Biomassa / Hasil Tani) + opsi BEBAS KIMIA
                  Positioned(
                    top: AppSpacing.sm10,
                    left: AppSpacing.sm10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ModeBadge(productMode: product.productMode),
                        if (product.isPromotionActive) ...[
                          SizedBox(height: AppSpacing.xs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(AppRadius.button),
                            ),
                            child: Text(
                              'marketplace.badge_promoted'.tr(),
                              style: TextStyle(
                                color: AppColors.surface,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                        if (product.productMode == 'ORGANIC_PRODUCE' &&
                            product.isChemicalFree) ...[
                          SizedBox(height: AppSpacing.xs),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryMedium,
                              borderRadius: BorderRadius.circular(AppRadius.button),
                            ),
                            child: Text(
                              'marketplace.badge_chemical_free'.tr(),
                              style: TextStyle(
                                color: AppColors.surface,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (discountPercentage != null && discountPercentage > 0)
                    Positioned(
                      top: AppSpacing.sm10,
                      right: AppSpacing.sm10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                        child: Text(
                          'marketplace.discount_off'.tr(
                            namedArgs: {'percent': '$discountPercentage'},
                          ),
                          style: TextStyle(
                            color: AppColors.surface,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: ProductLikeButton(
                      productId: product.id,
                      size: 16,
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.sm,
                    right: 44.w,
                    child: BlocBuilder<CompareCubit, CompareState>(
                      builder: (context, compareState) {
                        final selected = compareState.contains(product.id);
                        return Material(
                          color: AppColors.transparent,
                          child: InkWell(
                            onTap: () {
                              final cubit = context.read<CompareCubit>();
                              final wasSelected =
                                  cubit.state.contains(product.id);
                              final err = cubit.toggle(product);
                              if (!context.mounted) return;
                              if (err != null) {
                                showErrorSnackBar(context, err);
                                return;
                              }
                              if (!wasSelected) {
                                context.push('/compare-products');
                              }
                            },
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            child: Container(
                              padding: EdgeInsets.all(AppSpacing.xs6),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primaryLight
                                    : AppColors.surface.withValues(alpha: 0.92),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LucideIcons.columns3,
                                size: 16.sp,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: ProductAddToCartButton(
                      product: product,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Content area
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.sm10,
                AppSpacing.sm,
                AppSpacing.sm10,
                AppSpacing.sm10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Top Section: Name and Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.originalPrice != null)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 2.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 1.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.error,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      formatMoneyDisplay(product.originalPrice!),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textOnPrimary,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: AppColors.textOnPrimary,
                                      ),
                                    ),
                                  ),
                                Text(
                                  formatMoneyDisplay(product.pricePerUnit),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Text(
                              '/ ${product.unit}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  // Bottom Section: Seller, Location and Badges
                  if (showSellerInfo)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SellerIdentityRow(
                          displayName: _sellerDisplayName,
                          avatarUrl: product.seller.avatarUrl,
                          isVerified: product.seller.isVerified,
                          onTap: () => _openSupplierStore(context),
                          showChevron: true,
                          avatarRadius: AppRadius.md,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 11.sp,
                              color: AppColors.textHint,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                product.regency ?? product.province,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (product.totalSold > 0) ...[
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.shoppingBag,
                                size: 11.sp,
                                color: AppColors.textHint,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'marketplace.sold_count'.tr(
                                  namedArgs: {
                                    'count': '${product.totalSold}',
                                  },
                                ),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  if (product.productMode == 'ORGANIC_PRODUCE' ||
                      product.isCertified ||
                      product.isIotMonitored ||
                      product.isEscrowProtected) ...[
                    if (showSellerInfo) SizedBox(height: 6.h),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (product.productMode == 'ORGANIC_PRODUCE') ...[
                          if (product.fertilizerType != null &&
                              product.fertilizerType!.isNotEmpty)
                            _buildSmallBadge(
                              LucideIcons.leaf,
                              product.fertilizerType!
                                      .toUpperCase()
                                      .contains('BIOCHAR')
                                  ? 'marketplace.badge_biochar_soil'.tr()
                                  : product.fertilizerType!,
                              AppColors.secondary,
                            ),
                        ] else ...[
                          if (product.grade != null)
                            _buildSmallBadge(
                              LucideIcons.medal,
                              'marketplace.badge_grade'.tr(
                                namedArgs: {'grade': '${product.grade}'},
                              ),
                              AppColors.warning,
                            ),
                        ],
                        if (product.isCertified)
                          _buildSmallBadge(
                            LucideIcons.award,
                            'marketplace.badge_certified'.tr(),
                            AppColors.success,
                          ),
                        if (product.isIotMonitored)
                          Tooltip(
                            message: 'marketplace.badge_iot_tooltip'.tr(),
                            child: _buildSmallBadge(
                              LucideIcons.cpu,
                              'marketplace.badge_iot'.tr(),
                              AppColors.info,
                            ),
                          ),
                        if (product.isEscrowProtected)
                          _buildSmallBadge(
                            LucideIcons.shieldCheck,
                            'marketplace.badge_secure'.tr(),
                            AppColors.ocean,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!product.isPromotionActive) return card;

    return VisibilityDetector(
      key: Key('promo-card-${product.id}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.55) {
          PromoAnalyticsTracker.recordImpression(product.id);
        }
      },
      child: card,
    );
  }

  Widget _buildSmallBadge(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: color),
          SizedBox(width: 2.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pin "Biomassa" / "Hasil Tani" pada thumbnail produk supaya pembeli langsung
/// paham kategori utama tanpa harus tap detail. Dipakai di seluruh ProductCard
/// (Marketplace, Favorit, Profil supplier, Rekomendasi, dll.).
class _ModeBadge extends StatelessWidget {
  final String productMode;
  const _ModeBadge({required this.productMode});

  @override
  Widget build(BuildContext context) {
    final isOrganic = productMode == 'ORGANIC_PRODUCE';
    final label = isOrganic
        ? 'marketplace.badge_mode_organic'.tr()
        : 'marketplace.badge_mode_biomass'.tr();
    final icon = isOrganic ? LucideIcons.sprout : LucideIcons.flame;
    // Hasil Tani → hijau emerald (segar/organik)
    // Biomassa  → amber (energi/karbon)
    final color = isOrganic ? AppColors.secondary : AppColors.warning;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.button),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: AppColors.textOnPrimary),
          SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              color: AppColors.surface,
              fontSize: 9.sp,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
