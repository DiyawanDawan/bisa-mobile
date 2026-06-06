import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/features/forum/presentation/bloc/forum_cubit.dart';
import 'package:mobile_bisa/features/forum/presentation/widgets/post_card.dart';
import 'package:mobile_bisa/features/forum/presentation/pages/add_post_page.dart';
import 'package:mobile_bisa/features/forum/presentation/pages/forum_detail_page.dart';
import 'package:mobile_bisa/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:mobile_bisa/shared/widgets/auth_sheet.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/shared/widgets/notification_bell_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mobile_bisa/shared/widgets/bisa_filter_chip.dart';
import 'package:mobile_bisa/shared/widgets/bisa_avatar.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';

class ForumPage extends StatefulWidget {
  /// Tag awal yang otomatis di-apply ke filter saat halaman dibuka — dipakai
  /// untuk deep-link dari chip `#tag` di post lain (lihat route `/forum-tag/:tag`).
  final String? initialTag;

  const ForumPage({super.key, this.initialTag});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  String _selectedCategory = 'Semua';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String? _activeTag;

  @override
  void initState() {
    super.initState();
    _activeTag = widget.initialTag;
    if (_activeTag != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ForumCubit>().getPosts(tag: _activeTag);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearTagFilter() {
    setState(() => _activeTag = null);
    context.read<ForumCubit>().getPosts(clearTag: true);
  }

  final List<String> _categories = [
    'Semua',
    'Hama',
    'Pupuk',
    'Harga Pasar',
    'Tips & Trik',
    'Teknologi',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_) {
            context.read<ForumCubit>().getPosts();
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BisaAppBar(
          showBackButton: false,
          centerTitle: false,
          title: _isSearching ? null : 'Komunitas BISA',
          titleWidget: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Cari diskusi...',
                    hintStyle: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    context.read<ForumCubit>().getPosts(
                      keyword: value.isNotEmpty ? value : null,
                    );
                  },
                )
              : null,
          backgroundColor: AppColors.surface,
          actions: [
            const NotificationBellButton(),
            // Shortcut ke halaman manajemen postingan sendiri — hanya muncul
            // kalau user sudah login. Memenuhi request "tau mana postingan
            // forum saya, bisa edit, hapus, atau draft".
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final isAuthenticated = authState.maybeWhen(
                  authenticated: (_) => true,
                  orElse: () => false,
                );
                if (!isAuthenticated) return const SizedBox.shrink();
                return BisaAppBarAction(
                  icon: LucideIcons.fileText,
                  onTap: () => context.push('/my-forum-posts'),
                  backgroundColor: AppColors.grey50,
                );
              },
            ),
            BisaAppBarAction(
              icon: _isSearching ? LucideIcons.x : LucideIcons.search,
              onTap: () {
                setState(() {
                  if (_isSearching) {
                    _isSearching = false;
                    _searchController.clear();
                    context.read<ForumCubit>().getPosts();
                  } else {
                    _isSearching = true;
                  }
                });
              },
              backgroundColor: AppColors.grey50,
            ),
          ],
        ),
        body: BlocBuilder<ForumCubit, ForumState>(
          builder: (context, state) {
            return state.maybeWhen(
              initial: () => const SizedBox.shrink(),
              loading: () => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: const ShimmerListPlaceholder(itemCount: 5, itemHeight: 120),
              ),
              success: () => const SizedBox.shrink(),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.badgeAlert,
                      size: 48.sp,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      message,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              loaded: (posts) {
                // Apply Category Filter
                final filteredPosts = _selectedCategory == 'Semua'
                    ? posts
                    : posts
                          .where((p) => p.category == _selectedCategory)
                          .toList();

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async => context.read<ForumCubit>().getPosts(),
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom: mainShellBottomPadding(
                        context,
                        kind: MainShellScrollKind.forum,
                      ),
                    ),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if (_activeTag != null) _buildActiveTagBanner(),
                      // Create Post Header
                      Container(
                        margin: EdgeInsets.all(20.r),
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, authState) {
                                final avatar = authState.maybeWhen(
                                  authenticated: (user) => user.avatar,
                                  orElse: () => null,
                                );
                                return BisaAvatar(
                                  imageUrl: avatar,
                                  radius: 20.r,
                                );
                              },
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final isAuthenticated = context
                                      .read<AuthCubit>()
                                      .state
                                      .maybeWhen(
                                        authenticated: (_) => true,
                                        orElse: () => false,
                                      );
                                  if (!isAuthenticated) {
                                    AuthSheet.show(context);
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddPostPage(),
                                    ),
                                  ).then((value) {
                                    if (!context.mounted) return;
                                    if (value == true) {
                                      context.read<ForumCubit>().getPosts();
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.grey50,
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                  child: Text(
                                    'Bagikan pengalaman atau tanya sesuatu...',
                                    style: TextStyle(
                                      color: AppColors.textHint,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Icon(
                              LucideIcons.image,
                              color: AppColors.grey400,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: SizedBox(
                          height: 36.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            itemCount: _categories.length,
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              final isSelected = _selectedCategory == category;
                              return Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Center(
                                  child: BisaFilterChip(
                                    label: category,
                                    isSelected: isSelected,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Posts List
                      if (filteredPosts.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 40.h),
                              Icon(
                                LucideIcons.messageSquare,
                                size: 64.sp,
                                color: AppColors.grey200,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                _selectedCategory == 'Semua'
                                    ? 'belum_ada_diskusi'.tr()
                                    : 'Belum ada diskusi untuk kategori ini',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...filteredPosts
                            .map(
                              (post) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: PostCard(
                                  post: post,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForumDetailPage(postId: post.id),
                                    ),
                                  ),
                                  onVoteUp: () {
                                    final isAuthenticated = context
                                        .read<AuthCubit>()
                                        .state
                                        .maybeWhen(
                                          authenticated: (_) => true,
                                          orElse: () => false,
                                        );
                                    if (!isAuthenticated) {
                                      AuthSheet.show(context);
                                      return;
                                    }
                                    context.read<ForumCubit>().toggleVote(
                                      post.id,
                                      'POST',
                                      'UP',
                                    );
                                  },
                                  onVoteDown: () {
                                    final isAuthenticated = context
                                        .read<AuthCubit>()
                                        .state
                                        .maybeWhen(
                                          authenticated: (_) => true,
                                          orElse: () => false,
                                        );
                                    if (!isAuthenticated) {
                                      AuthSheet.show(context);
                                      return;
                                    }
                                    context.read<ForumCubit>().toggleVote(
                                      post.id,
                                      'POST',
                                      'DOWN',
                                    );
                                  },
                                  onComment: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForumDetailPage(postId: post.id),
                                    ),
                                  ),
                                  onShare: () {
                                    Share.share(
                                      'Baca diskusi menarik di BISA Community: ${post.title}\n\n${post.contentPreview ?? post.content}',
                                      subject: post.title,
                                    );
                                  },
                                ),
                              ),
                            )
                            .toList(),
                    ],
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  /// Banner di atas list saat ada tag yang aktif. Ada tombol X untuk
  /// menghapus filter (kembali ke feed normal).
  Widget _buildActiveTagBanner() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.hash, size: 14.sp, color: AppColors.primary),
          SizedBox(width: 6.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                ),
                children: [
                  const TextSpan(text: 'Menampilkan diskusi dengan tag '),
                  TextSpan(
                    text: _activeTag,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: _clearTagFilter,
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(LucideIcons.x, size: 16.sp, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
