import 'package:dio/dio.dart';

abstract class AiRemoteDataSource {
  Future<Map<String, dynamic>> predictQuality({
    required String biomassaType,
    required double suhuPirolisis,
    required double waktuPembakaran,
    required double beratInput,
  });
  Future<List<Map<String, dynamic>>> getRecentPredictions({int limit = 20, bool iotOnly = false});
  Future<String> askChatbot(String question);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio dio;

  AiRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> predictQuality({
    required String biomassaType,
    required double suhuPirolisis,
    required double waktuPembakaran,
    required double beratInput,
  }) async {
    final response = await dio.post('/ai/predict', data: {
      'biomassaType': biomassaType,
      'suhuPirolisis': suhuPirolisis,
      'waktuPembakaran': waktuPembakaran,
      'beratInput': beratInput,
    });
    return response.data['data'];
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentPredictions({
    int limit = 20,
    bool iotOnly = false,
  }) async {
    final response = await dio.get(
      '/ai/predictions/recent',
      queryParameters: {
        'limit': limit,
        'iotOnly': iotOnly.toString(),
      },
    );
    final List data = response.data['data']['predictions'] ?? [];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  Future<String> askChatbot(String question) async {
    final response = await dio.post('/ai/chatbot', data: {
      'question': question,
    });
    return response.data['data']['answer'];
  }
}
