import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';

class ProfileAllMenuPage extends StatelessWidget {
  const ProfileAllMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );
    final isAuthenticated = user != null;
    final isSupplier = user?.role == 'SUPPLIER';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.surface,
        title: 'profile.menu_all_menu'.tr(),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm10,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        children: [
          _MenuSection(
            title: 'profile.menu_important_features'.tr(),
            items: [
              _MenuGridItem(
                icon: LucideIcons.sparkles,
                label: 'profile.menu_important_features'.tr(),
                onTap: () => context.push('/important-features'),
              ),
            ],
          ),
          if (isAuthenticated) ...[
            _MenuSection(
              title: 'profile.all_menu_section_account'.tr(),
              items: [
                _MenuGridItem(
                  icon: LucideIcons.user,
                  label: 'profile.menu_edit_profile'.tr(),
                  onTap: () => context.push('/edit-profile', extra: user),
                ),
                _MenuGridItem(
                  icon: LucideIcons.shieldCheck,
                  label: 'profile.menu_verification'.tr(),
                  onTap: () => context.push('/verification'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.mapPin,
                  label: 'profile.menu_short_addresses'.tr(),
                  onTap: () => context.push('/addresses'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.lock,
                  label: 'profile.menu_short_password'.tr(),
                  onTap: () => context.push('/change-password'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.users,
                  label: 'profile.menu_connections'.tr(),
                  onTap: () => context.push('/follows'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.handshake,
                  label: 'profile.menu_my_contracts'.tr(),
                  onTap: () => context.push('/partnerships'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.bell,
                  label: 'profile.menu_notifications'.tr(),
                  onTap: () => context.push('/notifications'),
                ),
              ],
            ),
          ],
          if (isAuthenticated && !isSupplier)
            _MenuSection(
              title: 'profile.all_menu_section_shopping'.tr(),
              items: [
                _MenuGridItem(
                  icon: LucideIcons.package,
                  label: 'profile.menu_my_products'.tr(),
                  onTap: () => context.push('/buyer-products'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.heart,
                  label: 'profile.menu_short_wishlist'.tr(),
                  onTap: () => context.push('/wishlist'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.shoppingCart,
                  label: 'profile.menu_cart'.tr(),
                  onTap: () => context.push('/cart'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.messageSquare,
                  label: 'profile.menu_negotiations'.tr(),
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(1);
                    context.pop();
                  },
                ),
                _MenuGridItem(
                  icon: LucideIcons.shoppingBag,
                  label: 'profile.menu_orders'.tr(),
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  },
                ),
                _MenuGridItem(
                  icon: LucideIcons.calendarClock,
                  label: 'booking.menu_title'.tr(),
                  onTap: () => context.push('/bookings'),
                ),
              ],
            ),
          if (isAuthenticated && isSupplier)
            _MenuSection(
              title: 'profile.section_business'.tr(),
              items: [
                _MenuGridItem(
                  icon: LucideIcons.store,
                  label: 'profile.menu_store_management'.tr(),
                  onTap: () => context.push('/store-management'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.package,
                  label: 'profile.menu_manage_products'.tr(),
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(0);
                    context.pop();
                  },
                ),
                _MenuGridItem(
                  icon: LucideIcons.plus,
                  label: 'profile.menu_add_product'.tr(),
                  onTap: () => context.push('/add-product'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.chartBar,
                  label: 'profile.menu_sales_analytics'.tr(),
                  onTap: () => context.push('/sales-analytics'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.heart,
                  label: 'profile.menu_product_engagement'.tr(),
                  onTap: () => context.push('/product-engagement'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.calendarClock,
                  label: 'booking.incoming_title'.tr(),
                  onTap: () => context.push('/bookings'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.wallet,
                  label: 'profile.menu_wallet'.tr(),
                  onTap: () => context.push('/wallet'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.creditCard,
                  label: 'profile.menu_short_payment'.tr(),
                  onTap: () => context.push('/payment-methods'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.truck,
                  label: 'marketplace.action_shipping_origin'.tr(),
                  onTap: () => context.push('/supplier-shipping-origin'),
                ),
              ],
            ),
          _MenuSection(
            title: 'profile.all_menu_section_community'.tr(),
            items: [
              _MenuGridItem(
                icon: LucideIcons.users,
                label: 'profile.menu_forum'.tr(),
                onTap: () {
                  MainShellScope.maybeOf(context)?.selectTab(2);
                  context.pop();
                },
              ),
              if (isAuthenticated)
                _MenuGridItem(
                  icon: LucideIcons.fileText,
                  label: 'profile.menu_my_posts'.tr(),
                  onTap: () => context.push('/my-forum-posts'),
                ),
              if (isAuthenticated && isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.messageSquare,
                  label: 'profile.menu_negotiations'.tr(),
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(1);
                    context.pop();
                  },
                ),
              if (isAuthenticated)
                _MenuGridItem(
                  icon: LucideIcons.shoppingBag,
                  label: 'profile.menu_orders'.tr(),
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  },
                ),
            ],
          ),
          _MenuSection(
            title: 'profile.section_market_insight'.tr(),
            items: [
              _MenuGridItem(
                icon: LucideIcons.trendingUp,
                label: 'profile.menu_market_ai'.tr(),
                onTap: () => context.push('/market-insight'),
              ),
              if (isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.cpu,
                  label: 'profile.menu_iot_monitoring'.tr(),
                  onTap: () => context.push('/iot-dashboard'),
                ),
              _MenuGridItem(
                icon: LucideIcons.map,
                label: 'profile.menu_short_waste_map'.tr(),
                onTap: () => context.push('/waste-mapping'),
              ),
              if (isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.sparkles,
                  label: 'profile.menu_bisa_pro'.tr(),
                  onTap: () => context.push('/iot-subscription'),
                ),
            ],
          ),
          _MenuSection(
            title: 'profile.all_menu_section_help_legal'.tr(),
            items: [
              _MenuGridItem(
                icon: LucideIcons.handHelping,
                label: 'profile.menu_help_center'.tr(),
                onTap: () => context.push('/help-center'),
              ),
              _MenuGridItem(
                icon: LucideIcons.fileText,
                label: 'profile.menu_terms'.tr(),
                onTap: () => context.push('/terms'),
              ),
              _MenuGridItem(
                icon: LucideIcons.shieldAlert,
                label: 'profile.menu_short_privacy'.tr(),
                onTap: () => context.push('/privacy'),
              ),
              _MenuGridItem(
                icon: LucideIcons.settings,
                label: 'profile.settings_title'.tr(),
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_MenuGridItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: 6.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm10,
              vertical: AppSpacing.sm10,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Wrap(
              spacing: 4.w,
              runSpacing: 8.h,
              children: items,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuGridItem extends StatelessWidget {
  const _MenuGridItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76.w,
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20.sp, color: AppColors.primary),
                SizedBox(height: 4.h),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
