import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import 'shimmer_loading.dart';

/// Shimmer placeholder untuk area gambar CDN (thumbnail, banner, hero).
///
/// Pakai ini (atau default [BisaNetworkImage]) saat media masih diunduh.
/// Jangan pakai [CircularProgressIndicator] untuk slot gambar — spinner
/// hanya untuk aksi (submit, pull refresh kecil, dialog).
class BisaMediaSkeleton extends StatelessWidget {
  const BisaMediaSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  factory BisaMediaSkeleton.circle({required double radius}) {
    final size = radius * 2;
    return BisaMediaSkeleton(
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isCircle = shape == BoxShape.circle;
    final radius = isCircle
        ? null
        : (borderRadius ?? BorderRadius.circular(AppRadius.button));

    Widget bone = Bone(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      borderRadius: isCircle
          ? BorderRadius.circular(999)
          : (radius ?? BorderRadius.zero),
    );

    if (width != null || height != null) {
      bone = SizedBox(width: width, height: height, child: bone);
    }

    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : radius,
        ),
        clipBehavior: Clip.antiAlias,
        child: bone,
      ),
    );
  }
}
