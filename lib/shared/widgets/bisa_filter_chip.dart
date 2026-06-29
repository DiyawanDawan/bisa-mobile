import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class BisaFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badgeCount;

  const BisaFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final showBadge = badgeCount != null && badgeCount! > 0;
    final badgeLabel = badgeCount != null && badgeCount! > 99 ? '99+' : '${badgeCount ?? 0}';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md12,
          vertical: 9.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySecondary(
                color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (showBadge) ...[
              SizedBox(width: 6.w),
              Container(
                constraints: BoxConstraints(minWidth: 18.w),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.surface.withValues(alpha: 0.22)
                      : AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  badgeLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.textOnPrimary : AppColors.primary,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
