import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/extensions.dart';

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
        color: Colors.white,
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
          _row('Subtotal Barang', subtotal.toRupiah),
          _row('Biaya Platform', platformFee.toRupiah),
          if (logisticsFee > 0)
            _row('Biaya Ongkir (BISA)', logisticsFee.toRupiah),
          _row('PPN', vatAmount.toRupiah),
          Divider(height: 20.h, color: AppColors.grey200),
          _row('Total Tagihan', totalAmount.toRupiah, isBold: true),
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
