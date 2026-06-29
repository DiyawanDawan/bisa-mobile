import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import 'auth_sheet.dart';
import 'custom_button.dart';

class GuestPlaceholder extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GuestPlaceholder({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = LucideIcons.lock,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            CustomButton(
              text: 'shared.guest_login_now'.tr(),
              useGradient: true,
              onPressed: () => AuthSheet.show(context),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => AuthSheet.show(context),
              child: Text(
                'shared.guest_register_prompt'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
