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
        title: 'Semua Menu',
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: [
          _MenuGrid(
            items: [
              _MenuGridItem(
                icon: LucideIcons.sparkles,
                label: 'Fitur Penting',
                color: AppColors.primary,
                onTap: () => context.push('/important-features'),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          if (isAuthenticated) ...[
            _sectionTitle('Akun'),
            _MenuGrid(
              items: [
                _MenuGridItem(
                  icon: LucideIcons.user,
                  label: 'Ubah Profil',
                  color: AppColors.primary,
                  onTap: () => context.push('/edit-profile', extra: user),
                ),
                _MenuGridItem(
                  icon: LucideIcons.shieldCheck,
                  label: 'Verifikasi',
                  color: AppColors.success,
                  onTap: () => context.push('/verification'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.mapPin,
                  label: 'Alamat',
                  color: AppColors.info,
                  onTap: () => context.push('/addresses'),
                ),
                if (!isSupplier)
                  _MenuGridItem(
                    icon: LucideIcons.creditCard,
                    label: 'Metode Bayar',
                    color: AppColors.warning,
                    onTap: () => context.push('/payment-methods'),
                  ),
                _MenuGridItem(
                  icon: LucideIcons.lock,
                  label: 'Kata Sandi',
                  color: AppColors.warning,
                  onTap: () => context.push('/change-password'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.users,
                  label: 'Koneksi',
                  color: AppColors.primary,
                  onTap: () => context.push('/follows'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.bell,
                  label: 'Notifikasi',
                  color: AppColors.error,
                  onTap: () => context.push('/notifications'),
                ),
              ],
            ),
          ],
          if (isAuthenticated && !isSupplier) ...[
            SizedBox(height: 14.h),
            _sectionTitle('Belanja & Produk'),
            _MenuGrid(
              items: [
                _MenuGridItem(
                  icon: LucideIcons.package,
                  label: 'Produk Saya',
                  color: AppColors.primary,
                  onTap: () => context.push('/buyer-products'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.heart,
                  label: 'Favorit',
                  color: AppColors.error,
                  onTap: () => context.push('/wishlist'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.shoppingCart,
                  label: 'Keranjang',
                  color: AppColors.success,
                  onTap: () => context.push('/cart'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.messageSquare,
                  label: 'Negosiasi',
                  color: AppColors.info,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(1);
                    context.pop();
                  },
                ),
                _MenuGridItem(
                  icon: LucideIcons.shoppingBag,
                  label: 'Pesanan',
                  color: AppColors.secondary,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  },
                ),
              ],
            ),
          ],
          if (isAuthenticated && isSupplier) ...[
            SizedBox(height: 14.h),
            _sectionTitle('Manajemen Bisnis'),
            _MenuGrid(
              items: [
                _MenuGridItem(
                  icon: LucideIcons.store,
                  label: 'Manajemen Toko',
                  color: AppColors.primary,
                  onTap: () => context.push('/store-management'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.package,
                  label: 'Kelola Produk',
                  color: AppColors.success,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(0);
                    context.pop();
                  },
                ),
                _MenuGridItem(
                  icon: LucideIcons.plus,
                  label: 'Tambah Produk',
                  color: AppColors.info,
                  onTap: () => context.push('/add-product'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.chartBar,
                  label: 'Analitik PRO',
                  color: AppColors.warning,
                  onTap: () => context.push('/sales-analytics'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.heart,
                  label: 'Minat Produk',
                  color: AppColors.error,
                  onTap: () => context.push('/product-engagement'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.wallet,
                  label: 'Dompet BISA',
                  color: AppColors.secondary,
                  onTap: () => context.push('/wallet'),
                ),
                _MenuGridItem(
                  icon: LucideIcons.creditCard,
                  label: 'Metode Bayar',
                  color: AppColors.textSecondary,
                  onTap: () => context.push('/payment-methods'),
                ),
              ],
            ),
          ],
          SizedBox(height: 14.h),
          _sectionTitle('Komunitas & Aktivitas'),
          _MenuGrid(
            items: [
              _MenuGridItem(
                icon: LucideIcons.users,
                label: 'Forum',
                color: AppColors.primary,
                onTap: () {
                  MainShellScope.maybeOf(context)?.selectTab(2);
                  context.pop();
                },
              ),
              if (isAuthenticated)
                _MenuGridItem(
                  icon: LucideIcons.fileText,
                  label: 'Postingan Saya',
                  color: AppColors.warning,
                  onTap: () => context.push('/my-forum-posts'),
                ),
              if (isAuthenticated && isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.messageSquare,
                  label: 'Negosiasi',
                  color: AppColors.info,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(1);
                    context.pop();
                  },
                ),
              if (isAuthenticated)
                _MenuGridItem(
                  icon: LucideIcons.shoppingBag,
                  label: 'Pesanan',
                  color: AppColors.success,
                  onTap: () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  },
                ),
            ],
          ),
          SizedBox(height: 14.h),
          _sectionTitle('Wawasan Pasar'),
          _MenuGrid(
            items: [
              _MenuGridItem(
                icon: LucideIcons.trendingUp,
                label: 'Market AI',
                color: AppColors.primary,
                onTap: () => context.push('/market-insight'),
              ),
              if (isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.cpu,
                  label: 'Monitoring IoT',
                  color: AppColors.info,
                  onTap: () => context.push('/iot-dashboard'),
                ),
              _MenuGridItem(
                icon: LucideIcons.map,
                label: 'Peta Limbah',
                color: AppColors.success,
                onTap: () => context.push('/waste-mapping'),
              ),
              // BISA Pro upsell hanya untuk Supplier (Pro = IoT/Analitik bisnis).
              if (isSupplier)
                _MenuGridItem(
                  icon: LucideIcons.sparkles,
                  label: 'BISA Pro',
                  color: AppColors.warning,
                  onTap: () => context.push('/iot-subscription'),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          _sectionTitle('Bantuan & Legal'),
          _MenuGrid(
            items: [
              _MenuGridItem(
                icon: LucideIcons.handHelping,
                label: 'Pusat Bantuan',
                color: AppColors.info,
                onTap: () => context.push('/help-center'),
              ),
              _MenuGridItem(
                icon: LucideIcons.fileText,
                label: 'Syarat & Ketentuan',
                color: AppColors.textSecondary,
                onTap: () => context.push('/terms'),
              ),
              _MenuGridItem(
                icon: LucideIcons.shieldAlert,
                label: 'Privasi',
                color: AppColors.textSecondary,
                onTap: () => context.push('/privacy'),
              ),
              _MenuGridItem(
                icon: LucideIcons.settings,
                label: 'Pengaturan',
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
