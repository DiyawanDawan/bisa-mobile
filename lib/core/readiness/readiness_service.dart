import 'package:dio/dio.dart';
import '../errors/failures.dart';
import 'readiness_models.dart';

class ReadinessService {
  ReadinessService(this._dio);

  final Dio _dio;

  Future<UserReadiness> fetchReadiness() async {
    final response = await _dio.get('/users/me/readiness');
    final data = response.data['data'];
    if (data is! Map<String, dynamic>) {
      return const UserReadiness(role: '', store: null, buyer: null);
    }
    return UserReadiness.fromJson(data);
  }

  static String? errorCodeFromDio(DioException error) {
    final raw = error.response?.data;
    if (raw is! Map<String, dynamic>) return null;
    final meta = raw['meta'];
    if (meta is Map<String, dynamic>) {
      return meta['code']?.toString();
    }
    return null;
  }

  static List<String> missingFromDio(DioException error) {
    final raw = error.response?.data;
    if (raw is! Map<String, dynamic>) return const [];
    final meta = raw['meta'];
    if (meta is! Map<String, dynamic>) return const [];
    final missing = meta['missing'];
    if (missing is! List) return const [];
    return missing.map((e) => e.toString()).toList();
  }

  static Failure? failureFromResponseData(
    Map<String, dynamic>? data,
    String message,
  ) {
    final meta = data?['meta'];
    if (meta is! Map<String, dynamic>) return null;
    final code = meta['code']?.toString();
    if (code != 'STORE_NOT_READY' && code != 'BUYER_NOT_READY') return null;
    final missing = (meta['missing'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    return ReadinessFailure(code: code!, message: message, missing: missing);
  }
}
