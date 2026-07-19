import 'package:dio/dio.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';
import '../../domain/entities/forum_group_entity.dart';

abstract class ForumGroupRemoteDataSource {
  Future<List<ForumGroupEntity>> getGroups({
    String? keyword,
    bool mine = false,
    int page = 1,
    int limit = 20,
  });
  Future<ForumGroupEntity> getGroupById(String id);
  Future<ForumGroupEntity> createGroup({
    required String name,
    String? description,
    String? avatarUrl,
    String? bannerUrl,
    bool isPublic = true,
  });
  Future<ForumGroupEntity> joinGroup(String id);
  Future<void> leaveGroup(String id);
  Future<String> uploadImage(String localPath);
}

class ForumGroupRemoteDataSourceImpl implements ForumGroupRemoteDataSource {
  final Dio dio;
  final MediaUploadQueue uploadQueue;

  ForumGroupRemoteDataSourceImpl({
    required this.dio,
    required this.uploadQueue,
  });

  @override
  Future<List<ForumGroupEntity>> getGroups({
    String? keyword,
    bool mine = false,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/forum/groups',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (keyword != null && keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
        if (mine) 'mine': 'true',
      },
    );
    final raw = response.data;
    final dynamic payload = raw is Map ? raw['data'] : null;
    final List data = payload is List
        ? payload
        : (payload is Map && payload['groups'] is List)
            ? payload['groups'] as List
            : const [];
    return data
        .whereType<Map>()
        .map((e) => ForumGroupEntity.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<ForumGroupEntity> getGroupById(String id) async {
    final response = await dio.get('/forum/groups/$id');
    final raw = response.data['data'];
    if (raw is! Map) {
      throw StateError('Response grup tidak valid.');
    }
    return ForumGroupEntity.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<ForumGroupEntity> createGroup({
    required String name,
    String? description,
    String? avatarUrl,
    String? bannerUrl,
    bool isPublic = true,
  }) async {
    final response = await dio.post(
      '/forum/groups',
      data: {
        'name': name,
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
        if (avatarUrl != null && avatarUrl.trim().isNotEmpty)
          'avatarUrl': avatarUrl.trim(),
        if (bannerUrl != null && bannerUrl.trim().isNotEmpty)
          'bannerUrl': bannerUrl.trim(),
        'isPublic': isPublic,
      },
    );
    final raw = response.data['data'];
    if (raw is! Map) {
      throw StateError('Response buat grup tidak valid.');
    }
    return ForumGroupEntity.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<ForumGroupEntity> joinGroup(String id) async {
    final response = await dio.post('/forum/groups/$id/join');
    final raw = response.data['data'];
    if (raw is! Map) {
      throw StateError('Response join grup tidak valid.');
    }
    return ForumGroupEntity.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<void> leaveGroup(String id) async {
    await dio.post('/forum/groups/$id/leave');
  }

  @override
  Future<String> uploadImage(String localPath) async {
    final uploaded = await uploadQueue.uploadFile(
      localPath: localPath,
      folder: 'forum-groups',
    );
    // url kosong ("") harus diabaikan — `??` tidak fallback bila string kosong.
    final url = uploaded.url?.trim();
    final path = uploaded.path.trim();
    if (url != null && url.isNotEmpty) return url;
    if (path.isNotEmpty) return path;
    throw StateError('Upload gambar gagal: URL kosong.');
  }
}
