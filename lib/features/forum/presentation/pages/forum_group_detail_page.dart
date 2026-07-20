import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/forum_cubit.dart';
import '../bloc/forum_group_cubit.dart';
import '../widgets/post_card.dart';
import 'add_post_page.dart';
import 'forum_detail_page.dart';

class ForumGroupDetailPage extends StatelessWidget {
  final String groupId;
  const ForumGroupDetailPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ForumGroupCubit>()..loadGroupDetail(groupId)),
        BlocProvider(create: (_) => sl<ForumCubit>()..getPosts(groupId: groupId)),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const BisaAppBar(title: 'Group'),
        body: BlocBuilder<ForumGroupCubit, ForumGroupState>(
          builder: (context, gState) {
            if (gState is ForumGroupLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (gState is ForumGroupError) {
              return Center(child: Text(gState.message));
            }
            if (gState is! ForumGroupDetailLoaded) {
              return const SizedBox.shrink();
            }

            final group = gState.group;
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<ForumGroupCubit>().loadGroupDetail(groupId);
                await context.read<ForumCubit>().getPosts(groupId: groupId);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 140.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        BisaNetworkImage(imageUrl: group.bannerUrl, fit: BoxFit.cover),
                        Positioned(
                          left: 16.w,
                          bottom: 16.h,
                          right: 16.w,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26.r,
                                backgroundColor: AppColors.surface,
                                backgroundImage:
                                    group.avatarUrl != null ? NetworkImage(group.avatarUrl!) : null,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group.name,
                                      style: TextStyle(
                                        color: AppColors.surface,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '${group.memberCount} members • ${group.postCount} posts',
                                      style: TextStyle(
                                        color: AppColors.surface.withValues(alpha: 0.9),
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                    child: Text(
                      group.description?.isNotEmpty == true
                          ? group.description!
                          : 'Belum ada deskripsi grup.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: group.isMember ? 'Leave Group' : 'Join Group',
                            isOutlined: group.isMember,
                            height: AppSpacing.buttonHeightSm,
                            onPressed: () async {
                              final isAuth = context.read<AuthCubit>().state.maybeWhen(
                                authenticated: (_) => true,
                                orElse: () => false,
                              );
                              if (!isAuth) {
                                AuthSheet.show(context);
                                return;
                              }
                              if (group.isMember) {
                                await context.read<ForumGroupCubit>().leaveGroup(group.id);
                              } else {
                                await context.read<ForumGroupCubit>().joinGroup(group.id);
                              }
                              if (context.mounted) {
                                context.read<ForumGroupCubit>().loadGroupDetail(group.id);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomButton(
                            text: 'Post in Group',
                            height: AppSpacing.buttonHeightSm,
                            onPressed: group.isMember
                                ? () async {
                                    final created = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddPostPage(
                                          groupId: group.id,
                                          groupName: group.name,
                                        ),
                                      ),
                                    );
                                    if (created == true && context.mounted) {
                                      context.read<ForumCubit>().getPosts(groupId: group.id);
                                      context.read<ForumGroupCubit>().loadGroupDetail(group.id);
                                    }
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  BlocBuilder<ForumCubit, ForumState>(
                    builder: (context, pState) {
                      return pState.maybeWhen(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        loaded: (posts) {
                          if (posts.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 48.h),
                              child: Center(
                                child: Text(
                                  'Belum ada postingan di grup ini.',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: posts
                                .map(
                                  (post) => Padding(
                                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                                    child: PostCard(
                                      post: post,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ForumDetailPage(postId: post.id),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
