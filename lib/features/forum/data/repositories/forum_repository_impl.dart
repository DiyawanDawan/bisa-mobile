import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/forum_entity.dart';
import '../../domain/entities/forum_media.dart';
import '../../domain/repositories/forum_repository.dart';
import '../datasources/forum_remote_data_source.dart';

class ForumRepositoryImpl implements ForumRepository {
  final ForumRemoteDataSource remoteDataSource;

  ForumRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ForumPostEntity>>> getPosts({
    String? categoryId,
    String? keyword,
    String? tag,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final models = await remoteDataSource.getPosts(
        categoryId: categoryId,
        keyword: keyword,
        tag: tag,
        page: page,
        limit: limit,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ForumPostEntity>> getPostById(String id) async {
    try {
      final model = await remoteDataSource.getPostById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createPost(
    String title,
    String content,
    String? categoryId, {
    List<ForumMediaItem>? mediaUrls,
    String? status,
    List<String>? tags,
  }) async {
    try {
      await remoteDataSource.createPost(
        title,
        content,
        categoryId,
        mediaUrls: forumMediaToJson(mediaUrls),
        status: status,
        tags: tags,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ForumPostEntity>>> getMyPosts({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.getMyPosts(
        status: status,
        page: page,
        limit: limit,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updatePost(
    String id, {
    String? title,
    String? content,
    String? categoryId,
    List<ForumMediaItem>? mediaUrls,
    String? status,
    List<String>? tags,
  }) async {
    try {
      await remoteDataSource.updatePost(
        id,
        title: title,
        content: content,
        categoryId: categoryId,
        mediaUrls: forumMediaToJson(mediaUrls),
        status: status,
        tags: tags,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePost(String id) async {
    try {
      await remoteDataSource.deletePost(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createComment(
    String postId,
    String content, {
    String? parentId,
    List<ForumMediaItem>? mediaUrls,
  }) async {
    try {
      await remoteDataSource.createComment(
        postId,
        content,
        parentId: parentId,
        mediaUrls: forumMediaToJson(mediaUrls),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ForumMediaItem>>> uploadMedia(
    List<ForumMediaAttachment> attachments,
  ) async {
    try {
      final raw = await remoteDataSource.uploadMedia(
        attachments.map((e) => e.localPath).toList(),
        attachments.map((e) => e.type).toList(),
      );
      return Right(raw.map(ForumMediaItem.fromJson).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> vote(String targetId, String targetType, String voteType) async {
    try {
      await remoteDataSource.vote(targetId, targetType, voteType);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ForumCategoryEntity>>> getCategories({String? type}) async {
    try {
      final models = await remoteDataSource.getCategories(type: type);
      return Right(models.map((e) => e.toEntity()).toList());
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
      final message = data?['meta']?['message'] ?? data?['message'] ?? 'Terjadi kesalahan';
      final errors = data?['errors'];
      String? firstFieldError;
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map && first['message'] != null) {
          firstFieldError = first['message'].toString();
        }
      }

      switch (statusCode) {
        case 401:
          return UnauthorizedFailure(message);
        case 403:
          return ForbiddenFailure(message);
        case 404:
          return const NotFoundFailure();
        case 400:
        case 422:
          return ValidationFailure(
            message: firstFieldError ?? message,
            errors: (errors is List)
                ? {
                    for (final e in errors)
                      if (e is Map && e['field'] != null)
                        e['field'].toString(): [e['message']?.toString() ?? ''],
                  }
                : null,
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
