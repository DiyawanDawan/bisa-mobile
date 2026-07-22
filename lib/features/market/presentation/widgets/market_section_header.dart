import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/constants/app_text_styles.dart';

/// TradingView-style section title with trailing chevron.
class MarketSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const MarketSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSeeAll,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle(fontWeight: FontWeight.w800),
          ),
          if (onSeeAll != null) ...[
            Text(
              ' ›',
              style: AppTextStyles.sectionTitle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Icon(
              LucideIcons.chevronRight,
              size: 16.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }
}
