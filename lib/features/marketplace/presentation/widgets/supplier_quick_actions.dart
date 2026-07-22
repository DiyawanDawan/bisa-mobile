import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/readiness/readiness_gate.dart';
import '../../../home/presentation/pages/main_screen.dart';

/// 12 aksi supplier dalam grid 4×3.
class SupplierQuickActions extends StatelessWidget {
  const SupplierQuickActions({super.key});

  static const int _columns = 4;
  static const int _rows = 3;

  @override
  Widget build(BuildContext context) {
    final actions = _primaryActions(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pageGutter,
        0,
        AppSpacing.pageGutter,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          AppSpacing.sm10,
          AppSpacing.md12,
          AppSpacing.sm10,
          AppSpacing.sm10,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'marketplace.quick_actions_title'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/profile/all-menu'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'profile.menu_all_menu'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 6.0;
                const cellAspectRatio = 0.82;
                final cellWidth =
                    (constraints.maxWidth - spacing * (_columns - 1)) /
                    _columns;
                final cellHeight = cellWidth / cellAspectRatio;
                final gridHeight = cellHeight * _rows + spacing * (_rows - 1);

                return SizedBox(
                  height: gridHeight,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _columns,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: cellAspectRatio,
                    ),
                    itemCount: actions.length.clamp(0, 12),
                    itemBuilder: (context, index) =>
                        _QuickActionItem(data: actions[index]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<_QuickActionData> _primaryActions(BuildContext context) {
    return [
      _QuickActionData(
        icon: LucideIcons.plus,
        label: 'marketplace.action_add_product'.tr(),
        onTap: () => ReadinessGate.pushAddProduct(context),
      ),
      _QuickActionData(
        icon: LucideIcons.package,
        label: 'marketplace.action_manage_products'.tr(),
        onTap: () => context.push('/product-management'),
      ),
      _QuickActionData(
        icon: LucideIcons.store,
        label: 'marketplace.action_store_management'.tr(),
        onTap: () => context.push('/store-management'),
      ),
      _QuickActionData(
        icon: LucideIcons.chartBar,
        label: 'marketplace.action_analytics'.tr(),
        onTap: () => context.push('/sales-analytics'),
      ),
      _QuickActionData(
        icon: LucideIcons.heart,
        label: 'marketplace.action_product_engagement'.tr(),
        onTap: () => context.push('/product-engagement'),
      ),
      _QuickActionData(
        icon: LucideIcons.wallet,
        label: 'marketplace.action_wallet'.tr(),
        onTap: () => context.push('/wallet'),
      ),
      _QuickActionData(
        icon: LucideIcons.shoppingBag,
        label: 'marketplace.action_orders'.tr(),
        onTap: () => MainShellScope.maybeOf(context)?.selectTab(3),
      ),
      _QuickActionData(
        icon: LucideIcons.messageSquare,
        label: 'marketplace.action_negotiation'.tr(),
        onTap: () => MainShellScope.maybeOf(context)?.selectTab(1),
      ),
      _QuickActionData(
        icon: LucideIcons.truck,
        label: 'marketplace.action_shipping_origin'.tr(),
        onTap: () => context.push('/supplier-shipping-origin'),
      ),
      _QuickActionData(
        icon: LucideIcons.cpu,
        label: 'marketplace.action_iot_monitoring'.tr(),
        onTap: () => context.push('/iot-dashboard'),
      ),
      _QuickActionData(
        icon: LucideIcons.shieldCheck,
        label: 'marketplace.action_verification'.tr(),
        onTap: () => context.push('/verification'),
      ),
      _QuickActionData(
        icon: LucideIcons.bell,
        label: 'marketplace.action_notifications'.tr(),
        onTap: () => context.push('/notifications'),
      ),
    ];
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({required this.data});

  final _QuickActionData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.grey200),
      ),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 6.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(data.icon, color: AppColors.primary, size: 16.sp),
              ),
              SizedBox(height: 4.h),
              Text(
                data.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
