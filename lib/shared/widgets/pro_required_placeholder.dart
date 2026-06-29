import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'custom_button.dart';

class ProRequiredPlaceholder extends StatelessWidget {
  final String? title;
  final String message;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final VoidCallback? onRetryPressed;

  const ProRequiredPlaceholder({
    super.key,
    this.title,
    required this.message,
    this.icon = LucideIcons.cpu,
    this.onActionPressed,
    this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160.w,
            height: 160.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: 80.sp,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                Positioned(
                  bottom: 30.h,
                  right: 30.w,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 3),
                    ),
                    child: Icon(
                      LucideIcons.lock,
                      color: AppColors.surface,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Text(
            title ?? 'shared.pro_required_title'.tr(),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 40.h),
          CustomButton(
            text: 'shared.pro_required_renew'.tr(),
            useGradient: true,
            onPressed: onActionPressed,
          ),
          if (onRetryPressed != null) ...[
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetryPressed,
              child: Text(
                'shared.pro_required_retry'.tr(),
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
