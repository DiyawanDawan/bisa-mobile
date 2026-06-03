import 'package:freezed_annotation/freezed_annotation.dart';

part 'iot_alert_model.freezed.dart';
part 'iot_alert_model.g.dart';

@freezed
abstract class IotAlertModel with _$IotAlertModel {
  const factory IotAlertModel({
    required String id,
    required String alertType,
    required String message,
    dynamic temperature,
    @Default(false) bool isRead,
    required String createdAt,
  }) = _IotAlertModel;

  factory IotAlertModel.fromJson(Map<String, dynamic> json) => _$IotAlertModelFromJson(json);
}
