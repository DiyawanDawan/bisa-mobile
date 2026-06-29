import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/constants/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/notifications/presentation/bloc/notification_cubit.dart';
import '../../features/notifications/presentation/bloc/notification_state.dart';
import 'auth_sheet.dart';
import 'bisa_app_bar.dart';

/// Tombol lonceng notifikasi dengan badge jumlah belum dibaca.
class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({
    super.key,
    this.useAppBarStyle = true,
    this.iconColor,
    this.backgroundColor,
  });

  final bool useAppBarStyle;
  final Color? iconColor;
  final Color? backgroundColor;

  void _onTap(BuildContext context) {
    final isAuthenticated = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        );
    if (!isAuthenticated) {
      AuthSheet.show(context);
      return;
    }
    context.push('/notifications').then((_) {
      if (context.mounted) {
        context.read<NotificationCubit>().refreshUnreadCount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        );
    if (!isAuthenticated) return const SizedBox.shrink();

    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final unread = state.unreadCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            useAppBarStyle
                ? BisaAppBarAction(
                    icon: LucideIcons.bell,
                    onTap: () => _onTap(context),
                    iconColor: iconColor,
                    backgroundColor: backgroundColor,
                  )
                : _HeaderIconButton(
                    onTap: () => _onTap(context),
                  ),
            if (unread > 0)
              Positioned(
                right: useAppBarStyle ? 2.w : 0,
                top: useAppBarStyle ? 2.h : 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: unread > 9 ? 4.w : 5.w,
                    vertical: 2.h,
                  ),
                  constraints: BoxConstraints(minWidth: AppSpacing.md),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unread > 99 ? '99+' : '$unread',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.grey50,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          LucideIcons.bell,
          color: AppColors.textPrimary,
          size: 20.sp,
        ),
        onPressed: onTap,
      ),
    );
  }
}
