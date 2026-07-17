import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({int page = 1, int limit = 20}) async {
    try {
      final models = await remoteDataSource.getNotifications(page: page, limit: limit);
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await remoteDataSource.markAsRead(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> registerFcmToken(String token, String platform) async {
    try {
      await remoteDataSource.registerFcmToken(token, platform);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deregisterFcmToken(String token) async {
    try {
      await remoteDataSource.deregisterFcmToken(token);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    try {
      await remoteDataSource.deleteNotification(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> getNotificationById(String id) async {
    try {
      final model = await remoteDataSource.getNotificationById(id);
      return Right(model.toEntity());
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
