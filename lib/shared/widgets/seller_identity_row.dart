import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/constants/app_colors.dart';
import 'bisa_avatar.dart';

/// Baris identitas toko/user: avatar + nama + badge verifikasi.
/// Dipakai di kartu produk, pesanan, tagihan — hindari ikon toko generik saja.
class SellerIdentityRow extends StatelessWidget {
  const SellerIdentityRow({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.isVerified = false,
    this.onTap,
    this.avatarRadius = 10,
    this.nameStyle,
    this.showChevron = false,
    this.fallbackIcon = LucideIcons.store,
    this.maxNameLines = 1,
  });

  final String displayName;
  final String? avatarUrl;
  final bool isVerified;
  final VoidCallback? onTap;
  final double avatarRadius;
  final TextStyle? nameStyle;
  final bool showChevron;
  final IconData fallbackIcon;
  final int maxNameLines;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        BisaAvatar(
          imageUrl: avatarUrl,
          radius: avatarRadius,
          fallbackIcon: fallbackIcon,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  displayName,
                  maxLines: maxNameLines,
                  overflow: TextOverflow.ellipsis,
                  style: nameStyle ??
                      TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              if (isVerified) ...[
                SizedBox(width: 2.w),
                Icon(
                  LucideIcons.badgeCheck,
                  size: 14.sp,
                  color: AppColors.info,
                ),
              ],
            ],
          ),
        ),
        if (showChevron)
          Icon(
            LucideIcons.chevronRight,
            size: 12.sp,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
      ],
    );

    if (onTap == null) return row;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: row,
    );
  }
}
