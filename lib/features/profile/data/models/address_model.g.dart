// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddressModel _$AddressModelFromJson(Map<String, dynamic> json) =>
    _AddressModel(
      id: json['id'] as String,
      name: json['label'] as String? ?? '',
      phoneNumber: json['phone'] as String? ?? '',
      address: json['fullAddress'] as String? ?? '',
      country: json['country'] as String? ?? '',
      province: json['province'] as String? ?? '',
      city: json['regency'] as String? ?? '',
      district: json['district'] as String? ?? '',
      village: json['village'] as String? ?? '',
      countryId: json['countryId'] as String?,
      provinceId: json['provinceId'] as String?,
      regencyId: json['regencyId'] as String?,
      districtId: json['districtId'] as String?,
      villageId: json['villageId'] as String?,
      postalCode: json['zipCode'] as String? ?? '',
      latitude: _doubleFromJson(json['latitude']),
      longitude: _doubleFromJson(json['longitude']),
      isPrimary: json['isPrimary'] as bool? ?? false,
    );

Map<String, dynamic> _$AddressModelToJson(_AddressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.name,
      'phone': instance.phoneNumber,
      'fullAddress': instance.address,
      'country': instance.country,
      'province': instance.province,
      'regency': instance.city,
      'district': instance.district,
      'village': instance.village,
      'countryId': instance.countryId,
      'provinceId': instance.provinceId,
      'regencyId': instance.regencyId,
      'districtId': instance.districtId,
      'villageId': instance.villageId,
      'zipCode': instance.postalCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isPrimary': instance.isPrimary,
    };
