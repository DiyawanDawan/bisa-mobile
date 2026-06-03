import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';

class InvoiceShippingCard extends StatelessWidget {
  final Map<String, dynamic>? snapshot;

  const InvoiceShippingCard({super.key, this.snapshot});

  @override
  Widget build(BuildContext context) {
    if (snapshot == null || snapshot!.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
        ),
        child: Text(
          'Alamat pengiriman pembeli belum tersedia.',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      );
    }

    final recipient = snapshot!['recipient']?.toString();
    final phone = snapshot!['phone']?.toString();
    final address = snapshot!['address']?.toString();
    final regency = snapshot!['regency']?.toString();
    final province = snapshot!['province']?.toString();

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
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                'Alamat Pengiriman',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if (recipient != null) _line('Penerima', recipient),
          if (phone != null && phone.isNotEmpty) _line('Telepon', phone),
          if (address != null) _line('Alamat', address),
          if (regency != null || province != null)
            _line('Wilayah', [regency, province].whereType<String>().join(', ')),
        ],
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
