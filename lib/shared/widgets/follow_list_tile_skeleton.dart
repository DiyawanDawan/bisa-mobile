import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

class FollowListTileSkeleton extends StatelessWidget {
  const FollowListTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: [
          Bone.circle(size: 48.r),
          SizedBox(width: AppSpacing.md12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(width: 140.w, height: 14.h),
                SizedBox(height: AppSpacing.xs6),
                Bone(width: 100.w, height: 11.h),
              ],
            ),
          ),
          Bone(
            width: 72.w,
            height: 32.h,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
        ],
      ),
    );
  }
}

class ShimmerFollowListPlaceholder extends StatelessWidget {
  const ShimmerFollowListPlaceholder({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.md),
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm10),
        itemBuilder: (_, __) => const FollowListTileSkeleton(),
      ),
    );
  }
}
