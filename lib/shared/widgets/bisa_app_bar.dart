import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/safe_navigator.dart';

class BisaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
  final Color? backButtonBackgroundColor;
  final bool centerTitle;
  final bool showShadow;
  final PreferredSizeWidget? bottom;

  const BisaAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.showBackButton = true,
    this.onBackTap,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
    this.backButtonBackgroundColor,
    this.centerTitle = true,
    this.bottom,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.textSecondary.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        centerTitle: centerTitle,
        bottom: bottom,
        leadingWidth: showBackButton ? 70.w : 0,
        leading: showBackButton
            ? Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.lg,
                  top: AppSpacing.sm,
                  bottom: AppSpacing.sm,
                ),
                child: GestureDetector(
                  onTap:
                      onBackTap ??
                      () {
                        if (context.canPop()) {
                          safeRouterPop(context);
                        } else {
                          context.go('/');
                        }
                      },
                  child: Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: backButtonBackgroundColor ?? AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey200),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: iconColor ?? AppColors.textPrimary,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              )
            : null,
        title:
            titleWidget ??
            (title != null
                ? Text(
                    title!,
                    style: AppTextStyles.pageTitle(
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                  )
                : null),
        actions: actions != null
            ? [
                ...actions!.map(
                  (action) => Padding(
                    padding: EdgeInsets.only(right: AppSpacing.md12),
                    child: action,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
              ]
            : null,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(64.h + (bottom?.preferredSize.height ?? 0));
}

/// Helper widget to create a circular action button consistent with the app bar style
class BisaAppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;

  const BisaAppBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.grey100),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}
