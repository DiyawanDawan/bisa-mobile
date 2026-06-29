import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mobile_bisa/core/media/compress_image_util.dart';
import 'package:mobile_bisa/core/media/media_upload_session_store.dart';
import 'package:mobile_bisa/core/media/uploaded_media.dart';
import 'package:mobile_bisa/core/network/token_repository.dart';

class ChunkedMediaUploadService {
  ChunkedMediaUploadService({
    required Dio apiDio,
    required TokenRepository tokenRepository,
    this.sessionStore,
  })  : _apiDio = apiDio,
        _tokenRepository = tokenRepository;

  final Dio _apiDio;
  final TokenRepository _tokenRepository;
  final MediaUploadSessionStore? sessionStore;

  static const int _maxPartRetries = 3;
  static const Duration _chunkTimeout = Duration(seconds: 120);

  Dio get _chunkDio => Dio(
        BaseOptions(
          connectTimeout: _chunkTimeout,
          sendTimeout: _chunkTimeout,
          receiveTimeout: _chunkTimeout,
          headers: {'Content-Type': 'application/octet-stream'},
        ),
      );

  Future<UploadedMedia> uploadFile({
    required String localPath,
    required String folder,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
    String? resumeSessionId,
  }) async {
    try {
      return await _uploadFileInternal(
        localPath: localPath,
        folder: folder,
        onProgress: onProgress,
        cancelToken: cancelToken,
        resumeSessionId: resumeSessionId,
      );
    } catch (e) {
      if (!_isStaleMultipartError(e)) rethrow;
      await sessionStore?.clear(localPath);
      return _uploadFileInternal(
        localPath: localPath,
        folder: folder,
        onProgress: onProgress,
        cancelToken: cancelToken,
        resumeSessionId: null,
      );
    }
  }

