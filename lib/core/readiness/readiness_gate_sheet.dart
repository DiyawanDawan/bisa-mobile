import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import 'readiness_models.dart';

/// Checklist blocker sebelum upload produk / negosiasi / checkout.
class ReadinessGateSheet extends StatelessWidget {
  const ReadinessGateSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.readiness,
    required this.routeForKey,
  });

  final String title;
  final String subtitle;
  final RoleReadiness readiness;
  final String? Function(String key) routeForKey;

  static Future<void> showStore(
    BuildContext context,
    RoleReadiness readiness,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReadinessGateSheet(
        title: 'Lengkapi data toko',
        subtitle:
            'Anda perlu melengkapi profil toko sebelum menambah atau mempublikasikan produk.',
        readiness: readiness,
        routeForKey: readinessRouteForStoreKey,
      ),
    );
  }

  static Future<void> showBuyer(
    BuildContext context,
    RoleReadiness readiness,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReadinessGateSheet(
        title: 'Lengkapi profil pengiriman',
        subtitle:
            'Tambahkan alamat dan kontak penerima sebelum negosiasi atau checkout.',
        readiness: readiness,
        routeForKey: readinessRouteForBuyerKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final blockers = readiness.messages.isNotEmpty
        ? readiness.messages
        : readiness.missing.map(readinessLabelForKey).toList();

    return Container(
      margin: EdgeInsets.only(top: 48.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        24.h + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 16.h),
          ...blockers.map(
            (text) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline, color: AppColors.warning, size: 18.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          if (readiness.missing.isNotEmpty) ...[
            CustomButton(
              text: 'Lengkapi sekarang',
              height: 46.h,
              useGradient: true,
              onPressed: () {
                final route = routeForKey(readiness.missing.first);
                Navigator.of(context).pop();
                if (route != null) context.push(route);
              },
            ),
            SizedBox(height: 8.h),
          ],
          CustomButton(
            text: 'Tutup',
            height: 44.h,
            isOutlined: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
