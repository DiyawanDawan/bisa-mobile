import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
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

  static const _tabs = [
    _TabInfo('Diterbitkan', 'PUBLISHED', LucideIcons.circleCheck),
    _TabInfo('Draft', 'DRAFT', LucideIcons.fileText),
    _TabInfo('Arsip', 'ARCHIVED', LucideIcons.archive),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
    _cubit.getMyPosts(status: _tabs[_tabController.index].status);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          title: 'Postingan Saya',
          backgroundColor: Colors.white,
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
              color: Colors.white,
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
                tabs: _tabs
                    .map(
                      (t) => Tab(
                        height: 44.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(t.icon, size: 14.sp),
                            SizedBox(width: 6.w),
                            Text(t.label),
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
                  padding: EdgeInsets.all(16.w),
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
                        SizedBox(height: 80.h),
                        _emptyState(_tabs[_tabController.index]),
                      ],
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 80.h),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
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
                    SizedBox(height: 80.h),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            Icon(
                              LucideIcons.circleAlert,
                              size: 48.sp,
                              color: AppColors.error,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              msg,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            TextButton(
                              onPressed: _loadCurrentTab,
                              child: const Text('Coba Lagi'),
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

  Widget _emptyState(_TabInfo tab) {
    final messages = {
      'PUBLISHED': (
        'Belum ada postingan yang dipublikasikan',
        'Diskusi yang Anda terbitkan akan muncul di sini & terlihat oleh komunitas.',
      ),
      'DRAFT': (
        'Belum ada draft',
        'Simpan tulisan yang belum siap dipublikasikan untuk diedit nanti.',
      ),
      'ARCHIVED': (
        'Belum ada postingan terarsip',
        'Postingan yang dihapus atau diarsipkan akan muncul di sini.',
      ),
    };
    final (title, subtitle) = messages[tab.status]!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          children: [
            Icon(tab.icon, size: 56.sp, color: AppColors.grey300),
            SizedBox(height: 16.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
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
              label: const Text('Buat Postingan Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 12.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
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
        title: const Text('Hapus diskusi?'),
        content: Text(
          'Diskusi "${post.title}" akan dipindahkan ke arsip. Anda bisa lihat di tab Arsip.',
          style: TextStyle(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dCtx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dCtx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await _cubit.deletePost(post.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Diskusi dipindahkan ke arsip' : 'Gagal menghapus diskusi',
        ),
        backgroundColor: ok ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
    if (ok) _loadCurrentTab();
  }

  Future<void> _onChangeStatus(ForumPostEntity post, String status) async {
    await _cubit.updatePost(post.id, status: status);
    // ForumCubit listener akan emit success → re-load tab.
  }
}

class _TabInfo {
  final String label;
  final String status;
  final IconData icon;
  const _TabInfo(this.label, this.status, this.icon);
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
    final dateText = DateFormat('dd MMM yyyy • HH:mm').format(post.createdAt);
    final hasMedia = post.mediaUrls.isNotEmpty;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: post.status == 'PUBLISHED' ? onView : onEdit,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.all(14.w),
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
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasMedia)
                    Container(
                      width: 56.w,
                      height: 56.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.grey100,
                        borderRadius: BorderRadius.circular(10.r),
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
              SizedBox(height: 10.h),
              Row(
                children: [
                  _statChip(
                    LucideIcons.thumbsUp,
                    '${post.upvotes}',
                    AppColors.success,
                  ),
                  SizedBox(width: 8.w),
                  _statChip(
                    LucideIcons.messageCircle,
                    '${post.commentCount}',
                    AppColors.info,
                  ),
                  SizedBox(width: 8.w),
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
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
        return _StatusInfo('Draft', LucideIcons.fileText, AppColors.warning);
      case 'ARCHIVED':
        return _StatusInfo('Arsip', LucideIcons.archive, AppColors.grey500);
      default:
        return _StatusInfo(
          'Terbit',
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
      tooltip: 'Aksi',
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
          const PopupMenuItem(
            value: 'view',
            child: _MenuRow(LucideIcons.eye, 'Lihat di feed'),
          ),
        const PopupMenuItem(
          value: 'edit',
          child: _MenuRow(LucideIcons.pencil, 'Edit'),
        ),
        if (status == 'DRAFT')
          const PopupMenuItem(
            value: 'publish',
            child: _MenuRow(LucideIcons.send, 'Terbitkan'),
          ),
        if (status == 'PUBLISHED')
          const PopupMenuItem(
            value: 'draft',
            child: _MenuRow(LucideIcons.fileText, 'Pindah ke Draft'),
          ),
        if (status == 'PUBLISHED' || status == 'DRAFT')
          const PopupMenuItem(
            value: 'archive',
            child: _MenuRow(LucideIcons.archive, 'Arsipkan'),
          ),
        const PopupMenuItem(
          value: 'delete',
          child: _MenuRow(LucideIcons.trash2, 'Hapus', danger: true),
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
