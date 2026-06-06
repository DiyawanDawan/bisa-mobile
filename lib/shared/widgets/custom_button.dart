import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

enum BisaButtonSize { sm, md, lg }

enum BisaButtonVariant { primary, secondary, outlined, ghost, destructive }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isOutlined;
  final bool useGradient;
  final BisaButtonVariant? variant;
  final BisaButtonSize? size;
  final IconData? icon;
  final bool iconTrailing;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isOutlined = false,
    this.useGradient = false,
    this.variant,
    this.size,
    this.icon,
    this.iconTrailing = false,
    this.fullWidth = true,
  });

  BisaButtonVariant get _variant {
    if (variant != null) return variant!;
    if (isOutlined) return BisaButtonVariant.outlined;
    return BisaButtonVariant.primary;
  }

  BisaButtonSize get _size {
    if (size != null) return size!;
    if (height != null) {
      if (height! <= 42.h) return BisaButtonSize.sm;
      if (height! <= 50.h) return BisaButtonSize.md;
      return BisaButtonSize.lg;
    }
    return BisaButtonSize.lg;
  }

  double get _effectiveHeight {
    if (height != null) return height!;
    switch (_size) {
      case BisaButtonSize.sm:
        return 40.h;
      case BisaButtonSize.md:
        return 48.h;
      case BisaButtonSize.lg:
        return 56.h;
    }
  }

  double get _fontSize {
    switch (_size) {
      case BisaButtonSize.sm:
        return 13.sp;
      case BisaButtonSize.md:
        return 14.sp;
      case BisaButtonSize.lg:
        return 16.sp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = fullWidth ? (width ?? double.infinity) : width;
    final radius = BorderRadius.circular(16.r);

    if (_variant == BisaButtonVariant.ghost) {
      return TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        ),
        icon: icon != null && !iconTrailing
            ? Icon(icon, size: _fontSize + 2)
            : const SizedBox.shrink(),
        label: _buildChild(),
      );
    }

    if (_variant == BisaButtonVariant.outlined ||
        _variant == BisaButtonVariant.destructive) {
      final borderColor = _variant == BisaButtonVariant.destructive
          ? AppColors.error
          : (backgroundColor ?? AppColors.primary);
      final fg = _variant == BisaButtonVariant.destructive
          ? AppColors.error
          : (backgroundColor ?? AppColors.primary);

      return SizedBox(
        width: effectiveWidth,
        height: _effectiveHeight,
        child: OutlinedButton.icon(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: borderColor, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: radius),
            foregroundColor: fg,
            splashFactory: InkRipple.splashFactory,
          ),
          icon: _buildIcon(fg),
          label: _buildChild(color: fg),
        ),
      );
    }

    final bool useGrad =
        useGradient && onPressed != null && _variant == BisaButtonVariant.primary;
    final Color fillColor = switch (_variant) {
      BisaButtonVariant.secondary => AppColors.grey100,
      BisaButtonVariant.destructive => AppColors.error,
      _ => backgroundColor ??
          (onPressed == null ? AppColors.grey300 : AppColors.primary),
    };

    return Container(
      width: effectiveWidth,
      height: _effectiveHeight,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: useGrad ? AppColors.primaryGradient : null,
        color: (!useGrad) ? fillColor : null,
        boxShadow: (onPressed != null && _variant == BisaButtonVariant.primary)
            ? AppColors.mediumShadow
            : null,
      ),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: textColor ?? AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(borderRadius: radius),
          splashFactory: InkRipple.splashFactory,
        ),
        icon: _buildIcon(textColor ?? AppColors.textOnPrimary),
        label: _buildChild(color: textColor ?? AppColors.textOnPrimary),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    if (icon == null || iconTrailing) return const SizedBox.shrink();
    return Icon(icon, size: _fontSize + 2, color: color);
  }

  Widget _buildChild({Color? color}) {
    if (isLoading) {
      return SizedBox(
        height: 24.h,
        width: 24.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            _variant == BisaButtonVariant.outlined ||
                    _variant == BisaButtonVariant.ghost
                ? AppColors.primary
                : (color ?? AppColors.textOnPrimary),
          ),
        ),
      );
    }

    final label = Text(
      text,
      style: TextStyle(
        fontSize: _fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: color,
      ),
    );

    if (icon == null || !iconTrailing) return label;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: label),
        SizedBox(width: 6.w),
        Icon(icon, size: _fontSize + 2, color: color),
      ],
    );
  }
}
