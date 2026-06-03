import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/entities/order_entity.dart';
import '../utils/order_list_grouping.dart';
import '../utils/checkout_navigation.dart';
import 'order_status_badge.dart';

/// Satu kartu gabungan untuk checkout multi-supplier (buyer view).
class OrderBatchCard extends StatelessWidget {
  const OrderBatchCard({super.key, required this.cluster});

  final OrderCheckoutCluster cluster;

  Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No. pesanan disalin'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String? _trackingOf(OrderEntity order) {
    final trk = order.shipment?.trackingNumber?.trim();
    if (trk != null && trk.isNotEmpty) return trk;
    return order.shipment?.awbNumber?.trim();
  }

  void _openBatchDetail(BuildContext context) {
    context.push('/order-batch/${cluster.leadOrder.id}');
  }

  bool get _allSameStatus {
    if (cluster.orders.isEmpty) return true;
    final first = cluster.orders.first.status.toUpperCase();
    return cluster.orders.every((o) => o.status.toUpperCase() == first);
  }

  @override
  Widget build(BuildContext context) {
    final batchNumber = cluster.checkoutBatchNumber;
    final createdAt = cluster.sortDate;
    final storeCount = cluster.length;
    final itemCount = cluster.totalItemCount;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _openBatchDetail(context),
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BatchCardHeader(
                  storeCount: storeCount,
                  itemCount: itemCount,
                  createdAt: createdAt,
                  showSingleStatus: _allSameStatus,
                  status: _allSameStatus
                      ? cluster.orders.first.status
                      : cluster.aggregateStatus,
                  statusesDiffer: !_allSameStatus,
                ),
                SizedBox(height: 10.h),
                _InfoBanner(storeCount: storeCount),
                if (batchNumber != null) ...[
                  SizedBox(height: 10.h),
                  _OrderNumberRow(
                    batchNumber: batchNumber,
                    onCopy: () => _copy(context, batchNumber),
                  ),
                ],
                SizedBox(height: 12.h),
                ...cluster.orders.map(
                  (order) => _SupplierSection(
                    order: order,
                    hasTracking: _trackingOf(order) != null,
                  ),
                ),
                SizedBox(height: 12.h),
                const Divider(height: 1, color: AppColors.grey100),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total yang dibayar',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            cluster.totalAmount.toRupiah,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      size: 20.sp,
                      color: AppColors.grey400,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Lacak paket',
                        height: 42.h,
                        isOutlined: true,
                        onPressed: () => _showTrackingSheet(context),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomButton(
                        text: 'Lihat detail',
                        height: 42.h,
                        useGradient: true,
                        onPressed: () => _openBatchDetail(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTrackingSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final maxH = MediaQuery.sizeOf(ctx).height * 0.75;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(ctx).bottom,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Lacak paket per toko',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Anda belanja dari ${cluster.length} toko. '
                            'Setiap toko mengirim paket sendiri dengan nomor resi berbeda.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              height: 1.45,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ...cluster.orders.map(
                            (order) => _TrackingStoreCard(
                              order: order,
                              tracking: _trackingOf(order),
                              onCopy: (v) => _copy(ctx, v),
                              onOpenDetail: () {
                                Navigator.pop(ctx);
                                openOrderDetailOrBatch(
                                  context,
                                  orderId: order.id,
                                  checkoutBatchId: order.checkoutBatchId,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BatchCardHeader extends StatelessWidget {
  const _BatchCardHeader({
    required this.storeCount,
    required this.itemCount,
    required this.createdAt,
    required this.showSingleStatus,
    required this.status,
    required this.statusesDiffer,
  });

  final int storeCount;
  final int itemCount;
  final DateTime createdAt;
  final bool showSingleStatus;
  final String status;
  final bool statusesDiffer;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            LucideIcons.store,
            size: 22.sp,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Belanja dari $storeCount toko',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '1× bayar · $itemCount barang · ${timeago.format(createdAt, locale: 'id')}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (statusesDiffer)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Status beda',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
          )
        else if (showSingleStatus)
          OrderStatusBadge(status: status),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.storeCount});

  final int storeCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, size: 14.sp, color: AppColors.info),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              storeCount > 1
                  ? 'Tiap toko punya pengiriman & status sendiri. '
                      'Nomor resi bisa berbeda-beda.'
                  : 'Pesanan dari beberapa toko dalam satu pembayaran.',
              style: TextStyle(
                fontSize: 10.sp,
                height: 1.4,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderNumberRow extends StatelessWidget {
  const _OrderNumberRow({
    required this.batchNumber,
    required this.onCopy,
  });

  final String batchNumber;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No. pesanan (untuk CS)',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _shortCode(batchNumber),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onCopy,
            icon: Icon(LucideIcons.copy, size: 14.sp),
            label: Text(
              'Salin',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  static String _shortCode(String full) {
    if (full.length <= 28) return full;
    return '${full.substring(0, 20)}…${full.substring(full.length - 6)}';
  }
}

/// Satu blok per toko — lebih mudah dipahami daripada list produk datar.
class _SupplierSection extends StatelessWidget {
  const _SupplierSection({
    required this.order,
    required this.hasTracking,
  });

  final OrderEntity order;
  final bool hasTracking;

  @override
  Widget build(BuildContext context) {
    final sellerName =
        order.seller.name.isNotEmpty ? order.seller.name : 'Toko';
    final items = order.items;
    const maxPreview = 2;
    final preview = items.take(maxPreview).toList();
    final extra = items.length - preview.length;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SellerAvatar(name: sellerName, avatarUrl: order.seller.avatarUrl),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  sellerName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          SizedBox(height: 8.h),
          ...preview.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6.r),
                    child: SizedBox(
                      width: 32.w,
                      height: 32.w,
                      child: hasResolvableMediaUrl(item.thumbnailUrl)
                          ? BisaNetworkImage(
                              imageUrl: item.thumbnailUrl!,
                              fit: BoxFit.cover,
                            )
                          : ColoredBox(
                              color: AppColors.white,
                              child: Icon(
                                LucideIcons.package,
                                size: 14.sp,
                                color: AppColors.grey300,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item.productName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item.quantity.toStringAsFixed(0)}×',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (extra > 0)
            Text(
              '+$extra produk lainnya',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          if (hasTracking) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(
                  LucideIcons.truck,
                  size: 12.sp,
                  color: AppColors.info,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Sudah ada nomor resi',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SellerAvatar extends StatelessWidget {
  const _SellerAvatar({required this.name, this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    if (hasResolvableMediaUrl(avatarUrl)) {
      return BisaAvatar(
        imageUrl: avatarUrl,
        radius: 14.r,
        fallbackIcon: LucideIcons.store,
      );
    }

    final initial =
        name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'T';
    return CircleAvatar(
      radius: 14.r,
      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
      child: Text(
        initial,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _TrackingStoreCard extends StatelessWidget {
  const _TrackingStoreCard({
    required this.order,
    required this.tracking,
    required this.onCopy,
    required this.onOpenDetail,
  });

  final OrderEntity order;
  final String? tracking;
  final void Function(String value) onCopy;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final sellerName =
        order.seller.name.isNotEmpty ? order.seller.name : 'Toko';
    final trk = tracking;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SellerAvatar(name: sellerName, avatarUrl: order.seller.avatarUrl),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  sellerName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          SizedBox(height: 10.h),
          if (trk != null) ...[
            Text(
              'Nomor resi',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            SelectableText(
              trk,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onCopy(trk),
                    icon: Icon(LucideIcons.copy, size: 16.sp),
                    label: const Text('Salin resi'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: FilledButton(
                    onPressed: onOpenDetail,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Detail toko'),
                  ),
                ),
              ],
            ),
          ] else
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.clock3,
                    size: 16.sp,
                    color: AppColors.textHint,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Resi belum tersedia. Toko akan mengirim setelah pesanan diproses.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
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
