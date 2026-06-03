import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/address_entity.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

double? _doubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

@freezed
abstract class AddressModel with _$AddressModel {
  const AddressModel._();

  const factory AddressModel({
    required String id,
    @JsonKey(name: 'label') @Default('') String name,
    @JsonKey(name: 'phone') @Default('') String phoneNumber,
    @JsonKey(name: 'fullAddress') @Default('') String address,
    @Default('') String country,
    @Default('') String province,
    @JsonKey(name: 'regency') @Default('') String city,
    @Default('') String district,
    @Default('') String village,
    String? countryId,
    String? provinceId,
    String? regencyId,
    String? districtId,
    String? villageId,
    @JsonKey(name: 'zipCode') @Default('') String postalCode,
    @JsonKey(fromJson: _doubleFromJson) double? latitude,
    @JsonKey(fromJson: _doubleFromJson) double? longitude,
    @Default(false) bool isPrimary,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  AddressEntity toEntity() => AddressEntity(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        country: country,
        province: province,
        city: city,
        district: district,
        village: village,
        countryId: countryId,
        provinceId: provinceId,
        regencyId: regencyId,
        districtId: districtId,
        villageId: villageId,
        postalCode: postalCode,
        latitude: latitude,
        longitude: longitude,
        isPrimary: isPrimary,
      );
}
