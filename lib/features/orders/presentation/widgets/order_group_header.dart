import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../utils/order_list_grouping.dart';

/// Header grup tanggal / prefix nomor order.
class OrderDateGroupHeader extends StatelessWidget {
  final OrderNumberGroup group;

  const OrderDateGroupHeader({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Row(
        children: [
          Icon(LucideIcons.calendar, size: 16.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              orderGroupTitle(group.groupKey, fallbackDate: group.sortDate),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${group.displayOrderCount} pesanan',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sub-header saat satu checkout menghasilkan beberapa pengiriman supplier.
class OrderCheckoutClusterHeader extends StatelessWidget {
  final OrderCheckoutCluster cluster;

  const OrderCheckoutClusterHeader({super.key, required this.cluster});

  Future<void> _copyNumber(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('No. pesanan disalin'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!cluster.isMulti) return const SizedBox.shrink();

    final batchNumber = cluster.checkoutBatchNumber;
    final trackings = cluster.orders
        .map((o) {
          final trk = o.shipment?.trackingNumber?.trim();
          if (trk != null && trk.isNotEmpty) return trk;
          return o.shipment?.awbNumber?.trim();
        })
        .whereType<String>()
        .where((t) => t.isNotEmpty)
        .toList();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.layers,
                size: 14.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Checkout ${cluster.length} supplier',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                cluster.totalAmount.toRupiah,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (batchNumber != null) ...[
            SizedBox(height: 10.h),
            Text(
              'No. Pesanan',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            InkWell(
              onTap: () => _copyNumber(context, batchNumber),
              borderRadius: BorderRadius.circular(8.r),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      batchNumber,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Icon(
                    LucideIcons.copy,
                    size: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
          if (trackings.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              'Tracking per supplier (${trackings.length})',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            ...trackings.map(
              (trk) => Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  trk,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
