import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/media/chunked_media_upload_service.dart';
import 'package:mobile_bisa/core/media/media_upload_progress_controller.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';
import 'package:mobile_bisa/core/network/token_repository.dart';
import 'package:mobile_bisa/features/negotiation/data/datasources/negotiation_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

NegotiationRemoteDataSourceImpl _buildDataSource(Dio dio) {
  return NegotiationRemoteDataSourceImpl(
    dio: dio,
    uploadQueue: MediaUploadQueue(
      uploadService: ChunkedMediaUploadService(
        apiDio: Dio(BaseOptions(baseUrl: 'http://test')),
        tokenRepository: TokenRepository(const FlutterSecureStorage()),
      ),
      progress: MediaUploadProgressController(),
    ),
  );
}

void main() {
  test('markMessagesAsRead sends PUT /negotiations/:id/read', () async {
    String? method;
    String? path;

    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          method = options.method;
          path = options.path;
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: {'meta': {'success': true}},
            ),
          );
        },
      ),
    );

    final dataSource = _buildDataSource(dio);
    await dataSource.markMessagesAsRead('neg-test-42');

    expect(method, 'PUT');
    expect(path, '/negotiations/neg-test-42/read');
  });
}
