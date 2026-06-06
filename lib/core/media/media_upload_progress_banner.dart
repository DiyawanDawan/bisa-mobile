import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/media/media_upload_progress_controller.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';

class MediaUploadProgressBanner extends StatelessWidget {
  const MediaUploadProgressBanner({
    super.key,
    required this.controller,
    this.uploadQueue,
    this.onRetrySuccess,
  });

  final MediaUploadProgressController controller;
  final MediaUploadQueue? uploadQueue;
  final VoidCallback? onRetrySuccess;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final snap = controller.snapshot;
        if (!snap.active && !snap.hasError) {
          return const SizedBox.shrink();
        }

        if (snap.hasError) {
          return _ErrorBanner(
            message: snap.errorMessage ?? 'Upload gagal',
            onRetry: uploadQueue == null
                ? null
                : () async {
                    try {
                      await uploadQueue!.retryLastFailed();
                      onRetrySuccess?.call();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Upload berhasil dilanjutkan')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal melanjutkan: $e'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
          );
        }

        final label = snap.totalFiles > 1
            ? 'Mengunggah ${snap.completedFiles + 1}/${snap.totalFiles}${snap.currentFileName != null ? ' — ${snap.currentFileName}' : ''}'
            : 'Mengunggah${snap.currentFileName != null ? ' ${snap.currentFileName}' : ''}...';

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          color: AppColors.primary.withValues(alpha: 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: snap.progress.clamp(0, 1),
                  minHeight: 4.h,
                  backgroundColor: AppColors.grey200,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.error.withValues(alpha: 0.1),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Icon(Icons.cloud_off, color: AppColors.error, size: 18.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 12.sp, color: AppColors.error),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Coba lagi',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
