import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/supplier_3d_widgets.dart';

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
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: [
          _MenuGrid(
            items: [
              _MenuGridItem(
                icon: LucideIcons.sparkles,
                label: 'profile.menu_important_features'.tr(),
                color: AppColors.primary,
                onTap: () => context.push('/important-features'),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (isAuthenticated) ...[
            _sectionTitle('profile.all_menu_section_account'.tr()),
            _MenuGrid(
              items: [
                _MenuGridItem(
                  icon: LucideIcons.user,
                  label: 'profile.menu_edit_profile'.tr(),
                  color: AppColors.primary,
                  onTap: () => context.push('/edit-profile', extra: user),
                ),
                _MenuGridItem(
                  icon: LucideIcons.shieldCheck,
                  label: 'profile.menu_verification'.tr(),
                  color: AppColors.success,
                  onTap: () => context.push('/verification'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.mapPin,
                  label: 'profile.menu_short_addresses'.tr(),
                  color: AppColors.info,
                  onTap: () => context.push('/addresses'),
                ),
                if (!isSupplier)
                  _MenuGridItem(
                    icon: LucideIcons.creditCard,
                    label: 'profile.menu_short_payment'.tr(),
                    color: AppColors.warning,
                    onTap: () => context.push('/payment-methods'),
                  ),
                _MenuGridItem(
                  icon: LucideIcons.lock,
                  label: 'profile.menu_short_password'.tr(),
                  color: AppColors.warning,
                  onTap: () => context.push('/change-password'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.users,
                  label: 'profile.menu_connections'.tr(),
                  color: AppColors.primary,
                  onTap: () => context.push('/follows'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.handshake,
                  label: 'partnership.menu_title'.tr(),
                  color: AppColors.success,
                  onTap: () => context.push('/partnerships'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.bell,
                  label: 'profile.menu_notifications'.tr(),
                  color: AppColors.error,
                  onTap: () => context.push('/notifications'),
                ),
              ],
            ),
          ],
          if (isAuthenticated && !isSupplier) ...[
            SizedBox(height: 14.h),
            _sectionTitle('profile.all_menu_section_shopping'.tr()),
            _MenuGrid(
              items: [
                _MenuGridItem(
                  icon: LucideIcons.package,
                  label: 'profile.menu_my_products'.tr(),
                  color: AppColors.primary,
                  onTap: () => context.push('/buyer-products'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.heart,
                  label: 'profile.menu_short_wishlist'.tr(),
                  color: AppColors.error,
                  onTap: () => context.push('/wishlist'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.shoppingCart,
                  label: 'profile.menu_cart'.tr(),
                  color: AppColors.success,
                  onTap: () => context.push('/cart'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.messageSquare,
                  label: 'profile.menu_negotiations'.tr(),
                  color: AppColors.info,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(1);
                    context.pop();
                  },
                ),
                _MenuGridItem(
                  icon: LucideIcons.shoppingBag,
                  label: 'profile.menu_orders'.tr(),
                  color: AppColors.secondary,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  },
                ),
                _MenuGridItem(
                  icon: LucideIcons.calendarClock,
                  label: 'booking.menu_title'.tr(),
                  color: AppColors.warning,
                  onTap: () => context.push('/bookings'),
                ),
              ],
            ),
          ],
          if (isAuthenticated && isSupplier) ...[
            SizedBox(height: 14.h),
            _sectionTitle('profile.section_business'.tr()),
            _MenuGrid(
              items: [
                _MenuGridItem(
                  icon: LucideIcons.store,
                  label: 'profile.menu_store_management'.tr(),
                  color: AppColors.primary,
                  onTap: () => context.push('/store-management'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.package,
                  label: 'profile.menu_manage_products'.tr(),
                  color: AppColors.success,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(0);
                    context.pop();
                  },
                ),
                _MenuGridItem(
                  icon: LucideIcons.plus,
                  label: 'profile.menu_add_product'.tr(),
                  color: AppColors.info,
                  onTap: () => context.push('/add-product'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.chartBar,
                  label: 'profile.menu_sales_analytics'.tr(),
                  color: AppColors.warning,
                  onTap: () => context.push('/sales-analytics'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.heart,
                  label: 'profile.menu_product_engagement'.tr(),
                  color: AppColors.error,
                  onTap: () => context.push('/product-engagement'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.calendarClock,
                  label: 'booking.incoming_title'.tr(),
                  color: AppColors.info,
                  onTap: () => context.push('/bookings'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.wallet,
                  label: 'profile.menu_wallet'.tr(),
                  color: AppColors.secondary,
                  onTap: () => context.push('/wallet'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.creditCard,
                  label: 'profile.menu_short_payment'.tr(),
                  color: AppColors.textSecondary,
                  onTap: () => context.push('/payment-methods'),
                ),
              ],
            ),
          ],
          SizedBox(height: 14.h),
          _sectionTitle('profile.all_menu_section_community'.tr()),
          _MenuGrid(
            items: [
              _MenuGridItem(
                icon: LucideIcons.users,
                label: 'profile.menu_forum'.tr(),
                color: AppColors.primary,
                onTap: () {
                  MainShellScope.maybeOf(context)?.selectTab(2);
                  context.pop();
                },
              ),
              if (isAuthenticated)
                _MenuGridItem(
                  icon: LucideIcons.fileText,
                  label: 'profile.menu_my_posts'.tr(),
                  color: AppColors.warning,
                  onTap: () => context.push('/my-forum-posts'),
                ),
              if (isAuthenticated && isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.messageSquare,
                  label: 'profile.menu_negotiations'.tr(),
                  color: AppColors.info,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(1);
                    context.pop();
                  },
                ),
              if (isAuthenticated)
                _MenuGridItem(
                  icon: LucideIcons.shoppingBag,
                  label: 'profile.menu_orders'.tr(),
                  color: AppColors.success,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  },
                ),
            ],
          ),
          SizedBox(height: 14.h),
          _sectionTitle('profile.section_market_insight'.tr()),
          _MenuGrid(
            items: [
              _MenuGridItem(
                icon: LucideIcons.trendingUp,
                label: 'profile.menu_market_ai'.tr(),
                color: AppColors.primary,
                onTap: () => context.push('/market-insight'),
              ),
              if (isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.cpu,
                  label: 'profile.menu_iot_monitoring'.tr(),
                  color: AppColors.info,
                  onTap: () => context.push('/iot-dashboard'),
                ),
              _MenuGridItem(
                icon: LucideIcons.map,
                label: 'profile.menu_short_waste_map'.tr(),
                color: AppColors.success,
                onTap: () => context.push('/waste-mapping'),
              ),
              if (isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.sparkles,
                  label: 'profile.menu_bisa_pro'.tr(),
                  color: AppColors.warning,
                  onTap: () => context.push('/iot-subscription'),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          _sectionTitle('profile.all_menu_section_help_legal'.tr()),
          _MenuGrid(
            items: [
              _MenuGridItem(
                icon: LucideIcons.handHelping,
                label: 'profile.menu_help_center'.tr(),
                color: AppColors.info,
                onTap: () => context.push('/help-center'),
              ),
              _MenuGridItem(
                icon: LucideIcons.fileText,
                label: 'profile.menu_terms'.tr(),
                color: AppColors.textSecondary,
                onTap: () => context.push('/terms'),
              ),
              _MenuGridItem(
                icon: LucideIcons.shieldAlert,
                label: 'profile.menu_short_privacy'.tr(),
                color: AppColors.textSecondary,
                onTap: () => context.push('/privacy'),
              ),
              _MenuGridItem(
                icon: LucideIcons.settings,
                label: 'profile.settings_title'.tr(),
                color: AppColors.primary,
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h, left: 2.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _MenuGrid extends StatelessWidget {
  const _MenuGrid({required this.items});

  final List<_MenuGridItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}

class _MenuGridItem extends StatelessWidget {
  const _MenuGridItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Supplier3DGridChip(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
    );
  }
}
