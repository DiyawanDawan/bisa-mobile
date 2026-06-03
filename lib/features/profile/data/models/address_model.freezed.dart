// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddressModel {

 String get id;@JsonKey(name: 'label') String get name;@JsonKey(name: 'phone') String get phoneNumber;@JsonKey(name: 'fullAddress') String get address; String get country; String get province;@JsonKey(name: 'regency') String get city; String get district; String get village; String? get countryId; String? get provinceId; String? get regencyId; String? get districtId; String? get villageId;@JsonKey(name: 'zipCode') String get postalCode;@JsonKey(fromJson: _doubleFromJson) double? get latitude;@JsonKey(fromJson: _doubleFromJson) double? get longitude; bool get isPrimary;
/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressModelCopyWith<AddressModel> get copyWith => _$AddressModelCopyWithImpl<AddressModel>(this as AddressModel, _$identity);

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.country, country) || other.country == country)&&(identical(other.province, province) || other.province == province)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.village, village) || other.village == village)&&(identical(other.countryId, countryId) || other.countryId == countryId)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,address,country,province,city,district,village,countryId,provinceId,regencyId,districtId,villageId,postalCode,latitude,longitude,isPrimary);

@override
String toString() {
  return 'AddressModel(id: $id, name: $name, phoneNumber: $phoneNumber, address: $address, country: $country, province: $province, city: $city, district: $district, village: $village, countryId: $countryId, provinceId: $provinceId, regencyId: $regencyId, districtId: $districtId, villageId: $villageId, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class $AddressModelCopyWith<$Res>  {
  factory $AddressModelCopyWith(AddressModel value, $Res Function(AddressModel) _then) = _$AddressModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'label') String name,@JsonKey(name: 'phone') String phoneNumber,@JsonKey(name: 'fullAddress') String address, String country, String province,@JsonKey(name: 'regency') String city, String district, String village, String? countryId, String? provinceId, String? regencyId, String? districtId, String? villageId,@JsonKey(name: 'zipCode') String postalCode,@JsonKey(fromJson: _doubleFromJson) double? latitude,@JsonKey(fromJson: _doubleFromJson) double? longitude, bool isPrimary
});




}
/// @nodoc
class _$AddressModelCopyWithImpl<$Res>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._self, this._then);

  final AddressModel _self;
  final $Res Function(AddressModel) _then;

