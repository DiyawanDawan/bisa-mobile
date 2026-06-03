// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iot_alert_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IotAlertModel {

 String get id; String get alertType; String get message; dynamic get temperature; bool get isRead; String get createdAt;
/// Create a copy of IotAlertModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IotAlertModelCopyWith<IotAlertModel> get copyWith => _$IotAlertModelCopyWithImpl<IotAlertModel>(this as IotAlertModel, _$identity);

  /// Serializes this IotAlertModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IotAlertModel&&(identical(other.id, id) || other.id == id)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.temperature, temperature)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,alertType,message,const DeepCollectionEquality().hash(temperature),isRead,createdAt);

@override
String toString() {
  return 'IotAlertModel(id: $id, alertType: $alertType, message: $message, temperature: $temperature, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $IotAlertModelCopyWith<$Res>  {
  factory $IotAlertModelCopyWith(IotAlertModel value, $Res Function(IotAlertModel) _then) = _$IotAlertModelCopyWithImpl;
@useResult
$Res call({
 String id, String alertType, String message, dynamic temperature, bool isRead, String createdAt
});




}
/// @nodoc
class _$IotAlertModelCopyWithImpl<$Res>
    implements $IotAlertModelCopyWith<$Res> {
  _$IotAlertModelCopyWithImpl(this._self, this._then);

  final IotAlertModel _self;
  final $Res Function(IotAlertModel) _then;

/// Create a copy of IotAlertModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? alertType = null,Object? message = null,Object? temperature = freezed,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as dynamic,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IotAlertModel].
extension IotAlertModelPatterns on IotAlertModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IotAlertModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IotAlertModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IotAlertModel value)  $default,){
final _that = this;
switch (_that) {
case _IotAlertModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IotAlertModel value)?  $default,){
final _that = this;
switch (_that) {
case _IotAlertModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String alertType,  String message,  dynamic temperature,  bool isRead,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IotAlertModel() when $default != null:
return $default(_that.id,_that.alertType,_that.message,_that.temperature,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String alertType,  String message,  dynamic temperature,  bool isRead,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _IotAlertModel():
return $default(_that.id,_that.alertType,_that.message,_that.temperature,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String alertType,  String message,  dynamic temperature,  bool isRead,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _IotAlertModel() when $default != null:
return $default(_that.id,_that.alertType,_that.message,_that.temperature,_that.isRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IotAlertModel implements IotAlertModel {
  const _IotAlertModel({required this.id, required this.alertType, required this.message, this.temperature, this.isRead = false, required this.createdAt});
  factory _IotAlertModel.fromJson(Map<String, dynamic> json) => _$IotAlertModelFromJson(json);

@override final  String id;
@override final  String alertType;
@override final  String message;
@override final  dynamic temperature;
@override@JsonKey() final  bool isRead;
@override final  String createdAt;

/// Create a copy of IotAlertModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IotAlertModelCopyWith<_IotAlertModel> get copyWith => __$IotAlertModelCopyWithImpl<_IotAlertModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IotAlertModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IotAlertModel&&(identical(other.id, id) || other.id == id)&&(identical(other.alertType, alertType) || other.alertType == alertType)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.temperature, temperature)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,alertType,message,const DeepCollectionEquality().hash(temperature),isRead,createdAt);

@override
String toString() {
  return 'IotAlertModel(id: $id, alertType: $alertType, message: $message, temperature: $temperature, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$IotAlertModelCopyWith<$Res> implements $IotAlertModelCopyWith<$Res> {
  factory _$IotAlertModelCopyWith(_IotAlertModel value, $Res Function(_IotAlertModel) _then) = __$IotAlertModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String alertType, String message, dynamic temperature, bool isRead, String createdAt
});




}
/// @nodoc
class __$IotAlertModelCopyWithImpl<$Res>
    implements _$IotAlertModelCopyWith<$Res> {
  __$IotAlertModelCopyWithImpl(this._self, this._then);

  final _IotAlertModel _self;
  final $Res Function(_IotAlertModel) _then;

/// Create a copy of IotAlertModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? alertType = null,Object? message = null,Object? temperature = freezed,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_IotAlertModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,alertType: null == alertType ? _self.alertType : alertType // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as dynamic,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
