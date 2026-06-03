import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

class ShimmerWalletPlaceholder extends StatelessWidget {
  const ShimmerWalletPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bone(
              width: double.infinity,
              height: 140.h,
              borderRadius: BorderRadius.circular(20.r),
            ),
            SizedBox(height: 20.h),
            Bone(width: 120.w, height: 16.h),
            SizedBox(height: 12.h),
            ...List.generate(
              5,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: i < 4 ? 10.h : 0),
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    children: [
                      Bone.circle(size: 40.r),
                      SizedBox(width: 12.w),
                      Expanded(child: Bone.multiText(lines: 2)),
                      Bone(width: 72.w, height: 14.h),
                    ],
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
