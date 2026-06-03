import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/custom_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../shared/widgets/shimmer_loading.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_cubit.dart';
import '../utils/notification_ui_utils.dart';

class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({super.key, required this.notificationId});

  final String notificationId;

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  NotificationEntity? _notification;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final cubit = context.read<NotificationCubit>();
    final notification = await cubit.fetchNotificationById(widget.notificationId);

    if (!mounted) return;

    if (notification == null) {
      setState(() {
        _loading = false;
        _error = 'Notifikasi tidak ditemukan';
      });
      return;
    }

    if (!notification.isRead) {
      await cubit.markAsRead(notification.id);
    }

    setState(() {
      _notification = notification.copyWith(isRead: true);
      _loading = false;
    });
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Notifikasi'),
        content: const Text('Notifikasi ini akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await context.read<NotificationCubit>().deleteNotification(widget.notificationId);
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BisaAppBar(
        backgroundColor: AppColors.surface,
        title: 'Detail Notifikasi',
        actions: [
          if (_notification != null)
            IconButton(
              onPressed: _delete,
              icon: Icon(LucideIcons.trash2, size: 20.sp, color: AppColors.error),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: ShimmerLoading(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone(width: 56.w, height: 56.h, borderRadius: BorderRadius.circular(14.r)),
              SizedBox(height: 20.h),
              Bone(width: double.infinity, height: 22.h),
              SizedBox(height: 12.h),
              const Bone.multiText(lines: 6),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.circleAlert, size: 48.sp, color: AppColors.error),
              SizedBox(height: 12.h),
              Text(_error!, textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              CustomButton(text: 'coba_lagi'.tr(), onPressed: _load),
            ],
          ),
        ),
      );
    }

    final n = _notification!;
    final action = notificationAction(n);
    final typeColor = notificationColor(n.type);
    final formattedDate = DateFormat('EEEE, d MMMM yyyy · HH:mm', 'id_ID').format(n.createdAt);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.grey100),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(notificationIcon(n.type), color: typeColor, size: 24.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notificationTypeLabel(n.type),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: typeColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            children: [
                              _badge(
                                notificationPriorityLabel(n.priority),
                                notificationPriorityColor(n.priority),
                              ),
                              _badge(
                                n.isRead ? 'Sudah dibaca' : 'Belum dibaca',
                                n.isRead ? AppColors.grey500 : AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  n.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  n.body,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Icon(LucideIcons.clock3, size: 14.sp, color: AppColors.textHint),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (action != null) ...[
            SizedBox(height: 16.h),
            CustomButton(
              text: action.label,
              width: double.infinity,
              onPressed: () => context.push(action.route),
            ),
          ],
          if (n.refId != null && n.refId!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.grey100),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.link, size: 16.sp, color: AppColors.textHint),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Referensi: ${n.refId}',
                      style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
