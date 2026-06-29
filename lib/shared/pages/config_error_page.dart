import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

/// Ditampilkan saat `API_URL` kosong di build non-debug.
class ConfigErrorPage extends StatelessWidget {
  const ConfigErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings_suggest_outlined,
                  size: 64.sp,
                  color: AppColors.error,
                ),
                SizedBox(height: 24.h),
                Text(
                  'shared.config_error_title'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'shared.config_error_body'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                if (kDebugMode) ...[
                  SizedBox(height: 16.h),
                  Text(
                    'shared.config_error_debug_note'.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
