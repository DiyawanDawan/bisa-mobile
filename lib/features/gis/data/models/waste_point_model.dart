import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_bisa/features/gis/domain/entities/waste_point_entity.dart';

part 'waste_point_model.freezed.dart';
part 'waste_point_model.g.dart';

@freezed
abstract class WastePointModel with _$WastePointModel {
  const factory WastePointModel({
    required String id,
    required String province,
    required String regency,
    required String biomassaType,
    required double volumeTon,
    required int year,
    required double lat,
    required double lng,
    String? source,
  }) = _WastePointModel;

  const WastePointModel._();

  factory WastePointModel.fromJson(Map<String, dynamic> json) =>
      _$WastePointModelFromJson(json);

  WastePointEntity toEntity() => WastePointEntity(
        id: id,
        province: province,
        regency: regency,
        biomassaType: biomassaType,
        volumeTon: volumeTon,
        year: year,
        lat: lat,
        lng: lng,
        source: source,
      );
}
