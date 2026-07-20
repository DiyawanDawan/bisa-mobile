import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/media_url_utils.dart';
import 'package:mobile_bisa/core/utils/money_format.dart';
import 'package:mobile_bisa/shared/widgets/bisa_network_image.dart';

/// Ringkasan produk di tagihan: thumbnail, nama, qty, harga, badge diskon merah.
class InvoiceProductSummaryCard extends StatelessWidget {
  const InvoiceProductSummaryCard({
    super.key,
    required this.productName,
    required this.quantity,
    required this.pricePerUnit,
    this.unit = 'unit',
    this.thumbnailUrl,
    this.catalogPricePerUnit,
    this.invoiceNumber,
    this.subtitle,
  });

  final String productName;
  final double quantity;
  final double pricePerUnit;
  final String unit;
  final String? thumbnailUrl;
  final double? catalogPricePerUnit;
  final String? invoiceNumber;
  final String? subtitle;

  double? get _discountPercent {
    final catalog = catalogPricePerUnit;
    if (catalog == null || catalog <= 0) return null;
    if (pricePerUnit >= catalog) return null;
    return ((catalog - pricePerUnit) / catalog) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final discount = _discountPercent;
    final catalog = catalogPricePerUnit;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (invoiceNumber != null && invoiceNumber!.isNotEmpty) ...[
            Text(
              'invoice.label_invoice_number'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              invoiceNumber!,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: hasResolvableMediaUrl(thumbnailUrl)
                    ? BisaNetworkImage(
                        imageUrl: thumbnailUrl!,
                        width: 64.w,
                        height: 64.w,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 64.w,
                        height: 64.w,
                        color: AppColors.primary.withValues(alpha: 0.08),
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.primary,
                          size: 28.sp,
                        ),
                      ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    SizedBox(height: 6.h),
                    Text(
                      '${'invoice.label_qty'.tr()}: ${quantity.toStringAsFixed(quantity % 1 == 0 ? 0 : 1)} $unit',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: [
                        if (catalog != null &&
                            catalog > 0 &&
                            catalog > pricePerUnit)
                          Text(
                            formatMoneyIdr(catalog),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textHint,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.textHint,
                            ),
                          ),
                        Text(
                          formatMoneyIdr(pricePerUnit),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '/ $unit',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (discount != null && discount > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'marketplace.discount_off'.tr(
                                namedArgs: {
                                  'percent': discount.round().toString(),
                                },
                              ),
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
