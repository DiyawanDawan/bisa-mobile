import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

/// Skeleton layout menyerupai [ProductCard] — aman di masonry grid tanpa overflow.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({
    super.key,
    this.imageHeight,
    this.showSellerInfo = true,
    this.wrapWithShimmer = true,
  });

  /// Tinggi aman untuk [ListView] horizontal (rekomendasi, cart).
  /// Selaras dengan [ProductCard.horizontalViewportHeight].
  static double get horizontalListViewportHeight => 236.h;

  final double? imageHeight;
  final bool showSellerInfo;

  /// Set `false` bila parent sudah membungkus [ShimmerLoading] (grid placeholder).
  final bool wrapWithShimmer;

  @override
  Widget build(BuildContext context) {
    final imgH = imageHeight ?? 140.h;
    final content = Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.sm10,
              AppSpacing.sm,
              AppSpacing.sm10,
              AppSpacing.sm10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(width: double.infinity, height: 12.h),
                SizedBox(height: 4.h),
                Bone(width: 72.w, height: 12.h),
                SizedBox(height: AppSpacing.xs6),
                Bone(width: 88.w, height: 15.h),
                if (showSellerInfo) ...[
                  SizedBox(height: AppSpacing.sm),
                  Bone(width: double.infinity, height: 11.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (!wrapWithShimmer) return content;
    return ShimmerLoading(child: content);
  }
}
