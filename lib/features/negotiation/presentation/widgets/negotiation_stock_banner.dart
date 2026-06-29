import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
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
    final stockLabel = NegotiationQuantityRules.formatStock(stock, unit);
    final minOrderLabel = ProductPricingInfo.formatQty(minOrder);

    Color bg;
    Color border;
    Color iconColor;
    String title;
    String detail;

    if (outOfStock) {
      bg = AppColors.error.withValues(alpha: 0.08);
      border = AppColors.error.withValues(alpha: 0.25);
      iconColor = AppColors.error;
      title = 'negotiation.stock_out_title'.tr();
      detail = 'negotiation.stock_out_detail'.tr();
    } else if (qtyOverStock) {
      bg = AppColors.error.withValues(alpha: 0.08);
      border = AppColors.error.withValues(alpha: 0.25);
      iconColor = AppColors.error;
      title = 'negotiation.stock_over_title'.tr();
      detail = 'negotiation.stock_over_detail'.tr(namedArgs: {
        'requested': ProductPricingInfo.formatQty(requestedQty!),
        'unit': unit,
        'stock': stockLabel,
      });
    } else if (lowStock) {
      bg = AppColors.warning.withValues(alpha: 0.1);
      border = AppColors.warning.withValues(alpha: 0.3);
      iconColor = AppColors.warning;
      title = 'negotiation.stock_low_title'.tr();
      detail = 'negotiation.stock_low_detail'.tr(namedArgs: {
        'stock': stockLabel,
        'minOrder': minOrderLabel,
        'unit': unit,
      });
    } else {
      bg = AppColors.success.withValues(alpha: 0.08);
      border = AppColors.success.withValues(alpha: 0.2);
      iconColor = AppColors.success;
      title = 'negotiation.stock_ok_title'.tr();
      detail = 'negotiation.stock_ok_detail'.tr(namedArgs: {
        'stock': stockLabel,
        'minOrder': minOrderLabel,
        'unit': unit,
      });
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
          SizedBox(width: AppSpacing.sm10),
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
