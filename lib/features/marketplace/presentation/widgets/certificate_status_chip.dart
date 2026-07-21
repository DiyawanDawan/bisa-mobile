import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';

class CertificateStatusChip extends StatelessWidget {
  const CertificateStatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (color, icon, key) = switch (status) {
      'APPROVED' => (
        AppColors.success,
        LucideIcons.shieldCheck,
        'certificate.status_approved',
      ),
      'REJECTED' => (
        AppColors.error,
        LucideIcons.circleX,
        'certificate.status_rejected',
      ),
      _ => (
        AppColors.warning,
        LucideIcons.clock3,
        'certificate.status_pending',
      ),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: AppSpacing.xs),
          Text(
            key.tr(),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
