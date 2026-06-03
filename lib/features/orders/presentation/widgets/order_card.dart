import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../domain/entities/order_entity.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.isSupplierView = false,
    this.isMultiCheckout = false,
  });

  final OrderEntity order;
  final bool isSupplierView;
  /// True jika bagian dari checkout multi-supplier (nomor internal disembunyikan).
  final bool isMultiCheckout;

  static String? _trackingLabel(OrderEntity order) {
    final trk = order.shipment?.trackingNumber?.trim();
    if (trk != null && trk.isNotEmpty) {
      return 'Tracking: $trk';
    }
    final awb = order.shipment?.awbNumber?.trim();
    if (awb != null && awb.isNotEmpty) {
      return 'Resi: $awb';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final status = _OrderStatusStyle.from(order.status);
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final extraItems = order.items.length > 1 ? order.items.length - 1 : 0;
    final counterparty = isSupplierView ? order.buyer : order.seller;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push('/order/${order.id}'),
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isMultiCheckout) ...[
                              Text(
                                order.seller.name.isNotEmpty
                                    ? order.seller.name
                                    : 'Supplier',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                            ] else ...[
                              Text(
                                order.displayOrderNumber,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textHint,
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                            ],
                            Text(
                              timeago.format(order.createdAt, locale: 'id'),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(style: status),
                    ],
                  ),
                          SizedBox(height: 12.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  width: 72.w,
                                  height: 72.w,
                                  color: AppColors.grey50,
                                  child: hasResolvableMediaUrl(firstItem?.thumbnailUrl)
                                      ? BisaNetworkImage(
                                          imageUrl: firstItem!.thumbnailUrl!,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) => Icon(
                                            LucideIcons.package,
                                            color: AppColors.grey300,
                                            size: 24.sp,
                                          ),
                                        )
                                      : Icon(
                                          LucideIcons.shoppingBag,
                                          color: AppColors.grey300,
                                          size: 24.sp,
                                        ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      firstItem?.productName ?? 'Pesanan BISA',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (_trackingLabel(order) != null) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        _trackingLabel(order)!,
                                        style: TextStyle(
                                          fontSize: isMultiCheckout ? 11.sp : 10.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.info,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    if (extraItems > 0) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        '+$extraItems produk lainnya',
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                    SizedBox(height: 6.h),
                                    Wrap(
                                      spacing: 6.w,
                                      runSpacing: 4.h,
                                      children: [
                                        _MetaChip(
                                          icon: LucideIcons.box,
                                          label: '${order.totalQuantity.toStringAsFixed(0)} item',
                                        ),
                                        if (counterparty.name.isNotEmpty && !isMultiCheckout)
                                          _CounterpartyChip(
                                            name: counterparty.name,
                                            avatarUrl: counterparty.avatarUrl,
                                            isBuyer: isSupplierView,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    Text(
                                      order.totalAmount.toRupiah,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                LucideIcons.chevronRight,
                                size: 18.sp,
                                color: AppColors.grey400,
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Lacak',
                                  height: 40.h,
                                  isOutlined: true,
                                  onPressed: () => context.push('/order/${order.id}'),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: CustomButton(
                                  text: 'Detail',
                                  height: 40.h,
                                  useGradient: true,
                                  onPressed: () => context.push('/order/${order.id}'),
                                ),
                              ),
                            ],
                          ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CounterpartyChip extends StatelessWidget {
  const _CounterpartyChip({
    required this.name,
    this.avatarUrl,
    required this.isBuyer,
  });

  final String name;
  final String? avatarUrl;
  final bool isBuyer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BisaAvatar(
            imageUrl: avatarUrl,
            radius: 8.r,
            fallbackIcon: isBuyer ? LucideIcons.user : LucideIcons.store,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.style});

  final _OrderStatusStyle style;

  @override
  Widget build(BuildContext context) {
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

class _OrderStatusStyle {
  const _OrderStatusStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  factory _OrderStatusStyle.from(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return _OrderStatusStyle(
          label: 'Menunggu',
          color: AppColors.warning,
          icon: LucideIcons.clock3,
        );
      case 'CONFIRMED':
        return _OrderStatusStyle(
          label: 'Dikonfirmasi',
          color: AppColors.info,
          icon: LucideIcons.circleCheck,
        );
      case 'PAID':
      case 'PROCESSING':
        return _OrderStatusStyle(
          label: 'Diproses',
          color: AppColors.info,
          icon: LucideIcons.loader,
        );
      case 'SHIPPED':
        return _OrderStatusStyle(
          label: 'Dikirim',
          color: AppColors.primary,
          icon: LucideIcons.truck,
        );
      case 'COMPLETED':
        return _OrderStatusStyle(
          label: 'Selesai',
          color: AppColors.success,
          icon: LucideIcons.circleCheck,
        );
      case 'CANCELLED':
        return _OrderStatusStyle(
          label: 'Dibatalkan',
          color: AppColors.error,
          icon: LucideIcons.circleX,
        );
      case 'DISPUTED':
        return _OrderStatusStyle(
          label: 'Sengketa',
          color: AppColors.error,
          icon: LucideIcons.triangleAlert,
        );
      case 'REFUNDED':
        return _OrderStatusStyle(
          label: 'Refund',
          color: AppColors.warning,
          icon: LucideIcons.rotateCcw,
        );
      default:
        return _OrderStatusStyle(
          label: status,
          color: AppColors.grey500,
          icon: LucideIcons.info,
        );
    }
  }
}
