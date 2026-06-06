import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/media/media_upload_session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('save and get session by local path', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = MediaUploadSessionStore(prefs);

    await store.save(
      const PendingUploadSession(
        localPath: '/data/photo.jpg',
        sessionId: 'abc-123',
        folder: 'products',
        updatedAtMs: 1,
      ),
    );

    expect(await store.getSessionId('/data/photo.jpg'), 'abc-123');
  });

  test('clear removes session', () async {
    final prefs = await SharedPreferences.getInstance();
    final store = MediaUploadSessionStore(prefs);

    await store.save(
      const PendingUploadSession(
        localPath: '/data/doc.pdf',
        sessionId: 'xyz',
        folder: 'verification',
        updatedAtMs: 2,
      ),
    );
    await store.clear('/data/doc.pdf');

    expect(await store.getSessionId('/data/doc.pdf'), isNull);
  });
}
