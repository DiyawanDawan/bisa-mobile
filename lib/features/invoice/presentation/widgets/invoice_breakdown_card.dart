import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/money_format.dart';

class InvoiceBreakdownCard extends StatelessWidget {
  final double subtotal;
  final double platformFee;
  final double logisticsFee;
  final double vatAmount;
  final double totalAmount;
  final String? title;

  const InvoiceBreakdownCard({
    super.key,
    required this.subtotal,
    required this.platformFee,
    this.logisticsFee = 0,
    required this.vatAmount,
    required this.totalAmount,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
          ],
          _row('invoice.breakdown_subtotal'.tr(), formatMoneyIdr(subtotal)),
          _row('invoice.breakdown_platform'.tr(), formatMoneyIdr(platformFee)),
          if (logisticsFee > 0)
            _row('invoice.breakdown_logistics'.tr(), formatMoneyIdr(logisticsFee)),
          _row('invoice.breakdown_vat'.tr(), formatMoneyIdr(vatAmount)),
          Divider(height: 20.h, color: AppColors.grey200),
          _row('invoice.breakdown_total'.tr(), formatMoneyIdr(totalAmount), isBold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 15.sp : 12.sp,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
