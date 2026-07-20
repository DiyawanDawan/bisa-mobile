import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../domain/entities/forum_group_entity.dart';
import '../bloc/forum_group_cubit.dart';

class ForumPublicGroupsSection extends StatelessWidget {
  const ForumPublicGroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForumGroupCubit>()..loadGroups(mine: false),
      child: BlocBuilder<ForumGroupCubit, ForumGroupState>(
        builder: (context, state) {
          if (state is ForumGroupLoading || state is ForumGroupInitial) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: SizedBox(
                height: 112.h,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            );
          }

          if (state is ForumGroupError) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.read<ForumGroupCubit>().loadGroups(mine: false),
                    child: Text('forum.groups_retry'.tr()),
                  ),
                ],
              ),
            );
          }

          if (state is! ForumGroupListLoaded || state.groups.isEmpty) {
            return const SizedBox.shrink();
          }

          final groups = state.groups.take(8).toList();
          return Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'forum.groups_public_title'.tr(),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/forum-groups'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'forum.groups_see_all'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                SizedBox(
                  height: 118.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    itemCount: groups.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      return _PublicGroupCard(group: groups[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PublicGroupCard extends StatelessWidget {
  final ForumGroupEntity group;

  const _PublicGroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/forum-groups/${group.id}'),
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: 220.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.grey100),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 64.h,
              width: double.infinity,
              child: BisaNetworkImage(
                imageUrl: group.bannerUrl,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: AppColors.grey100,
                      backgroundImage: group.avatarUrl != null
                          ? NetworkImage(group.avatarUrl!)
                          : null,
                      child: group.avatarUrl == null
                          ? Icon(LucideIcons.users, size: 14.sp)
                          : null,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'forum.groups_meta'.tr(
                              namedArgs: {
                                'members': '${group.memberCount}',
                                'posts': '${group.postCount}',
                              },
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
