import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../utils/order_status_i18n.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final style = OrderStatusStyle.from(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm10, vertical: 5.h),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 11.sp, color: style.color),
          SizedBox(width: 4.w),
          Text(
            style.label,
            style: TextStyle(
              color: style.color,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderStatusStyle {
  const OrderStatusStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  factory OrderStatusStyle.from(String status) {
    final upper = status.toUpperCase();
    switch (upper) {
      case 'PENDING':
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.warning,
          icon: LucideIcons.clock3,
        );
      case 'CONFIRMED':
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.info,
          icon: LucideIcons.circleCheck,
        );
      case 'PAID':
      case 'PROCESSING':
        return OrderStatusStyle(
          label: orderStatusLabel('PROCESSING'),
          color: AppColors.info,
          icon: LucideIcons.loader,
        );
      case 'SHIPPED':
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.primary,
          icon: LucideIcons.truck,
        );
      case 'COMPLETED':
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.success,
          icon: LucideIcons.circleCheck,
        );
      case 'CANCELLED':
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.error,
          icon: LucideIcons.circleX,
        );
      case 'DISPUTED':
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.error,
          icon: LucideIcons.triangleAlert,
        );
      case 'REFUNDED':
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.warning,
          icon: LucideIcons.rotateCcw,
        );
      case 'EXPIRED':
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.error,
          icon: LucideIcons.circleX,
        );
      default:
        return OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.grey500,
          icon: LucideIcons.info,
        );
    }
  }
}
