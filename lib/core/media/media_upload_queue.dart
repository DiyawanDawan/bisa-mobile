import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mobile_bisa/core/media/chunked_media_upload_service.dart';
import 'package:mobile_bisa/core/media/media_upload_progress_controller.dart';
import 'package:mobile_bisa/core/media/uploaded_media.dart';

/// Antrian upload dengan maksimal [maxConcurrentFiles] file paralel.
class MediaUploadQueue {
  MediaUploadQueue({
    required ChunkedMediaUploadService uploadService,
    required MediaUploadProgressController progress,
    this.maxConcurrentFiles = 2,
  })  : _uploadService = uploadService,
        _progress = progress;

  final ChunkedMediaUploadService _uploadService;
  final MediaUploadProgressController _progress;
  final int maxConcurrentFiles;

  int _activeUploads = 0;
  final _slotWaiters = <Completer<void>>[];

  Future<UploadedMedia> uploadFile({
    required String localPath,
    required String folder,
    CancelToken? cancelToken,
    void Function(double progress)? onProgress,
  }) async {
    final manageBatch = !_progress.snapshot.active;
    if (manageBatch) {
      _progress.beginBatch(totalFiles: 1, folder: folder);
    }

    await _acquireSlot();
    try {
      _progress.beginFile(localPath);
      final resumeSessionId =
          await _uploadService.sessionStore?.getSessionId(localPath);

      final result = await _uploadService.uploadFile(
        localPath: localPath,
        folder: folder,
        cancelToken: cancelToken,
        resumeSessionId: resumeSessionId,
        onProgress: (fileProgress) {
          if (manageBatch) {
            _progress.updateFileProgress(0, fileProgress);
          }
          onProgress?.call(fileProgress);
        },
      );

      if (manageBatch) {
        _progress.completeFile(1);
        _progress.finishBatch();
      }
      return result;
    } catch (e) {
      final resumeId = await _uploadService.sessionStore?.getSessionId(localPath);
      _progress.setError(
        localPath: localPath,
        message: e.toString(),
        resumeSessionId: resumeId,
      );
      rethrow;
    } finally {
      _releaseSlot();
    }
  }

  Future<List<UploadedMedia>> uploadFiles({
    required List<String> localPaths,
    required String folder,
    CancelToken? cancelToken,
  }) async {
    if (localPaths.isEmpty) return [];

    _progress.beginBatch(totalFiles: localPaths.length, folder: folder);
    final results = <UploadedMedia>[];
    var completed = 0;
    final inFlight = <String, double>{};

    void reportAggregate() {
      final inFlightSum =
          inFlight.values.fold<double>(0, (sum, value) => sum + value);
      final aggregate =
          ((completed + inFlightSum) / localPaths.length).clamp(0.0, 1.0);
      _progress.updateFileProgress(completed, aggregate);
    }

    Future<UploadedMedia> uploadOne(String path) async {
      await _acquireSlot();
      try {
        _progress.beginFile(path);
        inFlight[path] = 0;
        reportAggregate();

        final resumeSessionId =
            await _uploadService.sessionStore?.getSessionId(path);
        final uploaded = await _uploadService.uploadFile(
          localPath: path,
          folder: folder,
          cancelToken: cancelToken,
          resumeSessionId: resumeSessionId,
          onProgress: (fileProgress) {
            inFlight[path] = fileProgress;
            reportAggregate();
          },
        );

        inFlight.remove(path);
        completed++;
        _progress.completeFile(completed);
        reportAggregate();
        return uploaded;
      } catch (e) {
        final resumeId = await _uploadService.sessionStore?.getSessionId(path);
        _progress.setError(
          localPath: path,
          message: e.toString(),
          resumeSessionId: resumeId,
        );
        rethrow;
      } finally {
        _releaseSlot();
      }
    }

    try {
      for (var i = 0; i < localPaths.length; i += maxConcurrentFiles) {
        final batch = localPaths
            .skip(i)
            .take(maxConcurrentFiles)
            .toList(growable: false);
        final batchResults = await Future.wait(batch.map(uploadOne));
        results.addAll(batchResults);
      }
      _progress.finishBatch();
      return results;
    } catch (_) {
      rethrow;
    }
  }

  Future<UploadedMedia?> retryLastFailed() async {
    final snap = _progress.snapshot;
    if (snap.failedLocalPath == null || snap.folder == null) return null;
    _progress.clearError();
    return uploadFile(
      localPath: snap.failedLocalPath!,
      folder: snap.folder!,
    );
  }

  Future<void> _acquireSlot() async {
    while (_activeUploads >= maxConcurrentFiles) {
      final waiter = Completer<void>();
      _slotWaiters.add(waiter);
      await waiter.future;
    }
    _activeUploads++;
  }

  void _releaseSlot() {
    _activeUploads = (_activeUploads - 1).clamp(0, maxConcurrentFiles);
    if (_slotWaiters.isNotEmpty) {
      _slotWaiters.removeAt(0).complete();
    }
  }
}
