import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/orders/domain/entities/order_entity.dart';

class InvoiceShippingCard extends StatelessWidget {
  final Map<String, dynamic>? snapshot;
  final Map<String, dynamic>? originSnapshot;
  final String? sellerOriginLabel;
  final OrderShippingEntity? orderShipping;

  const InvoiceShippingCard({
    super.key,
    this.snapshot,
    this.originSnapshot,
    this.sellerOriginLabel,
    this.orderShipping,
  });

  @override
  Widget build(BuildContext context) {
    final hasOrigin = originSnapshot != null && originSnapshot!.isNotEmpty;
    final hasDestination = snapshot != null && snapshot!.isNotEmpty;
    final methodLines = _shippingMethodLines();

    if (!hasOrigin && !hasDestination && methodLines.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
        ),
        child: Text(
          'invoice.shipping_missing'.tr(),
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                'invoice.shipping_bisa'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if (hasOrigin) ...[
            _addressBlock(
              'invoice.shipping_origin_title'.tr(),
              originSnapshot!,
              footer: sellerOriginLabel != null && sellerOriginLabel!.isNotEmpty
                  ? 'invoice.shipping_origin_label'.tr(namedArgs: {
                      'label': sellerOriginLabel!,
                    })
                  : null,
            ),
            if (hasDestination) SizedBox(height: 12.h),
          ],
          if (hasDestination)
            _addressBlock('invoice.shipping_dest_title'.tr(), snapshot!),
          if (methodLines.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              'invoice.shipping_method'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'BISA',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 6.h),
            ...methodLines.map(
              (line) => Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  line,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textPrimary,
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<String> _shippingMethodLines() {
    final lines = <String>[];
    Map<String, dynamic>? logistics;
    if (snapshot?['logistics'] is Map) {
      logistics = Map<String, dynamic>.from(snapshot!['logistics'] as Map);
    }

    final courier =
        (logistics?['courierCode'] ?? orderShipping?.courierCode)?.toString();
    final courierName =
        (logistics?['courierName'] ?? orderShipping?.courierName)?.toString();
    final service = (logistics?['verifiedService'] ??
            logistics?['serviceName'] ??
            orderShipping?.serviceName)
        ?.toString();
    final destination = (logistics?['destinationLabel'] ??
            orderShipping?.destinationLabel)
        ?.toString();
    final origin = (sellerOriginLabel ?? orderShipping?.originLabel)?.toString();
    final etd = (logistics?['etd'] ?? orderShipping?.etd)?.toString();

    if (courier != null && courier.isNotEmpty) {
      final label = courierName != null && courierName.isNotEmpty
          ? '$courierName (${courier.toUpperCase()})'
          : courier.toUpperCase();
      lines.add('invoice.shipping_line_courier'.tr(namedArgs: {'label': label}));
    }
    if (service != null && service.isNotEmpty) {
      lines.add('invoice.shipping_line_service'.tr(namedArgs: {'service': service}));
    }
    if (origin != null && origin.isNotEmpty) {
      lines.add('invoice.shipping_line_origin'.tr(namedArgs: {'origin': origin}));
    }
    if (destination != null && destination.isNotEmpty) {
      lines.add('invoice.shipping_line_dest'.tr(namedArgs: {'dest': destination}));
    }
    if (etd != null && etd.isNotEmpty) {
      lines.add('invoice.shipping_line_eta'.tr(namedArgs: {'eta': etd}));
    }
    return lines;
  }

  Widget _addressBlock(
    String title,
    Map<String, dynamic> snap, {
    String? footer,
  }) {
    final recipient = snap['recipient']?.toString();
    final phone = snap['phone']?.toString();
    final address = snap['address']?.toString();
    final regency = snap['regency']?.toString();
    final province = snap['province']?.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 6.h),
        if (recipient != null && recipient.isNotEmpty)
          _line('invoice.shipping_address_name'.tr(), recipient),
        if (phone != null && phone.isNotEmpty)
          _line('invoice.shipping_address_phone'.tr(), phone),
        if (address != null && address.isNotEmpty)
          _line('invoice.shipping_address_street'.tr(), address),
        if (regency != null || province != null)
          _line(
            'invoice.shipping_address_region'.tr(),
            [regency, province]
                .whereType<String>()
                .where((s) => s.isNotEmpty)
                .join(', '),
          ),
        if (footer != null && footer.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            footer,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
        ],
      ],
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
