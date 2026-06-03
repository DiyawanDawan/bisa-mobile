import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/follow_user_entity.dart';
import '../../domain/repositories/follow_repository.dart';
import '../datasources/follow_remote_data_source.dart';
import '../models/follow_models.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FollowRemoteDataSource remoteDataSource;

  FollowRepositoryImpl({required this.remoteDataSource});

  FollowUserEntity _mapUser(FollowUserModel model) => FollowUserEntity(
        id: model.id,
        fullName: model.fullName,
        avatarUrl: model.avatarUrl,
        role: model.role,
        province: model.province,
        regency: model.regency,
        isVerified: model.isVerified,
      );

  @override
  Future<Either<Failure, List<String>>> getMyFollowingIds() async {
    try {
      return Right(await remoteDataSource.getMyFollowingIds());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, FollowStatsEntity>> getFollowStats(String userId) async {
    try {
      final stats = await remoteDataSource.getFollowStats(userId);
      return Right(
        FollowStatsEntity(
          userId: stats.userId,
          followingCount: stats.followingCount,
          followersCount: stats.followersCount,
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FollowUserEntity>>> getFollowing({String? userId}) async {
    try {
      final list = await remoteDataSource.getFollowing(userId: userId);
      return Right(list.users.map(_mapUser).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FollowUserEntity>>> getFollowers({String? userId}) async {
    try {
      final list = await remoteDataSource.getFollowers(userId: userId);
      return Right(list.users.map(_mapUser).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFollow(String userId) async {
    try {
      return Right(await remoteDataSource.toggleFollow(userId));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkIsFollowing(String userId) async {
    try {
      return Right(await remoteDataSource.checkIsFollowing(userId));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
