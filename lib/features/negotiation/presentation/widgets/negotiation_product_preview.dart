import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_network_image.dart';

class NegotiationProductPreview extends StatelessWidget {
  const NegotiationProductPreview({
    super.key,
    required this.name,
    this.thumbnailUrl,
    required this.priceLabel,
    this.subtitle,
  });

  final String name;
  final String? thumbnailUrl;
  final String priceLabel;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final thumb = thumbnailUrl;
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: SizedBox(
              width: 48.w,
              height: 48.w,
              child: thumb != null && thumb.isNotEmpty
                  ? BisaNetworkImage(
                      imageUrl: resolveMediaUrl(thumb),
                      fit: BoxFit.cover,
                    )
                  : ColoredBox(
                      color: AppColors.grey50,
                      child: Icon(
                        LucideIcons.package,
                        color: AppColors.grey300,
                        size: 22.sp,
                      ),
                    ),
            ),
          ),
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: 2.h),
                Text(
                  priceLabel,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
