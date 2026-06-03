// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waste_point_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WastePointEntity {

 String get id; String get province; String get regency; String get biomassaType; double get volumeTon; int get year; double get lat; double get lng; String? get source;
/// Create a copy of WastePointEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WastePointEntityCopyWith<WastePointEntity> get copyWith => _$WastePointEntityCopyWithImpl<WastePointEntity>(this as WastePointEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WastePointEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.volumeTon, volumeTon) || other.volumeTon == volumeTon)&&(identical(other.year, year) || other.year == year)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,province,regency,biomassaType,volumeTon,year,lat,lng,source);

@override
String toString() {
  return 'WastePointEntity(id: $id, province: $province, regency: $regency, biomassaType: $biomassaType, volumeTon: $volumeTon, year: $year, lat: $lat, lng: $lng, source: $source)';
}


}

/// @nodoc
abstract mixin class $WastePointEntityCopyWith<$Res>  {
  factory $WastePointEntityCopyWith(WastePointEntity value, $Res Function(WastePointEntity) _then) = _$WastePointEntityCopyWithImpl;
@useResult
$Res call({
 String id, String province, String regency, String biomassaType, double volumeTon, int year, double lat, double lng, String? source
});




}
/// @nodoc
class _$WastePointEntityCopyWithImpl<$Res>
    implements $WastePointEntityCopyWith<$Res> {
  _$WastePointEntityCopyWithImpl(this._self, this._then);

  final WastePointEntity _self;
  final $Res Function(WastePointEntity) _then;

/// Create a copy of WastePointEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? province = null,Object? regency = null,Object? biomassaType = null,Object? volumeTon = null,Object? year = null,Object? lat = null,Object? lng = null,Object? source = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,regency: null == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String,biomassaType: null == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String,volumeTon: null == volumeTon ? _self.volumeTon : volumeTon // ignore: cast_nullable_to_non_nullable
as double,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WastePointEntity].
extension WastePointEntityPatterns on WastePointEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WastePointEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WastePointEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WastePointEntity value)  $default,){
final _that = this;
switch (_that) {
case _WastePointEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WastePointEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WastePointEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String province,  String regency,  String biomassaType,  double volumeTon,  int year,  double lat,  double lng,  String? source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WastePointEntity() when $default != null:
return $default(_that.id,_that.province,_that.regency,_that.biomassaType,_that.volumeTon,_that.year,_that.lat,_that.lng,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String province,  String regency,  String biomassaType,  double volumeTon,  int year,  double lat,  double lng,  String? source)  $default,) {final _that = this;
switch (_that) {
case _WastePointEntity():
return $default(_that.id,_that.province,_that.regency,_that.biomassaType,_that.volumeTon,_that.year,_that.lat,_that.lng,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String province,  String regency,  String biomassaType,  double volumeTon,  int year,  double lat,  double lng,  String? source)?  $default,) {final _that = this;
switch (_that) {
case _WastePointEntity() when $default != null:
return $default(_that.id,_that.province,_that.regency,_that.biomassaType,_that.volumeTon,_that.year,_that.lat,_that.lng,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _WastePointEntity implements WastePointEntity {
  const _WastePointEntity({required this.id, required this.province, required this.regency, required this.biomassaType, required this.volumeTon, required this.year, required this.lat, required this.lng, this.source});
  

@override final  String id;
@override final  String province;
@override final  String regency;
@override final  String biomassaType;
@override final  double volumeTon;
@override final  int year;
@override final  double lat;
@override final  double lng;
@override final  String? source;

/// Create a copy of WastePointEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WastePointEntityCopyWith<_WastePointEntity> get copyWith => __$WastePointEntityCopyWithImpl<_WastePointEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WastePointEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.volumeTon, volumeTon) || other.volumeTon == volumeTon)&&(identical(other.year, year) || other.year == year)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,province,regency,biomassaType,volumeTon,year,lat,lng,source);

@override
String toString() {
  return 'WastePointEntity(id: $id, province: $province, regency: $regency, biomassaType: $biomassaType, volumeTon: $volumeTon, year: $year, lat: $lat, lng: $lng, source: $source)';
}


}

/// @nodoc
abstract mixin class _$WastePointEntityCopyWith<$Res> implements $WastePointEntityCopyWith<$Res> {
  factory _$WastePointEntityCopyWith(_WastePointEntity value, $Res Function(_WastePointEntity) _then) = __$WastePointEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String province, String regency, String biomassaType, double volumeTon, int year, double lat, double lng, String? source
});




}
/// @nodoc
class __$WastePointEntityCopyWithImpl<$Res>
    implements _$WastePointEntityCopyWith<$Res> {
  __$WastePointEntityCopyWithImpl(this._self, this._then);

  final _WastePointEntity _self;
  final $Res Function(_WastePointEntity) _then;

/// Create a copy of WastePointEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? province = null,Object? regency = null,Object? biomassaType = null,Object? volumeTon = null,Object? year = null,Object? lat = null,Object? lng = null,Object? source = freezed,}) {
  return _then(_WastePointEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,regency: null == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String,biomassaType: null == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String,volumeTon: null == volumeTon ? _self.volumeTon : volumeTon // ignore: cast_nullable_to_non_nullable
as double,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
