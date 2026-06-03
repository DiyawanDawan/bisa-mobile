// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForumPostModel _$ForumPostModelFromJson(Map<String, dynamic> json) =>
    _ForumPostModel(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      contentPreview: json['contentPreview'] as String?,
      categoryId: json['categoryId'] as String? ?? '',
      mediaUrls: json['mediaUrls'] == null
          ? const []
          : _mediaFromJson(json['mediaUrls']),
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (json['downvotes'] as num?)?.toInt() ?? 0,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      count: json['_count'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String,
      user: json['user'] == null
          ? null
          : ForumUserModel.fromJson(json['user'] as Map<String, dynamic>),
      category: json['category'] as Map<String, dynamic>?,
      userVote: json['userVote'] as String?,
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => ForumCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      participants:
          (json['participants'] as List<dynamic>?)
              ?.map((e) => ForumUserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      status: json['status'] as String? ?? 'PUBLISHED',
      tags: json['tags'] == null ? const [] : _tagsFromJson(json['tags']),
      productMentions: json['productMentions'] == null
          ? const []
          : _mentionsFromJson(json['productMentions']),
    );

Map<String, dynamic> _$ForumPostModelToJson(_ForumPostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'contentPreview': instance.contentPreview,
      'categoryId': instance.categoryId,
      'mediaUrls': instance.mediaUrls,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'viewCount': instance.viewCount,
      '_count': instance.count,
      'createdAt': instance.createdAt,
      'user': instance.user,
      'category': instance.category,
      'userVote': instance.userVote,
      'comments': instance.comments,
      'participants': instance.participants,
      'status': instance.status,
      'tags': instance.tags,
      'productMentions': instance.productMentions,
    };

_ForumProductMentionModel _$ForumProductMentionModelFromJson(
  Map<String, dynamic> json,
) => _ForumProductMentionModel(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String?,
);

Map<String, dynamic> _$ForumProductMentionModelToJson(
  _ForumProductMentionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
};

_ForumCommentModel _$ForumCommentModelFromJson(Map<String, dynamic> json) =>
    _ForumCommentModel(
      id: json['id'] as String,
      content: json['content'] as String,
      mediaUrls: json['mediaUrls'] == null
          ? const []
          : _mediaFromJson(json['mediaUrls']),
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      downvotes: (json['downvotes'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String,
      user: ForumUserModel.fromJson(json['user'] as Map<String, dynamic>),
      userVote: json['userVote'] as String?,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => ForumCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ForumCommentModelToJson(_ForumCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'mediaUrls': instance.mediaUrls,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'createdAt': instance.createdAt,
      'user': instance.user,
      'userVote': instance.userVote,
      'replies': instance.replies,
    };

_ForumUserModel _$ForumUserModelFromJson(Map<String, dynamic> json) =>
    _ForumUserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String?,
      verification: json['verification'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ForumUserModelToJson(_ForumUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'role': instance.role,
      'verification': instance.verification,
    };

_ForumCategoryModel _$ForumCategoryModelFromJson(Map<String, dynamic> json) =>
    _ForumCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      categoryType: json['categoryType'] as String?,
    );

Map<String, dynamic> _$ForumCategoryModelToJson(_ForumCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'categoryType': instance.categoryType,
    };
