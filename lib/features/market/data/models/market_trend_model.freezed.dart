// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'market_trend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarketTrendModel {

 String get id; String get label; String get category; String get currentValue; String get trendType;// UP, DOWN, STABLE
 List<MarketDataPointModel> get historyData; List<MarketDataPointModel>? get projectedData; String? get insight;
/// Create a copy of MarketTrendModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketTrendModelCopyWith<MarketTrendModel> get copyWith => _$MarketTrendModelCopyWithImpl<MarketTrendModel>(this as MarketTrendModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketTrendModel&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.category, category) || other.category == category)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.trendType, trendType) || other.trendType == trendType)&&const DeepCollectionEquality().equals(other.historyData, historyData)&&const DeepCollectionEquality().equals(other.projectedData, projectedData)&&(identical(other.insight, insight) || other.insight == insight));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,category,currentValue,trendType,const DeepCollectionEquality().hash(historyData),const DeepCollectionEquality().hash(projectedData),insight);

@override
String toString() {
  return 'MarketTrendModel(id: $id, label: $label, category: $category, currentValue: $currentValue, trendType: $trendType, historyData: $historyData, projectedData: $projectedData, insight: $insight)';
}


}

/// @nodoc
abstract mixin class $MarketTrendModelCopyWith<$Res>  {
  factory $MarketTrendModelCopyWith(MarketTrendModel value, $Res Function(MarketTrendModel) _then) = _$MarketTrendModelCopyWithImpl;
@useResult
$Res call({
 String id, String label, String category, String currentValue, String trendType, List<MarketDataPointModel> historyData, List<MarketDataPointModel>? projectedData, String? insight
});




}
/// @nodoc
class _$MarketTrendModelCopyWithImpl<$Res>
    implements $MarketTrendModelCopyWith<$Res> {
  _$MarketTrendModelCopyWithImpl(this._self, this._then);

  final MarketTrendModel _self;
  final $Res Function(MarketTrendModel) _then;

/// Create a copy of MarketTrendModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? category = null,Object? currentValue = null,Object? trendType = null,Object? historyData = null,Object? projectedData = freezed,Object? insight = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as String,trendType: null == trendType ? _self.trendType : trendType // ignore: cast_nullable_to_non_nullable
as String,historyData: null == historyData ? _self.historyData : historyData // ignore: cast_nullable_to_non_nullable
as List<MarketDataPointModel>,projectedData: freezed == projectedData ? _self.projectedData : projectedData // ignore: cast_nullable_to_non_nullable
as List<MarketDataPointModel>?,insight: freezed == insight ? _self.insight : insight // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketTrendModel].
extension MarketTrendModelPatterns on MarketTrendModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketTrendModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketTrendModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketTrendModel value)  $default,){
final _that = this;
switch (_that) {
case _MarketTrendModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketTrendModel value)?  $default,){
final _that = this;
switch (_that) {
case _MarketTrendModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String category,  String currentValue,  String trendType,  List<MarketDataPointModel> historyData,  List<MarketDataPointModel>? projectedData,  String? insight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketTrendModel() when $default != null:
return $default(_that.id,_that.label,_that.category,_that.currentValue,_that.trendType,_that.historyData,_that.projectedData,_that.insight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String category,  String currentValue,  String trendType,  List<MarketDataPointModel> historyData,  List<MarketDataPointModel>? projectedData,  String? insight)  $default,) {final _that = this;
switch (_that) {
case _MarketTrendModel():
return $default(_that.id,_that.label,_that.category,_that.currentValue,_that.trendType,_that.historyData,_that.projectedData,_that.insight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String category,  String currentValue,  String trendType,  List<MarketDataPointModel> historyData,  List<MarketDataPointModel>? projectedData,  String? insight)?  $default,) {final _that = this;
switch (_that) {
case _MarketTrendModel() when $default != null:
return $default(_that.id,_that.label,_that.category,_that.currentValue,_that.trendType,_that.historyData,_that.projectedData,_that.insight);case _:
  return null;

}
}

}

/// @nodoc


class _MarketTrendModel implements MarketTrendModel {
  const _MarketTrendModel({required this.id, required this.label, required this.category, required this.currentValue, required this.trendType, required final  List<MarketDataPointModel> historyData, final  List<MarketDataPointModel>? projectedData, this.insight}): _historyData = historyData,_projectedData = projectedData;
  

@override final  String id;
@override final  String label;
@override final  String category;
@override final  String currentValue;
@override final  String trendType;
// UP, DOWN, STABLE
 final  List<MarketDataPointModel> _historyData;
// UP, DOWN, STABLE
@override List<MarketDataPointModel> get historyData {
  if (_historyData is EqualUnmodifiableListView) return _historyData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_historyData);
}

 final  List<MarketDataPointModel>? _projectedData;
@override List<MarketDataPointModel>? get projectedData {
  final value = _projectedData;
  if (value == null) return null;
  if (_projectedData is EqualUnmodifiableListView) return _projectedData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? insight;

/// Create a copy of MarketTrendModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketTrendModelCopyWith<_MarketTrendModel> get copyWith => __$MarketTrendModelCopyWithImpl<_MarketTrendModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketTrendModel&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.category, category) || other.category == category)&&(identical(other.currentValue, currentValue) || other.currentValue == currentValue)&&(identical(other.trendType, trendType) || other.trendType == trendType)&&const DeepCollectionEquality().equals(other._historyData, _historyData)&&const DeepCollectionEquality().equals(other._projectedData, _projectedData)&&(identical(other.insight, insight) || other.insight == insight));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,category,currentValue,trendType,const DeepCollectionEquality().hash(_historyData),const DeepCollectionEquality().hash(_projectedData),insight);

@override
String toString() {
  return 'MarketTrendModel(id: $id, label: $label, category: $category, currentValue: $currentValue, trendType: $trendType, historyData: $historyData, projectedData: $projectedData, insight: $insight)';
}


}

/// @nodoc
abstract mixin class _$MarketTrendModelCopyWith<$Res> implements $MarketTrendModelCopyWith<$Res> {
  factory _$MarketTrendModelCopyWith(_MarketTrendModel value, $Res Function(_MarketTrendModel) _then) = __$MarketTrendModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String category, String currentValue, String trendType, List<MarketDataPointModel> historyData, List<MarketDataPointModel>? projectedData, String? insight
});




}
/// @nodoc
class __$MarketTrendModelCopyWithImpl<$Res>
    implements _$MarketTrendModelCopyWith<$Res> {
  __$MarketTrendModelCopyWithImpl(this._self, this._then);

  final _MarketTrendModel _self;
  final $Res Function(_MarketTrendModel) _then;

/// Create a copy of MarketTrendModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? category = null,Object? currentValue = null,Object? trendType = null,Object? historyData = null,Object? projectedData = freezed,Object? insight = freezed,}) {
  return _then(_MarketTrendModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,currentValue: null == currentValue ? _self.currentValue : currentValue // ignore: cast_nullable_to_non_nullable
as String,trendType: null == trendType ? _self.trendType : trendType // ignore: cast_nullable_to_non_nullable
as String,historyData: null == historyData ? _self._historyData : historyData // ignore: cast_nullable_to_non_nullable
as List<MarketDataPointModel>,projectedData: freezed == projectedData ? _self._projectedData : projectedData // ignore: cast_nullable_to_non_nullable
as List<MarketDataPointModel>?,insight: freezed == insight ? _self.insight : insight // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MarketDataPointModel {

 String get x;// Date string
 num get y;
/// Create a copy of MarketDataPointModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarketDataPointModelCopyWith<MarketDataPointModel> get copyWith => _$MarketDataPointModelCopyWithImpl<MarketDataPointModel>(this as MarketDataPointModel, _$identity);

  /// Serializes this MarketDataPointModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarketDataPointModel&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y);

@override
String toString() {
  return 'MarketDataPointModel(x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class $MarketDataPointModelCopyWith<$Res>  {
  factory $MarketDataPointModelCopyWith(MarketDataPointModel value, $Res Function(MarketDataPointModel) _then) = _$MarketDataPointModelCopyWithImpl;
@useResult
$Res call({
 String x, num y
});




}
/// @nodoc
class _$MarketDataPointModelCopyWithImpl<$Res>
    implements $MarketDataPointModelCopyWith<$Res> {
  _$MarketDataPointModelCopyWithImpl(this._self, this._then);

  final MarketDataPointModel _self;
  final $Res Function(MarketDataPointModel) _then;

/// Create a copy of MarketDataPointModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? x = null,Object? y = null,}) {
  return _then(_self.copyWith(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as String,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [MarketDataPointModel].
extension MarketDataPointModelPatterns on MarketDataPointModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarketDataPointModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarketDataPointModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarketDataPointModel value)  $default,){
final _that = this;
switch (_that) {
case _MarketDataPointModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarketDataPointModel value)?  $default,){
final _that = this;
switch (_that) {
case _MarketDataPointModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String x,  num y)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarketDataPointModel() when $default != null:
return $default(_that.x,_that.y);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String x,  num y)  $default,) {final _that = this;
switch (_that) {
case _MarketDataPointModel():
return $default(_that.x,_that.y);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String x,  num y)?  $default,) {final _that = this;
switch (_that) {
case _MarketDataPointModel() when $default != null:
return $default(_that.x,_that.y);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MarketDataPointModel implements MarketDataPointModel {
  const _MarketDataPointModel({required this.x, required this.y});
  factory _MarketDataPointModel.fromJson(Map<String, dynamic> json) => _$MarketDataPointModelFromJson(json);

@override final  String x;
// Date string
@override final  num y;

/// Create a copy of MarketDataPointModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarketDataPointModelCopyWith<_MarketDataPointModel> get copyWith => __$MarketDataPointModelCopyWithImpl<_MarketDataPointModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MarketDataPointModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarketDataPointModel&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,x,y);

@override
String toString() {
  return 'MarketDataPointModel(x: $x, y: $y)';
}


}

/// @nodoc
abstract mixin class _$MarketDataPointModelCopyWith<$Res> implements $MarketDataPointModelCopyWith<$Res> {
  factory _$MarketDataPointModelCopyWith(_MarketDataPointModel value, $Res Function(_MarketDataPointModel) _then) = __$MarketDataPointModelCopyWithImpl;
@override @useResult
$Res call({
 String x, num y
});




}
/// @nodoc
class __$MarketDataPointModelCopyWithImpl<$Res>
    implements _$MarketDataPointModelCopyWith<$Res> {
  __$MarketDataPointModelCopyWithImpl(this._self, this._then);

  final _MarketDataPointModel _self;
  final $Res Function(_MarketDataPointModel) _then;

/// Create a copy of MarketDataPointModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? x = null,Object? y = null,}) {
  return _then(_MarketDataPointModel(
x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as String,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
