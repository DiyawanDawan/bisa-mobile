import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_bisa/core/services/notification_service.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  StreamSubscription<String>? _tokenRefreshSub;
  bool _fcmListenerAttached = false;

  NotificationCubit(this._repository) : super(const NotificationInitial());

  Future<void> bootstrap() async {
    await registerFcmDevice();
    await refreshUnreadCount();
  }

  /// Register (or refresh) FCM token with backend after login.
  Future<void> registerFcmDevice() async {
    _attachTokenRefreshListener();

    final token = await NotificationService.ensureFcmToken();
    if (token == null || token.isEmpty) return;

    await _sendFcmToken(token);
  }

  void _attachTokenRefreshListener() {
    if (_fcmListenerAttached) return;
    _fcmListenerAttached = true;
    _tokenRefreshSub = NotificationService.onTokenRefresh.listen((token) {
      unawaited(_sendFcmToken(token));
    });
  }

  Future<void> _sendFcmToken(String token) async {
    final platform = NotificationService.devicePlatformLabel();
    final result = await _repository.registerFcmToken(token, platform);
    result.fold(
      (failure) => debugPrint('[FCM] register failed: ${failure.message}'),
      (_) => debugPrint('[FCM] token registered ($platform)'),
    );
  }

  @override
  Future<void> close() {
    unawaited(_tokenRefreshSub?.cancel());
    return super.close();
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

  Future<void> deregisterFcmDevice() async {
    final token = await NotificationService.ensureFcmToken();
    if (token == null || token.isEmpty) return;
    await _repository.deregisterFcmToken(token);
    debugPrint('[FCM] token deregistered on logout');
  }

  void reset() {
    emit(const NotificationInitial(unreadCount: 0));
  }
}
