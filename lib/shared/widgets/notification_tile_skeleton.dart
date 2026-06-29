import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

class NotificationTileSkeleton extends StatelessWidget {
  const NotificationTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(
            width: 44.r,
            height: 44.r,
            borderRadius: BorderRadius.circular(AppRadius.tile),
          ),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(width: double.infinity, height: 14.h),
                SizedBox(height: AppSpacing.sm),
                Bone.multiText(lines: 2),
                SizedBox(height: AppSpacing.sm),
                Bone(width: 64.w, height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerNotificationListPlaceholder extends StatelessWidget {
  const ShimmerNotificationListPlaceholder({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md12,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md12),
        itemBuilder: (_, __) => const NotificationTileSkeleton(),
      ),
    );
  }
}
