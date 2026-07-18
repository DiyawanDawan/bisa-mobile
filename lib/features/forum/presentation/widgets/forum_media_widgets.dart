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

/// Maksimal tile yang ditampilkan di feed; sisanya via overlay +N lalu swipe di viewer.
const int _kFeedPreviewMax = 4;

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

  void _openGallery(BuildContext context, int initialIndex) {
    final item = media[initialIndex];
    if (item.isVideo) {
      _openVideoExternal(context, item);
      return;
    }
    // Mulai dari gambar terdekat jika index video (viewer fokus image swipe).
    final imageIndices = <int>[];
    for (var i = 0; i < media.length; i++) {
      if (media[i].isImage) imageIndices.add(i);
    }
    if (imageIndices.isEmpty) {
      _openVideoExternal(context, item);
      return;
    }
    var start = imageIndices.indexOf(initialIndex);
    if (start < 0) {
      start = 0;
      for (var i = 0; i < imageIndices.length; i++) {
        if (imageIndices[i] >= initialIndex) {
          start = i;
          break;
        }
      }
    }
    final images = imageIndices.map((i) => media[i]).toList();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: AppColors.black.withValues(alpha: 0.92),
        pageBuilder: (_, __, ___) => ForumMediaGalleryViewer(
          media: images,
          initialIndex: start,
        ),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  Future<void> _openVideoExternal(
    BuildContext context,
    ForumMediaItem item,
  ) async {
    final uri = Uri.tryParse(item.url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showErrorSnackBar(context, 'forum.media_open_failed');
      }
    }
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
                onTap: () => _openGallery(context, 0),
              ),
            );
          }

          final preview = media.take(_kFeedPreviewMax).toList();
          final extra = media.length - preview.length;
          final tileWidth = (maxWidth - 8.w) / 2;
          final tileHeight = tileWidth * 0.72;

          return Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (int i = 0; i < preview.length; i++)
                  _MediaTile(
                    item: preview[i],
                    width: tileWidth,
                    height: tileHeight,
                    showMoreOverlay: extra > 0 && i == preview.length - 1,
                    moreCount: extra,
                    onTap: () => _openGallery(context, i),
                  ),
              ],
            ),
          );
        },
      );
    }

    final isCompact = _resolvedLayout == ForumMediaLayout.compact;

    if (isCompact) {
      final preview = media.take(3).toList();
      final extra = media.length - preview.length;
      final tileSize = 72.w;
      return Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (int i = 0; i < preview.length; i++)
              _MediaTile(
                item: preview[i],
                width: tileSize,
                height: tileSize,
                showMoreOverlay: extra > 0 && i == preview.length - 1,
                moreCount: extra,
                onTap: () => _openGallery(context, i),
              ),
          ],
        ),
      );
    }

    // Feed / detail: collage rasio beragam, max 4 tile + overlay sisa.
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (maxWidth <= 0) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: _ForumMediaCollage(
            media: media,
            maxWidth: maxWidth,
            onOpen: (index) => _openGallery(context, index),
          ),
        );
      },
    );
  }
}

/// Collage ala galeri: 1 penuh, 2 sejajar, 3 (besar + 2), 4+ (2×2, last +N).
class _ForumMediaCollage extends StatelessWidget {
  const _ForumMediaCollage({
    required this.media,
    required this.maxWidth,
    required this.onOpen,
  });

  final List<ForumMediaItem> media;
  final double maxWidth;
  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    final gap = 6.w;
    final count = media.length;
    final previewCount = count >= _kFeedPreviewMax ? _kFeedPreviewMax : count;
    final extra = count - previewCount;

    if (count == 1) {
      return _MediaTile(
        item: media.first,
        width: maxWidth,
        height: 220.h,
        onTap: () => onOpen(0),
      );
    }

