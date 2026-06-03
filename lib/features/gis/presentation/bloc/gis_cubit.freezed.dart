// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gis_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GisState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GisState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GisState()';
}


}

/// @nodoc
class $GisStateCopyWith<$Res>  {
$GisStateCopyWith(GisState _, $Res Function(GisState) __);
}


/// Adds pattern-matching-related methods to [GisState].
extension GisStatePatterns on GisState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _WasteMapLoaded value)?  wasteMapLoaded,TResult Function( _MatchLoaded value)?  matchLoaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _WasteMapLoaded() when wasteMapLoaded != null:
return wasteMapLoaded(_that);case _MatchLoaded() when matchLoaded != null:
return matchLoaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _WasteMapLoaded value)  wasteMapLoaded,required TResult Function( _MatchLoaded value)  matchLoaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _WasteMapLoaded():
return wasteMapLoaded(_that);case _MatchLoaded():
return matchLoaded(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _WasteMapLoaded value)?  wasteMapLoaded,TResult? Function( _MatchLoaded value)?  matchLoaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _WasteMapLoaded() when wasteMapLoaded != null:
return wasteMapLoaded(_that);case _MatchLoaded() when matchLoaded != null:
return matchLoaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<RegionEntity> regions)?  loaded,TResult Function( List<WastePointEntity> points)?  wasteMapLoaded,TResult Function( Map<String, dynamic> data)?  matchLoaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.regions);case _WasteMapLoaded() when wasteMapLoaded != null:
return wasteMapLoaded(_that.points);case _MatchLoaded() when matchLoaded != null:
return matchLoaded(_that.data);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<RegionEntity> regions)  loaded,required TResult Function( List<WastePointEntity> points)  wasteMapLoaded,required TResult Function( Map<String, dynamic> data)  matchLoaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.regions);case _WasteMapLoaded():
return wasteMapLoaded(_that.points);case _MatchLoaded():
return matchLoaded(_that.data);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<RegionEntity> regions)?  loaded,TResult? Function( List<WastePointEntity> points)?  wasteMapLoaded,TResult? Function( Map<String, dynamic> data)?  matchLoaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.regions);case _WasteMapLoaded() when wasteMapLoaded != null:
return wasteMapLoaded(_that.points);case _MatchLoaded() when matchLoaded != null:
return matchLoaded(_that.data);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements GisState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GisState.initial()';
}


}




/// @nodoc


class _Loading implements GisState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GisState.loading()';
}


}




/// @nodoc


class _Loaded implements GisState {
  const _Loaded(final  List<RegionEntity> regions): _regions = regions;
  

 final  List<RegionEntity> _regions;
 List<RegionEntity> get regions {
  if (_regions is EqualUnmodifiableListView) return _regions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_regions);
}


/// Create a copy of GisState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._regions, _regions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_regions));

@override
String toString() {
  return 'GisState.loaded(regions: $regions)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $GisStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<RegionEntity> regions
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of GisState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? regions = null,}) {
  return _then(_Loaded(
null == regions ? _self._regions : regions // ignore: cast_nullable_to_non_nullable
as List<RegionEntity>,
  ));
}


}

/// @nodoc


class _WasteMapLoaded implements GisState {
  const _WasteMapLoaded(final  List<WastePointEntity> points): _points = points;
  

 final  List<WastePointEntity> _points;
 List<WastePointEntity> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of GisState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WasteMapLoadedCopyWith<_WasteMapLoaded> get copyWith => __$WasteMapLoadedCopyWithImpl<_WasteMapLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WasteMapLoaded&&const DeepCollectionEquality().equals(other._points, _points));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_points));

@override
String toString() {
  return 'GisState.wasteMapLoaded(points: $points)';
}


}

/// @nodoc
abstract mixin class _$WasteMapLoadedCopyWith<$Res> implements $GisStateCopyWith<$Res> {
  factory _$WasteMapLoadedCopyWith(_WasteMapLoaded value, $Res Function(_WasteMapLoaded) _then) = __$WasteMapLoadedCopyWithImpl;
@useResult
$Res call({
 List<WastePointEntity> points
});




}
/// @nodoc
class __$WasteMapLoadedCopyWithImpl<$Res>
    implements _$WasteMapLoadedCopyWith<$Res> {
  __$WasteMapLoadedCopyWithImpl(this._self, this._then);

  final _WasteMapLoaded _self;
  final $Res Function(_WasteMapLoaded) _then;

/// Create a copy of GisState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? points = null,}) {
  return _then(_WasteMapLoaded(
null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<WastePointEntity>,
  ));
}


}

/// @nodoc


class _MatchLoaded implements GisState {
  const _MatchLoaded(final  Map<String, dynamic> data): _data = data;
  

 final  Map<String, dynamic> _data;
 Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of GisState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchLoadedCopyWith<_MatchLoaded> get copyWith => __$MatchLoadedCopyWithImpl<_MatchLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchLoaded&&const DeepCollectionEquality().equals(other._data, _data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'GisState.matchLoaded(data: $data)';
}


}

/// @nodoc
abstract mixin class _$MatchLoadedCopyWith<$Res> implements $GisStateCopyWith<$Res> {
  factory _$MatchLoadedCopyWith(_MatchLoaded value, $Res Function(_MatchLoaded) _then) = __$MatchLoadedCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> data
});




}
/// @nodoc
class __$MatchLoadedCopyWithImpl<$Res>
    implements _$MatchLoadedCopyWith<$Res> {
  __$MatchLoadedCopyWithImpl(this._self, this._then);

  final _MatchLoaded _self;
  final $Res Function(_MatchLoaded) _then;

/// Create a copy of GisState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_MatchLoaded(
null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc


class _Error implements GisState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of GisState
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
  return 'GisState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $GisStateCopyWith<$Res> {
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

/// Create a copy of GisState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
