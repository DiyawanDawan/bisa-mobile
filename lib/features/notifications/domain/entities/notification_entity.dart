import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

@freezed
abstract class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required String id,
    required String title,
    required String body,
    required String type,
    required bool isRead,
    String? refId,
    @Default('MEDIUM') String priority,
    required DateTime createdAt,
  }) = _NotificationEntity;
}
