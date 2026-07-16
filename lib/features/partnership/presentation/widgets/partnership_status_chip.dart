import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PartnershipStatusChip extends StatelessWidget {
  final String status;

  const PartnershipStatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
      case 'ACTIVE':
        return AppColors.success;
      case 'PENDING':
      case 'AWAITING_SIGNATURE':
        return AppColors.warning;
      case 'RENEWAL_PENDING':
        return AppColors.warning;
      case 'REJECTED':
      case 'TERMINATED':
      case 'EXPIRED':
      case 'RENEWAL_PENDING':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String get _label => 'partnership.status_$status'.tr();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.35)),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
