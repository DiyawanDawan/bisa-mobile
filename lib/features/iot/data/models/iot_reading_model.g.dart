// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iot_reading_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_IotReadingModel _$IotReadingModelFromJson(Map<String, dynamic> json) =>
    _IotReadingModel(
      id: json['id'] as String,
      temperature: json['temperature'],
      humidity: json['humidity'],
      co2Level: json['co2Level'],
      recordedAt: json['recordedAt'] as String,
    );

Map<String, dynamic> _$IotReadingModelToJson(_IotReadingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'co2Level': instance.co2Level,
      'recordedAt': instance.recordedAt,
    };
