import 'package:dio/dio.dart';

class StretchRemoteDataSource {
  StretchRemoteDataSource(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> getReferralDashboard() async {
    final res = await _dio.get('/referrals/me');
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }

  Future<List<Map<String, dynamic>>> listErpKeys() async {
    final res = await _dio.get('/integrations/erp/keys');
    final list = res.data['data'] as List;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>> createErpKey(String name) async {
    final res = await _dio.post('/integrations/erp/keys', data: {'name': name});
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }

  Future<void> revokeErpKey(String id) async {
    await _dio.delete('/integrations/erp/keys/$id');
  }

  Future<List<Map<String, dynamic>>> listLiveSessions({String? status}) async {
    final res = await _dio.get(
      '/live-sessions',
      queryParameters: status != null ? {'status': status} : null,
    );
    final data = res.data['data'];
    final List sessions;
    if (data is Map<String, dynamic>) {
      sessions = data['sessions'] as List? ?? [];
    } else if (data is List) {
      sessions = data;
    } else {
      sessions = [];
    }
    return sessions.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>> getLiveSession(String id) async {
    final res = await _dio.get('/live-sessions/$id');
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }

  Future<void> recordLiveViewer(String id) async {
    try {
      await _dio.post('/live-sessions/$id/viewer');
    } catch (_) {}
  }

  Future<void> postLiveComment(String id, String message) async {
    await _dio.post('/live-sessions/$id/comments', data: {'message': message});
  }

  Future<List<Map<String, dynamic>>> listMyLiveSessions() async {
    final res = await _dio.get('/live-sessions/mine');
    final list = res.data['data'] as List;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>> createLiveSession(Map<String, dynamic> body) async {
    final res = await _dio.post('/live-sessions', data: body);
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }

  Future<void> startLiveSession(String id) async {
    await _dio.post('/live-sessions/$id/start');
  }

  Future<void> endLiveSession(String id) async {
    await _dio.post('/live-sessions/$id/end');
  }

  Future<Map<String, dynamic>> signOrderContract(String orderId) async {
    final res = await _dio.post('/orders/$orderId/sign');
    return Map<String, dynamic>.from(res.data['data'] as Map);
  }
}