/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? address = null,Object? country = null,Object? province = null,Object? city = null,Object? district = null,Object? village = null,Object? countryId = freezed,Object? provinceId = freezed,Object? regencyId = freezed,Object? districtId = freezed,Object? villageId = freezed,Object? postalCode = null,Object? latitude = freezed,Object? longitude = freezed,Object? isPrimary = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,village: null == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as String,countryId: freezed == countryId ? _self.countryId : countryId // ignore: cast_nullable_to_non_nullable
as String?,provinceId: freezed == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as String?,regencyId: freezed == regencyId ? _self.regencyId : regencyId // ignore: cast_nullable_to_non_nullable
as String?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String?,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as String?,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressModel].
extension AddressModelPatterns on AddressModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressModel value)  $default,){
final _that = this;
switch (_that) {
case _AddressModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressModel value)?  $default,){
final _that = this;
switch (_that) {
case _AddressModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'label')  String name, @JsonKey(name: 'phone')  String phoneNumber, @JsonKey(name: 'fullAddress')  String address,  String country,  String province, @JsonKey(name: 'regency')  String city,  String district,  String village,  String? countryId,  String? provinceId,  String? regencyId,  String? districtId,  String? villageId, @JsonKey(name: 'zipCode')  String postalCode, @JsonKey(fromJson: _doubleFromJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson)  double? longitude,  bool isPrimary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressModel() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.address,_that.country,_that.province,_that.city,_that.district,_that.village,_that.countryId,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.postalCode,_that.latitude,_that.longitude,_that.isPrimary);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'label')  String name, @JsonKey(name: 'phone')  String phoneNumber, @JsonKey(name: 'fullAddress')  String address,  String country,  String province, @JsonKey(name: 'regency')  String city,  String district,  String village,  String? countryId,  String? provinceId,  String? regencyId,  String? districtId,  String? villageId, @JsonKey(name: 'zipCode')  String postalCode, @JsonKey(fromJson: _doubleFromJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson)  double? longitude,  bool isPrimary)  $default,) {final _that = this;
switch (_that) {
case _AddressModel():
return $default(_that.id,_that.name,_that.phoneNumber,_that.address,_that.country,_that.province,_that.city,_that.district,_that.village,_that.countryId,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.postalCode,_that.latitude,_that.longitude,_that.isPrimary);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'label')  String name, @JsonKey(name: 'phone')  String phoneNumber, @JsonKey(name: 'fullAddress')  String address,  String country,  String province, @JsonKey(name: 'regency')  String city,  String district,  String village,  String? countryId,  String? provinceId,  String? regencyId,  String? districtId,  String? villageId, @JsonKey(name: 'zipCode')  String postalCode, @JsonKey(fromJson: _doubleFromJson)  double? latitude, @JsonKey(fromJson: _doubleFromJson)  double? longitude,  bool isPrimary)?  $default,) {final _that = this;
switch (_that) {
case _AddressModel() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.address,_that.country,_that.province,_that.city,_that.district,_that.village,_that.countryId,_that.provinceId,_that.regencyId,_that.districtId,_that.villageId,_that.postalCode,_that.latitude,_that.longitude,_that.isPrimary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddressModel extends AddressModel {
  const _AddressModel({required this.id, @JsonKey(name: 'label') this.name = '', @JsonKey(name: 'phone') this.phoneNumber = '', @JsonKey(name: 'fullAddress') this.address = '', this.country = '', this.province = '', @JsonKey(name: 'regency') this.city = '', this.district = '', this.village = '', this.countryId, this.provinceId, this.regencyId, this.districtId, this.villageId, @JsonKey(name: 'zipCode') this.postalCode = '', @JsonKey(fromJson: _doubleFromJson) this.latitude, @JsonKey(fromJson: _doubleFromJson) this.longitude, this.isPrimary = false}): super._();
  factory _AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'label') final  String name;
@override@JsonKey(name: 'phone') final  String phoneNumber;
@override@JsonKey(name: 'fullAddress') final  String address;
@override@JsonKey() final  String country;
@override@JsonKey() final  String province;
@override@JsonKey(name: 'regency') final  String city;
@override@JsonKey() final  String district;
@override@JsonKey() final  String village;
@override final  String? countryId;
@override final  String? provinceId;
@override final  String? regencyId;
@override final  String? districtId;
@override final  String? villageId;
@override@JsonKey(name: 'zipCode') final  String postalCode;
@override@JsonKey(fromJson: _doubleFromJson) final  double? latitude;
@override@JsonKey(fromJson: _doubleFromJson) final  double? longitude;
@override@JsonKey() final  bool isPrimary;

/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressModelCopyWith<_AddressModel> get copyWith => __$AddressModelCopyWithImpl<_AddressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.address, address) || other.address == address)&&(identical(other.country, country) || other.country == country)&&(identical(other.province, province) || other.province == province)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.village, village) || other.village == village)&&(identical(other.countryId, countryId) || other.countryId == countryId)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.regencyId, regencyId) || other.regencyId == regencyId)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,address,country,province,city,district,village,countryId,provinceId,regencyId,districtId,villageId,postalCode,latitude,longitude,isPrimary);

@override
String toString() {
  return 'AddressModel(id: $id, name: $name, phoneNumber: $phoneNumber, address: $address, country: $country, province: $province, city: $city, district: $district, village: $village, countryId: $countryId, provinceId: $provinceId, regencyId: $regencyId, districtId: $districtId, villageId: $villageId, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class _$AddressModelCopyWith<$Res> implements $AddressModelCopyWith<$Res> {
  factory _$AddressModelCopyWith(_AddressModel value, $Res Function(_AddressModel) _then) = __$AddressModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'label') String name,@JsonKey(name: 'phone') String phoneNumber,@JsonKey(name: 'fullAddress') String address, String country, String province,@JsonKey(name: 'regency') String city, String district, String village, String? countryId, String? provinceId, String? regencyId, String? districtId, String? villageId,@JsonKey(name: 'zipCode') String postalCode,@JsonKey(fromJson: _doubleFromJson) double? latitude,@JsonKey(fromJson: _doubleFromJson) double? longitude, bool isPrimary
});




}
/// @nodoc
class __$AddressModelCopyWithImpl<$Res>
    implements _$AddressModelCopyWith<$Res> {
  __$AddressModelCopyWithImpl(this._self, this._then);

  final _AddressModel _self;
  final $Res Function(_AddressModel) _then;

/// Create a copy of AddressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? address = null,Object? country = null,Object? province = null,Object? city = null,Object? district = null,Object? village = null,Object? countryId = freezed,Object? provinceId = freezed,Object? regencyId = freezed,Object? districtId = freezed,Object? villageId = freezed,Object? postalCode = null,Object? latitude = freezed,Object? longitude = freezed,Object? isPrimary = null,}) {
  return _then(_AddressModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,village: null == village ? _self.village : village // ignore: cast_nullable_to_non_nullable
as String,countryId: freezed == countryId ? _self.countryId : countryId // ignore: cast_nullable_to_non_nullable
as String?,provinceId: freezed == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as String?,regencyId: freezed == regencyId ? _self.regencyId : regencyId // ignore: cast_nullable_to_non_nullable
as String?,districtId: freezed == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String?,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as String?,postalCode: null == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
