import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class FloatingBottomNavItem {
  final IconData icon;
  final String label;
  final int? badgeCount;

  const FloatingBottomNavItem({
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}

class FloatingBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<FloatingBottomNavItem> items;
  final ValueChanged<int> onTap;

  const FloatingBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: EdgeInsets.only(bottom: AppSpacing.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.grey200, width: 1.h),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md12,
            AppSpacing.sm,
            AppSpacing.md12,
            AppSpacing.xs,
          ),
          child: Container(
            height: 58.h,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xs6,
              vertical: AppSpacing.xs6,
            ),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(AppSpacing.xxlPx.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final selected = currentIndex == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(AppSpacing.xlPx.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              item.icon,
                              size: 20.sp,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.grey400,
                            ),
                            if ((item.badgeCount ?? 0) > 0)
                              Positioned(
                                right: -AppSpacing.sm,
                                top: -6.h,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xs,
                                    vertical: 1.h,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: AppSpacing.section,
                                    minHeight: AppSpacing.section,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${item.badgeCount}',
                                      style: AppTextStyles.micro(
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro(
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w600,
                            color: selected
                                ? AppColors.primary
                                : AppColors.grey400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
