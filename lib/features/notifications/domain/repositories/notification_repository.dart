import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({int page = 1, int limit = 20});
  Future<Either<Failure, void>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> registerFcmToken(String token, String platform);
  Future<Either<Failure, void>> deleteNotification(String id);
  Future<Either<Failure, NotificationEntity>> getNotificationById(String id);
}
