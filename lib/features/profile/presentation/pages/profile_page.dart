import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/features/auth/domain/entities/user_entity.dart';
import 'package:mobile_bisa/features/follow/presentation/widgets/follow_button.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/vertical_product_grid_section.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import 'package:mobile_bisa/features/marketplace/presentation/widgets/store_banner_section.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/store_banner_cubit.dart';
import 'package:mobile_bisa/shared/widgets/auth_sheet.dart';
import 'package:mobile_bisa/shared/widgets/custom_button.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/i18n/failure_messages.dart';
import '../../../../core/i18n/locale_formatters.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/notification_bell_button.dart';
import '../../../../shared/widgets/app_version_label.dart';
import '../../../../shared/widgets/bisa_logo.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../../../shared/widgets/language_picker_sheet.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../bloc/profile_cubit.dart';
import '../../../../injection_container.dart';
class ProfilePage extends StatelessWidget {
  final String activeProductMode;

  const ProfilePage({
    super.key,
    required this.activeProductMode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..getProfile(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              state.maybeWhen(
                authenticated: (user) {
                  context.read<ProfileCubit>().applyProfile(user);
                },
                orElse: () {},
              );
            },
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              state.maybeWhen(
                success: (message) {
                  showSuccessSnackBar(context, message);
                  context.read<ProfileCubit>().getProfile();
                },
                orElse: () {},
              );
            },
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final currentUser = authState.maybeWhen(
              authenticated: (user) => user,
              orElse: () => null,
            );
            final isAuthenticated = currentUser != null;

            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: BisaAppBar(
                backgroundColor: AppColors.surface,
                showBackButton: false,
                centerTitle: false,
                title: 'profile.title'.tr(),
                actions: const [NotificationBellButton()],
              ),
              body: isAuthenticated
                  ? BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          loading: () => _buildProfileLoadingSkeleton(),
                          error: (message) => Center(child: Text(message.localizedFailure)),
                          loaded: (user) => SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                              bottom: mainShellBottomPadding(context),
                            ),
                            child: Column(
                              children: [
                                _buildProfileHeader(user),
                                if (user.role == 'SUPPLIER') ...[
                                  SizedBox(height: AppSpacing.sm),
                                  BlocProvider(
                                    create: (_) =>
                                        sl<StoreBannerCubit>()..loadMyBanners(),
                                    child: const StoreBannerSection(
                                      compact: true,
                                    ),
                                  ),
                                ],
                                // Pro subscription card hanya untuk Supplier.
                                // Fitur Pro (IoT, Analitik Mendalam) ditujukan
                                // untuk skema bisnis penjual, bukan pembeli.
                                if (user.role == 'SUPPLIER') ...[
                                  SizedBox(height: AppSpacing.md12),
                                  _buildProSubscriptionCard(context, user),
                                ],
                                SizedBox(height: AppSpacing.md12),
                                _buildMenuSection(
                                  context,
                                  user.role == 'SUPPLIER',
                                  isAuthenticated,
                                  user: user,
                                ),
                                if (user.role == 'BUYER') ...[
                                  SizedBox(height: AppSpacing.md),
                                  const Divider(height: 1),
                                  SizedBox(height: AppSpacing.md),
                                  VerticalProductGridSection(
                                    title: activeProductMode == 'ORGANIC_PRODUCE'
                                        ? 'profile.farm_for_you'.tr()
                                        : 'profile.products_for_you'.tr(),
                                    sortBy: 'createdAt',
                                    sortOrder: 'desc',
                                    productMode: activeProductMode,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          orElse: () => const SizedBox.shrink(),
                        );
                      },
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: mainShellBottomPadding(context),
                      ),
                      child: Column(
                        children: [
                          _buildGuestHeader(context),
                          SizedBox(height: AppSpacing.md12),
                          _buildMenuSection(context, false, isAuthenticated),
                          SizedBox(height: AppSpacing.md),
                          const Divider(height: 1),
                          SizedBox(height: AppSpacing.md),
                          VerticalProductGridSection(
                            title: activeProductMode == 'ORGANIC_PRODUCE'
                                ? 'profile.explore_farm'.tr()
                                : 'profile.explore_biomass'.tr(),
                            sortBy: 'createdAt',
                            sortOrder: 'desc',
                            productMode: activeProductMode,
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGuestHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md12, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.xlPx.r),
          bottomRight: Radius.circular(AppSpacing.xlPx.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const BisaLogoBadge(size: 88, showShadow: false),
          SizedBox(height: AppSpacing.md),
          Text(
            'profile.guest_welcome'.tr(),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'profile.guest_subtitle'.tr(),
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: 160.w,
            child: CustomButton(
              text: 'profile.guest_login_cta'.tr(),
              size: BisaButtonSize.md,
              fullWidth: true,
              onPressed: () => AuthSheet.show(context),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pro subscription helpers ──────────────────────────────────
  bool _isProActive(UserEntity user) {
    if (user.tier != 'PRO') return false;
    if (user.subscriptionExpiresAt == null) return false;
    return user.subscriptionExpiresAt!.isAfter(DateTime.now());
  }

  bool _isProExpired(UserEntity user) {
    if (user.tier != 'PRO') return false;
    if (user.subscriptionExpiresAt == null) return true;
    return user.subscriptionExpiresAt!.isBefore(DateTime.now());
  }

  Widget _buildProSubscriptionCard(BuildContext context, UserEntity user) {
    final isActive = _isProActive(user);
    final isExpired = _isProExpired(user);
    final isFree = user.tier == 'FREE' || user.tier == 'user';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: () => context.push('/iot-subscription'),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [AppColors.primary, AppColors.primary]
                  : isExpired
                  ? [AppColors.error, AppColors.warning]
                  : [AppColors.primary, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: [
              BoxShadow(
                color:
                    (isActive
                            ? AppColors.primary
                            : isExpired
                            ? AppColors.warning
                            : AppColors.error)
                        .withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm10),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isActive
                      ? LucideIcons.crown
                      : isExpired
                      ? LucideIcons.clockAlert
                      : LucideIcons.sparkles,
                  color: AppColors.surface,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: AppSpacing.section),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isActive
                              ? 'profile.pro_active'.tr()
                              : isExpired
                              ? 'profile.pro_expired'.tr()
                              : 'profile.pro_upgrade'.tr(),
                          style: TextStyle(
                            color: AppColors.surface,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        if (isActive)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'PRO',
                              style: TextStyle(
                                color: AppColors.surface,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      isActive && user.subscriptionExpiresAt != null
                          ? 'profile.pro_active_until'.tr(namedArgs: {
                              'date': context.formatDate(user.subscriptionExpiresAt!),
                            })
                          : isExpired && user.subscriptionExpiresAt != null
                          ? 'profile.pro_expired_on'.tr(namedArgs: {
                              'date': context.formatDate(user.subscriptionExpiresAt!),
                            })
                          : isExpired
                          ? 'profile.pro_sub_expired'.tr()
                          : 'profile.pro_sub_benefits'.tr(),
                      style: TextStyle(
                        color: AppColors.textOnPrimary.withOpacity(0.85),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  isActive
                      ? 'profile.pro_extend'.tr()
                      : isExpired
                      ? 'profile.pro_extend'.tr()
                      : 'profile.pro_start'.tr(),
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileLoadingSkeleton() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md12, AppSpacing.lg, AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSpacing.xlPx.r),
                  bottomRight: Radius.circular(AppSpacing.xlPx.r),
                ),
              ),
              child: Column(
                children: [
                  Bone.circle(size: 88.r),
                  SizedBox(height: AppSpacing.md),
                  Bone(width: 180.w, height: 22.h),
                  SizedBox(height: AppSpacing.sm),
                  Bone(width: 120.w, height: 14.h),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            const ShimmerListPlaceholder(itemCount: 5, itemHeight: 72),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserEntity user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md12, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.xlPx.r),
          bottomRight: Radius.circular(AppSpacing.xlPx.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 44.r,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: resolveMediaImageProvider(user.avatar),
                  child: user.avatar == null
                      ? Icon(
                          LucideIcons.user,
                          size: 36.sp,
                          color: AppColors.primary,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 2.h,
                right: 2.w,
                child: Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: Icon(
                    LucideIcons.camera,
                    color: AppColors.surface,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md12),
          Text(
            user.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSpacing.md12),
          FollowStatsRow(userId: user.id),
          SizedBox(height: AppSpacing.md12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.section, vertical: AppSpacing.xs6),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.grey100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  user.role == 'SUPPLIER'
                      ? LucideIcons.store
                      : LucideIcons.shoppingBag,
                  size: 13.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  user.role == 'SUPPLIER'
                      ? 'profile.role_supplier'.tr()
                      : 'profile.role_buyer'.tr(),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    bool isSupplier,
    bool isAuthenticated, {
    UserEntity? user,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _menuCard([
            _menuItem(
              LucideIcons.sparkles,
              'profile.menu_important_features'.tr(),
              () => context.push('/important-features'),
            ),
            _menuItem(
              LucideIcons.layoutGrid,
              'profile.menu_all_menu'.tr(),
              () => context.push('/profile/all-menu'),
            ),
          ]),
          SizedBox(height: AppSpacing.md12),
          _sectionTitle('profile.section_account'.tr()),
          SizedBox(height: AppSpacing.sm),
          _menuCard([
            if (isAuthenticated) ...[
              _menuItem(
                LucideIcons.user,
                'profile.menu_edit_profile'.tr(),
                () => context.push('/edit-profile', extra: user),
              ),
              _menuItem(
                LucideIcons.shieldCheck,
                'verification.title'.tr(),
                () => context.push('/verification'),
                trailing: _kycStatusBadge(user),
              ),
              _menuItem(
                LucideIcons.mapPin,
                'profile.menu_addresses'.tr(),
                () => context.push('/addresses'),
              ),
              _menuItem(
                LucideIcons.creditCard,
                'profile.menu_payment_methods'.tr(),
                () => context.push('/payment-methods'),
              ),
              _menuItem(
                LucideIcons.lock,
                'profile.menu_change_password'.tr(),
                () => context.push('/change-password'),
              ),
            ],
            _menuItem(
              LucideIcons.languages,
              'settings.change_language'.tr(),
              () => showLanguagePickerSheet(context),
            ),
          ]),
          if (isAuthenticated && !isSupplier) ...[
            SizedBox(height: AppSpacing.md12),
            _sectionTitle('profile.section_my_products'.tr()),
            SizedBox(height: AppSpacing.sm),
            _menuCard([
              _menuItem(
                LucideIcons.package,
                'profile.menu_my_products'.tr(),
                () => context.push('/buyer-products'),
              ),
              _menuItem(
                LucideIcons.heart,
                'profile.menu_wishlist'.tr(),
                () => context.push('/wishlist'),
              ),
            ]),
          ],
          if (isAuthenticated && isSupplier) ...[
            SizedBox(height: AppSpacing.md12),
            _sectionTitle('profile.section_business'.tr()),
            SizedBox(height: AppSpacing.sm),
            _menuCard([
              _menuItem(
                LucideIcons.store,
                'profile.menu_store_management'.tr(),
                () => context.push('/store-management'),
              ),
              _menuItem(
                LucideIcons.chartBar,
                'profile.menu_sales_analytics'.tr(),
                () => context.push('/sales-analytics'),
                trailing: _proBadge(),
              ),
              _menuItem(
                LucideIcons.heart,
                'profile.menu_product_engagement'.tr(),
                () => context.push('/product-engagement'),
              ),
              _menuItem(
                LucideIcons.wallet,
                'profile.menu_wallet'.tr(),
                () => context.push('/wallet'),
              ),
            ]),
          ],
          SizedBox(height: AppSpacing.md12),
          _sectionTitle('profile.section_market_insight'.tr()),
          SizedBox(height: AppSpacing.sm),
          _menuCard([
            _menuItem(
              LucideIcons.trendingUp,
              'profile.menu_market_intelligence'.tr(),
              () => context.push('/market-insight'),
            ),
            // Analitik Mendalam = fitur Pro, khusus Supplier.
            if (isSupplier)
              _menuItem(
                LucideIcons.sparkles,
                'profile.menu_deep_analytics'.tr(),
                () => context.push('/market-deep-analytics'),
                trailing: _proBadge(),
              ),
            if (isAuthenticated && isSupplier)
              _menuItem(
                LucideIcons.cpu,
                'profile.menu_iot_monitoring'.tr(),
                () => context.push('/iot-dashboard'),
              ),
            _menuItem(
              LucideIcons.map,
              'profile.menu_waste_map'.tr(),
              () => context.push('/waste-mapping'),
            ),
          ]),
          SizedBox(height: AppSpacing.md12),
          _sectionTitle('profile.section_other'.tr()),
          SizedBox(height: AppSpacing.sm),
          _menuCard([
            if (isSupplier)
              _menuItem(
                LucideIcons.creditCard,
                'profile.menu_payment_methods'.tr(),
                () => context.push('/payment-methods'),
              ),
            _menuItem(
              LucideIcons.bell,
              'profile.menu_notifications'.tr(),
              () => context.push('/notifications'),
            ),
            _menuItem(
              LucideIcons.handHelping,
              'profile.menu_help_center'.tr(),
              () => context.push('/help-center'),
            ),
            _menuItem(
              LucideIcons.fileText,
              'profile.menu_terms'.tr(),
              () => context.push('/terms'),
            ),
            _menuItem(
              LucideIcons.shieldAlert,
              'profile.menu_privacy'.tr(),
              () => context.push('/privacy'),
            ),
            if (isAuthenticated)
              _menuItem(
                LucideIcons.logOut,
                'profile.menu_logout'.tr(),
                () => _showLogoutDialog(context),
                textColor: AppColors.error,
                showChevron: false,
              ),
          ]),
          SizedBox(height: AppSpacing.lg),
          const Center(child: AppVersionLabel()),
          SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _menuCard(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.grey100.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget item = entry.value;
          return Column(
            children: [
              item,
              if (idx < items.length - 1)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Divider(
                    height: 1,
                    color: AppColors.grey100.withOpacity(0.5),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget? _kycStatusBadge(UserEntity? user) {
    if (user == null) return null;

    final String labelKey;
    final Color color;

    if (user.isKycApproved) {
      labelKey = 'verification.kyc_badge_verified';
      color = AppColors.success;
    } else if (user.isKycPending) {
      labelKey = 'verification.kyc_badge_pending';
      color = AppColors.warning;
    } else if (user.isKycRejected) {
      labelKey = 'verification.kyc_badge_rejected';
      color = AppColors.error;
    } else {
      return null;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        labelKey.tr(),
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _proBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        'PRO',
        style: TextStyle(
          color: AppColors.surface,
          fontSize: 9.sp,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? textColor,
    bool showChevron = true,
    Widget? trailing,
    bool isLocked = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 0),
      visualDensity: VisualDensity.compact,
      leading: Container(
        padding: EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color:
              (isLocked ? AppColors.grey400 : (textColor ?? AppColors.primary))
                  .withOpacity(0.06),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(
          icon,
          color: isLocked
              ? AppColors.grey400
              : (textColor ?? AppColors.textPrimary),
          size: 18.sp,
        ),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14.sp,
          color: isLocked
              ? AppColors.grey400
              : (textColor ?? AppColors.textPrimary),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing:
          trailing ??
          (isLocked
              ? Icon(LucideIcons.lock, size: 14.sp, color: AppColors.grey300)
              : (showChevron
                    ? Icon(
                        LucideIcons.chevronRight,
                        size: 16.sp,
                        color: AppColors.grey300,
                      )
                    : null)),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        title: Text(
          'keluar'.tr(),
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18.sp),
        ),
        content: Text(
          'apakah_anda_yakin_ingin_keluar_1'.tr(),
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'batal'.tr(),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            child: Text(
              'keluar'.tr(),
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
