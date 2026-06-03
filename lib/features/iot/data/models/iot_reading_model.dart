import 'package:freezed_annotation/freezed_annotation.dart';

part 'iot_reading_model.freezed.dart';
part 'iot_reading_model.g.dart';

@freezed
abstract class IotReadingModel with _$IotReadingModel {
  const factory IotReadingModel({
    required String id,
    required dynamic temperature,
    dynamic humidity,
    dynamic co2Level,
    required String recordedAt,
  }) = _IotReadingModel;

  factory IotReadingModel.fromJson(Map<String, dynamic> json) => _$IotReadingModelFromJson(json);
}
