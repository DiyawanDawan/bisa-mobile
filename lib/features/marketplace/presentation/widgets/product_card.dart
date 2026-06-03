import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/seller_identity_row.dart';
import '../../domain/entities/product_entity.dart';
import '../../../commerce/presentation/widgets/product_like_button.dart';
import '../../../commerce/presentation/widgets/product_add_to_cart_button.dart';

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

    return GestureDetector(
      onTap: onTap ?? () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
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
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
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
                    top: 10.h,
                    left: 10.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ModeBadge(productMode: product.productMode),
                        if (product.productMode == 'ORGANIC_PRODUCE' &&
                            product.isChemicalFree) ...[
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryMedium,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'BEBAS KIMIA',
                              style: TextStyle(
                                color: Colors.white,
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
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '$discountPercentage% OFF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 8.h,
                    left: 8.w,
                    child: ProductLikeButton(
                      productId: product.id,
                      size: 16,
                    ),
                  ),
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
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
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
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
                                      product.originalPrice!.toRupiah,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                Text(
                                  product.pricePerUnit.toRupiah,
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
                          SizedBox(width: 4.w),
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
                  SizedBox(height: 8.h),
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
                          avatarRadius: 10.r,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: 11.sp,
                              color: AppColors.textHint,
                            ),
                            SizedBox(width: 4.w),
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
                              SizedBox(width: 4.w),
                              Text(
                                'Terjual ${product.totalSold}',
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
                      spacing: 4.w,
                      runSpacing: 4.h,
                      children: [
                        if (product.productMode == 'ORGANIC_PRODUCE') ...[
                          if (product.fertilizerType != null &&
                              product.fertilizerType!.isNotEmpty)
                            _buildSmallBadge(
                              LucideIcons.leaf,
                              product.fertilizerType!
                                      .toUpperCase()
                                      .contains('BIOCHAR')
                                  ? 'Tanah Biochar'
                                  : product.fertilizerType!,
                              AppColors.secondary,
                            ),
                        ] else ...[
                          if (product.grade != null)
                            _buildSmallBadge(
                              LucideIcons.medal,
                              'Grade ${product.grade}',
                              AppColors.warning,
                            ),
                        ],
                        if (product.isCertified)
                          _buildSmallBadge(
                            LucideIcons.award,
                            'Certified',
                            AppColors.success,
                          ),
                        if (product.isIotMonitored)
                          _buildSmallBadge(
                            LucideIcons.cpu,
                            'IoT',
                            AppColors.info,
                          ),
                        if (product.isEscrowProtected)
                          _buildSmallBadge(
                            LucideIcons.shieldCheck,
                            'Secure',
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
  }

  Widget _buildSmallBadge(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
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
    final label = isOrganic ? 'Hasil Tani' : 'Biomassa';
    final icon = isOrganic ? LucideIcons.sprout : LucideIcons.flame;
    // Hasil Tani → hijau emerald (segar/organik)
    // Biomassa  → amber (energi/karbon)
    final color = isOrganic ? AppColors.secondary : AppColors.warning;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
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
          Icon(icon, size: 11.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
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
