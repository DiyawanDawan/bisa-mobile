import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

/// Skeleton untuk [SupplierProductTile] di daftar produk supplier.
class SupplierProductTileSkeleton extends StatelessWidget {
  const SupplierProductTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(
              width: 72.w,
              height: 72.w,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            SizedBox(width: AppSpacing.sm10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone.multiText(lines: 2),
                  SizedBox(height: AppSpacing.xs6),
                  Bone(width: 90.w, height: 14.h),
                  SizedBox(height: AppSpacing.xs6),
                  Row(
                    children: [
                      Bone.circle(size: 18.w),
                      SizedBox(width: AppSpacing.xs6),
                      Bone(width: 64.w, height: 11.h),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs6),
                  Bone(width: 120.w, height: 10.h),
                ],
              ),
            ),
            Column(
              children: [
                Bone(width: 28.w, height: 28.w),
                SizedBox(height: AppSpacing.xs6),
                Bone(width: 28.w, height: 28.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
