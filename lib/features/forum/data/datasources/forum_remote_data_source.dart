import 'dart:io';

import 'package:dio/dio.dart';
import '../models/forum_model.dart';

abstract class ForumRemoteDataSource {
  Future<List<ForumPostModel>> getPosts({
    String? categoryId,
    String? keyword,
    String? tag,
    int page = 1,
    int limit = 10,
  });
  Future<ForumPostModel> getPostById(String id);
  Future<void> createPost(
    String title,
    String content,
    String? categoryId, {
    List<Map<String, dynamic>>? mediaUrls,
    String? status,
    List<String>? tags,
  });
  Future<void> createComment(
    String postId,
    String content, {
    String? parentId,
    List<Map<String, dynamic>>? mediaUrls,
  });
  Future<List<Map<String, dynamic>>> uploadMedia(List<String> filePaths, List<String> types);
  Future<void> vote(String targetId, String targetType, String voteType);
  Future<List<ForumCategoryModel>> getCategories({String? type});

  /// GET /forum/posts/me — list postingan milik user sendiri, dengan filter
  /// status (PUBLISHED / DRAFT / ARCHIVED) opsional.
  Future<List<ForumPostModel>> getMyPosts({
    String? status,
    int page = 1,
    int limit = 20,
  });

  /// PUT /forum/posts/:id — edit / ubah status postingan sendiri.
  Future<void> updatePost(
    String id, {
    String? title,
    String? content,
    String? categoryId,
    List<Map<String, dynamic>>? mediaUrls,
    String? status,
    List<String>? tags,
  });

  /// DELETE /forum/posts/:id — soft-delete (status → ARCHIVED) di backend.
  Future<void> deletePost(String id);
}

class ForumRemoteDataSourceImpl implements ForumRemoteDataSource {
  final Dio dio;

  ForumRemoteDataSourceImpl({required this.dio});

  Map<String, dynamic> _normalizeForumJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['userId'] = normalized['userId'] ?? normalized['user']?['id'];
    if (normalized['createdAt'] != null) {
      normalized['createdAt'] = normalized['createdAt'].toString();
    }
    if (normalized['comments'] is List) {
      normalized['comments'] = (normalized['comments'] as List)
          .map((c) => _normalizeCommentJson(Map<String, dynamic>.from(c as Map)))
          .toList();
    }
    return normalized;
  }

  Map<String, dynamic> _normalizeCommentJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['createdAt'] =
        normalized['createdAt']?.toString() ?? DateTime.now().toIso8601String();

    if (normalized['mediaUrls'] == null && normalized['media_urls'] != null) {
      normalized['mediaUrls'] = normalized['media_urls'];
    }

    final userRaw = normalized['user'];
    if (userRaw is Map) {
      final user = Map<String, dynamic>.from(userRaw);
      user['id'] = user['id']?.toString() ??
          normalized['userId']?.toString() ??
          '';
      user['fullName'] =
          user['fullName'] ?? user['name'] ?? user['full_name'] ?? 'Pengguna';
      normalized['user'] = user;
    } else {
      normalized['user'] = {
        'id': normalized['userId']?.toString() ?? '',
        'fullName': 'Pengguna',
      };
    }

    if (normalized['replies'] is List) {
      normalized['replies'] = (normalized['replies'] as List)
          .map((r) => _normalizeCommentJson(Map<String, dynamic>.from(r as Map)))
          .toList();
    }
    return normalized;
  }

  @override
  Future<List<ForumPostModel>> getPosts({
    String? categoryId,
    String? keyword,
    String? tag,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dio.get(
      '/forum/posts',
      queryParameters: {
        if (categoryId != null) 'categoryId': categoryId,
        if (keyword != null) 'keyword': keyword,
        if (tag != null && tag.isNotEmpty) 'tag': tag,
        'page': page,
        'limit': limit,
      },
    );
    final List data = response.data['data'];
    return data.map((e) {
      final json = Map<String, dynamic>.from(e);
      json['content'] = json['content'] ?? json['contentPreview'] ?? '';
      return ForumPostModel.fromJson(json);
    }).toList();
  }

  @override
  Future<ForumPostModel> getPostById(String id) async {
    final response = await dio.get('/forum/posts/$id');
    final json = _normalizeForumJson(
      Map<String, dynamic>.from(response.data['data']),
    );
    return ForumPostModel.fromJson(json);
  }

  @override
  Future<void> createPost(
    String title,
    String content,
    String? categoryId, {
    List<Map<String, dynamic>>? mediaUrls,
    String? status,
    List<String>? tags,
  }) async {
    await dio.post(
      '/forum/posts',
      data: {
        'title': title,
        'content': content,
        if (categoryId != null && categoryId.isNotEmpty)
          'categoryId': categoryId,
        if (mediaUrls != null && mediaUrls.isNotEmpty) 'mediaUrls': mediaUrls,
        if (status != null) 'status': status,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      },
    );
  }

  @override
  Future<List<ForumPostModel>> getMyPosts({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/forum/posts/me',
      queryParameters: {
        if (status != null) 'status': status,
        'page': page,
        'limit': limit,
      },
    );
    final List data = response.data['data'];
    return data.map((e) {
      final json = Map<String, dynamic>.from(e);
      json['content'] = json['content'] ?? json['contentPreview'] ?? '';
      return ForumPostModel.fromJson(json);
    }).toList();
  }

  @override
  Future<void> updatePost(
    String id, {
    String? title,
    String? content,
    String? categoryId,
    List<Map<String, dynamic>>? mediaUrls,
    String? status,
    List<String>? tags,
  }) async {
    await dio.put(
      '/forum/posts/$id',
      data: {
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (categoryId != null) 'categoryId': categoryId,
        if (mediaUrls != null) 'mediaUrls': mediaUrls,
        if (status != null) 'status': status,
        if (tags != null) 'tags': tags,
      },
    );
  }

  @override
  Future<void> deletePost(String id) async {
    await dio.delete('/forum/posts/$id');
  }

  @override
  Future<void> createComment(
    String postId,
    String content, {
    String? parentId,
    List<Map<String, dynamic>>? mediaUrls,
  }) async {
    await dio.post(
      '/forum/comments',
      data: {
        'postId': postId,
        'content': content,
        if (parentId != null) 'parentId': parentId,
        if (mediaUrls != null && mediaUrls.isNotEmpty) 'mediaUrls': mediaUrls,
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> uploadMedia(
    List<String> filePaths,
    List<String> types,
  ) async {
    final results = <Map<String, dynamic>>[];
    for (var i = 0; i < filePaths.length; i++) {
      final path = filePaths[i];
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          path,
          filename: path.split(Platform.pathSeparator).last,
        ),
      });
      final response = await dio.post(
        '/system/upload',
        queryParameters: {'folder': 'forum'},
        data: formData,
      );
      results.add({
        'url': response.data['data']['url'] as String,
        'type': types[i],
      });
    }
    return results;
  }

  @override
  Future<void> vote(String targetId, String targetType, String voteType) async {
    await dio.post(
      '/forum/vote',
      data: {
        'targetId': targetId,
        'targetType': targetType,
        'voteType': voteType,
      },
    );
  }

  @override
  Future<List<ForumCategoryModel>> getCategories({String? type}) async {
    final response = await dio.get('/categories', queryParameters: {
      if (type != null) 'type': type,
    });
    final List data = response.data['data'];
    return data.map((e) => ForumCategoryModel.fromJson(e)).toList();
  }
}
