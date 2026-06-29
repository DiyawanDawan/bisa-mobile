import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/i18n/locale_formatters.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/features/forum/domain/entities/forum_entity.dart';
import 'package:mobile_bisa/features/forum/presentation/bloc/forum_cubit.dart';
import 'package:mobile_bisa/features/forum/presentation/pages/add_post_page.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:mobile_bisa/shared/widgets/bisa_network_image.dart';

/// Halaman manajemen postingan forum milik user sendiri.
///
/// Tab:
/// - **Diterbitkan** (`PUBLISHED`) — sudah tayang di feed publik.
/// - **Draft** (`DRAFT`) — disimpan untuk di-edit, tidak muncul di feed.
/// - **Arsip** (`ARCHIVED`) — dihapus atau diarsipkan (otomatis kalau
///   downvotes melewati threshold moderasi).
///
/// Setiap card punya overflow menu: Edit / Terbitkan / Simpan Draft / Hapus.
class MyForumPostsPage extends StatefulWidget {
  const MyForumPostsPage({super.key});

  @override
  State<MyForumPostsPage> createState() => _MyForumPostsPageState();
}

class _MyForumPostsPageState extends State<MyForumPostsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ForumCubit _cubit;

  static const _tabMeta = [
    ('forum.tab_published', 'PUBLISHED', LucideIcons.circleCheck),
    ('forum.tab_draft', 'DRAFT', LucideIcons.fileText),
    ('forum.tab_archived', 'ARCHIVED', LucideIcons.archive),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabMeta.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _loadCurrentTab();
    });
    _cubit = sl<ForumCubit>();
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentTab());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _loadCurrentTab() {
    _cubit.getMyPosts(status: _tabMeta[_tabController.index].$2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'forum.my_posts_title'.tr(),
          backgroundColor: AppColors.surface,
          actions: [
            BisaAppBarAction(
              icon: LucideIcons.plus,
              onTap: () async {
                final created = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPostPage()),
                );
                if (created == true) _loadCurrentTab();
              },
              backgroundColor: AppColors.grey50,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: Container(
              color: AppColors.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                tabs: _tabMeta
                    .map(
                      (t) => Tab(
                        height: 44.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(t.$3, size: 14.sp),
                            SizedBox(width: 6.w),
                            Text(t.$1.tr()),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        body: BlocConsumer<ForumCubit, ForumState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                _loadCurrentTab();
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => _loadCurrentTab(),
              child: state.maybeWhen(
                loading: () => Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: const ShimmerListPlaceholder(
                    itemCount: 4,
                    itemHeight: 120,
                  ),
                ),
                loaded: (posts) {
                  if (posts.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: mainShellBottomPadding(
                            context,
                            kind: MainShellScrollKind.forum,
                          ),
                        ),
                        _emptyState(_tabMeta[_tabController.index].$2),
                      ],
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      16.w,
                      14.h,
                      16.w,
                      mainShellBottomPadding(
                        context,
                        kind: MainShellScrollKind.forum,
                      ),
                    ),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md12),
                    itemBuilder: (_, i) => _PostManageCard(
                      post: posts[i],
                      onEdit: () => _onEdit(posts[i]),
                      onDelete: () => _onDelete(posts[i]),
                      onPublish: () => _onChangeStatus(posts[i], 'PUBLISHED'),
                      onDraft: () => _onChangeStatus(posts[i], 'DRAFT'),
                      onArchive: () => _onChangeStatus(posts[i], 'ARCHIVED'),
                      onView: () =>
                          context.push('/forum-detail/${posts[i].id}'),
                    ),
                  );
                },
                error: (msg) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: mainShellBottomPadding(
                        context,
                        kind: MainShellScrollKind.forum,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.circleAlert,
                              size: 48.sp,
                              color: AppColors.error,
                            ),
                            SizedBox(height: AppSpacing.md12),
                            Text(
                              msg,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: AppSpacing.md),
                            TextButton(
                              onPressed: _loadCurrentTab,
                              child: Text('coba_lagi'.tr()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _emptyState(String status) {
    final (titleKey, subtitleKey, icon) = switch (status) {
      'DRAFT' => (
          'forum.empty_draft_title',
          'forum.empty_draft_subtitle',
          LucideIcons.fileText,
        ),
      'ARCHIVED' => (
          'forum.empty_archived_title',
          'forum.empty_archived_subtitle',
          LucideIcons.archive,
        ),
      _ => (
          'forum.empty_published_title',
          'forum.empty_published_subtitle',
          LucideIcons.circleCheck,
        ),
    };
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          children: [
            Icon(icon, size: 56.sp, color: AppColors.grey300),
            SizedBox(height: AppSpacing.md),
            Text(
              titleKey.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              subtitleKey.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton.icon(
              onPressed: () async {
                final created = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPostPage()),
                );
                if (created == true) _loadCurrentTab();
              },
              icon: const Icon(LucideIcons.plus, size: 16),
              label: Text('forum.create_new'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onEdit(ForumPostEntity post) async {
    final edited = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddPostPage(editPost: post)),
    );
    if (edited == true) _loadCurrentTab();
  }

  Future<void> _onDelete(ForumPostEntity post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('forum.delete_title'.tr()),
        content: Text(
          'forum.delete_message'.tr(namedArgs: {'title': post.title}),
          style: TextStyle(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx, false),
            child: Text('batal'.tr()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dCtx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: Text('hapus'.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await _cubit.deletePost(post.id);
    if (!mounted) return;
    if (ok) {
      showSuccessSnackBar(context, 'forum.archived_success');
    } else {
      showErrorSnackBar(context, 'forum.delete_failed');
    }
    if (ok) _loadCurrentTab();
  }

  Future<void> _onChangeStatus(ForumPostEntity post, String status) async {
    await _cubit.updatePost(post.id, status: status);
    // ForumCubit listener akan emit success → re-load tab.
  }
}

class _PostManageCard extends StatelessWidget {
  final ForumPostEntity post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPublish;
  final VoidCallback onDraft;
  final VoidCallback onArchive;
  final VoidCallback onView;

  const _PostManageCard({
    required this.post,
    required this.onEdit,
    required this.onDelete,
    required this.onPublish,
    required this.onDraft,
    required this.onArchive,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfoFor(post.status);
    final dateText = context.formatDateTime(post.createdAt);
    final hasMedia = post.mediaUrls.isNotEmpty;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.tile),
      child: InkWell(
        onTap: post.status == 'PUBLISHED' ? onView : onEdit,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.section),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _statusBadge(statusInfo),
                  const Spacer(),
                  Text(
                    dateText,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasMedia)
                    Container(
                      width: 56.w,
                      height: 56.w,
                      margin: EdgeInsets.only(right: AppSpacing.md12),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: post.mediaUrls.first.isImage
                          ? BisaNetworkImage(
                              imageUrl: post.mediaUrls.first.url,
                              width: 56.w,
                              height: 56.w,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              LucideIcons.play,
                              color: AppColors.grey500,
                              size: 20.sp,
                            ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          post.contentPreview ?? post.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm10),
              Row(
                children: [
                  _statChip(
                    LucideIcons.thumbsUp,
                    '${post.upvotes}',
                    AppColors.success,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  _statChip(
                    LucideIcons.messageCircle,
                    '${post.commentCount}',
                    AppColors.info,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  _statChip(
                    LucideIcons.eye,
                    '${post.viewCount}',
                    AppColors.textSecondary,
                  ),
                  const Spacer(),
                  _PostActionsMenu(
                    status: post.status,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onPublish: onPublish,
                    onDraft: onDraft,
                    onArchive: onArchive,
                    onView: onView,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(_StatusInfo info) => Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: info.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(info.icon, size: 11.sp, color: info.color),
            SizedBox(width: 4.w),
            Text(
              info.label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: info.color,
              ),
            ),
          ],
        ),
      );

  Widget _statChip(IconData icon, String label, Color color) => Row(
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      );

  static _StatusInfo _statusInfoFor(String status) {
    switch (status) {
      case 'DRAFT':
        return _StatusInfo(
          'forum.status_draft_badge'.tr(),
          LucideIcons.fileText,
          AppColors.warning,
        );
      case 'ARCHIVED':
        return _StatusInfo(
          'forum.status_archived_badge'.tr(),
          LucideIcons.archive,
          AppColors.grey500,
        );
      default:
        return _StatusInfo(
          'forum.status_live_badge'.tr(),
          LucideIcons.circleCheck,
          AppColors.success,
        );
    }
  }
}

class _StatusInfo {
  final String label;
  final IconData icon;
  final Color color;
  const _StatusInfo(this.label, this.icon, this.color);
}

class _PostActionsMenu extends StatelessWidget {
  final String status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPublish;
  final VoidCallback onDraft;
  final VoidCallback onArchive;
  final VoidCallback onView;

  const _PostActionsMenu({
    required this.status,
    required this.onEdit,
    required this.onDelete,
    required this.onPublish,
    required this.onDraft,
    required this.onArchive,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(LucideIcons.ellipsisVertical, size: 18),
      tooltip: 'forum.actions_tooltip'.tr(),
      onSelected: (v) {
        switch (v) {
          case 'view':
            onView();
            break;
          case 'edit':
            onEdit();
            break;
          case 'publish':
            onPublish();
            break;
          case 'draft':
            onDraft();
            break;
          case 'archive':
            onArchive();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (_) => [
        if (status == 'PUBLISHED')
          PopupMenuItem(
            value: 'view',
            child: _MenuRow(
              LucideIcons.eye,
              'forum.menu_view_feed'.tr(),
            ),
          ),
        PopupMenuItem(
          value: 'edit',
          child: _MenuRow(LucideIcons.pencil, 'forum.menu_edit'.tr()),
        ),
        if (status == 'DRAFT')
          PopupMenuItem(
            value: 'publish',
            child: _MenuRow(
              LucideIcons.send,
              'forum.menu_publish'.tr(),
            ),
          ),
        if (status == 'PUBLISHED')
          PopupMenuItem(
            value: 'draft',
            child: _MenuRow(
              LucideIcons.fileText,
              'forum.menu_to_draft'.tr(),
            ),
          ),
        if (status == 'PUBLISHED' || status == 'DRAFT')
          PopupMenuItem(
            value: 'archive',
            child: _MenuRow(
              LucideIcons.archive,
              'forum.menu_archive'.tr(),
            ),
          ),
        PopupMenuItem(
          value: 'delete',
          child: _MenuRow(
            LucideIcons.trash2,
            'forum.menu_delete'.tr(),
            danger: true,
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;
  const _MenuRow(this.icon, this.label, {this.danger = false});

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : AppColors.textPrimary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}
