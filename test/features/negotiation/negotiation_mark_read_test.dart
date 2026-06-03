import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/features/negotiation/data/datasources/negotiation_remote_data_source.dart';

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

    final dataSource = NegotiationRemoteDataSourceImpl(dio: dio);
    await dataSource.markMessagesAsRead('neg-test-42');

    expect(method, 'PUT');
    expect(path, '/negotiations/neg-test-42/read');
  });
}
