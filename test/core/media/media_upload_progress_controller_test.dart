import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/media/media_upload_progress_controller.dart';

void main() {
  test('beginBatch and finishBatch toggle active state', () {
    final controller = MediaUploadProgressController();

    controller.beginBatch(totalFiles: 3, folder: 'products');
    expect(controller.snapshot.active, isTrue);
    expect(controller.snapshot.totalFiles, 3);
    expect(controller.snapshot.folder, 'products');

    controller.updateFileProgress(1, 0.5);
    expect(controller.snapshot.progress, closeTo(0.5, 0.01));

    controller.completeFile(2);
    expect(controller.snapshot.completedFiles, 2);

    controller.finishBatch();
    expect(controller.snapshot.active, isFalse);
    expect(controller.snapshot.progress, 1);
  });

  test('setError stores resume metadata', () {
    final controller = MediaUploadProgressController();
    controller.beginBatch(totalFiles: 1, folder: 'forum');
    controller.setError(
      localPath: '/tmp/photo.jpg',
      message: 'timeout',
      resumeSessionId: 'sess-1',
    );

    expect(controller.snapshot.hasError, isTrue);
    expect(controller.snapshot.failedLocalPath, '/tmp/photo.jpg');
    expect(controller.snapshot.resumeSessionId, 'sess-1');

    controller.clearError();
    expect(controller.snapshot.hasError, isFalse);
  });
}
