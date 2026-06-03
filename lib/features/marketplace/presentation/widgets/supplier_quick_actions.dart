import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../home/presentation/pages/main_screen.dart';

class SupplierQuickActions extends StatelessWidget {
  const SupplierQuickActions({super.key});

  static const int _columns = 4;
  static const int _rows = 3;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );

    final actions = _buildActions(context, user);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Aksi Cepat',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 10.0;
                // Lebar sel > tinggi sel agar icon 3D + label 2 baris tidak overflow.
                const cellAspectRatio = 0.84;
                final cellWidth =
                    (constraints.maxWidth - spacing * (_columns - 1)) /
                        _columns;
                final cellHeight = cellWidth / cellAspectRatio;
                final gridHeight =
                    cellHeight * _rows + spacing * (_rows - 1);

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
                        _QuickActionCard(data: actions[index]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<_QuickActionData> _buildActions(BuildContext context, UserEntity? user) {
    return [
      _QuickActionData(
        icon: LucideIcons.plus,
        label: 'Tambah Produk',
        color: AppColors.success,
        onTap: () => context.push('/add-product'),
      ),
      _QuickActionData(
        icon: LucideIcons.package,
        label: 'Kelola Produk',
        color: AppColors.primary,
        onTap: () => context.push('/product-management'),
      ),
      _QuickActionData(
        icon: LucideIcons.store,
        label: 'Manajemen Toko',
        color: AppColors.primaryDark,
        onTap: () => context.push('/store-management'),
      ),
      _QuickActionData(
        icon: LucideIcons.chartBar,
        label: 'Analitik',
        color: AppColors.info,
        onTap: () => context.push('/sales-analytics'),
      ),
      _QuickActionData(
        icon: LucideIcons.heart,
        label: 'Minat Produk',
        color: AppColors.error,
        onTap: () => context.push('/product-engagement'),
      ),
      _QuickActionData(
        icon: LucideIcons.shoppingBag,
        label: 'Pesanan',
        color: AppColors.secondary,
        onTap: () => MainShellScope.maybeOf(context)?.selectTab(3),
      ),
      _QuickActionData(
        icon: LucideIcons.messageSquare,
        label: 'Negosiasi',
        color: AppColors.ocean,
        onTap: () => MainShellScope.maybeOf(context)?.selectTab(1),
      ),
      _QuickActionData(
        icon: LucideIcons.wallet,
        label: 'Dompet',
        color: AppColors.warning,
        onTap: () => context.push('/wallet'),
      ),
      _QuickActionData(
        icon: LucideIcons.cpu,
        label: 'Monitoring IoT',
        color: AppColors.info,
        onTap: () => context.push('/iot-dashboard'),
      ),
      _QuickActionData(
        icon: LucideIcons.shieldCheck,
        label: 'Verifikasi',
        color: AppColors.success,
        onTap: () => context.push('/verification'),
      ),
      _QuickActionData(
        icon: LucideIcons.bell,
        label: 'Notifikasi',
        color: AppColors.error,
        onTap: () => context.push('/notifications'),
      ),
    ];
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
}

class _QuickActionCard extends StatefulWidget {
  const _QuickActionCard({required this.data});

  final _QuickActionData data;

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _pressed = false;

  _QuickActionData get data => widget.data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: data.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.grey100.withValues(alpha: 0.85),
            ),
            boxShadow: _pressed
                ? AppColors.softShadow
                : [
                    BoxShadow(
                      color: data.color.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _QuickActionIcon3D(icon: data.icon, color: data.color),
              SizedBox(height: 4.h),
              Flexible(
                child: Text(
                  data.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Icon badge dengan gradient + shadow agar terlihat sedikit 3D / mengambang.
class _QuickActionIcon3D extends StatelessWidget {
  const _QuickActionIcon3D({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final top = Color.lerp(color, AppColors.white, 0.45)!;
    final mid = color;
    final bottom = Color.lerp(color, AppColors.black, 0.12)!;

    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [top, mid, bottom],
          stops: const [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.42),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.65),
            blurRadius: 0,
            offset: const Offset(-1.5, -1.5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 4.h,
            left: 6.w,
            child: Container(
              width: 10.r,
              height: 5.r,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
          Icon(
            icon,
            color: AppColors.white,
            size: 16.sp,
          ),
        ],
      ),
    );
  }
}
