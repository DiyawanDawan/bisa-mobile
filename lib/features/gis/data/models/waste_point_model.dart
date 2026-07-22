import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_bisa/features/gis/data/province_centroids.dart';
import 'package:mobile_bisa/features/gis/domain/entities/waste_point_entity.dart';

part 'waste_point_model.freezed.dart';

double? _asDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

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

  /// API sering kirim `regency`/`lat`/`lng` null — isi centroid provinsi.
  factory WastePointModel.fromJson(Map<String, dynamic> json) {
    final province = (json['province'] ?? '').toString();
    final centroid = resolveProvinceCentroid(province);
    final lat = _asDouble(json['lat']) ?? centroid.lat;
    final lng = _asDouble(json['lng']) ?? centroid.lng;

    return WastePointModel(
      id: (json['id'] ?? '').toString(),
      province: province.isEmpty ? 'Indonesia' : province,
      regency: (json['regency'] ?? '').toString(),
      biomassaType: (json['biomassaType'] ?? '').toString(),
      volumeTon: _asDouble(json['volumeTon']) ?? 0,
      year: _asInt(json['year'], DateTime.now().year),
      lat: lat,
      lng: lng,
      source: json['source']?.toString(),
    );
  }

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
