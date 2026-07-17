import 'package:dio/dio.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
  });
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> registerFcmToken(String token, String platform);
  Future<void> deregisterFcmToken(String token);
  Future<void> deleteNotification(String id);
  Future<NotificationModel> getNotificationById(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/notifications',
      queryParameters: {'page': page, 'limit': limit},
    );
    final List data = response.data['data'];
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await dio.patch('/notifications/$id/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await dio.patch('/notifications/read-all');
  }

  @override
  Future<void> registerFcmToken(String token, String platform) async {
    await dio.post(
      '/notifications/tokens',
      data: {'fcmToken': token, 'platform': platform.toUpperCase()},
    );
  }

  @override
  Future<void> deregisterFcmToken(String token) async {
    await dio.delete('/notifications/tokens', data: {'fcmToken': token});
  }

  @override
  Future<void> deleteNotification(String id) async {
    await dio.delete('/notifications/$id');
  }

  @override
  Future<NotificationModel> getNotificationById(String id) async {
    final response = await dio.get('/notifications/$id');
    return NotificationModel.fromJson(response.data['data']);
  }
}
