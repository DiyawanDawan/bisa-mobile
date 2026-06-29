import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/forum_group_entity.dart';
import '../../domain/repositories/forum_group_repository.dart';
import '../datasources/forum_group_remote_data_source.dart';

class ForumGroupRepositoryImpl implements ForumGroupRepository {
  final ForumGroupRemoteDataSource remoteDataSource;

  ForumGroupRepositoryImpl({required this.remoteDataSource});

  Failure _mapDio(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['meta']?['message'] != null) {
      return ServerFailure(message: data['meta']['message'].toString());
    }
    return ServerFailure(message: e.message ?? 'Terjadi kesalahan jaringan');
  }

  @override
  Future<Either<Failure, List<ForumGroupEntity>>> getGroups({
    String? keyword,
    bool mine = false,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final groups = await remoteDataSource.getGroups(
        keyword: keyword,
        mine: mine,
        page: page,
        limit: limit,
      );
      return Right(groups);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ForumGroupEntity>> getGroupById(String id) async {
    try {
      final group = await remoteDataSource.getGroupById(id);
      return Right(group);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ForumGroupEntity>> createGroup({
    required String name,
    String? description,
    String? avatarUrl,
    String? bannerUrl,
    bool isPublic = true,
  }) async {
    try {
      final group = await remoteDataSource.createGroup(
        name: name,
        description: description,
        avatarUrl: avatarUrl,
        bannerUrl: bannerUrl,
        isPublic: isPublic,
      );
      return Right(group);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ForumGroupEntity>> joinGroup(String id) async {
    try {
      final group = await remoteDataSource.joinGroup(id);
      return Right(group);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> leaveGroup(String id) async {
    try {
      await remoteDataSource.leaveGroup(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String localPath) async {
    try {
      final url = await remoteDataSource.uploadImage(localPath);
      return Right(url);
    } on DioException catch (e) {
      return Left(_mapDio(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }
}
