import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import 'bisa_media_skeleton.dart';
import 'shimmer_loading.dart';

class ShimmerForumDetailPlaceholder extends StatelessWidget {
  const ShimmerForumDetailPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppColors.surface,
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Bone.circle(size: 40.r),
                      SizedBox(width: AppSpacing.sm10),
                      Expanded(child: Bone.multiText(lines: 2)),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  Bone.multiText(lines: 4),
                  SizedBox(height: AppSpacing.md),
                  BisaMediaSkeleton(
                    width: double.infinity,
                    height: 180.h,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md12),
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.section),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone.circle(size: 32.r),
                          SizedBox(width: AppSpacing.sm10),
                          Expanded(child: Bone.multiText(lines: 2)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
