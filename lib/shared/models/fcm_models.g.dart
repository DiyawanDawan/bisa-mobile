// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FcmRegisterRequest _$FcmRegisterRequestFromJson(Map<String, dynamic> json) =>
    _FcmRegisterRequest(
      fcmToken: json['fcmToken'] as String,
      platform: json['platform'] as String,
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      appVersion: json['appVersion'] as String,
    );

Map<String, dynamic> _$FcmRegisterRequestToJson(_FcmRegisterRequest instance) =>
    <String, dynamic>{
      'fcmToken': instance.fcmToken,
      'platform': instance.platform,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'appVersion': instance.appVersion,
    };

_FcmUnregisterRequest _$FcmUnregisterRequestFromJson(
  Map<String, dynamic> json,
) => _FcmUnregisterRequest(fcmToken: json['fcmToken'] as String);

Map<String, dynamic> _$FcmUnregisterRequestToJson(
  _FcmUnregisterRequest instance,
) => <String, dynamic>{'fcmToken': instance.fcmToken};

_FcmResponseModel _$FcmResponseModelFromJson(Map<String, dynamic> json) =>
    _FcmResponseModel(
      meta: FcmMetaModel.fromJson(json['meta'] as Map<String, dynamic>),
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$FcmResponseModelToJson(_FcmResponseModel instance) =>
    <String, dynamic>{'meta': instance.meta, 'data': instance.data};

_FcmMetaModel _$FcmMetaModelFromJson(Map<String, dynamic> json) =>
    _FcmMetaModel(
      success: json['success'] as bool,
      status: (json['status'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$FcmMetaModelToJson(_FcmMetaModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'status': instance.status,
      'message': instance.message,
    };
