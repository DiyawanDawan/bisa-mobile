import 'package:dio/dio.dart';
import '../models/follow_models.dart';

abstract class FollowRemoteDataSource {
  Future<List<String>> getMyFollowingIds();
  Future<FollowStatsModel> getFollowStats(String userId);
  Future<FollowListModel> getFollowing({String? userId});
  Future<FollowListModel> getFollowers({String? userId});
  Future<bool> toggleFollow(String userId);
  Future<bool> checkIsFollowing(String userId);
}

class FollowRemoteDataSourceImpl implements FollowRemoteDataSource {
  final Dio dio;

  FollowRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<String>> getMyFollowingIds() async {
    final response = await dio.get('/follows/me/ids');
    final data = response.data['data'] as Map<String, dynamic>;
    return (data['userIds'] as List? ?? []).cast<String>();
  }

  @override
  Future<FollowStatsModel> getFollowStats(String userId) async {
    final response = await dio.get('/follows/stats/$userId');
    return FollowStatsModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<FollowListModel> getFollowing({String? userId}) async {
    final path = userId == null ? '/follows/me/following' : '/follows/$userId/following';
    final response = await dio.get(path);
    return FollowListModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<FollowListModel> getFollowers({String? userId}) async {
    final path = userId == null ? '/follows/me/followers' : '/follows/$userId/followers';
    final response = await dio.get(path);
    return FollowListModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<bool> toggleFollow(String userId) async {
    final response = await dio.post('/follows/toggle', data: {'userId': userId});
    final data = response.data['data'] as Map<String, dynamic>;
    return data['following'] as bool? ?? false;
  }

  @override
  Future<bool> checkIsFollowing(String userId) async {
    final response = await dio.get('/follows/check/$userId');
    final data = response.data['data'] as Map<String, dynamic>;
    return data['isFollowing'] as bool? ?? false;
  }
}
