import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/ai_remote_data_source.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remoteDataSource;

  AiRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> predictQuality({
    required String biomassaType,
    required double suhuPirolisis,
    required double waktuPembakaran,
    required double beratInput,
  }) async {
    try {
      final result = await remoteDataSource.predictQuality(
        biomassaType: biomassaType,
        suhuPirolisis: suhuPirolisis,
        waktuPembakaran: waktuPembakaran,
        beratInput: beratInput,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getRecentIotPredictions({
    int limit = 20,
  }) async {
    try {
      final result = await remoteDataSource.getRecentPredictions(limit: limit, iotOnly: true);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, String>> askChatbot(String question) async {
    try {
      final answer = await remoteDataSource.askChatbot(question);
      return Right(answer);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _mapDioExceptionToFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const TimeoutFailure();
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final rawData = e.response?.data;
      final data = rawData is Map<String, dynamic> ? rawData : null;
      final message = data?['meta']?['message'] ?? data?['message'] ?? 'errors.generic';

      switch (statusCode) {
        case 401:
          return UnauthorizedFailure(message);
        case 403:
          return ForbiddenFailure(message);
        case 404:
          return const NotFoundFailure();
        case 422:
          return ValidationFailure(
            message: message,
            errors: (data?['errors'] as Map?)?.map(
              (k, v) => MapEntry(
                k.toString(),
                (v as List).map((e) => e.toString()).toList(),
              ),
            ),
          );
        default:
          return ServerFailure(message: message, statusCode: statusCode);
      }
    } else if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return const UnexpectedFailure();
  }
}
