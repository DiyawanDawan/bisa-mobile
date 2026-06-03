import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/media_url_utils.dart';
import 'bisa_media_skeleton.dart';
import 'bisa_network_image.dart';

/// Avatar bulat dengan resolve URL + header ngrok (sama pola profil/forum).
/// Gunakan untuk seller/user/participant yang punya `avatarUrl` dari API —
/// jangan ganti dengan ikon toko generik saja di kartu produk atau pesanan.
class BisaAvatar extends StatelessWidget {
  const BisaAvatar({
    super.key,
    required this.imageUrl,
    this.radius = 22,
    this.fallbackIcon = LucideIcons.user,
    this.backgroundColor,
  });

  final String? imageUrl;
  final double radius;
  final IconData fallbackIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;
    final bg = backgroundColor ?? AppColors.primaryLight;

    if (!hasResolvableMediaUrl(imageUrl)) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        child: Icon(fallbackIcon, size: radius, color: AppColors.primary),
      );
    }

    return ClipOval(
      child: BisaNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => BisaMediaSkeleton.circle(radius: radius),
        errorWidget: (_, __, ___) => CircleAvatar(
          radius: radius,
          backgroundColor: bg,
          child: Icon(
            fallbackIcon,
            size: radius * 0.9,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
