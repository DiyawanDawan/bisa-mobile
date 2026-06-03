// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iot_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IotState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IotState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IotState()';
}


}

/// @nodoc
class $IotStateCopyWith<$Res>  {
$IotStateCopyWith(IotState _, $Res Function(IotState) __);
}


/// Adds pattern-matching-related methods to [IotState].
extension IotStatePatterns on IotState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _DashboardLoaded value)?  dashboardLoaded,TResult Function( _SubscriptionSuccess value)?  subscriptionSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _DashboardLoaded() when dashboardLoaded != null:
return dashboardLoaded(_that);case _SubscriptionSuccess() when subscriptionSuccess != null:
return subscriptionSuccess(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _DashboardLoaded value)  dashboardLoaded,required TResult Function( _SubscriptionSuccess value)  subscriptionSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _DashboardLoaded():
return dashboardLoaded(_that);case _SubscriptionSuccess():
return subscriptionSuccess(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _DashboardLoaded value)?  dashboardLoaded,TResult? Function( _SubscriptionSuccess value)?  subscriptionSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _DashboardLoaded() when dashboardLoaded != null:
return dashboardLoaded(_that);case _SubscriptionSuccess() when subscriptionSuccess != null:
return subscriptionSuccess(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<IotDeviceModel> devices,  IotFleetAnalyticsEntity? fleet,  IotStatusSummaryEntity? statusSummary)?  loaded,TResult Function( IotDashboardEntity dashboard,  String range,  IotAlertsPageEntity? alertsPage,  bool alertsLoading)?  dashboardLoaded,TResult Function( Map<String, dynamic> data)?  subscriptionSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.devices,_that.fleet,_that.statusSummary);case _DashboardLoaded() when dashboardLoaded != null:
return dashboardLoaded(_that.dashboard,_that.range,_that.alertsPage,_that.alertsLoading);case _SubscriptionSuccess() when subscriptionSuccess != null:
return subscriptionSuccess(_that.data);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<IotDeviceModel> devices,  IotFleetAnalyticsEntity? fleet,  IotStatusSummaryEntity? statusSummary)  loaded,required TResult Function( IotDashboardEntity dashboard,  String range,  IotAlertsPageEntity? alertsPage,  bool alertsLoading)  dashboardLoaded,required TResult Function( Map<String, dynamic> data)  subscriptionSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.devices,_that.fleet,_that.statusSummary);case _DashboardLoaded():
return dashboardLoaded(_that.dashboard,_that.range,_that.alertsPage,_that.alertsLoading);case _SubscriptionSuccess():
return subscriptionSuccess(_that.data);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<IotDeviceModel> devices,  IotFleetAnalyticsEntity? fleet,  IotStatusSummaryEntity? statusSummary)?  loaded,TResult? Function( IotDashboardEntity dashboard,  String range,  IotAlertsPageEntity? alertsPage,  bool alertsLoading)?  dashboardLoaded,TResult? Function( Map<String, dynamic> data)?  subscriptionSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.devices,_that.fleet,_that.statusSummary);case _DashboardLoaded() when dashboardLoaded != null:
return dashboardLoaded(_that.dashboard,_that.range,_that.alertsPage,_that.alertsLoading);case _SubscriptionSuccess() when subscriptionSuccess != null:
return subscriptionSuccess(_that.data);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements IotState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IotState.initial()';
}


}




/// @nodoc


class _Loading implements IotState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'IotState.loading()';
}


}




/// @nodoc


class _Loaded implements IotState {
  const _Loaded(final  List<IotDeviceModel> devices, {this.fleet, this.statusSummary}): _devices = devices;
  

 final  List<IotDeviceModel> _devices;
 List<IotDeviceModel> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

