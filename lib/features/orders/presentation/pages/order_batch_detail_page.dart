import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../domain/entities/checkout_batch_detail_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../widgets/order_status_badge.dart';

class OrderBatchDetailPage extends StatefulWidget {
  const OrderBatchDetailPage({super.key, required this.anchorOrderId});

  final String anchorOrderId;

  @override
  State<OrderBatchDetailPage> createState() => _OrderBatchDetailPageState();
}

class _OrderBatchDetailPageState extends State<OrderBatchDetailPage> {
  CheckoutBatchDetailEntity? _batch;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result =
        await sl<OrderRepository>().getCheckoutBatchDetail(widget.anchorOrderId);
    if (!mounted) return;
    result.fold(
      (f) => setState(() {
        _loading = false;
        _error = f.message;
      }),
      (batch) => setState(() {
        _loading = false;
        _batch = batch;
      }),
    );
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Disalin'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String? _trackingOf(OrderEntity order) {
    final trk = order.shipment?.trackingNumber?.trim();
    if (trk != null && trk.isNotEmpty) return trk;
    return order.shipment?.awbNumber?.trim();
  }

  String? _addressLine(CheckoutBatchDetailEntity batch) {
    final snap = batch.shippingAddressSnapshot;
    if (snap == null) return null;
    final parts = <String>[
      if (snap['recipient'] != null) snap['recipient'].toString(),
      if (snap['address'] != null) snap['address'].toString(),
      if (snap['regency'] != null) snap['regency'].toString(),
      if (snap['province'] != null) snap['province'].toString(),
    ].where((s) => s.trim().isNotEmpty).toList();
    return parts.isEmpty ? null : parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: BisaAppBar(
        title: 'Detail Pesanan',
        onBackTap: () => context.pop(),
      ),
      body: _loading
          ? Center(child: ShimmerLoading(child: SizedBox(height: 200.h)))
          : _error != null
              ? _ErrorBody(message: _error!, onRetry: _load)
              : _batch == null
                  ? _ErrorBody(message: 'Data tidak ditemukan', onRetry: _load)
                  : RefreshIndicator(
                      onRefresh: _load,
                      color: AppColors.primary,
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                        children: [
                          _BatchSummaryCard(
                            batch: _batch!,
                            address: _addressLine(_batch!),
                            onCopy: () => _copy(_batch!.displayOrderNumber),
                          ),
                          SizedBox(height: 16.h),
          Text(
            'Detail per toko (${_batch!.orders.length})',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Satu pembayaran, tetapi tiap toko mengirim paket sendiri. '
            'Status dan nomor resi bisa berbeda.',
            style: TextStyle(
              fontSize: 11.sp,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
                          SizedBox(height: 12.h),
                          ..._batch!.orders.map(
                            (order) => _SupplierDetailCard(
                              order: order,
                              tracking: _trackingOf(order),
                              onOpenDetail: () => context.push('/order/${order.id}'),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: 16.h),
            CustomButton(text: 'Coba lagi', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

class _BatchSummaryCard extends StatelessWidget {
  const _BatchSummaryCard({
    required this.batch,
    required this.onCopy,
    this.address,
  });

  final CheckoutBatchDetailEntity batch;
  final VoidCallback onCopy;
  final String? address;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(batch.createdAt);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.layers, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Belanja dari ${batch.supplierCount} toko',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
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
            onTap: onCopy,
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    batch.displayOrderNumber,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(LucideIcons.copy, size: 14.sp, color: AppColors.textSecondary),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(dateLabel,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
          if (address != null) ...[
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.mapPin, size: 14.sp, color: AppColors.textSecondary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    address!,
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 12.h),
          Divider(color: AppColors.grey100, height: 1),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total checkout',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                batch.batchTotalAmount.toRupiah,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupplierDetailCard extends StatelessWidget {
  const _SupplierDetailCard({
    required this.order,
    required this.tracking,
    required this.onOpenDetail,
  });

  final OrderEntity order;
  final String? tracking;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final sellerName =
        order.seller.name.isNotEmpty ? order.seller.name : 'Supplier';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BisaAvatar(
                imageUrl: order.seller.avatarUrl,
                radius: 16.r,
                fallbackIcon: LucideIcons.store,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sellerName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.orderNumber,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textHint,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              OrderStatusBadge(status: order.status),
            ],
          ),
          if (tracking != null) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(LucideIcons.route, size: 13.sp, color: AppColors.info),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    tracking!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 12.h),
          ...order.items.map((item) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      width: 52.w,
                      height: 52.w,
                      color: AppColors.grey50,
                      child: item.thumbnailUrl != null &&
                              item.thumbnailUrl!.isNotEmpty
                          ? BisaNetworkImage(
                              imageUrl: item.thumbnailUrl!,
                              fit: BoxFit.cover,
                            )
                          : Icon(LucideIcons.package, color: AppColors.grey300),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${item.quantity.toStringAsFixed(0)} × ${item.pricePerUnit.toRupiah}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item.subtotal.toRupiah,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
          Divider(color: AppColors.grey100, height: 1),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal toko',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
              ),
              Text(
                order.totalAmount.toRupiah,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomButton(
            text: 'Kelola pesanan toko ini',
            height: 42.h,
            isOutlined: true,
            onPressed: onOpenDetail,
          ),
        ],
      ),
    );
  }
}
