import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_feedback.dart';
import '../../core/utils/safe_area_utils.dart';
import '../../core/currency/display_currency_service.dart';

Future<void> showCurrencySelectorSheet(BuildContext context) async {
  await DisplayCurrencyService.instance.ensureLoaded();
  final current = DisplayCurrencyService.instance.currency;

  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.pill)),
    ),
    builder: (ctx) {
      return Padding(
        padding: bisaSheetPadding(
          ctx,
          horizontal: AppSpacing.lg,
          top: AppSpacing.md,
          bottom: AppSpacing.xl28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'commerce.display_currency_title'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.xs6),
            Text(
              'commerce.display_currency_hint'.tr(),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            for (final code in DisplayCurrencyService.instance.supported)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  code,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
                trailing: current == code
                    ? Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 20.sp,
                      )
                    : null,
                onTap: () async {
                  await DisplayCurrencyService.instance.setCurrency(code);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    showCustomSnackBar(
                      context,
                      content: Text(
                        'commerce.display_currency_updated'.tr(
                          namedArgs: {'code': code},
                        ),
                      ),
                      backgroundColor: AppColors.success,
                    );
                  }
                },
              ),
          ],
        ),
      );
    },
  );
}
