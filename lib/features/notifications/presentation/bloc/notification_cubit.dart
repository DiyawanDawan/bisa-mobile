import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository) : super(const NotificationInitial());

  Future<void> bootstrap() async {
    await refreshUnreadCount();
  }

  Future<void> refreshUnreadCount() async {
    final result = await _repository.getNotifications(limit: 50);
    result.fold(
      (_) {},
      (notifications) {
        if (state is NotificationLoaded) {
          emit(NotificationLoaded(notifications));
        } else {
          final count = notifications.where((n) => !n.isRead).length;
          emit(NotificationInitial(unreadCount: count));
        }
      },
    );
  }

  Future<void> getNotifications() async {
    final previousCount = state.unreadCount;
    emit(NotificationLoading(unreadCount: previousCount));
    final result = await _repository.getNotifications();
    result.fold(
      (failure) => emit(NotificationError(failure.message, unreadCount: previousCount)),
      (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await _repository.markAsRead(id);
    result.fold(
      (failure) => null,
      (_) => getNotifications(),
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _repository.markAllAsRead();
    result.fold(
      (failure) => null,
      (_) => getNotifications(),
    );
  }

  Future<void> deleteNotification(String id) async {
    final result = await _repository.deleteNotification(id);
    result.fold(
      (failure) => null,
      (_) => getNotifications(),
    );
  }

  Future<NotificationEntity?> fetchNotificationById(String id) async {
    final result = await _repository.getNotificationById(id);
    return result.fold((_) => null, (notification) => notification);
  }

  Future<bool> markAsReadSilent(String id) async {
    final result = await _repository.markAsRead(id);
    return result.isRight();
  }

  void reset() {
    emit(const NotificationInitial(unreadCount: 0));
  }
}
