import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/forum_entity.dart';
import '../entities/forum_media.dart';

abstract class ForumRepository {
  Future<Either<Failure, List<ForumPostEntity>>> getPosts({
    String? categoryId,
    String? keyword,
    String? tag,
    String? groupId,
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, ForumPostEntity>> getPostById(String id);
  Future<Either<Failure, void>> createPost(
    String title,
    String content,
    String? categoryId, {
    String? groupId,
    List<ForumMediaItem>? mediaUrls,
    String? status,
    List<String>? tags,
  });
  Future<Either<Failure, void>> createComment(
    String postId,
    String content, {
    String? parentId,
    List<ForumMediaItem>? mediaUrls,
  });
  Future<Either<Failure, List<ForumMediaItem>>> uploadMedia(
    List<ForumMediaAttachment> attachments,
  );
  Future<Either<Failure, void>> vote(String targetId, String targetType, String voteType);
  Future<Either<Failure, List<ForumCategoryEntity>>> getCategories({String? type});

  /// Postingan milik user sendiri (untuk halaman manajemen).
  Future<Either<Failure, List<ForumPostEntity>>> getMyPosts({
    String? status,
    int page = 1,
    int limit = 20,
  });

  Future<Either<Failure, void>> updatePost(
    String id, {
    String? title,
    String? content,
    String? categoryId,
    List<ForumMediaItem>? mediaUrls,
    String? status,
    List<String>? tags,
  });

  Future<Either<Failure, void>> deletePost(String id);
}
