import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../domain/entities/forum_entity.dart';
import '../../domain/entities/forum_media.dart';

part 'forum_model.freezed.dart';
part 'forum_model.g.dart';

List<ForumMediaItem> _mediaFromJson(dynamic json) =>
    parseForumMediaList(json) ?? [];

List<String> _tagsFromJson(dynamic raw) {
  if (raw is List) {
    return raw
        .whereType<Object>()
        .map((e) => e.toString().trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  if (raw is String && raw.isNotEmpty) {
    return raw.split(',').map((e) => e.trim().toLowerCase()).toList();
  }
  return const [];
}

List<ForumProductMentionModel> _mentionsFromJson(dynamic raw) {
  if (raw is! List) return const [];
  return raw
      .whereType<Map>()
      .map((m) => ForumProductMentionModel.fromJson(
            Map<String, dynamic>.from(m),
          ))
      .toList();
}

@freezed
abstract class ForumPostModel with _$ForumPostModel {
  const factory ForumPostModel({
    required String id,
    @Default('') String userId,
    required String title,
    @Default('') String content,
    String? contentPreview,
    @Default('') String categoryId,
    @JsonKey(fromJson: _mediaFromJson) @Default([]) List<ForumMediaItem> mediaUrls,
    @Default(0) int upvotes,
    @Default(0) int downvotes,
    @Default(0) int viewCount,
    @JsonKey(name: '_count') Map<String, dynamic>? count,
    required String createdAt,
    ForumUserModel? user,
    Map<String, dynamic>? category,
    String? userVote,
    List<ForumCommentModel>? comments,
    @Default([]) List<ForumUserModel> participants,
    @Default('PUBLISHED') String status,
    @JsonKey(fromJson: _tagsFromJson) @Default([]) List<String> tags,
    @JsonKey(name: 'productMentions', fromJson: _mentionsFromJson)
    @Default([])
    List<ForumProductMentionModel> productMentions,
  }) = _ForumPostModel;

  factory ForumPostModel.fromJson(Map<String, dynamic> json) =>
      _$ForumPostModelFromJson(json);

  const ForumPostModel._();

  ForumPostEntity toEntity() => ForumPostEntity(
    id: id,
    userId: userId,
    title: title,
    content: content,
    contentPreview: contentPreview,
    categoryId: categoryId,
    category: category?['name'],
    mediaUrls: resolveForumMediaList(mediaUrls),
    upvotes: upvotes,
    downvotes: downvotes,
    viewCount: viewCount,
    commentCount: (count?['comments'] as num?)?.toInt() ??
        comments?.length ??
        0,
    createdAt: DateTime.parse(createdAt),
    user: user?.toEntity() ??
        const ForumUserEntity(id: '', fullName: 'Pengguna'),
    userVote: userVote,
    comments: comments?.map((e) => e.toEntity()).toList(),
    participants: participants.map((e) => e.toEntity()).toList(),
    status: status,
    tags: tags,
    productMentions: productMentions.map((e) => e.toEntity()).toList(),
  );
}

@freezed
abstract class ForumProductMentionModel with _$ForumProductMentionModel {
  const factory ForumProductMentionModel({
    required String id,
    required String name,
    String? slug,
  }) = _ForumProductMentionModel;

  factory ForumProductMentionModel.fromJson(Map<String, dynamic> json) =>
      _$ForumProductMentionModelFromJson(json);

  const ForumProductMentionModel._();

  ForumProductMentionEntity toEntity() => ForumProductMentionEntity(
    id: id,
    name: name,
    slug: slug,
  );
}

@freezed
abstract class ForumCommentModel with _$ForumCommentModel {
  const factory ForumCommentModel({
    required String id,
    required String content,
    @JsonKey(fromJson: _mediaFromJson) @Default([]) List<ForumMediaItem> mediaUrls,
    @Default(0) int upvotes,
    @Default(0) int downvotes,
    required String createdAt,
    required ForumUserModel user,
    String? userVote,
    List<ForumCommentModel>? replies,
  }) = _ForumCommentModel;

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) =>
      _$ForumCommentModelFromJson(json);

  const ForumCommentModel._();

  ForumCommentEntity toEntity() => ForumCommentEntity(
    id: id,
    content: content,
    mediaUrls: resolveForumMediaList(mediaUrls),
    upvotes: upvotes,
    downvotes: downvotes,
    createdAt: DateTime.parse(createdAt),
    user: user.toEntity(),
    userVote: userVote,
    replies: replies?.map((e) => e.toEntity()).toList(),
  );
}

@freezed
abstract class ForumUserModel with _$ForumUserModel {
  const factory ForumUserModel({
    required String id,
    required String fullName,
    String? avatarUrl,
    String? role,
    Map<String, dynamic>? verification,
  }) = _ForumUserModel;

  factory ForumUserModel.fromJson(Map<String, dynamic> json) =>
      _$ForumUserModelFromJson(json);

  const ForumUserModel._();

  ForumUserEntity toEntity() => ForumUserEntity(
    id: id,
    fullName: fullName,
    avatarUrl: resolveMediaField(avatarUrl),
    role: role,
    isVerified: verification?['isVerified'] ?? false,
  );
}

@freezed
abstract class ForumCategoryModel with _$ForumCategoryModel {
  const factory ForumCategoryModel({
    required String id,
    required String name,
    String? description,
    String? categoryType,
  }) = _ForumCategoryModel;

  factory ForumCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ForumCategoryModelFromJson(json);

  const ForumCategoryModel._();

  ForumCategoryEntity toEntity() => ForumCategoryEntity(
    id: id,
    name: name,
    description: description,
    categoryType: categoryType,
  );
}
