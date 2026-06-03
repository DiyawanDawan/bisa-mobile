// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iot_reading_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IotReadingModel {

 String get id; dynamic get temperature; dynamic get humidity; dynamic get co2Level; String get recordedAt;
/// Create a copy of IotReadingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IotReadingModelCopyWith<IotReadingModel> get copyWith => _$IotReadingModelCopyWithImpl<IotReadingModel>(this as IotReadingModel, _$identity);

  /// Serializes this IotReadingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IotReadingModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.temperature, temperature)&&const DeepCollectionEquality().equals(other.humidity, humidity)&&const DeepCollectionEquality().equals(other.co2Level, co2Level)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(temperature),const DeepCollectionEquality().hash(humidity),const DeepCollectionEquality().hash(co2Level),recordedAt);

@override
String toString() {
  return 'IotReadingModel(id: $id, temperature: $temperature, humidity: $humidity, co2Level: $co2Level, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $IotReadingModelCopyWith<$Res>  {
  factory $IotReadingModelCopyWith(IotReadingModel value, $Res Function(IotReadingModel) _then) = _$IotReadingModelCopyWithImpl;
@useResult
$Res call({
 String id, dynamic temperature, dynamic humidity, dynamic co2Level, String recordedAt
});




}
/// @nodoc
class _$IotReadingModelCopyWithImpl<$Res>
    implements $IotReadingModelCopyWith<$Res> {
  _$IotReadingModelCopyWithImpl(this._self, this._then);

  final IotReadingModel _self;
  final $Res Function(IotReadingModel) _then;

/// Create a copy of IotReadingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? temperature = freezed,Object? humidity = freezed,Object? co2Level = freezed,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as dynamic,humidity: freezed == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as dynamic,co2Level: freezed == co2Level ? _self.co2Level : co2Level // ignore: cast_nullable_to_non_nullable
as dynamic,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IotReadingModel].
extension IotReadingModelPatterns on IotReadingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IotReadingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IotReadingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IotReadingModel value)  $default,){
final _that = this;
switch (_that) {
case _IotReadingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IotReadingModel value)?  $default,){
final _that = this;
switch (_that) {
case _IotReadingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  dynamic temperature,  dynamic humidity,  dynamic co2Level,  String recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IotReadingModel() when $default != null:
return $default(_that.id,_that.temperature,_that.humidity,_that.co2Level,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  dynamic temperature,  dynamic humidity,  dynamic co2Level,  String recordedAt)  $default,) {final _that = this;
switch (_that) {
case _IotReadingModel():
return $default(_that.id,_that.temperature,_that.humidity,_that.co2Level,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  dynamic temperature,  dynamic humidity,  dynamic co2Level,  String recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _IotReadingModel() when $default != null:
return $default(_that.id,_that.temperature,_that.humidity,_that.co2Level,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IotReadingModel implements IotReadingModel {
  const _IotReadingModel({required this.id, required this.temperature, this.humidity, this.co2Level, required this.recordedAt});
  factory _IotReadingModel.fromJson(Map<String, dynamic> json) => _$IotReadingModelFromJson(json);

@override final  String id;
@override final  dynamic temperature;
@override final  dynamic humidity;
@override final  dynamic co2Level;
@override final  String recordedAt;

/// Create a copy of IotReadingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IotReadingModelCopyWith<_IotReadingModel> get copyWith => __$IotReadingModelCopyWithImpl<_IotReadingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IotReadingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IotReadingModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.temperature, temperature)&&const DeepCollectionEquality().equals(other.humidity, humidity)&&const DeepCollectionEquality().equals(other.co2Level, co2Level)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(temperature),const DeepCollectionEquality().hash(humidity),const DeepCollectionEquality().hash(co2Level),recordedAt);

@override
String toString() {
  return 'IotReadingModel(id: $id, temperature: $temperature, humidity: $humidity, co2Level: $co2Level, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$IotReadingModelCopyWith<$Res> implements $IotReadingModelCopyWith<$Res> {
  factory _$IotReadingModelCopyWith(_IotReadingModel value, $Res Function(_IotReadingModel) _then) = __$IotReadingModelCopyWithImpl;
@override @useResult
$Res call({
 String id, dynamic temperature, dynamic humidity, dynamic co2Level, String recordedAt
});




}
/// @nodoc
class __$IotReadingModelCopyWithImpl<$Res>
    implements _$IotReadingModelCopyWith<$Res> {
  __$IotReadingModelCopyWithImpl(this._self, this._then);

  final _IotReadingModel _self;
  final $Res Function(_IotReadingModel) _then;

/// Create a copy of IotReadingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? temperature = freezed,Object? humidity = freezed,Object? co2Level = freezed,Object? recordedAt = null,}) {
  return _then(_IotReadingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as dynamic,humidity: freezed == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as dynamic,co2Level: freezed == co2Level ? _self.co2Level : co2Level // ignore: cast_nullable_to_non_nullable
as dynamic,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
