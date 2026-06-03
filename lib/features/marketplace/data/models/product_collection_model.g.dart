// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductCollectionModel _$ProductCollectionModelFromJson(
  Map<String, dynamic> json,
) => _ProductCollectionModel(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$ProductCollectionModelToJson(
  _ProductCollectionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'description': instance.description,
  'thumbnailUrl': instance.thumbnailUrl,
  'isActive': instance.isActive,
};
