import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

class ShimmerWalletPlaceholder extends StatelessWidget {
  const ShimmerWalletPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.cardPadding,
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Bone(
              width: double.infinity,
              height: 140.h,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            SizedBox(height: AppSpacing.lg),
            Bone(width: 120.w, height: 16.h),
            SizedBox(height: AppSpacing.md12),
            ...List.generate(
              5,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: i < 4 ? AppSpacing.sm10 : 0),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.section),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.tile),
                  ),
                  child: Row(
                    children: [
                      Bone.circle(size: 40.r),
                      SizedBox(width: AppSpacing.md12),
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
