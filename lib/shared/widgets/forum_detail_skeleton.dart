import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
              color: AppColors.white,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Bone.circle(size: 40.r),
                      SizedBox(width: 10.w),
                      Expanded(child: Bone.multiText(lines: 2)),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Bone.multiText(lines: 4),
                  SizedBox(height: 16.h),
                  BisaMediaSkeleton(
                    width: double.infinity,
                    height: 180.h,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Bone.circle(size: 32.r),
                          SizedBox(width: 10.w),
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
