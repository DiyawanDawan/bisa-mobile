import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
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
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/safe_area_utils.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/notification_bell_button.dart';
import '../../../../shared/widgets/app_version_label.dart';
import '../../../../shared/widgets/bisa_logo.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
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
                authenticated: (_) {
                  context.read<ProfileCubit>().getProfile();
                },
                orElse: () {},
              );
            },
          ),
          BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              state.maybeWhen(
                success: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message.tr()),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
                backgroundColor: AppColors.white,
                showBackButton: false,
                centerTitle: false,
                title: 'Profil Saya',
                actions: const [NotificationBellButton()],
              ),
              body: isAuthenticated
                  ? BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return state.maybeWhen(
                          loading: () => _buildProfileLoadingSkeleton(),
                          error: (message) => Center(child: Text(message)),
                          loaded: (user) => SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.only(
                              bottom: mainShellBottomPadding(context),
                            ),
                            child: Column(
                              children: [
                                _buildProfileHeader(user),
                                if (user.role == 'SUPPLIER') ...[
                                  SizedBox(height: 8.h),
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
                                  SizedBox(height: 12.h),
                                  _buildProSubscriptionCard(context, user),
                                ],
                                SizedBox(height: 12.h),
                                _buildMenuSection(
                                  context,
                                  user.role == 'SUPPLIER',
                                  isAuthenticated,
                                  user: user,
                                ),
                                if (user.role == 'BUYER') ...[
                                  SizedBox(height: 16.h),
                                  const Divider(height: 1),
                                  SizedBox(height: 16.h),
                                  VerticalProductGridSection(
                                    title: activeProductMode == 'ORGANIC_PRODUCE'
                                        ? 'Hasil Tani Untuk Anda'
                                        : 'Produk Untuk Anda',
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
                          SizedBox(height: 12.h),
                          _buildMenuSection(context, false, isAuthenticated),
                          SizedBox(height: 16.h),
                          const Divider(height: 1),
                          SizedBox(height: 16.h),
                          VerticalProductGridSection(
                            title: activeProductMode == 'ORGANIC_PRODUCE'
                                ? 'Eksplor Hasil Tani'
                                : 'Eksplor Biomassa',
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
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const BisaLogoBadge(size: 88, showShadow: false),
          SizedBox(height: 16.h),
          Text(
            'Selamat Datang!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Masuk untuk akses fitur lengkap BISA',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: 160.w,
            child: CustomButton(
              text: 'Masuk / Daftar',
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
            borderRadius: BorderRadius.circular(20.r),
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
          padding: EdgeInsets.all(20.r),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isActive
                      ? LucideIcons.crown
                      : isExpired
                      ? LucideIcons.clockAlert
                      : LucideIcons.sparkles,
                  color: AppColors.white,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          isActive
                              ? 'BISA Pro Aktif'
                              : isExpired
                              ? 'BISA Pro Berakhir'
                              : 'Upgrade ke BISA Pro',
                          style: TextStyle(
                            color: AppColors.white,
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
                                color: AppColors.white,
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
                          ? 'Aktif hingga ${DateFormat('d MMMM yyyy').format(user.subscriptionExpiresAt!)} · Ketuk untuk perpanjang'
                          : isExpired && user.subscriptionExpiresAt != null
                          ? 'Berakhir pada ${DateFormat('d MMMM yyyy').format(user.subscriptionExpiresAt!)}'
                          : isExpired
                          ? 'Status Berlangganan Berakhir'
                          : 'Akses fitur premium: IoT & Asisten AI',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.85),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  isActive
                      ? 'Perpanjang'
                      : isExpired
                      ? 'Perpanjang'
                      : 'Mulai',
                  style: TextStyle(
                    color: AppColors.white,
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
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                children: [
                  Bone.circle(size: 88.r),
                  SizedBox(height: 16.h),
                  Bone(width: 180.w, height: 22.h),
                  SizedBox(height: 8.h),
                  Bone(width: 120.w, height: 14.h),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            const ShimmerListPlaceholder(itemCount: 5, itemHeight: 72),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserEntity user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
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
                    color: AppColors.white,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
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
          SizedBox(height: 12.h),
          FollowStatsRow(userId: user.id),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12.r),
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
                  user.role == 'SUPPLIER' ? 'SUPPLIER AKUN' : 'PEMBELI AKUN',
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _menuCard([
            _menuItem(
              LucideIcons.sparkles,
              'Fitur Penting',
              () => context.push('/important-features'),
            ),
            _menuItem(
              LucideIcons.layoutGrid,
              'Semua Menu',
              () => context.push('/profile/all-menu'),
            ),
          ]),
          SizedBox(height: 12.h),
          _sectionTitle('Akun Saya'),
          SizedBox(height: 8.h),
          _menuCard([
            if (isAuthenticated) ...[
              _menuItem(
                LucideIcons.user,
                'Ubah Profil',
                () => context.push('/edit-profile', extra: user),
              ),
              _menuItem(
                LucideIcons.shieldCheck,
                'Verifikasi Akun',
                () => context.push('/verification'),
              ),
              _menuItem(
                LucideIcons.mapPin,
                'Alamat Pengiriman',
                () => context.push('/addresses'),
              ),
              _menuItem(
                LucideIcons.creditCard,
                'Metode Pembayaran',
                () => context.push('/payment-methods'),
              ),
              _menuItem(
                LucideIcons.lock,
                'Ubah Kata Sandi',
                () => context.push('/change-password'),
              ),
            ],
            _menuItem(
              LucideIcons.languages,
              'Ganti Bahasa',
              () => _showLanguageBottomSheet(context),
            ),
          ]),
          if (isAuthenticated && !isSupplier) ...[
            SizedBox(height: 12.h),
            _sectionTitle('Produk Saya'),
            SizedBox(height: 8.h),
            _menuCard([
              _menuItem(
                LucideIcons.package,
                'Produk Saya',
                () => context.push('/buyer-products'),
              ),
              _menuItem(
                LucideIcons.heart,
                'Favorit Saya',
                () => context.push('/wishlist'),
              ),
            ]),
          ],
          if (isAuthenticated && isSupplier) ...[
            SizedBox(height: 12.h),
            _sectionTitle('Manajemen Bisnis'),
            SizedBox(height: 8.h),
            _menuCard([
              _menuItem(
                LucideIcons.store,
                'Manajemen Toko',
                () => context.push('/store-management'),
              ),
              _menuItem(
                LucideIcons.chartBar,
                'Analitik PRO',
                () => context.push('/sales-analytics'),
                trailing: _proBadge(),
              ),
              _menuItem(
                LucideIcons.heart,
                'Minat Produk',
                () => context.push('/product-engagement'),
              ),
              _menuItem(
                LucideIcons.wallet,
                'Dompet BISA',
                () => context.push('/wallet'),
              ),
            ]),
          ],
          SizedBox(height: 12.h),
          _sectionTitle('Wawasan Pasar'),
          SizedBox(height: 8.h),
          _menuCard([
            _menuItem(
              LucideIcons.trendingUp,
              'Market Intelligence',
              () => context.push('/market-insight'),
            ),
            // Analitik Mendalam = fitur Pro, khusus Supplier.
            if (isSupplier)
              _menuItem(
                LucideIcons.sparkles,
                'Analitik Mendalam',
                () => context.push('/market-deep-analytics'),
                trailing: _proBadge(),
              ),
            if (isAuthenticated && isSupplier)
              _menuItem(
                LucideIcons.cpu,
                'Monitoring IoT',
                () => context.push('/iot-dashboard'),
              ),
            _menuItem(
              LucideIcons.map,
              'Peta Sebaran Limbah',
              () => context.push('/waste-mapping'),
            ),
          ]),
          SizedBox(height: 12.h),
          _sectionTitle('Lainnya'),
          SizedBox(height: 8.h),
          _menuCard([
            if (isSupplier)
              _menuItem(
                LucideIcons.creditCard,
                'Metode Pembayaran',
                () => context.push('/payment-methods'),
              ),
            _menuItem(
              LucideIcons.bell,
              'Notifikasi',
              () => context.push('/notifications'),
            ),
            _menuItem(
              LucideIcons.handHelping,
              'Pusat Bantuan',
              () => context.push('/help-center'),
            ),
            _menuItem(
              LucideIcons.fileText,
              'Syarat & Ketentuan',
              () => context.push('/terms'),
            ),
            _menuItem(
              LucideIcons.shieldAlert,
              'Kebijakan Privasi',
              () => context.push('/privacy'),
            ),
            if (isAuthenticated)
              _menuItem(
                LucideIcons.logOut,
                'Keluar Aplikasi',
                () => _showLogoutDialog(context),
                textColor: AppColors.error,
                showChevron: false,
              ),
          ]),
          SizedBox(height: 20.h),
          const Center(child: AppVersionLabel()),
          SizedBox(height: 8.h),
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
          color: AppColors.white,
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
      visualDensity: VisualDensity.compact,
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color:
              (isLocked ? AppColors.grey400 : (textColor ?? AppColors.primary))
                  .withOpacity(0.06),
          borderRadius: BorderRadius.circular(10.r),
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
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Keluar',
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
              'Batal',
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
              'Keluar',
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

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        final currentLocale = context.locale;
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Bahasa',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),
              _langTile(
                context,
                'Bahasa Indonesia',
                'id',
                'ID',
                currentLocale.languageCode == 'id',
              ),
              _langTile(
                context,
                'English (US)',
                'en',
                'US',
                currentLocale.languageCode == 'en',
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _langTile(
    BuildContext context,
    String title,
    String code,
    String country,
    bool selected,
  ) {
    return ListTile(
      onTap: () {
        context.setLocale(Locale(code, country));
        Navigator.pop(context);
      },
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
          color: selected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: selected
          ? const Icon(LucideIcons.check, color: AppColors.primary)
          : null,
    );
  }
}
