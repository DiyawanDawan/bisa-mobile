import '../../domain/entities/notification_entity.dart';

abstract class NotificationState {
  const NotificationState({this.unreadCount = 0});

  final int unreadCount;
}

class NotificationInitial extends NotificationState {
  const NotificationInitial({super.unreadCount});
}

class NotificationLoading extends NotificationState {
  const NotificationLoading({super.unreadCount});
}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  NotificationLoaded(this.notifications)
      : super(
          unreadCount: notifications.where((n) => !n.isRead).length,
        );
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message, {super.unreadCount});
}
