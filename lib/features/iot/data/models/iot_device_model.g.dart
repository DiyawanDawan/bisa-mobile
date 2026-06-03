// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IotDeviceModel _$IotDeviceModelFromJson(Map<String, dynamic> json) =>
    _IotDeviceModel(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      monitoringStatus: json['monitoringStatus'] as String? ?? 'ACTIVE',
      isMonitoringEnabled: json['isMonitoringEnabled'] as bool? ?? true,
      lastTemp: (json['lastTemp'] as num?)?.toDouble(),
      lastHum: (json['lastHum'] as num?)?.toDouble(),
      lastCo2: (json['lastCo2'] as num?)?.toDouble(),
      lastReadingAt: json['lastReadingAt'] == null
          ? null
          : DateTime.parse(json['lastReadingAt'] as String),
      thresholdMin: (json['thresholdMin'] as num?)?.toDouble(),
      thresholdMax: (json['thresholdMax'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$IotDeviceModelToJson(_IotDeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deviceId': instance.deviceId,
      'name': instance.name,
      'status': instance.status,
      'monitoringStatus': instance.monitoringStatus,
      'isMonitoringEnabled': instance.isMonitoringEnabled,
      'lastTemp': instance.lastTemp,
      'lastHum': instance.lastHum,
      'lastCo2': instance.lastCo2,
      'lastReadingAt': instance.lastReadingAt?.toIso8601String(),
      'thresholdMin': instance.thresholdMin,
      'thresholdMax': instance.thresholdMax,
    };

_IotReadingModel _$IotReadingModelFromJson(Map<String, dynamic> json) =>
    _IotReadingModel(
      id: json['id'] as String,
      temp: (json['temp'] as num).toDouble(),
      hum: (json['hum'] as num).toDouble(),
      co2: (json['co2'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$IotReadingModelToJson(_IotReadingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'temp': instance.temp,
      'hum': instance.hum,
      'co2': instance.co2,
      'createdAt': instance.createdAt.toIso8601String(),
    };
