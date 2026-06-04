import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../home/presentation/pages/main_screen.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';

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
      appBar: const BisaAppBar(
        title: 'Fitur Penting',
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
        children: [
          _introCard(),
          SizedBox(height: 16.h),
          _sectionTitle('§28 — Bayar & instruksi'),
          _tile(
            icon: LucideIcons.creditCard,
            title: 'Pesanan menunggu bayar',
            subtitle: 'Pilih metode → VA/QRIS/webview → instruksi bayar',
            onTap: loggedIn
                ? () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  }
                : () => context.push('/login'),
          ),
          if (loggedIn)
            _tile(
              icon: LucideIcons.wallet,
              title: 'Metode pembayaran',
              subtitle: 'Kanal bayar yang tersedia di platform',
              onTap: () => context.push('/payment-methods'),
            ),
          SizedBox(height: 14.h),
          _sectionTitle('§29 — Lacak & notifikasi'),
          _tile(
            icon: LucideIcons.mapPin,
            title: 'Lacak pesanan (login)',
            subtitle: 'Detail pesanan · peta · sync kurir',
            onTap: loggedIn
                ? () {
                    MainShellScope.maybeOf(context)?.selectTab(3);
                    context.pop();
                  }
                : () => context.push('/login'),
          ),
          _tile(
            icon: LucideIcons.scanLine,
            title: 'Verifikasi kontrak publik',
            subtitle: 'Scan QR / nomor pesanan',
            onTap: () => context.push('/verify'),
          ),
          _tile(
            icon: LucideIcons.truck,
            title: 'Lacak pengiriman publik',
            subtitle: 'Tanpa login — nomor pesanan',
            onTap: () => context.push('/track'),
          ),
          if (loggedIn)
            _tile(
              icon: LucideIcons.bell,
              title: 'Notifikasi',
              subtitle: 'Tap notifikasi → pesanan / nego / KYC',
              onTap: () => context.push('/notifications'),
            ),
          SizedBox(height: 14.h),
          if (isSupplier) ...[
            _sectionTitle('§30 — Supplier'),
            _tile(
              icon: LucideIcons.store,
              title: 'Kelola toko & banner',
              subtitle: 'Banner promosi di halaman toko',
              onTap: () => context.push('/store-management'),
            ),
            _tile(
              icon: LucideIcons.heart,
              title: 'Minat produk',
              subtitle: 'Engagement & views',
              onTap: () => context.push('/product-engagement'),
            ),
            _tile(
              icon: LucideIcons.chartBar,
              title: 'Analitik penjualan',
              subtitle: 'Omzet & tren (BISA Pro)',
              onTap: () => context.push('/sales-analytics'),
            ),
            _tile(
              icon: LucideIcons.cpu,
              title: 'BISA Pro & IoT',
              subtitle: 'Langganan & monitoring',
              onTap: () => context.push('/iot-subscription'),
            ),
            SizedBox(height: 14.h),
          ],
          _sectionTitle('§31 — Katalog'),
          _tile(
            icon: LucideIcons.layoutGrid,
            title: 'Jelajahi katalog',
            subtitle: 'Koleksi toko · spesifikasi · filter biomassa/organik',
            onTap: () {
              MainShellScope.maybeOf(context)?.selectTab(0);
              context.pop();
            },
          ),
          if (loggedIn)
            _tile(
              icon: LucideIcons.map,
              title: 'Alamat & peta',
              subtitle: 'Picker lokasi saat checkout / tagihan',
              onTap: () => context.push('/addresses'),
            ),
          SizedBox(height: 14.h),
          _sectionTitle('§32 — Sosial & akun'),
          if (loggedIn && !isSupplier) ...[
            _tile(
              icon: LucideIcons.heart,
              title: 'Wishlist',
              onTap: () => context.push('/wishlist'),
            ),
            _tile(
              icon: LucideIcons.users,
              title: 'Follow & koneksi',
              onTap: () => context.push('/follows'),
            ),
          ],
          if (loggedIn)
            _tile(
              icon: LucideIcons.lock,
              title: 'Ubah kata sandi',
              onTap: () => context.push('/change-password'),
            ),
          _tile(
            icon: LucideIcons.settings,
            title: 'Pengaturan notifikasi',
            subtitle: 'Preferensi push & bahasa',
            onTap: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }

  Widget _introCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        'Akses cepat ke alur penting: instruksi bayar, lacak kirim, tools supplier, dan akun.',
        style: TextStyle(
          color: Colors.white,
          fontSize: 13.sp,
          height: 1.45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
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
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey100),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
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
