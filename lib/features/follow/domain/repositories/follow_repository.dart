import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/follow_user_entity.dart';

abstract class FollowRepository {
  Future<Either<Failure, List<String>>> getMyFollowingIds();
  Future<Either<Failure, FollowStatsEntity>> getFollowStats(String userId);
  Future<Either<Failure, List<FollowUserEntity>>> getFollowing({String? userId});
  Future<Either<Failure, List<FollowUserEntity>>> getFollowers({String? userId});
  Future<Either<Failure, bool>> toggleFollow(String userId);
  Future<Either<Failure, bool>> checkIsFollowing(String userId);
}
