import 'package:freezed_annotation/freezed_annotation.dart';

part 'waste_point_entity.freezed.dart';

@freezed
abstract class WastePointEntity with _$WastePointEntity {
  const factory WastePointEntity({
    required String id,
    required String province,
    required String regency,
    required String biomassaType,
    required double volumeTon,
    required int year,
    required double lat,
    required double lng,
    String? source,
  }) = _WastePointEntity;
}