 final  IotFleetAnalyticsEntity? fleet;
 final  IotStatusSummaryEntity? statusSummary;

/// Create a copy of IotState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._devices, _devices)&&(identical(other.fleet, fleet) || other.fleet == fleet)&&(identical(other.statusSummary, statusSummary) || other.statusSummary == statusSummary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices),fleet,statusSummary);

@override
String toString() {
  return 'IotState.loaded(devices: $devices, fleet: $fleet, statusSummary: $statusSummary)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $IotStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<IotDeviceModel> devices, IotFleetAnalyticsEntity? fleet, IotStatusSummaryEntity? statusSummary
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of IotState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? devices = null,Object? fleet = freezed,Object? statusSummary = freezed,}) {
  return _then(_Loaded(
null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<IotDeviceModel>,fleet: freezed == fleet ? _self.fleet : fleet // ignore: cast_nullable_to_non_nullable
as IotFleetAnalyticsEntity?,statusSummary: freezed == statusSummary ? _self.statusSummary : statusSummary // ignore: cast_nullable_to_non_nullable
as IotStatusSummaryEntity?,
  ));
}


}

/// @nodoc


class _DashboardLoaded implements IotState {
  const _DashboardLoaded(this.dashboard, {this.range = '24h', this.alertsPage, this.alertsLoading = false});
  

 final  IotDashboardEntity dashboard;
@JsonKey() final  String range;
 final  IotAlertsPageEntity? alertsPage;
@JsonKey() final  bool alertsLoading;

/// Create a copy of IotState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardLoadedCopyWith<_DashboardLoaded> get copyWith => __$DashboardLoadedCopyWithImpl<_DashboardLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardLoaded&&(identical(other.dashboard, dashboard) || other.dashboard == dashboard)&&(identical(other.range, range) || other.range == range)&&(identical(other.alertsPage, alertsPage) || other.alertsPage == alertsPage)&&(identical(other.alertsLoading, alertsLoading) || other.alertsLoading == alertsLoading));
}


@override
int get hashCode => Object.hash(runtimeType,dashboard,range,alertsPage,alertsLoading);

@override
String toString() {
  return 'IotState.dashboardLoaded(dashboard: $dashboard, range: $range, alertsPage: $alertsPage, alertsLoading: $alertsLoading)';
}


}

/// @nodoc
abstract mixin class _$DashboardLoadedCopyWith<$Res> implements $IotStateCopyWith<$Res> {
  factory _$DashboardLoadedCopyWith(_DashboardLoaded value, $Res Function(_DashboardLoaded) _then) = __$DashboardLoadedCopyWithImpl;
@useResult
$Res call({
 IotDashboardEntity dashboard, String range, IotAlertsPageEntity? alertsPage, bool alertsLoading
});




}
/// @nodoc
class __$DashboardLoadedCopyWithImpl<$Res>
    implements _$DashboardLoadedCopyWith<$Res> {
  __$DashboardLoadedCopyWithImpl(this._self, this._then);

  final _DashboardLoaded _self;
  final $Res Function(_DashboardLoaded) _then;

/// Create a copy of IotState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dashboard = null,Object? range = null,Object? alertsPage = freezed,Object? alertsLoading = null,}) {
  return _then(_DashboardLoaded(
null == dashboard ? _self.dashboard : dashboard // ignore: cast_nullable_to_non_nullable
as IotDashboardEntity,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as String,alertsPage: freezed == alertsPage ? _self.alertsPage : alertsPage // ignore: cast_nullable_to_non_nullable
as IotAlertsPageEntity?,alertsLoading: null == alertsLoading ? _self.alertsLoading : alertsLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _SubscriptionSuccess implements IotState {
  const _SubscriptionSuccess(final  Map<String, dynamic> data): _data = data;
  

 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of IotState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionSuccessCopyWith<_SubscriptionSuccess> get copyWith => __$SubscriptionSuccessCopyWithImpl<_SubscriptionSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionSuccess&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'IotState.subscriptionSuccess(data: $data)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionSuccessCopyWith<$Res> implements $IotStateCopyWith<$Res> {
  factory _$SubscriptionSuccessCopyWith(_SubscriptionSuccess value, $Res Function(_SubscriptionSuccess) _then) = __$SubscriptionSuccessCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class __$SubscriptionSuccessCopyWithImpl<$Res>
    implements _$SubscriptionSuccessCopyWith<$Res> {
  __$SubscriptionSuccessCopyWithImpl(this._self, this._then);

  final _SubscriptionSuccess _self;
  final $Res Function(_SubscriptionSuccess) _then;

/// Create a copy of IotState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_SubscriptionSuccess(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc


class _Error implements IotState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of IotState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'IotState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $IotStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of IotState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
