import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/product_question_entity.dart';
import '../../domain/repositories/product_question_repository.dart';
import '../datasources/product_question_remote_data_source.dart';

class ProductQuestionRepositoryImpl implements ProductQuestionRepository {
  final ProductQuestionRemoteDataSource remoteDataSource;

  ProductQuestionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductQuestionEntity>>> getProductQuestions(
    String productId,
  ) async {
    try {
      final rows = await remoteDataSource.getProductQuestions(productId);
      return Right(rows.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> askQuestion({
    required String productId,
    required String question,
  }) async {
    try {
      await remoteDataSource.askQuestion(
        productId: productId,
        question: question,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> answerQuestion({
    required String questionId,
    required String answer,
  }) async {
    try {
      await remoteDataSource.answerQuestion(
        questionId: questionId,
        answer: answer,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _mapDio(DioException e) {
    final msg = e.response?.data?['message']?.toString() ??
        e.message ??
        'Request failed';
    return ServerFailure(message: msg);
  }
}
