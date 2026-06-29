import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/i18n/locale_formatters.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_avatar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../domain/entities/order_entity.dart';
import '../utils/order_status_i18n.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.isSupplierView = false,
    this.isMultiCheckout = false,
  });

  final OrderEntity order;
  final bool isSupplierView;
  final bool isMultiCheckout;

  static String? _trackingLabel(OrderEntity order) {
    final trk = order.shipment?.trackingNumber?.trim();
    if (trk != null && trk.isNotEmpty) {
      return 'orders.tracking_bisa_prefix'.tr(namedArgs: {'number': trk});
    }
    final awb = order.shipment?.awbNumber?.trim();
    if (awb != null && awb.isNotEmpty) {
      return 'orders.tracking_awb_prefix'.tr(namedArgs: {'number': awb});
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final payStatus = order.transaction?.paymentStatus?.toUpperCase() ?? '';
    final status = payStatus == 'EXPIRED' &&
            order.status.toUpperCase() == 'PENDING'
        ? _OrderStatusStyle.expired()
        : _OrderStatusStyle.from(order.status);
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final extraItems = order.items.length > 1 ? order.items.length - 1 : 0;
    final counterparty = isSupplierView ? order.buyer : order.seller;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.grey100),
        boxShadow: AppColors.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: () => context.push('/order/${order.id}'),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm10,
                vertical: AppSpacing.sm10,
              ),
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
                                    : 'orders.fallback_supplier'.tr(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ] else ...[
                              Text(
                                order.displayOrderNumber,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textHint,
                                  letterSpacing: 0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            Text(
                              context.formatTimeAgo(order.createdAt),
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _StatusBadge(style: status),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: Container(
                          width: 60.w,
                          height: 60.w,
                          color: AppColors.grey50,
                          child: hasResolvableMediaUrl(firstItem?.thumbnailUrl)
                              ? BisaNetworkImage(
                                  imageUrl: firstItem!.thumbnailUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Icon(
                                    LucideIcons.package,
                                    color: AppColors.grey300,
                                    size: 20.sp,
                                  ),
                                )
                              : Icon(
                                  LucideIcons.shoppingBag,
                                  color: AppColors.grey300,
                                  size: 20.sp,
                                ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              firstItem?.productName ??
                                  'orders.fallback_order_name'.tr(),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (_trackingLabel(order) != null) ...[
                              SizedBox(height: 2.h),
                              Text(
                                _trackingLabel(order)!,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.info,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            if (extraItems > 0) ...[
                              SizedBox(height: 2.h),
                              Text(
                                'orders.more_products'.tr(
                                  namedArgs: {'count': '$extraItems'},
                                ),
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                            SizedBox(height: 4.h),
                            Wrap(
                              spacing: 4.w,
                              runSpacing: 3.h,
                              children: [
                                _MetaChip(
                                  icon: LucideIcons.box,
                                  label: 'orders.item_count'.tr(namedArgs: {
                                    'count':
                                        order.totalQuantity.toStringAsFixed(0),
                                  }),
                                ),
                                if (counterparty.name.isNotEmpty &&
                                    !isMultiCheckout)
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
                      SizedBox(width: AppSpacing.xs6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'orders.total_label'.tr(),
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            formatMoneyIdr(order.totalAmount),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          SizedBox(height: 2.h),
                          Icon(
                            LucideIcons.chevronRight,
                            size: 14.sp,
                            color: AppColors.grey400,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'orders.action_track'.tr(),
                          height: 34.h,
                          isOutlined: true,
                          onPressed: () => context.push('/order/${order.id}'),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: CustomButton(
                          text: 'orders.action_detail'.tr(),
                          height: 34.h,
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
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BisaAvatar(
            imageUrl: avatarUrl,
            radius: 8.r,
            fallbackIcon: isBuyer ? LucideIcons.user : LucideIcons.store,
          ),
          SizedBox(width: 3.w),
          Flexible(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 9.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.sp, color: AppColors.textSecondary),
          SizedBox(width: 3.w),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.icon, size: 10.sp, color: style.color),
          SizedBox(width: 3.w),
          Text(
            style.label,
            style: TextStyle(
              color: style.color,
              fontSize: 9.sp,
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

  factory _OrderStatusStyle.expired() {
    return _OrderStatusStyle(
      label: orderStatusLabel('EXPIRED'),
      color: AppColors.error,
      icon: LucideIcons.circleX,
    );
  }

  factory _OrderStatusStyle.from(String status) {
    final upper = status.toUpperCase();
    switch (upper) {
      case 'PENDING':
        return _OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.warning,
          icon: LucideIcons.clock3,
        );
      case 'CONFIRMED':
        return _OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.info,
          icon: LucideIcons.circleCheck,
        );
      case 'PAID':
      case 'PROCESSING':
        return _OrderStatusStyle(
          label: orderStatusLabel('PROCESSING'),
          color: AppColors.info,
          icon: LucideIcons.loader,
        );
      case 'SHIPPED':
        return _OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.primary,
          icon: LucideIcons.truck,
        );
      case 'COMPLETED':
        return _OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.success,
          icon: LucideIcons.circleCheck,
        );
      case 'CANCELLED':
        return _OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.error,
          icon: LucideIcons.circleX,
        );
      case 'DISPUTED':
        return _OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.error,
          icon: LucideIcons.triangleAlert,
        );
      case 'REFUNDED':
        return _OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.warning,
          icon: LucideIcons.rotateCcw,
        );
      default:
        return _OrderStatusStyle(
          label: orderStatusLabel(upper),
          color: AppColors.grey500,
          icon: LucideIcons.info,
        );
    }
  }
}
