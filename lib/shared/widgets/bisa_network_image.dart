import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/media_url_utils.dart';
import 'bisa_media_skeleton.dart';

/// Gambar jaringan terpusat: wajib untuk semua URL media dari API
/// (resolve base URL + header ngrok otomatis). Jangan ganti dengan [Image.network].
class BisaNetworkImage extends StatelessWidget {
  const BisaNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.showShimmerPlaceholder = true,
    this.fadeInDuration = const Duration(milliseconds: 280),
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final BorderRadius? borderRadius;
  final bool showShimmerPlaceholder;
  final Duration fadeInDuration;

  @override
  Widget build(BuildContext context) {
    final resolved = resolveMediaUrl(imageUrl);
    if (resolved.isEmpty) {
      return _wrap(_defaultError(context, resolved));
    }

    final image = CachedNetworkImage(
      imageUrl: resolved,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: networkImageHttpHeaders,
      cacheKey: resolved,
      fadeInDuration: fadeInDuration,
      fadeOutDuration: const Duration(milliseconds: 120),
      placeholder: placeholder ??
          (showShimmerPlaceholder
              ? (_, __) => _defaultPlaceholder()
              : (_, __) => _legacySpinnerPlaceholder()),
      errorWidget: errorWidget ?? (_, __, ___) => _defaultError(context, resolved),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  Widget _defaultPlaceholder() {
    return BisaMediaSkeleton(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  Widget _legacySpinnerPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.grey100,
      child: Center(
        child: SizedBox(
          width: 20.sp,
          height: 20.sp,
          child: const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }

  Widget _defaultError(BuildContext context, String url) {
    return Container(
      width: width,
      height: height,
      color: AppColors.grey100,
      child: Icon(
        LucideIcons.imageOff,
        color: AppColors.grey300,
        size: (width != null && width! < 56) ? 18.sp : 32.sp,
      ),
    );
  }

  Widget _wrap(Widget child) {
    if (borderRadius == null) return child;
    return ClipRRect(borderRadius: borderRadius!, child: child);
  }
}
