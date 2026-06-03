import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _BubbleSkeleton(alignEnd: false, wide: true),
                SizedBox(height: 12.h),
                _BubbleSkeleton(alignEnd: true),
                SizedBox(height: 12.h),
                _BubbleSkeleton(alignEnd: false),
                SizedBox(height: 12.h),
                _BubbleSkeleton(alignEnd: true, wide: true),
                SizedBox(height: 12.h),
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
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: ShimmerLoading(
        child: Row(
          children: [
            BisaMediaSkeleton(
              width: 48.w,
              height: 48.w,
              borderRadius: BorderRadius.circular(12.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone(width: double.infinity, height: 14.h),
                  SizedBox(height: 6.h),
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
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}
