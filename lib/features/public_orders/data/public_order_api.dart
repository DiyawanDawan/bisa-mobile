import 'package:dio/dio.dart';
import '../../../../injection_container.dart';
import '../../../../core/network/api_client.dart';

class PublicOrderApi {
  final Dio _dio = sl<ApiClient>().dio;

  Future<Map<String, dynamic>> verifyContract(String orderNumber) async {
    final response = await _dio.get(
      '/orders/verify/${Uri.encodeComponent(orderNumber)}',
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  Future<Map<String, dynamic>> trackShipment(String orderNumber) async {
    final response = await _dio.get(
      '/orders/track/${Uri.encodeComponent(orderNumber)}',
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  Future<Map<String, dynamic>> fetchSupportSettings() async {
    final response = await _dio.get('/system/support');
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  Future<List<Map<String, dynamic>>> fetchFaqs({int limit = 50}) async {
    final response = await _dio.get(
      '/faqs',
      queryParameters: {'page': 1, 'limit': limit},
    );
    final data = response.data['data'];
    if (data is List) {
      return data
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    return [];
  }
}
