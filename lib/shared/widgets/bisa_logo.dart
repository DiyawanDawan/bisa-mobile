import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';

/// App logo from [AppAssets.logo].
class BisaLogo extends StatelessWidget {
  const BisaLogo({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final double? size;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final w = width ?? size ?? 48.w;
    final h = height ?? size ?? 48.w;

    return Image.asset(
      AppAssets.logo,
      width: w,
      height: h,
      fit: fit,
      errorBuilder: (_, __, ___) => Icon(
        Icons.eco,
        size: w * 0.65,
        color: AppColors.primary,
      ),
    );
  }
}

/// Circular badge wrapper for splash and profile guest states.
class BisaLogoBadge extends StatelessWidget {
  const BisaLogoBadge({
    super.key,
    this.size = 120,
    this.backgroundColor = Colors.white,
    this.showShadow = true,
  });

  final double size;
  final Color backgroundColor;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final badgeSize = size.w;
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(badgeSize * 0.22),
      child: SizedBox.expand(
        child: BisaLogo(fit: BoxFit.contain),
      ),
    );
  }
}

/// Compact logo with optional subtitle for headers.
class BisaLogoMark extends StatelessWidget {
  const BisaLogoMark({
    super.key,
    this.logoSize = 36,
    this.title,
    this.subtitle,
  });

  final double logoSize;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BisaLogo(size: logoSize.w),
        if (title != null) ...[
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
