import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

/// Skeleton mirip [OrderCard] — dipakai saat first load `OrdersPage`.
class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm10,
          vertical: AppSpacing.sm10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Bone.multiText(lines: 2, fontSize: 10.sp)),
                SizedBox(width: AppSpacing.sm),
                Bone(
                  width: 64.w,
                  height: 20.h,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(
                  width: 60.w,
                  height: 60.w,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                SizedBox(width: AppSpacing.sm10),
                Expanded(child: Bone.multiText(lines: 2, fontSize: 11.sp)),
                SizedBox(width: AppSpacing.xs6),
                Bone(width: 56.w, height: 28.h),
              ],
            ),
            SizedBox(height: AppSpacing.sm10),
            Row(
              children: [
                Expanded(
                  child: Bone(
                    height: 34.h,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Bone(
                    height: 34.h,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Daftar skeleton pesanan — shrinkWrap aman di dalam [SingleChildScrollView].
class ShimmerOrderListPlaceholder extends StatelessWidget {
  const ShimmerOrderListPlaceholder({
    super.key,
    this.itemCount = 4,
    this.padding,
  });

  final int itemCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.zero,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox.shrink(),
        itemBuilder: (_, __) => const OrderCardSkeleton(),
      ),
    );
  }
}
