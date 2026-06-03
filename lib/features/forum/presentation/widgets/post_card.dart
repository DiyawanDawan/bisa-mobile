import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../follow/presentation/widgets/follow_button.dart';
import '../../domain/entities/forum_entity.dart';
import '../widgets/forum_media_widgets.dart';
import '../widgets/forum_content_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final ForumPostEntity post;
  final VoidCallback? onVoteUp;
  final VoidCallback? onVoteDown;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.post,
    this.onVoteUp,
    this.onVoteDown,
    this.onComment,
    this.onShare,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: User Info, Follow Button & Category
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _openAuthorProfile(context),
                      child: Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.primaryLight,
                          backgroundImage: resolveMediaImageProvider(post.user.avatarUrl),
                          child: post.user.avatarUrl == null
                              ? Icon(
                                  LucideIcons.user,
                                  size: 20.sp,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _openAuthorProfile(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    post.user.fullName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                if (post.user.isVerified == true)
                                  _buildVerifiedBadge(),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  timeago.format(post.createdAt, locale: 'id'),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '  ·  ',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textHint,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    (post.category ?? 'Umum'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Follow button untuk author post.
                    // Tidak tampil jika `userId == currentUser.id` (sudah
                    // dihandle di internal FollowButton).
                    FollowButton(userId: post.user.id),
                  ],
                ),
                SizedBox(height: 12.h),

                // Participants badge — "siapa saja yang terlibat di diskusi ini"
                if (post.participants.isNotEmpty || post.commentCount > 0)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _buildParticipantsBadge(),
                  ),

                // Title
                Text(
                  post.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 8.h),

                // Content Preview — render dengan rich text supaya
                // #hashtag & @produk muncul sebagai highlight clickable.
                ForumContentText(
                  content: post.contentPreview ?? post.content,
                  productMentions: post.productMentions,
                  maxLines: 3,
                  baseStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                ForumMediaGrid(media: post.mediaUrls, compact: true),
                if (post.tags.isNotEmpty ||
                    post.productMentions.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  _buildTagChipsRow(context),
                ],
                SizedBox(height: 20.h),

                // Footer Stats
                Row(
                  children: [
                    _buildStat(
                      icon: LucideIcons.arrowBigUp,
                      label: post.upvotes.toString(),
                      color: AppColors.primary,
                      isActive: post.userVote == 'UP',
                      gradient: post.userVote == 'UP'
                          ? AppColors.voteUpGradient
                          : null,
                      onTap: onVoteUp,
                    ),
                    SizedBox(width: 8.w),
                    _buildStat(
                      icon: LucideIcons.arrowBigDown,
                      label: post.downvotes.toString(),
                      color: AppColors.error,
                      isActive: post.userVote == 'DOWN',
                      gradient: post.userVote == 'DOWN'
                          ? AppColors.voteDownGradient
                          : null,
                      onTap: onVoteDown,
                    ),
                    SizedBox(width: 8.w),
                    _buildStat(
                      icon: LucideIcons.messageCircle,
                      label: post.commentCount.toString(),
                      color: AppColors.info,
                      onTap: onComment ?? onTap,
                    ),
                    SizedBox(width: 8.w),
                    _buildStat(
                      icon: LucideIcons.share2,
                      label: '',
                      color: AppColors.textSecondary,
                      onTap: onShare,
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.eye,
                            size: 14.sp,
                            color: AppColors.textHint,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            post.viewCount.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Row chips: kombinasi hashtag (#) + produk mention (@) di bawah konten.
  /// Tap hashtag → push `/forum?tag=...`, tap produk → push `/product/:id`.
  Widget _buildTagChipsRow(BuildContext context) {
    final tagChips = post.tags.take(5).map(
          (t) => _ForumChip(
            icon: LucideIcons.hash,
            label: t,
            color: AppColors.primary,
            onTap: () => context.push('/forum-tag/${Uri.encodeComponent(t)}'),
          ),
        );
    final mentionChips = post.productMentions.take(3).map(
          (m) => _ForumChip(
            icon: LucideIcons.package,
            label: m.name,
            color: AppColors.success,
            onTap: () => context.push('/product/${m.id}'),
          ),
        );
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: [...mentionChips, ...tagChips],
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required Color color,
    Color? backgroundColor,
    Gradient? gradient,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 36.h,
        constraints: BoxConstraints(minWidth: label.isEmpty ? 36.h : 0),
        padding: EdgeInsets.symmetric(horizontal: label.isEmpty ? 0 : 12.w),
        decoration: BoxDecoration(
          color: gradient == null
              ? (backgroundColor ?? color.withOpacity(0.08))
              : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp, color: isActive ? Colors.white : color),
            if (label.isNotEmpty) ...[
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isActive ? Colors.white : color,
                  fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Buka profil author post. Supplier diarahkan ke storefront `/supplier/:id`,
  /// non-supplier (Buyer) tidak punya halaman publik — fallback diam saja
  /// (user masih bisa Follow lewat tombol di kanan).
  void _openAuthorProfile(BuildContext context) {
    final role = post.user.role?.toUpperCase();
    if (role == 'SUPPLIER') {
      context.push(
        '/supplier/${post.user.id}',
        extra: {'name': post.user.fullName},
      );
    }
  }

  Widget _buildVerifiedBadge() {
    return Container(
      margin: EdgeInsets.only(left: 4.w),
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check, color: Colors.white, size: 8.sp),
    );
  }

  /// Badge "siapa saja yang terlibat" di diskusi ini.
  ///
  /// Tampilkan max 4 avatar bertumpuk dari `post.participants` (commenter
  /// terbaru, distinct), diikuti label jumlah balasan. Jika `commentCount`
  /// melebihi jumlah avatar yang ditampilkan, muncul chip "+N" di akhir.
  Widget _buildParticipantsBadge() {
    final participants = post.participants.take(4).toList();
    final avatarSize = 22.r;
    final overlap = 10.w;
    final shown = participants.length;
    final extra = post.commentCount - shown;

    final label = participants.isEmpty
        ? '${post.commentCount} balasan menunggu'
        : (post.commentCount <= shown
            ? '$shown orang berdiskusi'
            : '$shown+ orang berdiskusi');

    return Container(
      padding: EdgeInsets.fromLTRB(8.w, 6.h, 12.w, 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (participants.isEmpty)
            Icon(
              LucideIcons.messageSquareText,
              size: 14.sp,
              color: AppColors.primary,
            )
          else
            SizedBox(
              height: avatarSize,
              width: avatarSize + (shown - 1) * (avatarSize - overlap),
              child: Stack(
                children: [
                  for (int i = 0; i < shown; i++)
                    Positioned(
                      left: i * (avatarSize - overlap),
                      child: _AvatarBubble(
                        user: participants[i],
                        size: avatarSize,
                      ),
                    ),
                ],
              ),
            ),
          if (extra > 0) ...[
            SizedBox(width: 6.w),
            Container(
              height: avatarSize,
              constraints: BoxConstraints(minWidth: avatarSize),
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(avatarSize / 2),
                border: Border.all(color: Colors.white, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                extra > 99 ? '99+' : '+$extra',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar bulat kecil dengan border putih untuk efek stack.
class _AvatarBubble extends StatelessWidget {
  final ForumUserEntity user;
  final double size;

  const _AvatarBubble({required this.user, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: AppColors.primaryLight,
        backgroundImage: resolveMediaImageProvider(user.avatarUrl),
        child: user.avatarUrl == null
            ? Icon(
                LucideIcons.user,
                size: size * 0.5,
                color: AppColors.primary,
              )
            : null,
      ),
    );
  }
}

class _ForumChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ForumChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12.sp, color: color),
              SizedBox(width: 4.w),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 160.w),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