    if (count == 2) {
      final w = (maxWidth - gap) / 2;
      return SizedBox(
        height: 200.h,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: _MediaTile(
                item: media[0],
                width: w * 1.1,
                height: 200.h,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(AppRadius.lg),
                ),
                onTap: () => onOpen(0),
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              flex: 4,
              child: _MediaTile(
                item: media[1],
                width: w * 0.9,
                height: 200.h,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(AppRadius.lg),
                ),
                onTap: () => onOpen(1),
              ),
            ),
          ],
        ),
      );
    }

    if (count == 3) {
      final rightW = (maxWidth - gap) * 0.42;
      final leftW = maxWidth - gap - rightW;
      final halfH = (220.h - gap) / 2;
      return SizedBox(
        height: 220.h,
        child: Row(
          children: [
            _MediaTile(
              item: media[0],
              width: leftW,
              height: 220.h,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(AppRadius.lg),
              ),
              onTap: () => onOpen(0),
            ),
            SizedBox(width: gap),
            Column(
              children: [
                _MediaTile(
                  item: media[1],
                  width: rightW,
                  height: halfH,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppRadius.lg),
                  ),
                  onTap: () => onOpen(1),
                ),
                SizedBox(height: gap),
                _MediaTile(
                  item: media[2],
                  width: rightW,
                  height: halfH,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(AppRadius.lg),
                  ),
                  onTap: () => onOpen(2),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // 4+: tampilkan 4, last tile overlay +sisa
    final cellW = (maxWidth - gap) / 2;
    final cellH = 110.h;
    return Column(
      children: [
        Row(
          children: [
            _MediaTile(
              item: media[0],
              width: cellW,
              height: cellH * 1.15,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.lg),
              ),
              onTap: () => onOpen(0),
            ),
            SizedBox(width: gap),
            _MediaTile(
              item: media[1],
              width: cellW,
              height: cellH * 1.15,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppRadius.lg),
              ),
              onTap: () => onOpen(1),
            ),
          ],
        ),
        SizedBox(height: gap),
        Row(
          children: [
            _MediaTile(
              item: media[2],
              width: cellW,
              height: cellH,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.lg),
              ),
              onTap: () => onOpen(2),
            ),
            SizedBox(width: gap),
            _MediaTile(
              item: media[3],
              width: cellW,
              height: cellH,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(AppRadius.lg),
              ),
              showMoreOverlay: extra > 0,
              moreCount: extra,
              onTap: () => onOpen(3),
            ),
          ],
        ),
      ],
    );
  }
}

class _MediaTile extends StatelessWidget {
  const _MediaTile({
    required this.item,
    required this.width,
    required this.height,
    required this.onTap,
    this.showMoreOverlay = false,
    this.moreCount = 0,
    this.borderRadius,
  });

  final ForumMediaItem item;
  final double width;
  final double height;
  final VoidCallback onTap;
  final bool showMoreOverlay;
  final int moreCount;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppRadius.lg);
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
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
                    borderRadius: radius,
                  ),
                  errorWidget: (_, __, ___) => _fallback(),
                )
              else
                ColoredBox(
                  color: AppColors.grey900,
                  child: Icon(
                    LucideIcons.play,
                    color: AppColors.surface,
                    size: 28.sp,
                  ),
                ),
              if (item.isVideo && !showMoreOverlay)
                ColoredBox(
                  color: AppColors.black.withValues(alpha: 0.35),
                  child: Icon(
                    LucideIcons.play,
                    color: AppColors.surface,
                    size: 24.sp,
                  ),
                ),
              if (showMoreOverlay)
                ColoredBox(
                  color: AppColors.black.withValues(alpha: 0.55),
                  child: Center(
                    child: Text(
                      '+$moreCount',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w800,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallback() {
    return ColoredBox(
      color: AppColors.grey100,
      child: Icon(LucideIcons.imageOff, color: AppColors.grey400),
    );
  }
}

/// Fullscreen gallery — swipe antar gambar.
class ForumMediaGalleryViewer extends StatefulWidget {
  const ForumMediaGalleryViewer({
    super.key,
    required this.media,
    this.initialIndex = 0,
  });

  final List<ForumMediaItem> media;
  final int initialIndex;

  @override
  State<ForumMediaGalleryViewer> createState() =>
      _ForumMediaGalleryViewerState();
}

class _ForumMediaGalleryViewerState extends State<ForumMediaGalleryViewer> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.media.length - 1);
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.media.length;
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: total,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final item = widget.media[i];
                return InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4,
                  child: Center(
                    child: BisaNetworkImage(
                      imageUrl: item.url,
                      fit: BoxFit.contain,
                      placeholder: (_, __) => BisaMediaSkeleton(
                        width: double.infinity,
                        height: 280.h,
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        LucideIcons.imageOff,
                        color: AppColors.white.withValues(alpha: 0.54),
                        size: 48.sp,
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 8.h,
              left: 8.w,
              right: 8.w,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppColors.white),
                  ),
                  const Spacer(),
                  if (total > 1)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        '${_index + 1} / $total',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.sp,
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
          padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md12, vertical: AppSpacing.sm),
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
