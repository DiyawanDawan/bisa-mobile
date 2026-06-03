import 'package:dio/dio.dart';

abstract class AiRemoteDataSource {
  Future<Map<String, dynamic>> predictQuality({
    required String biomassaType,
    required double suhuPirolisis,
    required double waktuPembakaran,
    required double beratInput,
  });
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
  Future<String> askChatbot(String question) async {
    final response = await dio.post('/ai/chatbot', data: {
      'question': question,
    });
    return response.data['data']['answer'];
  }
}
