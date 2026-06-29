import 'package:dio/dio.dart';
import '../models/product_question_model.dart';

abstract class ProductQuestionRemoteDataSource {
  Future<List<ProductQuestionModel>> getProductQuestions(String productId);
  Future<void> askQuestion({
    required String productId,
    required String question,
  });
  Future<void> answerQuestion({
    required String questionId,
    required String answer,
  });
}

class ProductQuestionRemoteDataSourceImpl
    implements ProductQuestionRemoteDataSource {
  final Dio dio;

  ProductQuestionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductQuestionModel>> getProductQuestions(
    String productId,
  ) async {
    final response = await dio.get('/products/$productId/questions');
    final List data = response.data['data'] as List? ?? const [];
    return data
        .map((e) => ProductQuestionModel.fromJson(
              Map<String, dynamic>.from(e as Map),
            ))
        .toList();
  }

  @override
  Future<void> askQuestion({
    required String productId,
    required String question,
  }) async {
    await dio.post(
      '/products/$productId/questions',
      data: {'question': question},
    );
  }

  @override
  Future<void> answerQuestion({
    required String questionId,
    required String answer,
  }) async {
    await dio.post(
      '/questions/$questionId/answer',
      data: {'answer': answer},
    );
  }
}
