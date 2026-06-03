import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../../../injection_container.dart';
import '../../../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../../../shared/widgets/auth_sheet.dart';
import '../../../../shared/widgets/bisa_app_bar.dart';
import '../../../follow/presentation/widgets/follow_button.dart';
import '../bloc/forum_cubit.dart';
import '../../domain/entities/forum_entity.dart';
import '../../domain/entities/forum_media.dart';
import '../widgets/forum_media_widgets.dart';
import '../../../../shared/widgets/forum_detail_skeleton.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForumDetailPage extends StatefulWidget {
  final String postId;

  const ForumDetailPage({super.key, required this.postId});

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  final _commentPicker = ImagePicker();
  String? _replyToId;
  String? _replyToUser;
  final Set<String> _expandedComments = {};
  final List<ForumMediaAttachment> _commentAttachments = [];
  bool _isSendingComment = false;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForumCubit>()..getPostDetail(widget.postId),
      child: Scaffold(
        backgroundColor: AppColors.grey50,
        appBar: BisaAppBar(
          backgroundColor: AppColors.grey50,
          actions: [BisaAppBarAction(icon: Icons.more_horiz, onTap: () {})],
        ),
        body: BlocBuilder<ForumCubit, ForumState>(
          builder: (builderContext, state) {
            return state.maybeWhen(
              loading: () => const ShimmerForumDetailPlaceholder(),
              error: (msg) => Center(child: Text(msg)),
              loaded: (posts) {
                final post = posts.firstWhere(
                  (element) => element.id == widget.postId,
                  orElse: () => posts.first,
                );
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main Content Section
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 24.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildAuthorInfo(post),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Main Thread Line
                                        Container(
                                          width: 2.w,
                                          margin: EdgeInsets.only(
                                            left: 25.w,
                                            right: 33.w,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.grey100,
                                            borderRadius: BorderRadius.circular(
                                              1.r,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 16.h),
                                              Text(
                                                post.title,
                                                style: TextStyle(
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w900,
                                                  color: AppColors.textPrimary,
                                                  height: 1.3,
                                                  letterSpacing: -0.8,
                                                ),
                                              ),
                                              SizedBox(height: 12.h),
                                              Text(
                                                post.content,
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  color: AppColors.textPrimary
                                                      .withOpacity(0.8),
                                                  height: 1.7,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              ForumMediaGrid(media: post.mediaUrls),
                                              SizedBox(height: 24.h),
                                              _buildInteractionBar(
                                                builderContext,
                                                post,
                                              ),
                                              SizedBox(height: 24.h),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Comments Header inside the same card
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                LucideIcons.messageSquare,
                                                color: Colors.white,
                                                size: 14.sp,
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                'Komentar (${post.commentCount})',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Terbaru',
                                          style: TextStyle(
                                            color: AppColors.textHint,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.textHint,
                                          size: 18.sp,
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (post.comments == null ||
                                      post.comments!.isEmpty)
                                    _buildEmptyComments()
                                  else
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: post.comments!.length,
                                      itemBuilder: (context, index) {
                                        final comment = post.comments![index];
                                        return _buildCommentItem(
                                          builderContext,
                                          comment,
                                          key: ValueKey(comment.id),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                    ),
                    _buildCommentInput(builderContext),
                  ],
                );
              },
              orElse: () => const ShimmerForumDetailPlaceholder(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Container(
      margin: EdgeInsets.only(left: 4.w),
      padding: EdgeInsets.all(2.r),
      decoration: const BoxDecoration(
        color: AppColors.secondary,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.check, color: Colors.white, size: 8.sp),
    );
  }

  Widget _buildMineBadge() {
    return Container(
      margin: EdgeInsets.only(left: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'Anda',
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }

  String _formatForumDateTime(DateTime dateTime) {
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dateTime);
  }

  Widget _buildCommentAuthorLine(
    ForumCommentEntity comment, {
    required bool isReply,
    required bool isMine,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                comment.user.fullName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: isReply ? FontWeight.w700 : FontWeight.w800,
                  fontSize: isReply ? 13.sp : 14.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (comment.user.isVerified == true) _buildVerifiedBadge(),
            if (isMine) _buildMineBadge(),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Icon(
              LucideIcons.calendar,
              size: 10.sp,
              color: AppColors.textHint,
            ),
            SizedBox(width: 4.w),
            Text(
              _formatForumDateTime(comment.createdAt),
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' · ${timeago.format(comment.createdAt, locale: 'id')}',
              style: TextStyle(
                color: AppColors.textHint.withValues(alpha: 0.85),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthorInfo(ForumPostEntity post) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CircleAvatar(
            radius: 26.r,
            backgroundColor: AppColors.grey100,
            backgroundImage: resolveMediaImageProvider(post.user.avatarUrl),
            child: post.user.avatarUrl == null
                ? Icon(LucideIcons.user, size: 26.sp, color: AppColors.textHint)
                : null,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    post.user.fullName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (post.user.isVerified == true) _buildVerifiedBadge(),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Icon(
                    LucideIcons.calendar,
                    size: 12.sp,
                    color: AppColors.textHint,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    _formatForumDateTime(post.createdAt),
                    style: TextStyle(
                      color: AppColors.textHint,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' · ${timeago.format(post.createdAt, locale: 'id')}',
                    style: TextStyle(
                      color: AppColors.textHint.withValues(alpha: 0.85),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        FollowButton(userId: post.user.id),
      ],
    );
  }

  Widget _buildInteractionBar(BuildContext context, ForumPostEntity post) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildStatItem(
            LucideIcons.arrowBigUp,
            post.upvotes.toString(),
            AppColors.primary,
            'Dukung',
            isActive: post.userVote == 'UP',
            gradient: post.userVote == 'UP'
                ? AppColors.voteUpGradient
                : null,
            onTap: () {
              final isAuthenticated = context.read<AuthCubit>().state.maybeWhen(
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
                postId: post.id,
              );
            },
          ),
          SizedBox(width: 8.w),
          _buildStatItem(
            LucideIcons.arrowBigDown,
            post.downvotes.toString(),
            AppColors.error,
            'Turun',
            isActive: post.userVote == 'DOWN',
            gradient: post.userVote == 'DOWN'
                ? AppColors.voteDownGradient
                : null,
            onTap: () {
              final isAuthenticated = context.read<AuthCubit>().state.maybeWhen(
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
                postId: post.id,
              );
            },
          ),
          SizedBox(width: 8.w),
          _buildStatItem(
            LucideIcons.messageCircle,
            post.commentCount.toString(),
            AppColors.info,
            'Komen',
            onTap: () {
              // Focus the comment input
            },
          ),
          SizedBox(width: 8.w),
          _buildStatItem(
            LucideIcons.share2,
            '',
            AppColors.textSecondary,
            'Share',
            onTap: () {
              Share.share(
                'Yuk diskusi di Komunitas BISA: ${post.title}\n\n${post.contentPreview ?? post.content}\n\nBaca selengkapnya di aplikasi BISA!',
              );
            },
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.eye, size: 14.sp, color: AppColors.textHint),
                SizedBox(width: 4.w),
                Text(
                  post.viewCount.toString(),
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    Color color,
    String title, {
    VoidCallback? onTap,
    Gradient? gradient,
    bool isActive = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: gradient == null ? color.withOpacity(0.08) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isActive ? Colors.transparent : color.withOpacity(0.1),
        ),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          height: 40.h,
          constraints: BoxConstraints(minWidth: label.isEmpty ? 40.h : 0),
          padding: EdgeInsets.symmetric(horizontal: label.isEmpty ? 0 : 12.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20.sp, color: isActive ? Colors.white : color),
              if (label.isNotEmpty) ...[
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : color,
                    fontWeight: isActive ? FontWeight.w900 : FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoteBadge(
    BuildContext context, {
    required IconData icon,
    required int count,
    required Color color,
    required bool isActive,
    required VoidCallback onTap,
    Gradient? gradient,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isActive ? null : color.withOpacity(0.08),
        gradient: isActive ? gradient : null,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp, color: isActive ? Colors.white : color),
              SizedBox(width: 4.w),
              if (count > 0)
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isActive ? Colors.white : color,
                    fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    ForumCommentEntity comment, {
    int depth = 0,
    Key? key,
  }) {
    final double leftPadding = depth == 0 ? 0 : (depth == 1 ? 36.w : 52.w);
    final bool isReply = depth > 0;
    final currentUserId = context.read<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user.id,
      orElse: () => null,
    );
    final isMine =
        currentUserId != null && comment.user.id == currentUserId;
    final hasContent = comment.content.trim().isNotEmpty;
    final hasMedia = comment.mediaUrls.isNotEmpty;
    final hasReplies =
        comment.replies != null && comment.replies!.isNotEmpty;
    final isExpanded = _expandedComments.contains(comment.id);

    return Padding(
      key: key,
      padding: EdgeInsets.only(bottom: 16.h, left: leftPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: isReply ? 1 : 2,
              ),
            ),
            child: CircleAvatar(
              radius: isReply ? 14.r : 18.r,
              backgroundColor: AppColors.grey100,
              backgroundImage:
                  resolveMediaImageProvider(comment.user.avatarUrl),
              child: comment.user.avatarUrl == null
                  ? Icon(
                      LucideIcons.user,
                      size: isReply ? 14.sp : 18.sp,
                      color: AppColors.textHint,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCommentAuthorLine(
                  comment,
                  isReply: isReply,
                  isMine: isMine,
                ),
                SizedBox(height: 6.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
                  decoration: isMine
                      ? BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.18),
                          ),
                        )
                      : BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasContent)
                        Text(
                          comment.content,
                          style: TextStyle(
                            fontSize: isReply ? 13.sp : 14.sp,
                            color: AppColors.textPrimary.withOpacity(0.9),
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      if (hasMedia)
                        ForumMediaGrid(
                          media: comment.mediaUrls,
                          layout: ForumMediaLayout.comment,
                        ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          _buildVoteBadge(
                            context,
                            icon: LucideIcons.arrowBigUp,
                            count: comment.upvotes,
                            color: AppColors.primary,
                            isActive: comment.userVote == 'UP',
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
                              context.read<ForumCubit>().toggleVote(
                                comment.id,
                                'COMMENT',
                                'UP',
                                postId: widget.postId,
                              );
                            },
                            gradient: AppColors.voteUpGradient,
                          ),
                          SizedBox(width: 8.w),
                          _buildVoteBadge(
                            context,
                            icon: LucideIcons.arrowBigDown,
                            count: comment.downvotes,
                            color: AppColors.error,
                            isActive: comment.userVote == 'DOWN',
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
                              context.read<ForumCubit>().toggleVote(
                                comment.id,
                                'COMMENT',
                                'DOWN',
                                postId: widget.postId,
                              );
                            },
                            gradient: AppColors.voteDownGradient,
                          ),
                          SizedBox(width: 20.w),
                          GestureDetector(
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
                              // Set reply state
                              setState(() {
                                _replyToId = comment.id;
                                _replyToUser = comment.user.fullName;
                              });
                              _commentFocusNode.requestFocus();
                            },
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.reply,
                                  size: 14.sp,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Balas',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w800,
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
                if (hasReplies) ...[
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedComments.remove(comment.id);
                        } else {
                          _expandedComments.add(comment.id);
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 1.h,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          isExpanded
                              ? 'Sembunyikan balasan'
                              : 'Lihat ${comment.replies!.length} balasan',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 16.sp,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
                if (hasReplies && isExpanded && depth < 3)
                  ...comment.replies!.map(
                    (reply) => Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: _buildCommentItem(
                        context,
                        reply,
                        depth: depth + 1,
                        key: ValueKey(reply.id),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_commentAttachments.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            color: Colors.white,
            child: ForumMediaPickerRow(
              attachments: _commentAttachments,
              maxItems: 4,
              onRemove: (i) => setState(() => _commentAttachments.removeAt(i)),
              onPickImage: _pickCommentImages,
              onPickVideo: _pickCommentVideo,
            ),
          ),
        if (_replyToId != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            color: AppColors.primary.withOpacity(0.05),
            child: Row(
              children: [
                Icon(LucideIcons.reply, size: 14.sp, color: AppColors.primary),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Membalas @${_replyToUser}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _replyToId = null;
                    _replyToUser = null;
                  }),
                  child: Icon(
                    LucideIcons.x,
                    size: 16.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: EdgeInsets.fromLTRB(
            20.w,
            12.h,
            20.w,
            20.h + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_replyToId != null ? 0 : 30.r),
              topRight: Radius.circular(_replyToId != null ? 0 : 30.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 25,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    LucideIcons.image,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                  onPressed: _isSendingComment ? null : _pickCommentImages,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.grey100),
                    ),
                    child: TextField(
                      controller: _commentController,
                      focusNode: _commentFocusNode,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: _replyToId != null
                            ? 'Tulis balasan Anda...'
                            : 'Tulis tanggapan Anda...',
                        hintStyle: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                GestureDetector(
                  onTap: _isSendingComment ? null : () => _submitComment(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 48.h,
                    width: 48.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      LucideIcons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyComments() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.messageSquare,
                size: 40.sp,
                color: AppColors.grey200,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Jadilah yang pertama berkomentar!',
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCommentImages() async {
    if (_commentAttachments.length >= 4) return;
    final files = await _commentPicker.pickMultiImage(imageQuality: 85);
    if (files.isEmpty) return;
    setState(() {
      for (final file in files) {
        if (_commentAttachments.length >= 4) break;
        _commentAttachments.add(
          ForumMediaAttachment(localPath: file.path, type: 'image'),
        );
      }
    });
  }

  Future<void> _pickCommentVideo() async {
    if (_commentAttachments.length >= 4) return;
    final file = await _commentPicker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;
    setState(() {
      _commentAttachments.add(
        ForumMediaAttachment(localPath: file.path, type: 'video'),
      );
    });
  }

  Future<void> _submitComment(BuildContext context) async {
    final isAuthenticated = context.read<AuthCubit>().state.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        );
    if (!isAuthenticated) {
      AuthSheet.show(context);
      return;
    }

    final text = _commentController.text.trim();
    final hasMedia = _commentAttachments.isNotEmpty;
    if (text.isEmpty && !hasMedia) return;

    final parent = _replyToId;
    final attachments = List<ForumMediaAttachment>.from(_commentAttachments);
    final savedText = text;
    final savedAttachments = attachments;

    setState(() {
      _isSendingComment = true;
      if (parent != null) {
        _expandedComments.add(parent);
      }
    });
    _commentController.clear();
    _commentAttachments.clear();
    _replyToId = null;
    _replyToUser = null;
    FocusScope.of(context).unfocus();

    final error = await context.read<ForumCubit>().addComment(
          widget.postId,
          savedText,
          parentId: parent,
          attachments: savedAttachments,
        );

    if (!context.mounted) return;
    setState(() => _isSendingComment = false);
    if (error != null) {
      _commentController.text = savedText;
      setState(() {
        _commentAttachments
          ..clear()
          ..addAll(savedAttachments);
        _replyToId = parent;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
