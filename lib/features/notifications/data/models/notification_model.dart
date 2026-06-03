  import 'package:freezed_annotation/freezed_annotation.dart';
  import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    required String type,
    @Default(false) bool isRead,
    String? refId,
    @Default('MEDIUM') String priority,
    required String createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  const NotificationModel._();

  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        title: title,
        body: body,
        type: type,
        isRead: isRead,
        refId: refId,
        priority: priority,
        createdAt: DateTime.parse(createdAt),
      );
}
