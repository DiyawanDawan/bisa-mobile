import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_layout.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_feedback.dart';
import '../../../../shared/widgets/bisa_media_skeleton.dart';
import '../../../../shared/widgets/bisa_network_image.dart';
import '../../domain/entities/forum_media.dart';

enum ForumMediaLayout { compact, standard, comment }

/// Grid preview for forum post/comment attachments.
class ForumMediaGrid extends StatelessWidget {
  const ForumMediaGrid({
    super.key,
    required this.media,
    this.layout = ForumMediaLayout.standard,
    this.compact = false,
  });

  final List<ForumMediaItem> media;
  final ForumMediaLayout layout;
  final bool compact;

  ForumMediaLayout get _resolvedLayout {
    if (compact) return ForumMediaLayout.compact;
    return layout;
  }

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox.shrink();

    if (_resolvedLayout == ForumMediaLayout.comment) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          if (maxWidth <= 0) return const SizedBox.shrink();

          if (media.length == 1) {
            return Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: _MediaTile(
                item: media.first,
                width: maxWidth,
                height: 200.h,
              ),
            );
          }

          final tileWidth = (maxWidth - 8.w) / 2;
          final tileHeight = tileWidth * 0.72;

          return Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final item in media)
                  _MediaTile(
                    item: item,
                    width: tileWidth,
                    height: tileHeight,
                  ),
              ],
            ),
          );
        },
      );
    }

    final isCompact = _resolvedLayout == ForumMediaLayout.compact;
    final items = media.take(isCompact ? 3 : media.length).toList();
    final extra = media.length - items.length;
    final tileSize = isCompact ? 72.w : 100.w;

    return Padding(
      padding: EdgeInsets.only(top: isCompact ? 8.h : 12.h),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (int i = 0; i < items.length; i++)
            _MediaTile(
              item: items[i],
              width: tileSize,
              height: tileSize,
              showMoreOverlay: isCompact && extra > 0 && i == items.length - 1,
              moreCount: extra,
            ),
        ],
      ),
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.item,
    required this.width,
    required this.height,
    this.showMoreOverlay = false,
    this.moreCount = 0,
  });

  final ForumMediaItem item;
  final double width;
  final double height;
  final bool showMoreOverlay;
  final int moreCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openMedia(context, item),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            if (item.isImage)
              BisaNetworkImage(
                imageUrl: item.url,
                width: width,
                height: height,
                fit: BoxFit.cover,
                placeholder: (_, __) => BisaMediaSkeleton(
                  width: width,
                  height: height,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                errorWidget: (_, __, ___) => _fallback(),
              )
            else
              Container(
                width: width,
                height: height,
                color: AppColors.grey900,
                child: Icon(
                  LucideIcons.play,
                  color: AppColors.surface,
                  size: 28.sp,
                ),
              ),
            if (item.isVideo && !showMoreOverlay)
              Positioned.fill(
                child: Container(
                  color: AppColors.textHint,
                  child: Icon(
                    LucideIcons.play,
                    color: AppColors.surface,
                    size: 24.sp,
                  ),
                ),
              ),
            if (showMoreOverlay)
              Positioned.fill(
                child: Container(
                  color: AppColors.textSecondary,
                  alignment: Alignment.center,
                  child: Text(
                    '+$moreCount',
                    style: TextStyle(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.grey100,
      child: Icon(LucideIcons.imageOff, color: AppColors.grey400),
    );
  }

  Future<void> _openMedia(BuildContext context, ForumMediaItem item) async {
    if (item.isImage) {
      await showDialog<void>(
        context: context,
        barrierColor: AppColors.textPrimary,
        builder: (ctx) => Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          backgroundColor: AppColors.transparent,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                minScale: 0.8,
                maxScale: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: BisaNetworkImage(
                    imageUrl: item.url,
                    fit: BoxFit.contain,
                    placeholder: (_, __) => BisaMediaSkeleton(
                      width: double.infinity,
                      height: 240.h,
                    ),
                    errorWidget: (_, __, ___) => SizedBox(
                      height: 240.h,
                      child: Icon(
                        LucideIcons.imageOff,
                        color: AppColors.white.withValues(alpha: 0.54),
                        size: 48.sp,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close, color: AppColors.textOnPrimary),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(item.url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showErrorSnackBar(context, 'forum.media_open_failed');
      }
    }
  }
}

/// Local attachment picker preview + actions for compose screens.
class ForumMediaPickerRow extends StatelessWidget {
  const ForumMediaPickerRow({
    super.key,
    required this.attachments,
    required this.onRemove,
    required this.onPickImage,
    required this.onPickVideo,
    this.maxItems = 10,
  });

  final List<ForumMediaAttachment> attachments;
  final ValueChanged<int> onRemove;
  final VoidCallback onPickImage;
  final VoidCallback onPickVideo;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _ActionChip(
              icon: LucideIcons.image,
              label: 'forum.media_photo'.tr(),
              onTap: attachments.length >= maxItems ? null : onPickImage,
            ),
            SizedBox(width: AppSpacing.sm),
            _ActionChip(
              icon: LucideIcons.video,
              label: 'forum.media_video'.tr(),
              onTap: attachments.length >= maxItems ? null : onPickVideo,
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              '${attachments.length}/$maxItems',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
            ),
          ],
        ),
        if (attachments.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm10),
          SizedBox(
            height: 84.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: attachments.length,
              separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = attachments[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: item.isVideo
                          ? Container(
                              width: 84.w,
                              height: 84.h,
                              color: AppColors.grey900,
                              child: Icon(
                                LucideIcons.film,
                                color: AppColors.surface,
                                size: 24.sp,
                              ),
                            )
                          : Image.file(
                              File(item.localPath),
                              width: 84.w,
                              height: 84.h,
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () => onRemove(index),
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.x,
                            size: 12.sp,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.grey50,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp, color: AppColors.primary),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Upload local attachments and return remote media items (chunked).
class ForumMediaUploader {
  ForumMediaUploader(this._uploadQueue);

  final MediaUploadQueue _uploadQueue;

  Future<List<ForumMediaItem>> uploadAll(
    List<ForumMediaAttachment> files, {
    void Function(int completed, int total)? onBatchProgress,
  }) async {
    final paths = files.map((f) => f.localPath).toList();
    final uploadedList = await _uploadQueue.uploadFiles(
      localPaths: paths,
      folder: 'forum',
    );
    final uploaded = <ForumMediaItem>[];
    for (var i = 0; i < uploadedList.length; i++) {
      final result = uploadedList[i];
      uploaded.add(
        ForumMediaItem(url: result.url ?? result.path, type: files[i].type),
      );
      onBatchProgress?.call(i + 1, files.length);
    }
    return uploaded;
  }
}
