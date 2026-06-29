import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';

/// Icon badge gradient + shadow (gaya quick action 3D).
class Bisa3DIconBadge extends StatelessWidget {
  const Bisa3DIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 36,
    this.iconSize,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final top = Color.lerp(color, AppColors.white, 0.45)!;
    final mid = color;
    final bottom = Color.lerp(color, AppColors.black, 0.12)!;
    final badge = size.r;

    return Container(
      width: badge,
      height: badge,
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
      child: Icon(
        icon,
        color: AppColors.surface,
        size: iconSize ?? (size * 0.48).sp,
      ),
    );
  }
}

/// Kartu section dengan shadow mengambang (wrapper quick actions).
class Supplier3DSectionCard extends StatelessWidget {
  const Supplier3DSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.padding,
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ??
          EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.section,
          ),
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
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            child,
          ],
        ),
      );
  }
}

/// Tile menu list dengan icon 3D (Manajemen Toko, profil list).
class Supplier3DMenuTile extends StatefulWidget {
  const Supplier3DMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  State<Supplier3DMenuTile> createState() => _Supplier3DMenuTileState();
}

class _Supplier3DMenuTileState extends State<Supplier3DMenuTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.grey100.withValues(alpha: 0.85)),
            boxShadow: _pressed
                ? AppColors.softShadow
                : [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.14),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Bisa3DIconBadge(icon: widget.icon, color: widget.color, size: 40),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 18.sp,
                color: AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip grid horizontal 3D (Semua Menu, profil).
class Supplier3DGridChip extends StatefulWidget {
  const Supplier3DGridChip({
    super.key,
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
  State<Supplier3DGridChip> createState() => _Supplier3DGridChipState();
}

class _Supplier3DGridChipState extends State<Supplier3DGridChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 120),
        child: SizedBox(
          width: 68.w,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.grey100.withValues(alpha: 0.85)),
              boxShadow: _pressed
                  ? AppColors.softShadow
                  : [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.18),
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
              children: [
                Bisa3DIconBadge(
                  icon: widget.icon,
                  color: widget.color,
                  size: 32,
                  iconSize: 15.sp,
                ),
                SizedBox(height: 6.h),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
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
      ),
    );
  }
}

/// Stat card kecil 3D.
class Supplier3DStatCard extends StatelessWidget {
  const Supplier3DStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey100.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bisa3DIconBadge(icon: icon, color: color, size: 32, iconSize: 14.sp),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
