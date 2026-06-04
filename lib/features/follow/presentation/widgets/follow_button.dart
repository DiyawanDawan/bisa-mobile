import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/follow_cubit.dart';

class FollowButton extends StatefulWidget {
  final String userId;
  final bool compact;

  const FollowButton({
    super.key,
    required this.userId,
    this.compact = true,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FollowCubit>().ensureFollowingStatus(widget.userId);
    });
  }

  Future<void> _onTap(BuildContext context) async {
    final currentUser = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (currentUser == null) {
      AuthSheet.show(context);
      return;
    }
    if (currentUser.id == widget.userId) return;

    setState(() => _loading = true);
    final error = await context.read<FollowCubit>().toggleFollow(
          widget.userId,
          currentUserId: currentUser.id,
        );
    if (!mounted) return;
    setState(() => _loading = false);
    if (error != null && error.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u,
          orElse: () => null,
        );
    if (currentUser?.id == widget.userId) return const SizedBox.shrink();

    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, state) {
        final isFollowing = state.isFollowing(widget.userId);
        final bgColor = isFollowing
            ? AppColors.grey100
            : AppColors.primary.withValues(alpha: 0.08);
        final textColor =
            isFollowing ? AppColors.textSecondary : AppColors.primary;
        final label = isFollowing ? 'Mengikuti' : 'Ikuti';

        return GestureDetector(
          onTap: _loading ? null : () => _onTap(context),
          child: Container(
            constraints: BoxConstraints(maxWidth: widget.compact ? 108.w : 130.w),
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 12.w : 16.w,
              vertical: widget.compact ? 8.h : 10.h,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isFollowing
                    ? AppColors.grey200
                    : AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: _loading
                ? SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor,
                    ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

/// Stats mengikuti/pengikut untuk user yang sedang dilihat (mis. profil supplier).
class UserFollowStatsRow extends StatefulWidget {
  final String userId;

  const UserFollowStatsRow({super.key, required this.userId});

  @override
  State<UserFollowStatsRow> createState() => _UserFollowStatsRowState();
}

class _UserFollowStatsRowState extends State<UserFollowStatsRow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FollowCubit>().loadFollowStatsForUser(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, state) {
        final stats = state.statsForUser(widget.userId);
        if (stats == null) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: SizedBox(
              width: 16.w,
              height: 16.w,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatChip(
              value: '${stats.followingCount}',
              label: 'Mengikuti',
            ),
            SizedBox(width: 20.w),
            _StatChip(
              value: '${stats.followersCount}',
              label: 'Pengikut',
            ),
          ],
        );
      },
    );
  }
}

class FollowStatsRow extends StatelessWidget {
  final String userId;

  const FollowStatsRow({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, state) {
        final stats = state.myStats;
        final following = stats?.followingCount ?? 0;
        final followers = stats?.followersCount ?? 0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatTap(
              value: '$following',
              label: 'Mengikuti',
              onTap: () => context.push('/follows?tab=following'),
            ),
            SizedBox(width: 28.w),
            _StatTap(
              value: '$followers',
              label: 'Pengikut',
              onTap: () => context.push('/follows?tab=followers'),
            ),
          ],
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
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
    );
  }
}

class _StatTap extends StatelessWidget {
  const _StatTap({
    required this.value,
    required this.label,
    required this.onTap,
  });

  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