  bool _isStaleMultipartError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('multipart upload does not exist') ||
        msg.contains('specified multipart upload') ||
        msg.contains('sesi upload kedaluwarsa') ||
        msg.contains('sesi upload sudah selesai') ||
        msg.contains('sesi upload dibatalkan');
  }

  Future<UploadedMedia> _uploadFileInternal({
    required String localPath,
    required String folder,
    void Function(double progress)? onProgress,
    CancelToken? cancelToken,
    String? resumeSessionId,
  }) async {
    final prepared = await compressImageIfNeeded(localPath);
    final file = File(prepared);
    if (!await file.exists()) {
      throw Exception('File tidak ditemukan: $prepared');
    }

    final totalBytes = await file.length();
    final mimeType = _mimeFromPath(prepared);
    final fileName = prepared.split(Platform.pathSeparator).last;

    late final String sessionId;
    late final int partSize;
    late final int totalParts;
    late final String uploadMode;

    var resumed = false;
    if (resumeSessionId != null) {
      try {
        final status = await _getSession(resumeSessionId, cancelToken);
        final sessionStatus = status['status'] as String?;
        if (sessionStatus == 'COMPLETED' && status['finalPath'] != null) {
          await sessionStore?.clear(localPath);
          return UploadedMedia(
            path: status['finalPath'] as String,
            url: status['url'] as String?,
          );
        }
        if (sessionStatus == 'EXPIRED' || sessionStatus == 'ABORTED') {
          await sessionStore?.clear(localPath);
        } else {
          sessionId = status['sessionId'] as String;
          partSize = status['partSize'] as int;
          totalParts = status['totalParts'] as int;
          uploadMode = status['uploadMode'] as String? ?? 'proxy';
          resumed = true;
        }
      } catch (_) {
        await sessionStore?.clear(localPath);
      }
    }

    if (!resumed) {
      final init = await _initUpload(
        folder: folder,
        fileName: fileName,
        mimeType: mimeType,
        totalBytes: totalBytes,
        cancelToken: cancelToken,
      );
      sessionId = init['sessionId'] as String;
      partSize = init['partSize'] as int;
      totalParts = init['totalParts'] as int;
      uploadMode = init['uploadMode'] as String? ?? 'proxy';
      await sessionStore?.save(
        PendingUploadSession(
          localPath: localPath,
          sessionId: sessionId,
          folder: folder,
          updatedAtMs: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }

    final completedParts = <Map<String, dynamic>>[];
    if (resumed) {
      final status = await _getSession(sessionId, cancelToken);
      final existing = status['completedParts'];
      if (existing is List) {
        for (final item in existing) {
          if (item is Map<String, dynamic>) {
            completedParts.add(item);
          } else if (item is Map) {
            completedParts.add(Map<String, dynamic>.from(item));
          }
        }
      }
    }

    final donePartNumbers =
        completedParts.map((e) => e['partNumber'] as int).toSet();

    for (var partNumber = 1; partNumber <= totalParts; partNumber++) {
      if (donePartNumbers.contains(partNumber)) {
        onProgress?.call(partNumber / totalParts);
        continue;
      }

      final start = (partNumber - 1) * partSize;
      final end = min(start + partSize, totalBytes);
      final chunk = await file.openRead(start, end).fold<BytesBuilder>(
            BytesBuilder(copy: false),
            (b, data) {
              b.add(data);
              return b;
            },
          );
      final bytes = chunk.takeBytes();

      final etag = await _uploadPartWithRetry(
        sessionId: sessionId,
        partNumber: partNumber,
        bytes: bytes,
        uploadMode: uploadMode,
        cancelToken: cancelToken,
      );

      completedParts.add({'partNumber': partNumber, 'etag': etag});
      onProgress?.call(partNumber / totalParts);
    }

    final complete = await _completeUpload(
      sessionId: sessionId,
      parts: completedParts
          .map(
            (p) => {
              'partNumber': p['partNumber'],
              'etag': p['etag'],
            },
          )
          .toList(),
      cancelToken: cancelToken,
    );

    await sessionStore?.clear(localPath);

    return UploadedMedia(
      path: complete['path'] as String,
      url: complete['url'] as String?,
    );
  }

  Future<Map<String, dynamic>> _initUpload({
    required String folder,
    required String fileName,
    required String mimeType,
    required int totalBytes,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiDio.post(
      '/media/uploads/init',
      data: {
        'folder': folder,
        'fileName': fileName,
        'mimeType': mimeType,
        'totalBytes': totalBytes,
      },
      cancelToken: cancelToken,
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  Future<Map<String, dynamic>> _getSession(
    String sessionId,
    CancelToken? cancelToken,
  ) async {
    final response = await _apiDio.get(
      '/media/uploads/$sessionId',
      cancelToken: cancelToken,
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  Future<String> _uploadPartWithRetry({
    required String sessionId,
    required int partNumber,
    required Uint8List bytes,
    required String uploadMode,
    CancelToken? cancelToken,
  }) async {
    Object? lastError;
    for (var attempt = 0; attempt < _maxPartRetries; attempt++) {
      try {
        return await _uploadPart(
          sessionId: sessionId,
          partNumber: partNumber,
          bytes: bytes,
          uploadMode: uploadMode,
          cancelToken: cancelToken,
        );
      } catch (e) {
        lastError = e;
        if (attempt < _maxPartRetries - 1) {
          await Future<void>.delayed(Duration(milliseconds: 500 * (attempt + 1)));
        }
      }
    }
    throw lastError ?? Exception('Upload chunk gagal');
  }

  Future<String> _uploadPart({
    required String sessionId,
    required int partNumber,
    required Uint8List bytes,
    required String uploadMode,
    CancelToken? cancelToken,
  }) async {
    final presignRes = await _apiDio.get(
      '/media/uploads/$sessionId/parts/$partNumber/presign',
      cancelToken: cancelToken,
    );
    final presign = Map<String, dynamic>.from(presignRes.data['data'] as Map);
    final uploadUrl = presign['uploadUrl'] as String;
    final useAuth = uploadMode == 'proxy';

    final headers = <String, dynamic>{
      'Content-Type': 'application/octet-stream',
    };
    if (useAuth) {
      final token = await _tokenRepository.getAccessToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }

    final response = await _chunkDio.put(
      uploadUrl,
      data: bytes,
      options: Options(headers: headers, responseType: ResponseType.json),
      cancelToken: cancelToken,
    );

    if (uploadMode == 'proxy') {
      final data = response.data;
      if (data is Map && data['data'] is Map) {
        return (data['data'] as Map)['etag'] as String;
      }
    }

    final etag = response.headers.value('etag') ?? response.headers.value('ETag');
    if (etag != null) return etag.replaceAll('"', '');
    throw Exception('ETag tidak ditemukan pada response chunk');
  }

  Future<Map<String, dynamic>> _completeUpload({
    required String sessionId,
    required List<Map<String, dynamic>> parts,
    CancelToken? cancelToken,
  }) async {
    final response = await _apiDio.post(
      '/media/uploads/$sessionId/complete',
      data: {'parts': parts},
      cancelToken: cancelToken,
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  String _mimeFromPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.heic')) return 'image/heic';
    if (lower.endsWith('.heif')) return 'image/heif';
    if (lower.endsWith('.pdf')) return 'application/pdf';
    return 'image/jpeg';
  }
}
