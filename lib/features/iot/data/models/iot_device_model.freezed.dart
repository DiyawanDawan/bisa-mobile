// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iot_device_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IotDeviceModel {

 String get id; String get deviceId; String get name; String get status;// ONLINE, OFFLINE, ALERT, DISABLED, MAINTENANCE
 String get monitoringStatus; bool get isMonitoringEnabled; double? get lastTemp; double? get lastHum; double? get lastCo2; DateTime? get lastReadingAt; double? get thresholdMin; double? get thresholdMax;
/// Create a copy of IotDeviceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IotDeviceModelCopyWith<IotDeviceModel> get copyWith => _$IotDeviceModelCopyWithImpl<IotDeviceModel>(this as IotDeviceModel, _$identity);

  /// Serializes this IotDeviceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IotDeviceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.monitoringStatus, monitoringStatus) || other.monitoringStatus == monitoringStatus)&&(identical(other.isMonitoringEnabled, isMonitoringEnabled) || other.isMonitoringEnabled == isMonitoringEnabled)&&(identical(other.lastTemp, lastTemp) || other.lastTemp == lastTemp)&&(identical(other.lastHum, lastHum) || other.lastHum == lastHum)&&(identical(other.lastCo2, lastCo2) || other.lastCo2 == lastCo2)&&(identical(other.lastReadingAt, lastReadingAt) || other.lastReadingAt == lastReadingAt)&&(identical(other.thresholdMin, thresholdMin) || other.thresholdMin == thresholdMin)&&(identical(other.thresholdMax, thresholdMax) || other.thresholdMax == thresholdMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,name,status,monitoringStatus,isMonitoringEnabled,lastTemp,lastHum,lastCo2,lastReadingAt,thresholdMin,thresholdMax);

@override
String toString() {
  return 'IotDeviceModel(id: $id, deviceId: $deviceId, name: $name, status: $status, monitoringStatus: $monitoringStatus, isMonitoringEnabled: $isMonitoringEnabled, lastTemp: $lastTemp, lastHum: $lastHum, lastCo2: $lastCo2, lastReadingAt: $lastReadingAt, thresholdMin: $thresholdMin, thresholdMax: $thresholdMax)';
}


}

