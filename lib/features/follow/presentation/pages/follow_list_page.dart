import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/i18n/failure_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../domain/entities/follow_user_entity.dart';
import '../bloc/follow_cubit.dart';
import '../widgets/follow_button.dart';
import '../../../../shared/widgets/follow_list_tile_skeleton.dart';

class FollowListPage extends StatefulWidget {
  final int initialTab;

  const FollowListPage({super.key, this.initialTab = 0});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<FollowCubit>();
      cubit.loadFollowingList();
      cubit.loadFollowersList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (u) => u.id,
          orElse: () => null,
        );

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          backgroundColor: AppColors.surface,
          title: 'follow.page_title'.tr(),
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'follow.tab_following'.tr()),
              Tab(text: 'follow.tab_followers'.tr()),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _FollowUserList(
              isFollowingTab: true,
              currentUserId: userId,
            ),
            _FollowUserList(
              isFollowingTab: false,
              currentUserId: userId,
            ),
          ],
        ),
      );
  }
}

class _FollowUserList extends StatelessWidget {
  const _FollowUserList({
    required this.isFollowingTab,
    required this.currentUserId,
  });

  final bool isFollowingTab;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowCubit, FollowState>(
      builder: (context, state) {
        if (state.isLoading &&
            (isFollowingTab
                ? state.followingUsers.isEmpty
                : state.followerUsers.isEmpty)) {
          return const ShimmerFollowListPlaceholder();
        }

        if (state.error != null &&
            (isFollowingTab
                ? state.followingUsers.isEmpty
                : state.followerUsers.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error!.localizedFailure),
                TextButton(
                  onPressed: () {
                    if (isFollowingTab) {
                      context.read<FollowCubit>().loadFollowingList();
                    } else {
                      context.read<FollowCubit>().loadFollowersList();
                    }
                  },
                  child: Text('follow.retry'.tr()),
                ),
              ],
            ),
          );
        }

        final users =
            isFollowingTab ? state.followingUsers : state.followerUsers;

        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.users,
                  size: 48.sp,
                  color: AppColors.grey300,
                ),
                SizedBox(height: 12.h),
                Text(
                  isFollowingTab
                      ? 'follow.empty_following'.tr()
                      : 'follow.empty_followers'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            if (isFollowingTab) {
              await context.read<FollowCubit>().loadFollowingList();
            } else {
              await context.read<FollowCubit>().loadFollowersList();
            }
          },
          child: ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: users.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) =>
                _FollowUserTile(user: users[index], currentUserId: currentUserId),
          ),
        );
      },
    );
  }
}

class _FollowUserTile extends StatelessWidget {
  const _FollowUserTile({
    required this.user,
    required this.currentUserId,
  });

  final FollowUserEntity user;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final location = [user.regency, user.province]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: () => context.push(
          '/supplier/${user.id}',
          extra: {'name': user.fullName},
        ),
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.grey100),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.grey100,
                backgroundImage: resolveMediaImageProvider(user.avatarUrl),
                child: user.avatarUrl == null
                    ? Icon(LucideIcons.user, color: AppColors.grey400)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.fullName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isVerified) ...[
                          SizedBox(width: 4.w),
                          Icon(
                            LucideIcons.badgeCheck,
                            size: 14.sp,
                            color: AppColors.info,
                          ),
                        ],
                      ],
                    ),
                    if (location.isNotEmpty)
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (currentUserId != null && currentUserId != user.id)
                FollowButton(userId: user.id),
            ],
          ),
        ),
      ),
    );
  }
}
