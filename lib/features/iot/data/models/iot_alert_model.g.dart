// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IotAlertModel _$IotAlertModelFromJson(Map<String, dynamic> json) =>
    _IotAlertModel(
      id: json['id'] as String,
      alertType: json['alertType'] as String,
      message: json['message'] as String,
      temperature: json['temperature'],
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$IotAlertModelToJson(_IotAlertModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alertType': instance.alertType,
      'message': instance.message,
      'temperature': instance.temperature,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt,
    };
