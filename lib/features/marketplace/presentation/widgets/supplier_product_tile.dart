import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/seller_identity_row.dart';
import '../../domain/entities/product_entity.dart';

class SupplierProductTile extends StatelessWidget {
  const SupplierProductTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get _sellerDisplayName {
    final company = product.seller.companyName?.trim();
    if (company != null && company.isNotEmpty) return company;
    final name = product.seller.name.trim();
    if (name.isNotEmpty) return name;
    return 'marketplace.store_default_name'.tr();
  }

  void _openSupplierStore(BuildContext context) {
    context.push(
      '/supplier/${product.seller.id}',
      extra: {'name': _sellerDisplayName},
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.originalPrice != null &&
        product.originalPrice! > product.pricePerUnit;
    final discountPercent = hasDiscount
        ? ((product.originalPrice! - product.pricePerUnit) /
                product.originalPrice! *
                100)
            .round()
        : 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.grey100),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: hasResolvableMediaUrl(product.thumbnailUrl)
                      ? BisaNetworkImage(
                          imageUrl: product.thumbnailUrl,
                          width: 72.w,
                          height: 72.w,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _imgPlaceholder(),
                        )
                      : _imgPlaceholder(),
                ),
                if (hasDiscount)
                  Positioned(
                    top: 4.r,
                    left: 4.r,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: AppSpacing.sm10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      _StatusBadge(status: product.status),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          formatMoneyDisplay(product.pricePerUnit),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasDiscount) ...[
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            formatMoneyDisplay(product.originalPrice!),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.grey400,
                              decoration: TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  SellerIdentityRow(
                    displayName: _sellerDisplayName,
                    avatarUrl: product.seller.avatarUrl,
                    isVerified: product.seller.isVerified,
                    onTap: () => _openSupplierStore(context),
                    showChevron: true,
                    avatarRadius: 9.r,
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 5.w,
                    runSpacing: 5.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _metaChip(
                        LucideIcons.package,
                        'marketplace.stock_chip'.tr(namedArgs: {
                          'stock': _trimNum(product.stock),
                          'unit': product.unit,
                        }),
                        AppColors.info,
                      ),
                      _metaChip(
                        LucideIcons.shoppingBag,
                        'marketplace.sold_count'.tr(namedArgs: {
                          'count': '${product.totalSold}',
                        }),
                        AppColors.success,
                      ),
                      if (product.isCertified)
                        _iconPill(LucideIcons.award, AppColors.success),
                      if (product.isIotMonitored)
                        _iconPill(LucideIcons.cpu, AppColors.info),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 6.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _compactAction(LucideIcons.pencil, AppColors.info, onEdit),
                SizedBox(height: 6.h),
                _compactAction(LucideIcons.trash2, AppColors.error, onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
        width: 72.w,
        height: 72.w,
        color: AppColors.grey100,
        child: Icon(LucideIcons.image, color: AppColors.grey400),
      );

  Widget _metaChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconPill(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(icon, size: 12.sp, color: color),
    );
  }

  Widget _compactAction(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(icon, size: 15.sp, color: color),
        ),
      ),
    );
  }

  String _trimNum(num value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    late final String label;

    switch (status.toUpperCase()) {
      case 'ACTIVE':
        color = AppColors.success;
        label = 'marketplace.status_active'.tr();
        break;
      case 'DRAFT':
        color = AppColors.warning;
        label = 'marketplace.status_draft'.tr();
        break;
      case 'OUT_OF_STOCK':
        color = AppColors.error;
        label = 'marketplace.status_out_of_stock'.tr();
        break;
      case 'INACTIVE':
        color = AppColors.grey500;
        label = 'marketplace.status_inactive'.tr();
        break;
      default:
        color = AppColors.grey500;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Future<void> showSupplierDeleteProductDialog({
  required BuildContext context,
  required ProductEntity product,
  required VoidCallback onConfirm,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('marketplace.delete_product'.tr()),
      content: Text(
        'marketplace.delete_product_confirm'.tr(
          namedArgs: {'name': product.name},
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text('batal'.tr()),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            onConfirm();
          },
          child: Text('hapus'.tr(), style: const TextStyle(color: AppColors.error)),
        ),
      ],
    ),
  );
}
