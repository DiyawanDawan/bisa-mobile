import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/money_format.dart';
import '../utils/order_list_grouping.dart';

/// Header grup tanggal / prefix nomor order.
class OrderDateGroupHeader extends StatelessWidget {
  final OrderNumberGroup group;

  const OrderDateGroupHeader({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm10, bottom: AppSpacing.xs6),
      child: Row(
        children: [
          Icon(LucideIcons.calendar, size: 14.sp, color: AppColors.primary),
          SizedBox(width: AppSpacing.xs6),
          Expanded(
            child: Text(
              orderGroupTitle(group.groupKey, fallbackDate: group.sortDate),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.button),
            ),
            child: Text(
              'orders.group_order_count'.tr(
                namedArgs: {'count': '${group.displayOrderCount}'},
              ),
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
    showSuccessSnackBar(
      context,
      'orders.order_number_copied',
      duration: const Duration(seconds: 2),
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
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
                  'orders.batch_checkout_suppliers'.tr(
                    namedArgs: {'count': '${cluster.length}'},
                  ),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                formatMoneyIdr(cluster.totalAmount),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (batchNumber != null) ...[
            SizedBox(height: AppSpacing.sm10),
            Text(
              'orders.field_order_number'.tr(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            InkWell(
              onTap: () => _copyNumber(context, batchNumber),
              borderRadius: BorderRadius.circular(AppRadius.button),
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
            SizedBox(height: AppSpacing.sm),
            Text(
              'orders.tracking_per_supplier'.tr(
                namedArgs: {'count': '${trackings.length}'},
              ),
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
