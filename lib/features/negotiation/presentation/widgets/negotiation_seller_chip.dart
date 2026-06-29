import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bisa_avatar.dart';

/// Menampilkan toko/supplier tujuan penawaran negosiasi.
class NegotiationSellerChip extends StatelessWidget {
  const NegotiationSellerChip({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.isVerified = false,
    this.subtitle,
  });

  final String displayName;
  final String? avatarUrl;
  final bool isVerified;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: [
          BisaAvatar(
            imageUrl: avatarUrl,
            radius: 18.r,
            fallbackIcon: LucideIcons.store,
          ),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle ?? 'negotiation.seller_chip_subtitle'.tr(),
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isVerified) ...[
                      SizedBox(width: 6.w),
                      Icon(
                        LucideIcons.badgeCheck,
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
