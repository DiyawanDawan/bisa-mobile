// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WastePointModel _$WastePointModelFromJson(Map<String, dynamic> json) =>
    _WastePointModel(
      id: json['id'] as String,
      province: json['province'] as String,
      regency: json['regency'] as String,
      biomassaType: json['biomassaType'] as String,
      volumeTon: (json['volumeTon'] as num).toDouble(),
      year: (json['year'] as num).toInt(),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      source: json['source'] as String?,
    );

Map<String, dynamic> _$WastePointModelToJson(_WastePointModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'province': instance.province,
      'regency': instance.regency,
      'biomassaType': instance.biomassaType,
      'volumeTon': instance.volumeTon,
      'year': instance.year,
      'lat': instance.lat,
      'lng': instance.lng,
      'source': instance.source,
    };
