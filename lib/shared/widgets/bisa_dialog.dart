import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'custom_button.dart';

/// Konfirmasi sederhana — mengganti AlertDialog + TextButton/ElevatedButton.
Future<bool?> showBisaConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  bool destructive = false,
  IconData? icon,
}) {
  final resolvedConfirm = confirmText ?? 'common.yes'.tr();
  final resolvedCancel = cancelText ?? 'batal'.tr();
  final dialogIcon = icon ?? (destructive ? LucideIcons.trash2 : null);

  return showDialog<bool>(
    context: context,
    barrierDismissible: !destructive,
    builder: (ctx) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.comfortable,
            AppSpacing.comfortable,
            AppSpacing.comfortable,
            AppSpacing.sectionGap,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (dialogIcon != null) ...[
                Center(
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: (destructive ? AppColors.error : AppColors.primary)
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      dialogIcon,
                      color: destructive ? AppColors.error : AppColors.primary,
                      size: 22.sp,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.sectionGap),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.sectionTitle(
                  fontWeight: FontWeight.w800,
                ).copyWith(fontSize: 17.sp),
              ),
              SizedBox(height: AppSpacing.compact),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySm(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              SizedBox(height: AppSpacing.sectionGapLarge),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: resolvedCancel,
                      height: AppSpacing.buttonHeight,
                      isOutlined: true,
                      onPressed: () => Navigator.pop(ctx, false),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md12),
                  Expanded(
                    child: CustomButton(
                      text: resolvedConfirm,
                      height: AppSpacing.buttonHeight,
                      backgroundColor: destructive
                          ? AppColors.error
                          : AppColors.primary,
                      onPressed: () => Navigator.pop(ctx, true),
                    ),
                  ),
                ],
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
  String? cancelText,
}) {
  final resolvedCancel = cancelText ?? 'batal'.tr();
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
          insetPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxDialogH),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.sectionTitle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: AppSpacing.section),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: fields,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  CustomButton(
                    text: submitText,
                    height: AppSpacing.buttonHeight,
                    onPressed: () {
                      if (onSubmit()) Navigator.pop(ctx);
                    },
                  ),
                  SizedBox(height: AppSpacing.sm),
                  CustomButton(
                    text: resolvedCancel,
                    height: AppSpacing.buttonHeight,
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
