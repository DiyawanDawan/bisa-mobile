import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/extensions.dart';
import '../../domain/entities/invoice_deal_economics.dart';

/// Panel harga katalog vs nego, diskon %, stok, estimasi bersih supplier.
class InvoiceDealEconomicsCard extends StatelessWidget {
  const InvoiceDealEconomicsCard({
    super.key,
    required this.economics,
  });

  final InvoiceDealEconomics economics;

  @override
  Widget build(BuildContext context) {
    final e = economics;
    final discountColor =
        e.hasDiscount ? AppColors.success : AppColors.warning;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.chartLine, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                'Ringkasan Harga & Keuntungan',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _metricRow(
            'Harga katalog / ${e.unit}',
            e.catalogPricePerUnit.toRupiah,
            muted: true,
          ),
          _metricRow(
            'Harga nego / ${e.unit}',
            e.negotiatedPricePerUnit.toRupiah,
            emphasized: true,
          ),
          if (e.hasDiscount)
            _badge(
              'Diskon ${e.discountPercentPerUnit.toStringAsFixed(1)}% per ${e.unit}',
              discountColor,
            )
          else if (e.isPremiumOverCatalog)
            _badge(
              'Di atas katalog (+${(e.negotiatedPricePerUnit - e.catalogPricePerUnit).toRupiah}/${e.unit})',
              AppColors.warning,
            ),
          SizedBox(height: 8.h),
          const Divider(height: 1, color: AppColors.grey100),
          SizedBox(height: 8.h),
          _metricRow('Total harga awal (katalog)', e.catalogSubtotal.toRupiah,
              strikethrough: e.hasDiscount),
          _metricRow('Total setelah nego', e.negotiatedSubtotal.toRupiah,
              emphasized: true),
          if (e.hasDiscount) ...[
            SizedBox(height: 6.h),
            _metricRow(
              'Hemat pembeli',
              '${e.savingsTotal.toRupiah} (${e.discountPercentTotal.toStringAsFixed(1)}%)',
              valueColor: AppColors.success,
            ),
          ],
          SizedBox(height: 8.h),
          const Divider(height: 1, color: AppColors.grey100),
          SizedBox(height: 8.h),
          _metricRow(
            'Stok tersedia',
            '${e.productStock.toStringAsFixed(0)} ${e.unit}',
          ),
          _metricRow(
            'Stok setelah deal',
            '${e.stockAfterDeal.toStringAsFixed(0)} ${e.unit}',
            valueColor:
                e.stockAfterDeal <= 0 ? AppColors.error : AppColors.textPrimary,
          ),
          _metricRow('Jumlah nego', '${e.quantity.toStringAsFixed(0)} ${e.unit}'),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimasi bersih supplier',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  e.sellerNetEstimate.toRupiah,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Setelah biaya platform ${e.platformFee.toRupiah} '
                  '(${e.platformFeePercent.toStringAsFixed(1)}% dari subtotal nego)',
                  style: TextStyle(fontSize: 10.sp, color: AppColors.textHint),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricRow(
    String label,
    String value, {
    bool emphasized = false,
    bool strikethrough = false,
    bool muted = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: emphasized ? 14.sp : 12.sp,
              fontWeight: emphasized ? FontWeight.w800 : FontWeight.w700,
              color: valueColor ??
                  (muted ? AppColors.textHint : AppColors.textPrimary),
              decoration: strikethrough ? TextDecoration.lineThrough : null,
              decorationColor: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, bottom: 4.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}
