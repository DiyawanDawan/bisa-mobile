import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'bisa_media_skeleton.dart';
import 'shimmer_loading.dart';

/// Skeleton halaman detail produk (buyer & supplier manage).
class ShimmerProductDetailPlaceholder extends StatelessWidget {
  const ShimmerProductDetailPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: BisaMediaSkeleton(
            width: double.infinity,
            height: 350.h,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverToBoxAdapter(
            child: ShimmerLoading(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Bone.multiText(lines: 2),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone.circle(size: 44.w),
                      SizedBox(width: 12.w),
                      const Expanded(child: Bone.multiText(lines: 2)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Bone(width: double.infinity, height: 56.h),
                  SizedBox(height: 12.h),
                  Bone(width: double.infinity, height: 120.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
