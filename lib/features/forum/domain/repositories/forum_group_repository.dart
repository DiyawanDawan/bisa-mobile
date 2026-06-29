import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/forum_group_entity.dart';

abstract class ForumGroupRepository {
  Future<Either<Failure, List<ForumGroupEntity>>> getGroups({
    String? keyword,
    bool mine = false,
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, ForumGroupEntity>> getGroupById(String id);
  Future<Either<Failure, ForumGroupEntity>> createGroup({
    required String name,
    String? description,
    String? avatarUrl,
    String? bannerUrl,
    bool isPublic = true,
  });
  Future<Either<Failure, ForumGroupEntity>> joinGroup(String id);
  Future<Either<Failure, void>> leaveGroup(String id);
  Future<Either<Failure, String>> uploadImage(String localPath);
}
