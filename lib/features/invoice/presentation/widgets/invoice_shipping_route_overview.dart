import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_draft.dart';
import 'package:mobile_bisa/features/invoice/presentation/bloc/create_invoice_cubit.dart';

/// Ringkasan asal (toko supplier) dan tujuan (pembeli) sebelum hitung ongkir.
class InvoiceShippingRouteOverview extends StatelessWidget {
  const InvoiceShippingRouteOverview({
    super.key,
    required this.sellerSnapshot,
    required this.buyerDraft,
    this.sellerOriginLabel,
    this.sellerOriginResolved,
  });

  final Map<String, dynamic>? sellerSnapshot;
  final InvoiceDraft buyerDraft;
  final String? sellerOriginLabel;
  final bool? sellerOriginResolved;

  @override
  Widget build(BuildContext context) {
    final destReady = CreateInvoiceCubit.isDestinationReady(buyerDraft);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'invoice.route_title'.tr(),
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          _routeStop(
            icon: Icons.storefront_outlined,
            title: 'invoice.route_origin_store'.tr(),
            name: sellerSnapshot?['recipient']?.toString() ??
                'invoice.supplier_store_fallback'.tr(),
            address: _formatAddress(
              sellerSnapshot?['address']?.toString(),
              sellerSnapshot?['regency']?.toString(),
              sellerSnapshot?['province']?.toString(),
            ),
            footer: _sellerOriginFooter(),
            footerColor: sellerOriginResolved == true
                ? AppColors.success
                : AppColors.warning,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Icon(Icons.arrow_downward, size: 18.sp, color: AppColors.primary),
                SizedBox(width: 8.w),
                Expanded(
                  child: Container(height: 1, color: AppColors.grey200),
                ),
              ],
            ),
          ),
          _routeStop(
            icon: Icons.local_shipping_outlined,
            title: 'invoice.shipping_dest_title'.tr(),
            name: buyerDraft.recipient.isNotEmpty
                ? buyerDraft.recipient
                : 'invoice.buyer_label'.tr(),
            address: _formatAddress(
              buyerDraft.address,
              buyerDraft.regency,
              buyerDraft.province,
            ),
            footer: destReady
                ? 'invoice.dest_ready'.tr()
                : 'invoice.dest_incomplete'.tr(),
            footerColor:
                destReady ? AppColors.success : AppColors.warning,
          ),
        ],
      ),
    );
  }

  String _sellerOriginFooter() {
    if (sellerOriginResolved == true) {
      return 'invoice.shipping_origin_label'.tr(namedArgs: {
        'label': sellerOriginLabel ?? 'invoice.shipping_origin_auto'.tr(),
      });
    }
    if (sellerOriginLabel != null && sellerOriginLabel!.isNotEmpty) {
      return 'invoice.shipping_origin_unlinked'.tr(namedArgs: {
        'label': sellerOriginLabel!,
      });
    }
    return 'invoice.shipping_origin_pending'.tr();
  }

  String _formatAddress(String? street, String? regency, String? province) {
    final parts = <String>[
      if (street != null && street.trim().isNotEmpty) street.trim(),
      if (regency != null && regency.trim().isNotEmpty) regency.trim(),
      if (province != null && province.trim().isNotEmpty) province.trim(),
    ];
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  Widget _routeStop({
    required IconData icon,
    required String title,
    required String name,
    required String address,
    required String footer,
    required Color footerColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.sp, color: AppColors.primary),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                address,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                footer,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: footerColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