/// @nodoc
abstract mixin class $IotDeviceModelCopyWith<$Res>  {
  factory $IotDeviceModelCopyWith(IotDeviceModel value, $Res Function(IotDeviceModel) _then) = _$IotDeviceModelCopyWithImpl;
@useResult
$Res call({
 String id, String deviceId, String name, String status, String monitoringStatus, bool isMonitoringEnabled, double? lastTemp, double? lastHum, double? lastCo2, DateTime? lastReadingAt, double? thresholdMin, double? thresholdMax
});




}
/// @nodoc
class _$IotDeviceModelCopyWithImpl<$Res>
    implements $IotDeviceModelCopyWith<$Res> {
  _$IotDeviceModelCopyWithImpl(this._self, this._then);

  final IotDeviceModel _self;
  final $Res Function(IotDeviceModel) _then;

/// Create a copy of IotDeviceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? name = null,Object? status = null,Object? monitoringStatus = null,Object? isMonitoringEnabled = null,Object? lastTemp = freezed,Object? lastHum = freezed,Object? lastCo2 = freezed,Object? lastReadingAt = freezed,Object? thresholdMin = freezed,Object? thresholdMax = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,monitoringStatus: null == monitoringStatus ? _self.monitoringStatus : monitoringStatus // ignore: cast_nullable_to_non_nullable
as String,isMonitoringEnabled: null == isMonitoringEnabled ? _self.isMonitoringEnabled : isMonitoringEnabled // ignore: cast_nullable_to_non_nullable
as bool,lastTemp: freezed == lastTemp ? _self.lastTemp : lastTemp // ignore: cast_nullable_to_non_nullable
as double?,lastHum: freezed == lastHum ? _self.lastHum : lastHum // ignore: cast_nullable_to_non_nullable
as double?,lastCo2: freezed == lastCo2 ? _self.lastCo2 : lastCo2 // ignore: cast_nullable_to_non_nullable
as double?,lastReadingAt: freezed == lastReadingAt ? _self.lastReadingAt : lastReadingAt // ignore: cast_nullable_to_non_nullable
as DateTime?,thresholdMin: freezed == thresholdMin ? _self.thresholdMin : thresholdMin // ignore: cast_nullable_to_non_nullable
as double?,thresholdMax: freezed == thresholdMax ? _self.thresholdMax : thresholdMax // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [IotDeviceModel].
extension IotDeviceModelPatterns on IotDeviceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IotDeviceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IotDeviceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IotDeviceModel value)  $default,){
final _that = this;
switch (_that) {
case _IotDeviceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IotDeviceModel value)?  $default,){
final _that = this;
switch (_that) {
case _IotDeviceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String deviceId,  String name,  String status,  String monitoringStatus,  bool isMonitoringEnabled,  double? lastTemp,  double? lastHum,  double? lastCo2,  DateTime? lastReadingAt,  double? thresholdMin,  double? thresholdMax)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IotDeviceModel() when $default != null:
return $default(_that.id,_that.deviceId,_that.name,_that.status,_that.monitoringStatus,_that.isMonitoringEnabled,_that.lastTemp,_that.lastHum,_that.lastCo2,_that.lastReadingAt,_that.thresholdMin,_that.thresholdMax);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String deviceId,  String name,  String status,  String monitoringStatus,  bool isMonitoringEnabled,  double? lastTemp,  double? lastHum,  double? lastCo2,  DateTime? lastReadingAt,  double? thresholdMin,  double? thresholdMax)  $default,) {final _that = this;
switch (_that) {
case _IotDeviceModel():
return $default(_that.id,_that.deviceId,_that.name,_that.status,_that.monitoringStatus,_that.isMonitoringEnabled,_that.lastTemp,_that.lastHum,_that.lastCo2,_that.lastReadingAt,_that.thresholdMin,_that.thresholdMax);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String deviceId,  String name,  String status,  String monitoringStatus,  bool isMonitoringEnabled,  double? lastTemp,  double? lastHum,  double? lastCo2,  DateTime? lastReadingAt,  double? thresholdMin,  double? thresholdMax)?  $default,) {final _that = this;
switch (_that) {
case _IotDeviceModel() when $default != null:
return $default(_that.id,_that.deviceId,_that.name,_that.status,_that.monitoringStatus,_that.isMonitoringEnabled,_that.lastTemp,_that.lastHum,_that.lastCo2,_that.lastReadingAt,_that.thresholdMin,_that.thresholdMax);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IotDeviceModel implements IotDeviceModel {
  const _IotDeviceModel({required this.id, required this.deviceId, required this.name, required this.status, this.monitoringStatus = 'ACTIVE', this.isMonitoringEnabled = true, this.lastTemp, this.lastHum, this.lastCo2, this.lastReadingAt, this.thresholdMin, this.thresholdMax});
  factory _IotDeviceModel.fromJson(Map<String, dynamic> json) => _$IotDeviceModelFromJson(json);

@override final  String id;
@override final  String deviceId;
@override final  String name;
@override final  String status;
// ONLINE, OFFLINE, ALERT, DISABLED, MAINTENANCE
@override@JsonKey() final  String monitoringStatus;
@override@JsonKey() final  bool isMonitoringEnabled;
@override final  double? lastTemp;
@override final  double? lastHum;
@override final  double? lastCo2;
@override final  DateTime? lastReadingAt;
@override final  double? thresholdMin;
@override final  double? thresholdMax;

/// Create a copy of IotDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IotDeviceModelCopyWith<_IotDeviceModel> get copyWith => __$IotDeviceModelCopyWithImpl<_IotDeviceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IotDeviceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IotDeviceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.monitoringStatus, monitoringStatus) || other.monitoringStatus == monitoringStatus)&&(identical(other.isMonitoringEnabled, isMonitoringEnabled) || other.isMonitoringEnabled == isMonitoringEnabled)&&(identical(other.lastTemp, lastTemp) || other.lastTemp == lastTemp)&&(identical(other.lastHum, lastHum) || other.lastHum == lastHum)&&(identical(other.lastCo2, lastCo2) || other.lastCo2 == lastCo2)&&(identical(other.lastReadingAt, lastReadingAt) || other.lastReadingAt == lastReadingAt)&&(identical(other.thresholdMin, thresholdMin) || other.thresholdMin == thresholdMin)&&(identical(other.thresholdMax, thresholdMax) || other.thresholdMax == thresholdMax));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,deviceId,name,status,monitoringStatus,isMonitoringEnabled,lastTemp,lastHum,lastCo2,lastReadingAt,thresholdMin,thresholdMax);

@override
String toString() {
  return 'IotDeviceModel(id: $id, deviceId: $deviceId, name: $name, status: $status, monitoringStatus: $monitoringStatus, isMonitoringEnabled: $isMonitoringEnabled, lastTemp: $lastTemp, lastHum: $lastHum, lastCo2: $lastCo2, lastReadingAt: $lastReadingAt, thresholdMin: $thresholdMin, thresholdMax: $thresholdMax)';
}


}

/// @nodoc
abstract mixin class _$IotDeviceModelCopyWith<$Res> implements $IotDeviceModelCopyWith<$Res> {
  factory _$IotDeviceModelCopyWith(_IotDeviceModel value, $Res Function(_IotDeviceModel) _then) = __$IotDeviceModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String deviceId, String name, String status, String monitoringStatus, bool isMonitoringEnabled, double? lastTemp, double? lastHum, double? lastCo2, DateTime? lastReadingAt, double? thresholdMin, double? thresholdMax
});




}
/// @nodoc
class __$IotDeviceModelCopyWithImpl<$Res>
    implements _$IotDeviceModelCopyWith<$Res> {
  __$IotDeviceModelCopyWithImpl(this._self, this._then);

  final _IotDeviceModel _self;
  final $Res Function(_IotDeviceModel) _then;

/// Create a copy of IotDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? name = null,Object? status = null,Object? monitoringStatus = null,Object? isMonitoringEnabled = null,Object? lastTemp = freezed,Object? lastHum = freezed,Object? lastCo2 = freezed,Object? lastReadingAt = freezed,Object? thresholdMin = freezed,Object? thresholdMax = freezed,}) {
  return _then(_IotDeviceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,monitoringStatus: null == monitoringStatus ? _self.monitoringStatus : monitoringStatus // ignore: cast_nullable_to_non_nullable
as String,isMonitoringEnabled: null == isMonitoringEnabled ? _self.isMonitoringEnabled : isMonitoringEnabled // ignore: cast_nullable_to_non_nullable
as bool,lastTemp: freezed == lastTemp ? _self.lastTemp : lastTemp // ignore: cast_nullable_to_non_nullable
as double?,lastHum: freezed == lastHum ? _self.lastHum : lastHum // ignore: cast_nullable_to_non_nullable
as double?,lastCo2: freezed == lastCo2 ? _self.lastCo2 : lastCo2 // ignore: cast_nullable_to_non_nullable
as double?,lastReadingAt: freezed == lastReadingAt ? _self.lastReadingAt : lastReadingAt // ignore: cast_nullable_to_non_nullable
as DateTime?,thresholdMin: freezed == thresholdMin ? _self.thresholdMin : thresholdMin // ignore: cast_nullable_to_non_nullable
as double?,thresholdMax: freezed == thresholdMax ? _self.thresholdMax : thresholdMax // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$IotReadingModel {

 String get id; double get temp; double get hum; double get co2; DateTime get createdAt;
/// Create a copy of IotReadingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IotReadingModelCopyWith<IotReadingModel> get copyWith => _$IotReadingModelCopyWithImpl<IotReadingModel>(this as IotReadingModel, _$identity);

  /// Serializes this IotReadingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IotReadingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.hum, hum) || other.hum == hum)&&(identical(other.co2, co2) || other.co2 == co2)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,temp,hum,co2,createdAt);

@override
String toString() {
  return 'IotReadingModel(id: $id, temp: $temp, hum: $hum, co2: $co2, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $IotReadingModelCopyWith<$Res>  {
  factory $IotReadingModelCopyWith(IotReadingModel value, $Res Function(IotReadingModel) _then) = _$IotReadingModelCopyWithImpl;
@useResult
$Res call({
 String id, double temp, double hum, double co2, DateTime createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? temp = null,Object? hum = null,Object? co2 = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,hum: null == hum ? _self.hum : hum // ignore: cast_nullable_to_non_nullable
as double,co2: null == co2 ? _self.co2 : co2 // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double temp,  double hum,  double co2,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IotReadingModel() when $default != null:
return $default(_that.id,_that.temp,_that.hum,_that.co2,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double temp,  double hum,  double co2,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _IotReadingModel():
return $default(_that.id,_that.temp,_that.hum,_that.co2,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double temp,  double hum,  double co2,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _IotReadingModel() when $default != null:
return $default(_that.id,_that.temp,_that.hum,_that.co2,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IotReadingModel implements IotReadingModel {
  const _IotReadingModel({required this.id, required this.temp, required this.hum, required this.co2, required this.createdAt});
  factory _IotReadingModel.fromJson(Map<String, dynamic> json) => _$IotReadingModelFromJson(json);

@override final  String id;
@override final  double temp;
@override final  double hum;
@override final  double co2;
@override final  DateTime createdAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IotReadingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.temp, temp) || other.temp == temp)&&(identical(other.hum, hum) || other.hum == hum)&&(identical(other.co2, co2) || other.co2 == co2)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,temp,hum,co2,createdAt);

@override
String toString() {
  return 'IotReadingModel(id: $id, temp: $temp, hum: $hum, co2: $co2, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$IotReadingModelCopyWith<$Res> implements $IotReadingModelCopyWith<$Res> {
  factory _$IotReadingModelCopyWith(_IotReadingModel value, $Res Function(_IotReadingModel) _then) = __$IotReadingModelCopyWithImpl;
@override @useResult
$Res call({
 String id, double temp, double hum, double co2, DateTime createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? temp = null,Object? hum = null,Object? co2 = null,Object? createdAt = null,}) {
  return _then(_IotReadingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,temp: null == temp ? _self.temp : temp // ignore: cast_nullable_to_non_nullable
as double,hum: null == hum ? _self.hum : hum // ignore: cast_nullable_to_non_nullable
as double,co2: null == co2 ? _self.co2 : co2 // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
