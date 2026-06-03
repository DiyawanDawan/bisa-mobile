import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/product_pricing.dart';
import '../utils/negotiation_quantity_rules.dart';

/// Info stok & min order di form/preview negosiasi.
class NegotiationStockBanner extends StatelessWidget {
  const NegotiationStockBanner({
    super.key,
    required this.stock,
    required this.minOrder,
    required this.unit,
    this.requestedQty,
  });

  final double stock;
  final double minOrder;
  final String unit;
  final double? requestedQty;

  @override
  Widget build(BuildContext context) {
    final outOfStock = NegotiationQuantityRules.isOutOfStock(stock);
    final qtyOverStock =
        requestedQty != null && !outOfStock && requestedQty! > stock;
    final lowStock = !outOfStock && stock <= minOrder * 2;

    Color bg;
    Color border;
    Color iconColor;
    String title;
    String detail;

    if (outOfStock) {
      bg = AppColors.error.withValues(alpha: 0.08);
      border = AppColors.error.withValues(alpha: 0.25);
      iconColor = AppColors.error;
      title = 'Stok habis';
      detail = 'Produk tidak tersedia untuk penawaran jumlah baru.';
    } else if (qtyOverStock) {
      bg = AppColors.error.withValues(alpha: 0.08);
      border = AppColors.error.withValues(alpha: 0.25);
      iconColor = AppColors.error;
      title = 'Jumlah melebihi stok';
      detail =
          'Anda meminta ${ProductPricingInfo.formatQty(requestedQty!)} $unit, '
          'stok tersedia ${NegotiationQuantityRules.formatStock(stock, unit)}.';
    } else if (lowStock) {
      bg = AppColors.warning.withValues(alpha: 0.1);
      border = AppColors.warning.withValues(alpha: 0.3);
      iconColor = AppColors.warning;
      title = 'Stok terbatas';
      detail =
          'Tersedia ${NegotiationQuantityRules.formatStock(stock, unit)} · '
          'min. order ${ProductPricingInfo.formatQty(minOrder)} $unit';
    } else {
      bg = AppColors.success.withValues(alpha: 0.08);
      border = AppColors.success.withValues(alpha: 0.2);
      iconColor = AppColors.success;
      title = 'Stok tersedia';
      detail =
          '${NegotiationQuantityRules.formatStock(stock, unit)} · '
          'min. order ${ProductPricingInfo.formatQty(minOrder)} $unit';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            outOfStock || qtyOverStock
                ? LucideIcons.circleAlert
                : LucideIcons.warehouse,
            size: 18.sp,
            color: iconColor,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: iconColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 11.sp,
                    height: 1.35,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
