import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_entity.freezed.dart';

@freezed
abstract class AddressEntity with _$AddressEntity {
  const factory AddressEntity({
    required String id,
    required String name,
    required String phoneNumber,
    required String address,
    required String country,
    required String province,
    required String city,
    required String district,
    required String village,
    String? countryId,
    String? provinceId,
    String? regencyId,
    String? districtId,
    String? villageId,
    required String postalCode,
    double? latitude,
    double? longitude,
    @Default(false) bool isPrimary,
  }) = _AddressEntity;
}
