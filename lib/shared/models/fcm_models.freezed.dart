// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fcm_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FcmRegisterRequest {

 String get fcmToken; String get platform; String get deviceId; String get deviceName; String get appVersion;
/// Create a copy of FcmRegisterRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FcmRegisterRequestCopyWith<FcmRegisterRequest> get copyWith => _$FcmRegisterRequestCopyWithImpl<FcmRegisterRequest>(this as FcmRegisterRequest, _$identity);

  /// Serializes this FcmRegisterRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FcmRegisterRequest&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fcmToken,platform,deviceId,deviceName,appVersion);

@override
String toString() {
  return 'FcmRegisterRequest(fcmToken: $fcmToken, platform: $platform, deviceId: $deviceId, deviceName: $deviceName, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class $FcmRegisterRequestCopyWith<$Res>  {
  factory $FcmRegisterRequestCopyWith(FcmRegisterRequest value, $Res Function(FcmRegisterRequest) _then) = _$FcmRegisterRequestCopyWithImpl;
@useResult
$Res call({
 String fcmToken, String platform, String deviceId, String deviceName, String appVersion
});




}
/// @nodoc
class _$FcmRegisterRequestCopyWithImpl<$Res>
    implements $FcmRegisterRequestCopyWith<$Res> {
  _$FcmRegisterRequestCopyWithImpl(this._self, this._then);

  final FcmRegisterRequest _self;
  final $Res Function(FcmRegisterRequest) _then;

/// Create a copy of FcmRegisterRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fcmToken = null,Object? platform = null,Object? deviceId = null,Object? deviceName = null,Object? appVersion = null,}) {
  return _then(_self.copyWith(
fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FcmRegisterRequest].
extension FcmRegisterRequestPatterns on FcmRegisterRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FcmRegisterRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FcmRegisterRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FcmRegisterRequest value)  $default,){
final _that = this;
switch (_that) {
case _FcmRegisterRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FcmRegisterRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FcmRegisterRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fcmToken,  String platform,  String deviceId,  String deviceName,  String appVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FcmRegisterRequest() when $default != null:
return $default(_that.fcmToken,_that.platform,_that.deviceId,_that.deviceName,_that.appVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fcmToken,  String platform,  String deviceId,  String deviceName,  String appVersion)  $default,) {final _that = this;
switch (_that) {
case _FcmRegisterRequest():
return $default(_that.fcmToken,_that.platform,_that.deviceId,_that.deviceName,_that.appVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fcmToken,  String platform,  String deviceId,  String deviceName,  String appVersion)?  $default,) {final _that = this;
switch (_that) {
case _FcmRegisterRequest() when $default != null:
return $default(_that.fcmToken,_that.platform,_that.deviceId,_that.deviceName,_that.appVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FcmRegisterRequest implements FcmRegisterRequest {
  const _FcmRegisterRequest({required this.fcmToken, required this.platform, required this.deviceId, required this.deviceName, required this.appVersion});
  factory _FcmRegisterRequest.fromJson(Map<String, dynamic> json) => _$FcmRegisterRequestFromJson(json);

@override final  String fcmToken;
@override final  String platform;
@override final  String deviceId;
@override final  String deviceName;
@override final  String appVersion;

/// Create a copy of FcmRegisterRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FcmRegisterRequestCopyWith<_FcmRegisterRequest> get copyWith => __$FcmRegisterRequestCopyWithImpl<_FcmRegisterRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FcmRegisterRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FcmRegisterRequest&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fcmToken,platform,deviceId,deviceName,appVersion);

@override
String toString() {
  return 'FcmRegisterRequest(fcmToken: $fcmToken, platform: $platform, deviceId: $deviceId, deviceName: $deviceName, appVersion: $appVersion)';
}


}

/// @nodoc
abstract mixin class _$FcmRegisterRequestCopyWith<$Res> implements $FcmRegisterRequestCopyWith<$Res> {
  factory _$FcmRegisterRequestCopyWith(_FcmRegisterRequest value, $Res Function(_FcmRegisterRequest) _then) = __$FcmRegisterRequestCopyWithImpl;
@override @useResult
$Res call({
 String fcmToken, String platform, String deviceId, String deviceName, String appVersion
});




}
/// @nodoc
class __$FcmRegisterRequestCopyWithImpl<$Res>
    implements _$FcmRegisterRequestCopyWith<$Res> {
  __$FcmRegisterRequestCopyWithImpl(this._self, this._then);

  final _FcmRegisterRequest _self;
  final $Res Function(_FcmRegisterRequest) _then;

/// Create a copy of FcmRegisterRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fcmToken = null,Object? platform = null,Object? deviceId = null,Object? deviceName = null,Object? appVersion = null,}) {
  return _then(_FcmRegisterRequest(
fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FcmUnregisterRequest {

 String get fcmToken;
/// Create a copy of FcmUnregisterRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FcmUnregisterRequestCopyWith<FcmUnregisterRequest> get copyWith => _$FcmUnregisterRequestCopyWithImpl<FcmUnregisterRequest>(this as FcmUnregisterRequest, _$identity);

  /// Serializes this FcmUnregisterRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FcmUnregisterRequest&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fcmToken);

@override
String toString() {
  return 'FcmUnregisterRequest(fcmToken: $fcmToken)';
}


}

/// @nodoc
abstract mixin class $FcmUnregisterRequestCopyWith<$Res>  {
  factory $FcmUnregisterRequestCopyWith(FcmUnregisterRequest value, $Res Function(FcmUnregisterRequest) _then) = _$FcmUnregisterRequestCopyWithImpl;
@useResult
$Res call({
 String fcmToken
});




}
/// @nodoc
class _$FcmUnregisterRequestCopyWithImpl<$Res>
    implements $FcmUnregisterRequestCopyWith<$Res> {
  _$FcmUnregisterRequestCopyWithImpl(this._self, this._then);

  final FcmUnregisterRequest _self;
  final $Res Function(FcmUnregisterRequest) _then;

/// Create a copy of FcmUnregisterRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fcmToken = null,}) {
  return _then(_self.copyWith(
fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FcmUnregisterRequest].
extension FcmUnregisterRequestPatterns on FcmUnregisterRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FcmUnregisterRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FcmUnregisterRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FcmUnregisterRequest value)  $default,){
final _that = this;
switch (_that) {
case _FcmUnregisterRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FcmUnregisterRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FcmUnregisterRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fcmToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FcmUnregisterRequest() when $default != null:
return $default(_that.fcmToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fcmToken)  $default,) {final _that = this;
switch (_that) {
case _FcmUnregisterRequest():
return $default(_that.fcmToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fcmToken)?  $default,) {final _that = this;
switch (_that) {
case _FcmUnregisterRequest() when $default != null:
return $default(_that.fcmToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FcmUnregisterRequest implements FcmUnregisterRequest {
  const _FcmUnregisterRequest({required this.fcmToken});
  factory _FcmUnregisterRequest.fromJson(Map<String, dynamic> json) => _$FcmUnregisterRequestFromJson(json);

@override final  String fcmToken;

/// Create a copy of FcmUnregisterRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FcmUnregisterRequestCopyWith<_FcmUnregisterRequest> get copyWith => __$FcmUnregisterRequestCopyWithImpl<_FcmUnregisterRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FcmUnregisterRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FcmUnregisterRequest&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fcmToken);

@override
String toString() {
  return 'FcmUnregisterRequest(fcmToken: $fcmToken)';
}


}

/// @nodoc
abstract mixin class _$FcmUnregisterRequestCopyWith<$Res> implements $FcmUnregisterRequestCopyWith<$Res> {
  factory _$FcmUnregisterRequestCopyWith(_FcmUnregisterRequest value, $Res Function(_FcmUnregisterRequest) _then) = __$FcmUnregisterRequestCopyWithImpl;
@override @useResult
$Res call({
 String fcmToken
});




}
/// @nodoc
class __$FcmUnregisterRequestCopyWithImpl<$Res>
    implements _$FcmUnregisterRequestCopyWith<$Res> {
  __$FcmUnregisterRequestCopyWithImpl(this._self, this._then);

  final _FcmUnregisterRequest _self;
  final $Res Function(_FcmUnregisterRequest) _then;

/// Create a copy of FcmUnregisterRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fcmToken = null,}) {
  return _then(_FcmUnregisterRequest(
fcmToken: null == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$FcmResponseModel {

 FcmMetaModel get meta; Map<String, dynamic> get data;
/// Create a copy of FcmResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FcmResponseModelCopyWith<FcmResponseModel> get copyWith => _$FcmResponseModelCopyWithImpl<FcmResponseModel>(this as FcmResponseModel, _$identity);

  /// Serializes this FcmResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FcmResponseModel&&(identical(other.meta, meta) || other.meta == meta)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meta,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'FcmResponseModel(meta: $meta, data: $data)';
}


}

/// @nodoc
abstract mixin class $FcmResponseModelCopyWith<$Res>  {
  factory $FcmResponseModelCopyWith(FcmResponseModel value, $Res Function(FcmResponseModel) _then) = _$FcmResponseModelCopyWithImpl;
@useResult
$Res call({
 FcmMetaModel meta, Map<String, dynamic> data
});


$FcmMetaModelCopyWith<$Res> get meta;

}
/// @nodoc
class _$FcmResponseModelCopyWithImpl<$Res>
    implements $FcmResponseModelCopyWith<$Res> {
  _$FcmResponseModelCopyWithImpl(this._self, this._then);

  final FcmResponseModel _self;
  final $Res Function(FcmResponseModel) _then;

/// Create a copy of FcmResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? meta = null,Object? data = null,}) {
  return _then(_self.copyWith(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as FcmMetaModel,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of FcmResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FcmMetaModelCopyWith<$Res> get meta {
  
  return $FcmMetaModelCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [FcmResponseModel].
extension FcmResponseModelPatterns on FcmResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FcmResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FcmResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FcmResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _FcmResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FcmResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _FcmResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FcmMetaModel meta,  Map<String, dynamic> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FcmResponseModel() when $default != null:
return $default(_that.meta,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FcmMetaModel meta,  Map<String, dynamic> data)  $default,) {final _that = this;
switch (_that) {
case _FcmResponseModel():
return $default(_that.meta,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FcmMetaModel meta,  Map<String, dynamic> data)?  $default,) {final _that = this;
switch (_that) {
case _FcmResponseModel() when $default != null:
return $default(_that.meta,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FcmResponseModel implements FcmResponseModel {
  const _FcmResponseModel({required this.meta, final  Map<String, dynamic> data = const {}}): _data = data;
  factory _FcmResponseModel.fromJson(Map<String, dynamic> json) => _$FcmResponseModelFromJson(json);

@override final  FcmMetaModel meta;
 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of FcmResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FcmResponseModelCopyWith<_FcmResponseModel> get copyWith => __$FcmResponseModelCopyWithImpl<_FcmResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FcmResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FcmResponseModel&&(identical(other.meta, meta) || other.meta == meta)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,meta,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'FcmResponseModel(meta: $meta, data: $data)';
}


}

/// @nodoc
abstract mixin class _$FcmResponseModelCopyWith<$Res> implements $FcmResponseModelCopyWith<$Res> {
  factory _$FcmResponseModelCopyWith(_FcmResponseModel value, $Res Function(_FcmResponseModel) _then) = __$FcmResponseModelCopyWithImpl;
@override @useResult
$Res call({
 FcmMetaModel meta, Map<String, dynamic> data
});


@override $FcmMetaModelCopyWith<$Res> get meta;

}
/// @nodoc
class __$FcmResponseModelCopyWithImpl<$Res>
    implements _$FcmResponseModelCopyWith<$Res> {
  __$FcmResponseModelCopyWithImpl(this._self, this._then);

  final _FcmResponseModel _self;
  final $Res Function(_FcmResponseModel) _then;

/// Create a copy of FcmResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? meta = null,Object? data = null,}) {
  return _then(_FcmResponseModel(
meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as FcmMetaModel,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of FcmResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FcmMetaModelCopyWith<$Res> get meta {
  
  return $FcmMetaModelCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$FcmMetaModel {

 bool get success; int get status; String get message;
/// Create a copy of FcmMetaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FcmMetaModelCopyWith<FcmMetaModel> get copyWith => _$FcmMetaModelCopyWithImpl<FcmMetaModel>(this as FcmMetaModel, _$identity);

  /// Serializes this FcmMetaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FcmMetaModel&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,status,message);

@override
String toString() {
  return 'FcmMetaModel(success: $success, status: $status, message: $message)';
}


}

/// @nodoc
abstract mixin class $FcmMetaModelCopyWith<$Res>  {
  factory $FcmMetaModelCopyWith(FcmMetaModel value, $Res Function(FcmMetaModel) _then) = _$FcmMetaModelCopyWithImpl;
@useResult
$Res call({
 bool success, int status, String message
});




}
/// @nodoc
class _$FcmMetaModelCopyWithImpl<$Res>
    implements $FcmMetaModelCopyWith<$Res> {
  _$FcmMetaModelCopyWithImpl(this._self, this._then);

  final FcmMetaModel _self;
  final $Res Function(FcmMetaModel) _then;

/// Create a copy of FcmMetaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? status = null,Object? message = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FcmMetaModel].
extension FcmMetaModelPatterns on FcmMetaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FcmMetaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FcmMetaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FcmMetaModel value)  $default,){
final _that = this;
switch (_that) {
case _FcmMetaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FcmMetaModel value)?  $default,){
final _that = this;
switch (_that) {
case _FcmMetaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  int status,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FcmMetaModel() when $default != null:
return $default(_that.success,_that.status,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  int status,  String message)  $default,) {final _that = this;
switch (_that) {
case _FcmMetaModel():
return $default(_that.success,_that.status,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  int status,  String message)?  $default,) {final _that = this;
switch (_that) {
case _FcmMetaModel() when $default != null:
return $default(_that.success,_that.status,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FcmMetaModel implements FcmMetaModel {
  const _FcmMetaModel({required this.success, required this.status, required this.message});
  factory _FcmMetaModel.fromJson(Map<String, dynamic> json) => _$FcmMetaModelFromJson(json);

@override final  bool success;
@override final  int status;
@override final  String message;

/// Create a copy of FcmMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FcmMetaModelCopyWith<_FcmMetaModel> get copyWith => __$FcmMetaModelCopyWithImpl<_FcmMetaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FcmMetaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FcmMetaModel&&(identical(other.success, success) || other.success == success)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,status,message);

@override
String toString() {
  return 'FcmMetaModel(success: $success, status: $status, message: $message)';
}


}

/// @nodoc
abstract mixin class _$FcmMetaModelCopyWith<$Res> implements $FcmMetaModelCopyWith<$Res> {
  factory _$FcmMetaModelCopyWith(_FcmMetaModel value, $Res Function(_FcmMetaModel) _then) = __$FcmMetaModelCopyWithImpl;
@override @useResult
$Res call({
 bool success, int status, String message
});




}
/// @nodoc
class __$FcmMetaModelCopyWithImpl<$Res>
    implements _$FcmMetaModelCopyWith<$Res> {
  __$FcmMetaModelCopyWithImpl(this._self, this._then);

  final _FcmMetaModel _self;
  final $Res Function(_FcmMetaModel) _then;

/// Create a copy of FcmMetaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? status = null,Object? message = null,}) {
  return _then(_FcmMetaModel(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
