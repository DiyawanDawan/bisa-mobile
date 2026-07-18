import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../bloc/forum_group_cubit.dart';

class ForumGroupsPage extends StatefulWidget {
  const ForumGroupsPage({super.key});

  @override
  State<ForumGroupsPage> createState() => _ForumGroupsPageState();
}

class _ForumGroupsPageState extends State<ForumGroupsPage> {
  bool _mineOnly = false;
  bool _pendingMineSwitch = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ForumGroupCubit>()..loadGroups(mine: _mineOnly),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (_) {
              if (!_pendingMineSwitch) return;
              _pendingMineSwitch = false;
              setState(() => _mineOnly = true);
              context.read<ForumGroupCubit>().loadGroups(mine: true);
            },
            orElse: () {},
          );
        },
        child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'Forum Groups',
          backgroundColor: AppColors.surface,
          actions: [
            BisaAppBarAction(
              icon: LucideIcons.plus,
              onTap: () async {
                final isAuth = context.read<AuthCubit>().state.maybeWhen(
                  authenticated: (_) => true,
                  orElse: () => false,
                );
                if (!isAuth) {
                  AuthSheet.show(context);
                  return;
                }
                final created = await context.push('/forum-groups/create');
                if (created == true && context.mounted) {
                  context.read<ForumGroupCubit>().loadGroups(mine: _mineOnly);
                }
              },
              backgroundColor: AppColors.grey50,
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Discover',
                      height: 40.h,
                      isOutlined: _mineOnly,
                      onPressed: () {
                        setState(() => _mineOnly = false);
                        context.read<ForumGroupCubit>().loadGroups(mine: false);
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: CustomButton(
                      text: 'My Groups',
                      height: 40.h,
                      isOutlined: !_mineOnly,
                      onPressed: () {
                        final isAuth = context.read<AuthCubit>().state.maybeWhen(
                          authenticated: (_) => true,
                          orElse: () => false,
                        );
                        if (!isAuth) {
                          _pendingMineSwitch = true;
                          AuthSheet.show(context);
                          return;
                        }
                        setState(() => _mineOnly = true);
                        context.read<ForumGroupCubit>().loadGroups(mine: true);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ForumGroupCubit, ForumGroupState>(
                builder: (context, state) {
                  if (state is ForumGroupLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ForumGroupError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: 12.h),
                            CustomButton(
                              text: 'Coba lagi',
                              height: 40.h,
                              onPressed: () => context
                                  .read<ForumGroupCubit>()
                                  .loadGroups(mine: _mineOnly),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ForumGroupListLoaded) {
                    if (state.groups.isEmpty) {
                      return Center(
                        child: Text(
                          _mineOnly ? 'Belum join grup.' : 'Belum ada grup.',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => context
                          .read<ForumGroupCubit>()
                          .loadGroups(mine: _mineOnly),
                      child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                      itemCount: state.groups.length,
                      itemBuilder: (context, index) {
                        final g = state.groups[index];
                        return InkWell(
                          onTap: () => context.push('/forum-groups/${g.id}'),
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: AppColors.grey100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.r),
                                  ),
                                  child: SizedBox(
                                    height: 96.h,
                                    width: double.infinity,
                                    child: BisaNetworkImage(
                                      imageUrl: g.bannerUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: AppColors.grey100,
                                        backgroundImage: g.avatarUrl != null
                                            ? NetworkImage(g.avatarUrl!)
                                            : null,
                                        child: g.avatarUrl == null
                                            ? const Icon(LucideIcons.users)
                                            : null,
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              g.name,
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              '${g.memberCount} members • ${g.postCount} posts',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (g.isMember)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.success.withValues(alpha: 0.14),
                                            borderRadius: BorderRadius.circular(20.r),
                                          ),
                                          child: Text(
                                            'Joined',
                                            style: TextStyle(
                                              color: AppColors.success,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10.sp,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}