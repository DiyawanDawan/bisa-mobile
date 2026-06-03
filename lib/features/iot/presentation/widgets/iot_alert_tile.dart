import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/iot_alert_model.dart';

class IotAlertTile extends StatelessWidget {
  const IotAlertTile({
    super.key,
    required this.alert,
    required this.onMarkRead,
  });

  final IotAlertModel alert;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    final isUnread = !alert.isRead;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isUnread
            ? AppColors.error.withValues(alpha: 0.06)
            : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isUnread
              ? AppColors.error.withValues(alpha: 0.25)
              : AppColors.grey100,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.triangleAlert,
            size: 18.sp,
            color: isUnread ? AppColors.error : AppColors.grey400,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.alertType.replaceAll('_', ' '),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  alert.message,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (alert.temperature != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'Suhu: ${alert.temperature}°C',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                  ),
                ],
              ],
            ),
          ),
          if (isUnread)
            TextButton(
              onPressed: onMarkRead,
              child: Text(
                'Baca',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700),
              ),
            ),
        ],
      ),
    );
  }
}
