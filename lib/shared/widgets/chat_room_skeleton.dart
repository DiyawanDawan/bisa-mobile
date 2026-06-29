import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import 'bisa_media_skeleton.dart';
import 'shimmer_loading.dart';

/// Skeleton room nego/chat: HUD produk + beberapa bubble.
class ShimmerChatRoomPlaceholder extends StatelessWidget {
  const ShimmerChatRoomPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HudSkeleton(),
        Expanded(
          child: ShimmerLoading(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _BubbleSkeleton(alignEnd: false, wide: true),
                SizedBox(height: AppSpacing.md12),
                _BubbleSkeleton(alignEnd: true),
                SizedBox(height: AppSpacing.md12),
                _BubbleSkeleton(alignEnd: false),
                SizedBox(height: AppSpacing.md12),
                _BubbleSkeleton(alignEnd: true, wide: true),
                SizedBox(height: AppSpacing.md12),
                _BubbleSkeleton(alignEnd: false),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HudSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md12,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: ShimmerLoading(
        child: Row(
          children: [
            BisaMediaSkeleton(
              width: 48.w,
              height: 48.w,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            SizedBox(width: AppSpacing.md12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone(width: double.infinity, height: 14.h),
                  SizedBox(height: AppSpacing.xs6),
                  Bone(width: 120.w, height: 11.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleSkeleton extends StatelessWidget {
  const _BubbleSkeleton({required this.alignEnd, this.wide = false});

  final bool alignEnd;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: Bone(
        width: wide ? 220.w : 160.w,
        height: wide ? 56.h : 40.h,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
    );
  }
}
