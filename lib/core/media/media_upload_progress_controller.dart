import 'package:flutter/foundation.dart';

class MediaUploadProgressSnapshot {
  const MediaUploadProgressSnapshot({
    required this.active,
    required this.progress,
    required this.totalFiles,
    required this.completedFiles,
    this.currentFileName,
    this.errorMessage,
    this.failedLocalPath,
    this.resumeSessionId,
    this.folder,
  });

  final bool active;
  final double progress;
  final int totalFiles;
  final int completedFiles;
  final String? currentFileName;
  final String? errorMessage;
  final String? failedLocalPath;
  final String? resumeSessionId;
  final String? folder;

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;

  MediaUploadProgressSnapshot copyWith({
    bool? active,
    double? progress,
    int? totalFiles,
    int? completedFiles,
    String? currentFileName,
    String? errorMessage,
    String? failedLocalPath,
    String? resumeSessionId,
    String? folder,
    bool clearError = false,
  }) {
    return MediaUploadProgressSnapshot(
      active: active ?? this.active,
      progress: progress ?? this.progress,
      totalFiles: totalFiles ?? this.totalFiles,
      completedFiles: completedFiles ?? this.completedFiles,
      currentFileName: currentFileName ?? this.currentFileName,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      failedLocalPath: clearError ? null : (failedLocalPath ?? this.failedLocalPath),
      resumeSessionId: clearError ? null : (resumeSessionId ?? this.resumeSessionId),
      folder: folder ?? this.folder,
    );
  }
}

class MediaUploadProgressController extends ChangeNotifier {
  MediaUploadProgressSnapshot _snapshot = const MediaUploadProgressSnapshot(
    active: false,
    progress: 0,
    totalFiles: 0,
    completedFiles: 0,
  );

  MediaUploadProgressSnapshot get snapshot => _snapshot;

  void beginBatch({required int totalFiles, required String folder}) {
    _snapshot = MediaUploadProgressSnapshot(
      active: true,
      progress: 0,
      totalFiles: totalFiles,
      completedFiles: 0,
      folder: folder,
    );
    notifyListeners();
  }

  void beginFile(String localPath) {
    final name = localPath.split(RegExp(r'[/\\]')).last;
    _snapshot = _snapshot.copyWith(
      active: true,
      currentFileName: name,
      clearError: true,
    );
    notifyListeners();
  }

  void updateFileProgress(int completedFiles, double currentFileProgress) {
    final total = _snapshot.totalFiles;
    if (total <= 0) {
      _snapshot = _snapshot.copyWith(progress: currentFileProgress.clamp(0, 1));
    } else {
      final aggregate =
          ((completedFiles + currentFileProgress) / total).clamp(0.0, 1.0);
      _snapshot = _snapshot.copyWith(
        progress: aggregate,
        completedFiles: completedFiles,
      );
    }
    notifyListeners();
  }

  void completeFile(int completedFiles) {
    final total = _snapshot.totalFiles;
    final progress = total > 0 ? (completedFiles / total).clamp(0.0, 1.0) : 1.0;
    _snapshot = _snapshot.copyWith(
      completedFiles: completedFiles,
      progress: progress,
    );
    notifyListeners();
  }

  void finishBatch() {
    _snapshot = _snapshot.copyWith(
      active: false,
      progress: 1,
      currentFileName: null,
      clearError: true,
    );
    notifyListeners();
  }

  void setError({
    required String localPath,
    required String message,
    String? resumeSessionId,
  }) {
    _snapshot = _snapshot.copyWith(
      active: false,
      errorMessage: message,
      failedLocalPath: localPath,
      resumeSessionId: resumeSessionId,
    );
    notifyListeners();
  }

  void clearError() {
    _snapshot = _snapshot.copyWith(clearError: true);
    notifyListeners();
  }

  void reset() {
    _snapshot = const MediaUploadProgressSnapshot(
      active: false,
      progress: 0,
      totalFiles: 0,
      completedFiles: 0,
    );
    notifyListeners();
  }
}
