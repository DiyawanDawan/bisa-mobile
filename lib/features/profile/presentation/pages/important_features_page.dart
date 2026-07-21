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
import '../../../../shared/widgets/pro_tier_matrix.dart';

/// Pusat akses fitur penting §28–§32 (bayar, lacak, supplier tools, sosial).
class ImportantFeaturesPage extends StatelessWidget {
  const ImportantFeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    final isSupplier = user?.role == 'SUPPLIER';
    final loggedIn = user != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        title: 'profile.menu_important_features'.tr(),
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md12,
          AppSpacing.md,
          AppSpacing.xl28,
        ),
        children: [
          _introCard(),
          SizedBox(height: AppSpacing.md),
          _sectionTitle('pro.matrix_section_title'.tr()),
          const ProTierMatrix(),
          SizedBox(height: AppSpacing.sm),
          _tile(
            icon: LucideIcons.sparkles,
            title: 'profile.features_bisa_pro_iot_title'.tr(),
            subtitle: 'pro.matrix_upgrade_hint'.tr(),
            onTap: () => context.push(
              loggedIn ? '/iot-subscription' : '/login',
            ),
          ),
          SizedBox(height: AppSpacing.section),
          _sectionTitle('profile.features_section_payment'.tr()),
          _tile(
            icon: LucideIcons.creditCard,
            title: 'profile.features_pending_payment_title'.tr(),
            subtitle: 'profile.features_pending_payment_subtitle'.tr(),
            onTap: loggedIn
                ? () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  }
                : () => context.push('/login'),
          ),
          SizedBox(height: AppSpacing.section),
          _sectionTitle('profile.features_section_tracking'.tr()),
          _tile(
            icon: LucideIcons.mapPin,
            title: 'profile.features_track_order_title'.tr(),
            subtitle: 'profile.features_track_order_subtitle'.tr(),
            onTap: loggedIn
                ? () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  }
                : () => context.push('/login'),
          ),
          _tile(
            icon: LucideIcons.scanLine,
            title: 'profile.features_verify_contract_title'.tr(),
            subtitle: 'profile.features_verify_contract_subtitle'.tr(),
            onTap: () => context.push('/verify'),
          ),
          _tile(
            icon: LucideIcons.truck,
            title: 'profile.features_public_track_title'.tr(),
            subtitle: 'profile.features_public_track_subtitle'.tr(),
            onTap: () => context.push('/track'),
          ),
          if (loggedIn)
            _tile(
              icon: LucideIcons.bell,
              title: 'profile.menu_notifications'.tr(),
              subtitle: 'profile.features_notifications_subtitle'.tr(),
              onTap: () => context.push('/notifications'),
            ),
          SizedBox(height: AppSpacing.section),
          if (isSupplier) ...[
            _sectionTitle('profile.features_section_supplier'.tr()),
            _tile(
              icon: LucideIcons.store,
              title: 'profile.features_store_banner_title'.tr(),
              subtitle: 'profile.features_store_banner_subtitle'.tr(),
              onTap: () => context.push('/store-management'),
            ),
            _tile(
              icon: LucideIcons.heart,
              title: 'profile.menu_product_engagement'.tr(),
              subtitle: 'profile.features_engagement_subtitle'.tr(),
              onTap: () => context.push('/product-engagement'),
            ),
            _tile(
              icon: LucideIcons.chartBar,
              title: 'profile.features_sales_analytics_title'.tr(),
              subtitle: 'profile.features_sales_analytics_subtitle'.tr(),
              onTap: () => context.push('/sales-analytics'),
            ),
            _tile(
              icon: LucideIcons.cpu,
              title: 'profile.features_bisa_pro_iot_title'.tr(),
              subtitle: 'profile.features_bisa_pro_iot_subtitle'.tr(),
              onTap: () => context.push('/iot-subscription'),
            ),
            _tile(
              icon: LucideIcons.plug,
              title: 'erp.title'.tr(),
              subtitle: 'erp.menu_subtitle'.tr(),
              onTap: () => context.push('/erp-integration'),
            ),
            SizedBox(height: AppSpacing.section),
          ],
          _sectionTitle('profile.features_section_catalog'.tr()),
          if (loggedIn && !isSupplier)
            _tile(
              icon: LucideIcons.fileText,
              title: 'rfq.menu_title'.tr(),
              subtitle: 'rfq.menu_subtitle'.tr(),
              onTap: () => context.push('/rfq'),
            ),
          if (isSupplier)
            _tile(
              icon: LucideIcons.inbox,
              title: 'rfq.inbox_title'.tr(),
              subtitle: 'rfq.menu_inbox_subtitle'.tr(),
              onTap: () => context.push('/rfq/inbox'),
            ),
          if (!isSupplier)
            _tile(
              icon: LucideIcons.building2,
              title: 'marketplace.supplier_directory'.tr(),
              subtitle: 'marketplace.supplier_directory_hint'.tr(),
              onTap: () => context.push('/supplier-directory'),
            ),
          _tile(
            icon: LucideIcons.layoutGrid,
            title: 'profile.features_browse_catalog_title'.tr(),
            subtitle: 'profile.features_browse_catalog_subtitle'.tr(),
            onTap: () {
              MainShellScope.maybeOf(context)?.selectTab(0);
              context.pop();
            },
          ),
          if (loggedIn)
            _tile(
              icon: LucideIcons.map,
              title: 'profile.features_address_map_title'.tr(),
              subtitle: 'profile.features_address_map_subtitle'.tr(),
              onTap: () => context.push('/addresses'),
            ),
          SizedBox(height: AppSpacing.section),
          _sectionTitle('profile.features_section_growth'.tr()),
          if (loggedIn)
            _tile(
              icon: LucideIcons.gift,
              title: 'referral.title'.tr(),
              subtitle: 'referral.menu_subtitle'.tr(),
              onTap: () => context.push('/referral'),
            ),
          _tile(
            icon: LucideIcons.radio,
            title: 'live.title'.tr(),
            subtitle: 'live.menu_subtitle'.tr(),
            onTap: () => context.push('/live'),
          ),
          SizedBox(height: AppSpacing.section),
          _sectionTitle('profile.features_section_social'.tr()),
          if (loggedIn && !isSupplier) ...[
            _tile(
              icon: LucideIcons.heart,
              title: 'profile.features_wishlist_title'.tr(),
              onTap: () => context.push('/wishlist'),
            ),
            _tile(
              icon: LucideIcons.users,
              title: 'profile.features_follow_title'.tr(),
              onTap: () => context.push('/follows'),
            ),
          ],
          if (loggedIn)
            _tile(
              icon: LucideIcons.lock,
              title: 'profile.features_change_password_title'.tr(),
              onTap: () => context.push('/change-password'),
            ),
          _tile(
            icon: LucideIcons.settings,
            title: 'profile.features_notification_settings_title'.tr(),
            subtitle: 'profile.features_notification_settings_subtitle'.tr(),
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }

  Widget _introCard() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        'profile.features_intro'.tr(),
        style: TextStyle(
          color: AppColors.surface,
          fontSize: 13.sp,
          height: 1.45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.grey100),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(AppRadius.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.sp),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
              )
            : null,
        trailing: Icon(LucideIcons.chevronRight, size: 18.sp, color: AppColors.grey300),
      ),
    );
  }
}
