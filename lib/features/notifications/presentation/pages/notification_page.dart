import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/i18n/locale_formatters.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_cubit.dart';
import '../bloc/notification_state.dart';
import '../utils/notification_ui_utils.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/notification_tile_skeleton.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NotificationCubit>().getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.surface,
        title: 'notifications.page_title'.tr(),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<NotificationCubit>().markAllAsRead(),
                child: Text(
                  'read_all'.tr(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const ShimmerNotificationListPlaceholder();
          } else if (state is NotificationError) {
            return Center(child: Text(state.message));
          } else if (state is NotificationLoaded) {
            final notifications = state.notifications;
            if (notifications.isEmpty) {
              return _buildEmptyState();
            }
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  context.read<NotificationCubit>().getNotifications(),
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 40.h),
                physics: const BouncingScrollPhysics(),
                itemCount: notifications.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return Dismissible(
                    key: Key(n.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.w),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        LucideIcons.trash2,
                        color: AppColors.textOnPrimary,
                        size: 24.sp,
                      ),
                    ),
                    onDismissed: (_) {
                      context.read<NotificationCubit>().deleteNotification(n.id);
                      showSuccessSnackBar(context, 'notification_deleted');
                    },
                    child: _buildNotificationItem(context, n),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _openNotification(BuildContext context, NotificationEntity n) {
    final cubit = context.read<NotificationCubit>();
    if (!n.isRead) {
      cubit.markAsRead(n.id);
    }

    final action = notificationAction(n);
    if (action != null) {
      context.push(action.route);
      return;
    }
    context.push('/notifications/${n.id}');
  }

  Widget _buildNotificationItem(BuildContext context, NotificationEntity n) {
    return Container(
      decoration: BoxDecoration(
        color: n.isRead ? AppColors.white : AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: n.isRead ? AppColors.softShadow : null,
        border: Border.all(
          color: n.isRead ? AppColors.grey100 : AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: () => _openNotification(context, n),
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: notificationColor(n.type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    notificationIcon(n.type),
                    color: notificationColor(n.type),
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: n.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            context.formatTimeAgo(n.createdAt, short: true),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textHint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        n.body,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!n.isRead)
                  Padding(
                    padding: EdgeInsets.only(left: 8.w, top: 4.h),
                    child: CircleAvatar(
                      radius: 4.r,
                      backgroundColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.r),
            decoration: BoxDecoration(
                        color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: AppColors.softShadow,
            ),
            child: Icon(
              LucideIcons.bellOff,
              size: 48.sp,
              color: AppColors.grey200,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'notifications.empty_title'.tr(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'notifications.empty_subtitle'.tr(),
            style: TextStyle(color: AppColors.textHint, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
