import '../../../../core/network/api_client.dart';
import '../../../../injection_container.dart';

class RfqRemoteDataSource {
  final _dio = sl<ApiClient>().dio;

  Future<Map<String, dynamic>> createRfq(Map<String, dynamic> body) async {
    final res = await _dio.post('/rfqs', data: body);
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }

  Future<Map<String, dynamic>> getRfqDetail(String id) async {
    final res = await _dio.get('/rfqs/$id');
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }

  Future<List<Map<String, dynamic>>> listMyRfqs({int page = 1}) async {
    final res = await _dio.get('/rfqs', queryParameters: {'page': page, 'limit': 20});
    final data = res.data['data'] as List? ?? [];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<List<Map<String, dynamic>>> listInbox({int page = 1}) async {
    final res = await _dio.get('/rfqs/inbox', queryParameters: {'page': page, 'limit': 20});
    final data = res.data['data'] as List? ?? [];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>> getInboxDetail(String id) async {
    final res = await _dio.get('/rfqs/inbox/$id');
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }

  Future<Map<String, dynamic>> respond(String rfqId, {String? message}) async {
    final res = await _dio.post('/rfqs/$rfqId/respond', data: {
      if (message != null && message.isNotEmpty) 'message': message,
    });
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }
}
