import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'custom_button.dart';

/// Konfirmasi sederhana — mengganti AlertDialog + TextButton/ElevatedButton.
Future<bool?> showBisaConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmText = 'Ya',
  String cancelText = 'Batal',
  bool destructive = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: confirmText,
                height: 46.h,
                backgroundColor: destructive ? AppColors.error : AppColors.primary,
                onPressed: () => Navigator.pop(ctx, true),
              ),
              SizedBox(height: 8.h),
              CustomButton(
                text: cancelText,
                height: 46.h,
                isOutlined: true,
                onPressed: () => Navigator.pop(ctx, false),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Form dialog scrollable + keyboard-safe (design-system).
void showBisaFormDialog(
  BuildContext context, {
  required String title,
  required List<Widget> fields,
  required String submitText,
  required bool Function() onSubmit,
  String cancelText = 'Batal',
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      final viewInsets = MediaQuery.viewInsetsOf(ctx);
      final screenH = MediaQuery.sizeOf(ctx).height;
      final maxDialogH = screenH - viewInsets.bottom - 48.h;

      return AnimatedPadding(
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxDialogH),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: fields,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomButton(
                    text: submitText,
                    height: 46.h,
                    onPressed: () {
                      if (onSubmit()) Navigator.pop(ctx);
                    },
                  ),
                  SizedBox(height: 8.h),
                  CustomButton(
                    text: cancelText,
                    height: 46.h,
                    isOutlined: true,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
