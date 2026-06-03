import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

/// Skeleton layout menyerupai [ProductCard] — tinggi eksplisit, aman di masonry grid.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({
    super.key,
    this.imageHeight,
    this.showSellerInfo = true,
  });

  final double? imageHeight;
  final bool showSellerInfo;

  @override
  Widget build(BuildContext context) {
    final imgH = imageHeight ?? 120.h;

    return ShimmerLoading(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: AppColors.softShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bone(
              width: double.infinity,
              height: imgH,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone(width: double.infinity, height: 13.h),
                  SizedBox(height: 6.h),
                  Bone(width: 100.w, height: 13.h),
                  SizedBox(height: 8.h),
                  Bone(width: 88.w, height: 16.h),
                  if (showSellerInfo) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Bone.circle(size: 18.w),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Bone(
                            width: double.infinity,
                            height: 11.h,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
