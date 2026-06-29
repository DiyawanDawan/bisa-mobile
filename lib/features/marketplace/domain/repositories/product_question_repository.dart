import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_question_entity.dart';

abstract class ProductQuestionRepository {
  Future<Either<Failure, List<ProductQuestionEntity>>> getProductQuestions(
    String productId,
  );
  Future<Either<Failure, void>> askQuestion({
    required String productId,
    required String question,
  });
  Future<Either<Failure, void>> answerQuestion({
    required String questionId,
    required String answer,
  });
}
