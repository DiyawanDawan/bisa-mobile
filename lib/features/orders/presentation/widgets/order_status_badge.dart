import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final style = OrderStatusStyle.from(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
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
    switch (status.toUpperCase()) {
      case 'PENDING':
        return OrderStatusStyle(
          label: 'Menunggu',
          color: AppColors.warning,
          icon: LucideIcons.clock3,
        );
      case 'CONFIRMED':
        return OrderStatusStyle(
          label: 'Dikonfirmasi',
          color: AppColors.info,
          icon: LucideIcons.circleCheck,
        );
      case 'PAID':
      case 'PROCESSING':
        return OrderStatusStyle(
          label: 'Diproses',
          color: AppColors.info,
          icon: LucideIcons.loader,
        );
      case 'SHIPPED':
        return OrderStatusStyle(
          label: 'Dikirim',
          color: AppColors.primary,
          icon: LucideIcons.truck,
        );
      case 'COMPLETED':
        return OrderStatusStyle(
          label: 'Selesai',
          color: AppColors.success,
          icon: LucideIcons.circleCheck,
        );
      case 'CANCELLED':
        return OrderStatusStyle(
          label: 'Dibatalkan',
          color: AppColors.error,
          icon: LucideIcons.circleX,
        );
      case 'DISPUTED':
        return OrderStatusStyle(
          label: 'Sengketa',
          color: AppColors.error,
          icon: LucideIcons.triangleAlert,
        );
      case 'REFUNDED':
        return OrderStatusStyle(
          label: 'Refund',
          color: AppColors.warning,
          icon: LucideIcons.rotateCcw,
        );
      default:
        return OrderStatusStyle(
          label: status,
          color: AppColors.grey500,
          icon: LucideIcons.info,
        );
    }
  }
}
