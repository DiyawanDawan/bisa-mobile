import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/shimmer_loading.dart';

/// Skeleton mirip [OrderCard] — dipakai saat first load `OrdersPage`.
class OrderCardSkeleton extends StatelessWidget {
  const OrderCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Bone.multiText(lines: 2),
                ),
                SizedBox(width: 8.w),
                Bone(
                  width: 72.w,
                  height: 24.h,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(
                  width: 72.w,
                  height: 72.w,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Bone.multiText(lines: 3),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Bone.circle(size: 28.r),
                SizedBox(width: 8.w),
                Expanded(child: Bone(width: double.infinity, height: 12.h)),
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
