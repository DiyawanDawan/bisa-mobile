// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waste_point_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WastePointModel {

 String get id; String get province; String get regency; String get biomassaType; double get volumeTon; int get year; double get lat; double get lng; String? get source;
/// Create a copy of WastePointModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WastePointModelCopyWith<WastePointModel> get copyWith => _$WastePointModelCopyWithImpl<WastePointModel>(this as WastePointModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WastePointModel&&(identical(other.id, id) || other.id == id)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.volumeTon, volumeTon) || other.volumeTon == volumeTon)&&(identical(other.year, year) || other.year == year)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,province,regency,biomassaType,volumeTon,year,lat,lng,source);

@override
String toString() {
  return 'WastePointModel(id: $id, province: $province, regency: $regency, biomassaType: $biomassaType, volumeTon: $volumeTon, year: $year, lat: $lat, lng: $lng, source: $source)';
}


}

/// @nodoc
abstract mixin class $WastePointModelCopyWith<$Res>  {
  factory $WastePointModelCopyWith(WastePointModel value, $Res Function(WastePointModel) _then) = _$WastePointModelCopyWithImpl;
@useResult
$Res call({
 String id, String province, String regency, String biomassaType, double volumeTon, int year, double lat, double lng, String? source
});




}
/// @nodoc
class _$WastePointModelCopyWithImpl<$Res>
    implements $WastePointModelCopyWith<$Res> {
  _$WastePointModelCopyWithImpl(this._self, this._then);

  final WastePointModel _self;
  final $Res Function(WastePointModel) _then;

/// Create a copy of WastePointModel
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


/// Adds pattern-matching-related methods to [WastePointModel].
extension WastePointModelPatterns on WastePointModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WastePointModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WastePointModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WastePointModel value)  $default,){
final _that = this;
switch (_that) {
case _WastePointModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WastePointModel value)?  $default,){
final _that = this;
switch (_that) {
case _WastePointModel() when $default != null:
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
case _WastePointModel() when $default != null:
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
case _WastePointModel():
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
case _WastePointModel() when $default != null:
return $default(_that.id,_that.province,_that.regency,_that.biomassaType,_that.volumeTon,_that.year,_that.lat,_that.lng,_that.source);case _:
  return null;

}
}

}

/// @nodoc


class _WastePointModel extends WastePointModel {
  const _WastePointModel({required this.id, required this.province, required this.regency, required this.biomassaType, required this.volumeTon, required this.year, required this.lat, required this.lng, this.source}): super._();
  

@override final  String id;
@override final  String province;
@override final  String regency;
@override final  String biomassaType;
@override final  double volumeTon;
@override final  int year;
@override final  double lat;
@override final  double lng;
@override final  String? source;

/// Create a copy of WastePointModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WastePointModelCopyWith<_WastePointModel> get copyWith => __$WastePointModelCopyWithImpl<_WastePointModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WastePointModel&&(identical(other.id, id) || other.id == id)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.volumeTon, volumeTon) || other.volumeTon == volumeTon)&&(identical(other.year, year) || other.year == year)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.source, source) || other.source == source));
}


@override
int get hashCode => Object.hash(runtimeType,id,province,regency,biomassaType,volumeTon,year,lat,lng,source);

@override
String toString() {
  return 'WastePointModel(id: $id, province: $province, regency: $regency, biomassaType: $biomassaType, volumeTon: $volumeTon, year: $year, lat: $lat, lng: $lng, source: $source)';
}


}

/// @nodoc
abstract mixin class _$WastePointModelCopyWith<$Res> implements $WastePointModelCopyWith<$Res> {
  factory _$WastePointModelCopyWith(_WastePointModel value, $Res Function(_WastePointModel) _then) = __$WastePointModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String province, String regency, String biomassaType, double volumeTon, int year, double lat, double lng, String? source
});




}
/// @nodoc
class __$WastePointModelCopyWithImpl<$Res>
    implements _$WastePointModelCopyWith<$Res> {
  __$WastePointModelCopyWithImpl(this._self, this._then);

  final _WastePointModel _self;
  final $Res Function(_WastePointModel) _then;

/// Create a copy of WastePointModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? province = null,Object? regency = null,Object? biomassaType = null,Object? volumeTon = null,Object? year = null,Object? lat = null,Object? lng = null,Object? source = freezed,}) {
  return _then(_WastePointModel(
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
