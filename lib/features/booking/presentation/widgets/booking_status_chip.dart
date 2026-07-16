import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class BookingStatusChip extends StatelessWidget {
  final String status;

  const BookingStatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
      case 'PENDING_PAYMENT':
        return AppColors.warning;
      case 'CONFIRMED':
        return AppColors.info;
      case 'FULFILLED':
        return AppColors.success;
      case 'CANCELLED':
      case 'EXPIRED':
        return AppColors.grey500;
      default:
        return AppColors.grey500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'booking.status_$status'.tr(),
        style: TextStyle(
          color: _color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
