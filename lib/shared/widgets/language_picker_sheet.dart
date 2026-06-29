import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';

/// Bottom sheet pemilih bahasa — dipakai di Profil & Pengaturan.
void showLanguagePickerSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.xlPx.r),
      ),
    ),
    builder: (sheetContext) {
      final currentLocale = sheetContext.locale;
      return Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'settings.choose_language'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            _LanguageTile(
              title: 'settings.language_indonesian'.tr(),
              code: 'id',
              country: 'ID',
              selected: currentLocale.languageCode == 'id',
              onSelected: () => _applyLocale(sheetContext, context, 'id', 'ID'),
            ),
            _LanguageTile(
              title: 'settings.language_english'.tr(),
              code: 'en',
              country: 'US',
              selected: currentLocale.languageCode == 'en',
              onSelected: () => _applyLocale(sheetContext, context, 'en', 'US'),
            ),
            SizedBox(height: AppSpacing.md12),
          ],
        ),
      );
    },
  );
}

Future<void> _applyLocale(
  BuildContext sheetContext,
  BuildContext parentContext,
  String code,
  String country,
) async {
  final previous = sheetContext.locale;
  final next = Locale(code, country);
  if (previous == next) {
    if (sheetContext.mounted) Navigator.pop(sheetContext);
    return;
  }

  await sheetContext.setLocale(next);
  if (sheetContext.mounted) Navigator.pop(sheetContext);

  if (!parentContext.mounted) return;
  showSuccessSnackBar(parentContext, 'settings.language_changed');
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.code,
    required this.country,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final String code;
  final String country;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onSelected,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
          color: selected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: selected
          ? const Icon(LucideIcons.check, color: AppColors.primary)
          : null,
    );
  }
}
