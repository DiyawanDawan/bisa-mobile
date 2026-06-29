import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
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
          padding: EdgeInsets.all(AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: ShimmerLoading(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Bone.multiText(lines: 2),
                  SizedBox(height: AppSpacing.md),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone.circle(size: 44.w),
                      SizedBox(width: AppSpacing.md12),
                      const Expanded(child: Bone.multiText(lines: 2)),
                    ],
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Bone(width: double.infinity, height: 56.h),
                  SizedBox(height: AppSpacing.md12),
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
