import 'package:freezed_annotation/freezed_annotation.dart';
import 'forum_media.dart';

part 'forum_entity.freezed.dart';

@freezed
abstract class ForumPostEntity with _$ForumPostEntity {
  const factory ForumPostEntity({
    required String id,
    required String userId,
    required String title,
    required String content,
    String? contentPreview,
    required String categoryId,
    String? category,
    @Default([]) List<ForumMediaItem> mediaUrls,
    required int upvotes,
    required int downvotes,
    required int viewCount,
    required int commentCount,
    required DateTime createdAt,
    required ForumUserEntity user,
    String? userVote,
    List<ForumCommentEntity>? comments,
    @Default([]) List<ForumUserEntity> participants,
    @Default('PUBLISHED') String status,
    /// Hashtag (lowercase, tanpa prefix `#`) yang diekstrak dari content.
    @Default([]) List<String> tags,
    /// Snapshot produk yang di-mention (@produk) saat posting.
    @Default([]) List<ForumProductMentionEntity> productMentions,
  }) = _ForumPostEntity;
}

@freezed
abstract class ForumProductMentionEntity with _$ForumProductMentionEntity {
  const factory ForumProductMentionEntity({
    required String id,
    required String name,
    String? slug,
  }) = _ForumProductMentionEntity;
}

@freezed
abstract class ForumCommentEntity with _$ForumCommentEntity {
  const factory ForumCommentEntity({
    required String id,
    required String content,
    @Default([]) List<ForumMediaItem> mediaUrls,
    required int upvotes,
    required int downvotes,
    required DateTime createdAt,
    required ForumUserEntity user,
    String? userVote,
    List<ForumCommentEntity>? replies,
  }) = _ForumCommentEntity;
}

@freezed
abstract class ForumUserEntity with _$ForumUserEntity {
  const factory ForumUserEntity({
    required String id,
    required String fullName,
    String? avatarUrl,
    String? role,
    @Default(false) bool isVerified,
  }) = _ForumUserEntity;
}

@freezed
abstract class ForumCategoryEntity with _$ForumCategoryEntity {
  const factory ForumCategoryEntity({
    required String id,
    required String name,
    String? description,
    String? categoryType,
  }) = _ForumCategoryEntity;
}
