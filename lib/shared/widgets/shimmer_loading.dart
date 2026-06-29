import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_colors.dart';
import 'product_card_skeleton.dart';

class ShimmerLoading extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.enabled = true,
  });

  static ShimmerEffect get defaultEffect => ShimmerEffect(
        baseColor: AppColors.grey200,
        highlightColor: AppColors.primaryLight.withValues(alpha: 0.55),
      );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      effect: defaultEffect,
      child: child,
    );
  }
}

class ShimmerListPlaceholder extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  /// `true` = [ListView] scroll sendiri (untuk child [Expanded]).
  /// `false` = shrinkWrap (untuk parent [SingleChildScrollView]).
  final bool scrollable;

  final EdgeInsetsGeometry? padding;

  const ShimmerListPlaceholder({
    super.key,
    this.itemCount = 4,
    this.itemHeight = 88,
    this.scrollable = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.separated(
        shrinkWrap: !scrollable,
        physics: scrollable
            ? const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              )
            : const NeverScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.zero,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (_, __) => SizedBox(
          height: itemHeight,
          child: const Bone.multiText(lines: 2),
        ),
      ),
    );
  }
}

/// Grid 2 kolom skeleton produk (marketplace, wishlist, supplier profile loading).
class ShimmerProductGridPlaceholder extends StatelessWidget {
  const ShimmerProductGridPlaceholder({
    super.key,
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.imageHeight,
    this.showSellerInfo = true,
    this.padding,
  });

  final int crossAxisCount;
  final int itemCount;
  final double? imageHeight;
  final bool showSellerInfo;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // Masonry = sama dengan grid produk loaded (marketplace); hindari overflow aspect-ratio tetap.
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(12.w, 0, 12.w, 24.h),
      child: ShimmerLoading(
        child: MasonryGridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 12.w,
          itemCount: itemCount,
          itemBuilder: (_, __) => ProductCardSkeleton(
            imageHeight: imageHeight,
            showSellerInfo: showSellerInfo,
            wrapWithShimmer: false,
          ),
        ),
      ),
    );
  }
}
