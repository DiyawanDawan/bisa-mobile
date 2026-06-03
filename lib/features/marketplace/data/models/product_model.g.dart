// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductSellerModel _$ProductSellerModelFromJson(Map<String, dynamic> json) =>
    _ProductSellerModel(
      id: json['id'] as String,
      name: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      profile: json['profile'] == null
          ? null
          : ProductSellerProfileModel.fromJson(
              json['profile'] as Map<String, dynamic>,
            ),
      isVerified: json['isVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$ProductSellerModelToJson(_ProductSellerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.name,
      'avatarUrl': instance.avatarUrl,
      'profile': instance.profile,
      'isVerified': instance.isVerified,
    };

_ProductSellerProfileModel _$ProductSellerProfileModelFromJson(
  Map<String, dynamic> json,
) => _ProductSellerProfileModel(
  companyName: json['companyName'] as String?,
  rajaongkirOriginId: (json['rajaongkirOriginId'] as num?)?.toInt(),
  rajaongkirOriginLabel: json['rajaongkirOriginLabel'] as String?,
);

Map<String, dynamic> _$ProductSellerProfileModelToJson(
  _ProductSellerProfileModel instance,
) => <String, dynamic>{
  'companyName': instance.companyName,
  'rajaongkirOriginId': instance.rajaongkirOriginId,
  'rajaongkirOriginLabel': instance.rajaongkirOriginLabel,
};

_ProductTechnicalSpecModel _$ProductTechnicalSpecModelFromJson(
  Map<String, dynamic> json,
) => _ProductTechnicalSpecModel(
  moistureContent: json['moistureContent'],
  carbonPurity: json['carbonPurity'],
  productionCapacity: json['productionCapacity'],
  surfaceArea: json['surfaceArea'],
  phLevel: json['phLevel'],
  density: json['density'] as String?,
  carbonOffsetPerTon: json['carbonOffsetPerTon'],
  grossWeightPerSak: json['grossWeightPerSak'],
  netWeightPerSak: json['netWeightPerSak'],
  bagDimension: json['bagDimension'] as String?,
);

Map<String, dynamic> _$ProductTechnicalSpecModelToJson(
  _ProductTechnicalSpecModel instance,
) => <String, dynamic>{
  'moistureContent': instance.moistureContent,
  'carbonPurity': instance.carbonPurity,
  'productionCapacity': instance.productionCapacity,
  'surfaceArea': instance.surfaceArea,
  'phLevel': instance.phLevel,
  'density': instance.density,
  'carbonOffsetPerTon': instance.carbonOffsetPerTon,
  'grossWeightPerSak': instance.grossWeightPerSak,
  'netWeightPerSak': instance.netWeightPerSak,
  'bagDimension': instance.bagDimension,
};

_ProductImageModel _$ProductImageModelFromJson(Map<String, dynamic> json) =>
    _ProductImageModel(
      id: json['id'] as String,
      url: json['url'] as String,
      isPrimary: json['isPrimary'] as bool? ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProductImageModelToJson(_ProductImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'isPrimary': instance.isPrimary,
      'order': instance.order,
    };
