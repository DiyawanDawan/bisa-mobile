import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class FloatingBottomNavItem {
  final IconData icon;
  final String label;
  final int? badgeCount;
  final GlobalKey? key;

  const FloatingBottomNavItem({
    required this.icon,
    required this.label,
    this.badgeCount,
    this.key,
  });
}

/// Bottom nav ringkas (buyer & supplier) — tinggi lebih pendek ala Shopee.
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

  /// Tinggi bar isi (tanpa safe area sistem).
  static double get barHeight => AppSpacing.bottomNavHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 8,
      shadowColor: AppColors.black.withValues(alpha: 0.06),
      child: SafeArea(
        top: false,
        minimum: EdgeInsets.zero,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.grey200, width: 0.5),
            ),
          ),
          child: SizedBox(
            height: barHeight,
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final selected = currentIndex == index;
                return Expanded(
                  child: Container(
                    key: item.key,
                    child: InkWell(
                      onTap: () => onTap(index),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              item.icon,
                              size: 18.sp,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.grey400,
                            ),
                            if ((item.badgeCount ?? 0) > 0)
                              Positioned(
                                right: -AppSpacing.sm,
                                top: -5.h,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 1.h,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 14.w,
                                    minHeight: 14.w,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${item.badgeCount}',
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        color: AppColors.textOnPrimary,
                                        fontWeight: FontWeight.w900,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          item.label.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro(
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: selected
                                ? AppColors.primary
                                : AppColors.grey400,
                          ).copyWith(fontSize: 9.sp, height: 1.1),
                        ),
                      ],
                    ),
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
