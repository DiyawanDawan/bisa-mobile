import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/i18n/failure_messages.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
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
import 'package:mobile_bisa/core/i18n/locale_formatters.dart';

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
              error: (msg) => Center(child: Text(msg.localizedFailure)),
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
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(AppSpacing.xxlPx.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.black.withOpacity(0.04),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.xl,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildAuthorInfo(context, post),
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
                                              SizedBox(height: AppSpacing.md),
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
                                              SizedBox(height: AppSpacing.md12),
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
                                              SizedBox(height: AppSpacing.xl),
                                              _buildInteractionBar(
                                                builderContext,
                                                post,
                                              ),
                                              SizedBox(height: AppSpacing.xl),
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
                                                color: AppColors.surface,
                                                size: 14.sp,
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                'forum.comments_count'.tr(namedArgs: {
                                                  'count': '${post.commentCount}',
                                                }),
                                                style: TextStyle(
                                                  color: AppColors.surface,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'forum.sort_latest'.tr(),
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
      child: Icon(Icons.check, color: AppColors.textOnPrimary, size: 8.sp),
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
        'forum.you_badge'.tr(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }

  String _formatForumDateTime(BuildContext context, DateTime dateTime) {
    return context.formatDateTime(dateTime);
  }

  Widget _buildCommentAuthorLine(
    BuildContext context,
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
              _formatForumDateTime(context, comment.createdAt),
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              ' · ${context.formatTimeAgo(comment.createdAt)}',
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

  Widget _buildAuthorInfo(BuildContext context, ForumPostEntity post) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.1),
              ],
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
        SizedBox(width: AppSpacing.md),
        Expanded(
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
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
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
                  Flexible(
                    child: Text(
                      '${_formatForumDateTime(context, post.createdAt)} · ${context.formatTimeAgo(post.createdAt)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
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
            'forum.vote_up'.tr(),
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
          SizedBox(width: AppSpacing.sm),
          _buildStatItem(
            LucideIcons.arrowBigDown,
            post.downvotes.toString(),
            AppColors.error,
            'forum.vote_down'.tr(),
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
          SizedBox(width: AppSpacing.sm),
          _buildStatItem(
            LucideIcons.messageCircle,
            post.commentCount.toString(),
            AppColors.info,
            'forum.comment'.tr(),
            onTap: () {
              // Focus the comment input
            },
          ),
          SizedBox(width: AppSpacing.sm),
          _buildStatItem(
            LucideIcons.share2,
            '',
            AppColors.textSecondary,
            'forum.share'.tr(),
            onTap: () {
              Share.share(
                'forum.share_detail'.tr(namedArgs: {
                  'title': post.title,
                  'content': post.contentPreview ?? post.content,
                }),
              );
            },
          ),
          SizedBox(width: AppSpacing.md12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm10, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(AppRadius.md),
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isActive ? AppColors.transparent : color.withOpacity(0.1),
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
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: 40.h,
          constraints: BoxConstraints(minWidth: label.isEmpty ? 40.h : 0),
          padding: EdgeInsets.symmetric(horizontal: label.isEmpty ? 0 : AppSpacing.md12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20.sp, color: isActive ? AppColors.white : color),
              if (label.isNotEmpty) ...[
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? AppColors.white : color,
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
        borderRadius: BorderRadius.circular(AppRadius.button),
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
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp, color: isActive ? AppColors.white : color),
              SizedBox(width: 4.w),
              if (count > 0)
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isActive ? AppColors.white : color,
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
      padding: EdgeInsets.only(bottom: AppSpacing.md, left: leftPadding),
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
              radius: isReply ? AppRadius.tile : 18.r,
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
          SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCommentAuthorLine(
                  context,
                  comment,
                  isReply: isReply,
                  isMine: isMine,
                ),
                SizedBox(height: 6.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(AppSpacing.sm10, AppSpacing.sm, AppSpacing.sm10, AppSpacing.sm),
                  decoration: isMine
                      ? BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.18),
                          ),
                        )
                      : BoxDecoration(
                          color: AppColors.grey50,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
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
                      SizedBox(height: AppSpacing.sm),
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
                          SizedBox(width: AppSpacing.sm),
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
                          SizedBox(width: AppSpacing.lg),
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
                                  'forum.reply'.tr(),
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
                  SizedBox(height: AppSpacing.sm10),
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
                          width: AppSpacing.md12,
                          height: 1.h,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          isExpanded
                              ? 'forum.hide_replies'.tr()
                              : 'forum.show_replies'.tr(namedArgs: {
                                  'count': '${comment.replies!.length}',
                                }),
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
                      padding: EdgeInsets.only(top: AppSpacing.md12),
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
            padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
            color: AppColors.surface,
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
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            color: AppColors.primary.withOpacity(0.05),
            child: Row(
              children: [
                Icon(LucideIcons.reply, size: 14.sp, color: AppColors.primary),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'forum.replying_to'.tr(namedArgs: {'user': _replyToUser ?? ''}),
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
            AppSpacing.lg,
            AppSpacing.md12,
            AppSpacing.lg,
            AppSpacing.lg + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_replyToId != null ? 0 : 30.r),
              topRight: Radius.circular(_replyToId != null ? 0 : 30.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.06),
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
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
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
                            ? 'forum.hint_reply'.tr()
                            : 'forum.hint_comment'.tr(),
                        hintStyle: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.section),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md12),
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
                      color: AppColors.surface,
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
              padding: EdgeInsets.all(AppSpacing.lg),
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
            SizedBox(height: AppSpacing.md),
            Text(
              'forum.empty_comments'.tr(),
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
      showErrorSnackBar(context, error);
    }
  }
}
