import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/readiness/readiness_gate.dart';

/// Empat aksi utama supplier + tautan Semua Menu (sisanya di profile/all-menu).
class SupplierQuickActions extends StatelessWidget {
  const SupplierQuickActions({super.key});

  static const int _columns = 2;

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
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
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
            Row(
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
            SizedBox(height: AppSpacing.sm10),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 8.0;
                const cellAspectRatio = 1.35;
                final cellWidth =
                    (constraints.maxWidth - spacing * (_columns - 1)) /
                    _columns;
                final cellHeight = cellWidth / cellAspectRatio;
                final gridHeight = cellHeight * 2 + spacing;

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
                    itemCount: actions.length,
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
        borderRadius: BorderRadius.circular(AppRadius.tile),
        side: const BorderSide(color: AppColors.grey200),
      ),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm10,
            vertical: 10.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Icon(data.icon, color: AppColors.primary, size: 18.sp),
              ),
              SizedBox(height: 6.h),
              Text(
                data.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.2,
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
