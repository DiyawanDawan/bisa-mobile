import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_layout.dart';
import '../../domain/entities/order_entity.dart';
import '../utils/order_list_grouping.dart';
import 'order_batch_card.dart';
import 'order_card.dart';
import 'order_group_header.dart';

/// Daftar pesanan dikelompokkan berdasarkan prefix nomor order (tanggal).
class GroupedOrdersList extends StatelessWidget {
  final List<OrderEntity> orders;
  final bool isSupplierView;

  const GroupedOrdersList({
    super.key,
    required this.orders,
    this.isSupplierView = false,
  });

  @override
  Widget build(BuildContext context) {
    final groups = groupOrdersByOrderNumber(orders);

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.md12, 2.h, AppSpacing.md12, AppSpacing.sm10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var gi = 0; gi < groups.length; gi++) ...[
            OrderDateGroupHeader(group: groups[gi]),
            for (final cluster in groups[gi].clusters) ...[
              if (cluster.isMulti && !isSupplierView)
                OrderBatchCard(cluster: cluster)
              else ...[
                OrderCheckoutClusterHeader(cluster: cluster),
                for (final order in cluster.orders)
                  OrderCard(
                    order: order,
                    isSupplierView: isSupplierView,
                    isMultiCheckout: cluster.isMulti,
                  ),
              ],
            ],
            if (gi < groups.length - 1) SizedBox(height: 4.h),
          ],
        ],
      ),
    );
  }
}
