import 'package:freezed_annotation/freezed_annotation.dart';

part 'iot_device_model.freezed.dart';
part 'iot_device_model.g.dart';

@freezed
abstract class IotDeviceModel with _$IotDeviceModel {
  const factory IotDeviceModel({
    required String id,
    required String deviceId,
    required String name,
    required String status, // ONLINE, OFFLINE, ALERT, DISABLED, MAINTENANCE
    @Default('ACTIVE') String monitoringStatus,
    @Default(true) bool isMonitoringEnabled,
    double? lastTemp,
    double? lastHum,
    double? lastCo2,
    DateTime? lastReadingAt,
    double? thresholdMin,
    double? thresholdMax,
  }) = _IotDeviceModel;

  factory IotDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$IotDeviceModelFromJson(json);
}

@freezed
abstract class IotReadingModel with _$IotReadingModel {
  const factory IotReadingModel({
    required String id,
    required double temp,
    required double hum,
    required double co2,
    required DateTime createdAt,
  }) = _IotReadingModel;

  factory IotReadingModel.fromJson(Map<String, dynamic> json) =>
      _$IotReadingModelFromJson(json);
}
