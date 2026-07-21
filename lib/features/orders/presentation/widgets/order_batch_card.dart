import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobile_bisa/core/i18n/locale_formatters.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../core/utils/money_format.dart';
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
    showSuccessSnackBar(
      context,
      'orders.order_number_copied',
      duration: const Duration(seconds: 2),
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
      margin: EdgeInsets.only(bottom: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: () => _openBatchDetail(context),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm10,
              vertical: AppSpacing.sm10,
            ),
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
                SizedBox(height: AppSpacing.sm10),
                _InfoBanner(storeCount: storeCount),
                if (batchNumber != null) ...[
                  SizedBox(height: AppSpacing.sm10),
                  _OrderNumberRow(
                    batchNumber: batchNumber,
                    onCopy: () => _copy(context, batchNumber),
                  ),
                ],
                SizedBox(height: AppSpacing.md12),
                ...cluster.orders.map(
                  (order) => _SupplierSection(
                    order: order,
                    hasTracking: _trackingOf(order) != null,
                  ),
                ),
                SizedBox(height: AppSpacing.md12),
                const Divider(height: 1, color: AppColors.grey100),
                SizedBox(height: AppSpacing.md12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'orders.total_paid'.tr(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            formatMoneyIdr(cluster.totalAmount),
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
                SizedBox(height: AppSpacing.md12),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'orders.action_track_packages'.tr(),
                        height: AppSpacing.buttonHeightSm,
                        isOutlined: true,
                        onPressed: () => _showTrackingSheet(context),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm10),
                    Expanded(
                      child: CustomButton(
                        text: 'orders.action_view_detail'.tr(),
                        height: AppSpacing.buttonHeightSm,
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
      backgroundColor: AppColors.transparent,
      builder: (ctx) {
        final maxH = MediaQuery.sizeOf(ctx).height * 0.75;
        return Padding(
          padding: sheetBottomPadding(ctx),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxH),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.xlPx.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: AppSpacing.sm10),
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
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.pageGutter,
                        AppSpacing.comfortable,
                        AppSpacing.pageGutter,
                        AppSpacing.spacious,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'orders.track_per_store_title'.tr(),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'orders.track_per_store_body'.tr(
                              namedArgs: {'count': '${cluster.length}'},
                            ),
                            style: TextStyle(
                              fontSize: 12.sp,
                              height: 1.45,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
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
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Icon(LucideIcons.store, size: 22.sp, color: AppColors.primary),
        ),
        SizedBox(width: AppSpacing.md12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'orders.batch_from_stores'.tr(
                  namedArgs: {'count': '$storeCount'},
                ),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'orders.batch_meta'.tr(
                  namedArgs: {
                    'count': '$itemCount',
                    'time': context.formatTimeAgo(createdAt),
                  },
                ),
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
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm10,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              'orders.batch_status_mixed'.tr(),
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
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm10,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, size: 14.sp, color: AppColors.info),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              storeCount > 1
                  ? 'orders.batch_info_multi'.tr()
                  : 'orders.batch_info_single'.tr(),
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
  const _OrderNumberRow({required this.batchNumber, required this.onCopy});

  final String batchNumber;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm10,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'orders.order_number_for_cs'.tr(),
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
              'orders.copy'.tr(),
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
  const _SupplierSection({required this.order, required this.hasTracking});

  final OrderEntity order;
  final bool hasTracking;

  @override
  Widget build(BuildContext context) {
    final sellerName = order.seller.name.isNotEmpty
        ? order.seller.name
        : 'orders.fallback_store'.tr();
    final items = order.items;
    const maxPreview = 2;
    final preview = items.take(maxPreview).toList();
    final extra = items.length - preview.length;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SellerAvatar(
                name: sellerName,
                avatarUrl: order.seller.avatarUrl,
              ),
              SizedBox(width: AppSpacing.sm),
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
          SizedBox(height: AppSpacing.sm),
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
                              color: AppColors.surface,
                              child: Icon(
                                LucideIcons.package,
                                size: 14.sp,
                                color: AppColors.grey300,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          '${item.quantity.toStringAsFixed(0)}× ${formatMoneyIdr(item.pricePerUnit)}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatMoneyIdr(item.subtotal),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (extra > 0)
            Text(
              'orders.more_products'.tr(namedArgs: {'count': '$extra'}),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  'orders.store_subtotal'.tr(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Text(
                formatMoneyIdr(order.totalAmount),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (hasTracking) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(LucideIcons.truck, size: 12.sp, color: AppColors.info),
                SizedBox(width: 4.w),
                Text(
                  'orders.tracking_available'.tr(),
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
        radius: AppRadius.tile,
        fallbackIcon: LucideIcons.store,
      );
    }

    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'T';
    return CircleAvatar(
      radius: AppRadius.tile,
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
    final sellerName = order.seller.name.isNotEmpty
        ? order.seller.name
        : 'orders.fallback_store'.tr();
    final trk = tracking;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm10),
      padding: EdgeInsets.all(AppSpacing.section),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SellerAvatar(
                name: sellerName,
                avatarUrl: order.seller.avatarUrl,
              ),
              SizedBox(width: AppSpacing.sm),
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
          SizedBox(height: AppSpacing.sm10),
          if (trk != null) ...[
            Text(
              'orders.field_tracking_number'.tr(),
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
            SizedBox(height: AppSpacing.sm10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => onCopy(trk),
                    icon: Icon(LucideIcons.copy, size: 16.sp),
                    label: Text('orders.copy_tracking'.tr()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: onOpenDetail,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text('orders.store_detail'.tr()),
                  ),
                ),
              ],
            ),
          ] else
            Container(
              padding: EdgeInsets.all(AppSpacing.sm10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.clock3,
                    size: 16.sp,
                    color: AppColors.textHint,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'orders.tracking_not_available'.tr(),
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
