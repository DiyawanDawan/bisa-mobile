import 'package:freezed_annotation/freezed_annotation.dart';

part 'fcm_models.freezed.dart';
part 'fcm_models.g.dart';

@freezed
abstract class FcmRegisterRequest with _$FcmRegisterRequest {
  const factory FcmRegisterRequest({
    required String fcmToken,
    required String platform,
    required String deviceId,
    required String deviceName,
    required String appVersion,
  }) = _FcmRegisterRequest;

  factory FcmRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$FcmRegisterRequestFromJson(json);
}

@freezed
abstract class FcmUnregisterRequest with _$FcmUnregisterRequest {
  const factory FcmUnregisterRequest({required String fcmToken}) =
      _FcmUnregisterRequest;

  factory FcmUnregisterRequest.fromJson(Map<String, dynamic> json) =>
      _$FcmUnregisterRequestFromJson(json);
}

@freezed
abstract class FcmResponseModel with _$FcmResponseModel {
  const factory FcmResponseModel({
    required FcmMetaModel meta,
    @Default({}) Map<String, dynamic> data,
  }) = _FcmResponseModel;

  factory FcmResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FcmResponseModelFromJson(json);
}

@freezed
abstract class FcmMetaModel with _$FcmMetaModel {
  const factory FcmMetaModel({
    required bool success,
    required int status,
    required String message,
  }) = _FcmMetaModel;

  factory FcmMetaModel.fromJson(Map<String, dynamic> json) =>
      _$FcmMetaModelFromJson(json);
}
