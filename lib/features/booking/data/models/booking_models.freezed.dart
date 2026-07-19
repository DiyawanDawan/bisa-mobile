// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingUserModel {

 String get id; String get fullName; String? get avatarUrl; String? get companyName;
/// Create a copy of BookingUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingUserModelCopyWith<BookingUserModel> get copyWith => _$BookingUserModelCopyWithImpl<BookingUserModel>(this as BookingUserModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,companyName);

@override
String toString() {
  return 'BookingUserModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class $BookingUserModelCopyWith<$Res>  {
  factory $BookingUserModelCopyWith(BookingUserModel value, $Res Function(BookingUserModel) _then) = _$BookingUserModelCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? companyName
});




}
/// @nodoc
class _$BookingUserModelCopyWithImpl<$Res>
    implements $BookingUserModelCopyWith<$Res> {
  _$BookingUserModelCopyWithImpl(this._self, this._then);

  final BookingUserModel _self;
  final $Res Function(BookingUserModel) _then;

/// Create a copy of BookingUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? companyName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingUserModel].
extension BookingUserModelPatterns on BookingUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingUserModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String? companyName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingUserModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.companyName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String? companyName)  $default,) {final _that = this;
switch (_that) {
case _BookingUserModel():
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.companyName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? avatarUrl,  String? companyName)?  $default,) {final _that = this;
switch (_that) {
case _BookingUserModel() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.companyName);case _:
  return null;

}
}

}

/// @nodoc


class _BookingUserModel implements BookingUserModel {
  const _BookingUserModel({required this.id, required this.fullName, this.avatarUrl, this.companyName});
  

@override final  String id;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String? companyName;

/// Create a copy of BookingUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingUserModelCopyWith<_BookingUserModel> get copyWith => __$BookingUserModelCopyWithImpl<_BookingUserModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,companyName);

@override
String toString() {
  return 'BookingUserModel(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class _$BookingUserModelCopyWith<$Res> implements $BookingUserModelCopyWith<$Res> {
  factory _$BookingUserModelCopyWith(_BookingUserModel value, $Res Function(_BookingUserModel) _then) = __$BookingUserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? companyName
});




}
/// @nodoc
class __$BookingUserModelCopyWithImpl<$Res>
    implements _$BookingUserModelCopyWith<$Res> {
  __$BookingUserModelCopyWithImpl(this._self, this._then);

  final _BookingUserModel _self;
  final $Res Function(_BookingUserModel) _then;

/// Create a copy of BookingUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? companyName = freezed,}) {
  return _then(_BookingUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$BookingProductModel {

 String get id; String get name; String? get thumbnailUrl; String get productMode; String get unit; double get stock; double get reservedStock; double get availableStock; double get pricePerUnit; String get availabilityType;
/// Create a copy of BookingProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingProductModelCopyWith<BookingProductModel> get copyWith => _$BookingProductModelCopyWithImpl<BookingProductModel>(this as BookingProductModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.reservedStock, reservedStock) || other.reservedStock == reservedStock)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.availabilityType, availabilityType) || other.availabilityType == availabilityType));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnailUrl,productMode,unit,stock,reservedStock,availableStock,pricePerUnit,availabilityType);

@override
String toString() {
  return 'BookingProductModel(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, productMode: $productMode, unit: $unit, stock: $stock, reservedStock: $reservedStock, availableStock: $availableStock, pricePerUnit: $pricePerUnit, availabilityType: $availabilityType)';
}


}

/// @nodoc
abstract mixin class $BookingProductModelCopyWith<$Res>  {
  factory $BookingProductModelCopyWith(BookingProductModel value, $Res Function(BookingProductModel) _then) = _$BookingProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? thumbnailUrl, String productMode, String unit, double stock, double reservedStock, double availableStock, double pricePerUnit, String availabilityType
});




}
/// @nodoc
class _$BookingProductModelCopyWithImpl<$Res>
    implements $BookingProductModelCopyWith<$Res> {
  _$BookingProductModelCopyWithImpl(this._self, this._then);

  final BookingProductModel _self;
  final $Res Function(BookingProductModel) _then;

/// Create a copy of BookingProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? thumbnailUrl = freezed,Object? productMode = null,Object? unit = null,Object? stock = null,Object? reservedStock = null,Object? availableStock = null,Object? pricePerUnit = null,Object? availabilityType = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,productMode: null == productMode ? _self.productMode : productMode // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,reservedStock: null == reservedStock ? _self.reservedStock : reservedStock // ignore: cast_nullable_to_non_nullable
as double,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as double,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,availabilityType: null == availabilityType ? _self.availabilityType : availabilityType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingProductModel].
extension BookingProductModelPatterns on BookingProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingProductModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? thumbnailUrl,  String productMode,  String unit,  double stock,  double reservedStock,  double availableStock,  double pricePerUnit,  String availabilityType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingProductModel() when $default != null:
return $default(_that.id,_that.name,_that.thumbnailUrl,_that.productMode,_that.unit,_that.stock,_that.reservedStock,_that.availableStock,_that.pricePerUnit,_that.availabilityType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? thumbnailUrl,  String productMode,  String unit,  double stock,  double reservedStock,  double availableStock,  double pricePerUnit,  String availabilityType)  $default,) {final _that = this;
switch (_that) {
case _BookingProductModel():
return $default(_that.id,_that.name,_that.thumbnailUrl,_that.productMode,_that.unit,_that.stock,_that.reservedStock,_that.availableStock,_that.pricePerUnit,_that.availabilityType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? thumbnailUrl,  String productMode,  String unit,  double stock,  double reservedStock,  double availableStock,  double pricePerUnit,  String availabilityType)?  $default,) {final _that = this;
switch (_that) {
case _BookingProductModel() when $default != null:
return $default(_that.id,_that.name,_that.thumbnailUrl,_that.productMode,_that.unit,_that.stock,_that.reservedStock,_that.availableStock,_that.pricePerUnit,_that.availabilityType);case _:
  return null;

}
}

}

/// @nodoc


class _BookingProductModel implements BookingProductModel {
  const _BookingProductModel({required this.id, required this.name, this.thumbnailUrl, required this.productMode, required this.unit, required this.stock, required this.reservedStock, required this.availableStock, required this.pricePerUnit, required this.availabilityType});
  

@override final  String id;
@override final  String name;
@override final  String? thumbnailUrl;
@override final  String productMode;
@override final  String unit;
@override final  double stock;
@override final  double reservedStock;
@override final  double availableStock;
@override final  double pricePerUnit;
@override final  String availabilityType;

/// Create a copy of BookingProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingProductModelCopyWith<_BookingProductModel> get copyWith => __$BookingProductModelCopyWithImpl<_BookingProductModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.reservedStock, reservedStock) || other.reservedStock == reservedStock)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.availabilityType, availabilityType) || other.availabilityType == availabilityType));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnailUrl,productMode,unit,stock,reservedStock,availableStock,pricePerUnit,availabilityType);

@override
String toString() {
  return 'BookingProductModel(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, productMode: $productMode, unit: $unit, stock: $stock, reservedStock: $reservedStock, availableStock: $availableStock, pricePerUnit: $pricePerUnit, availabilityType: $availabilityType)';
}


}

/// @nodoc
abstract mixin class _$BookingProductModelCopyWith<$Res> implements $BookingProductModelCopyWith<$Res> {
  factory _$BookingProductModelCopyWith(_BookingProductModel value, $Res Function(_BookingProductModel) _then) = __$BookingProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? thumbnailUrl, String productMode, String unit, double stock, double reservedStock, double availableStock, double pricePerUnit, String availabilityType
});




}
/// @nodoc
class __$BookingProductModelCopyWithImpl<$Res>
    implements _$BookingProductModelCopyWith<$Res> {
  __$BookingProductModelCopyWithImpl(this._self, this._then);

  final _BookingProductModel _self;
  final $Res Function(_BookingProductModel) _then;

/// Create a copy of BookingProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? thumbnailUrl = freezed,Object? productMode = null,Object? unit = null,Object? stock = null,Object? reservedStock = null,Object? availableStock = null,Object? pricePerUnit = null,Object? availabilityType = null,}) {
  return _then(_BookingProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,productMode: null == productMode ? _self.productMode : productMode // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,reservedStock: null == reservedStock ? _self.reservedStock : reservedStock // ignore: cast_nullable_to_non_nullable
as double,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as double,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,availabilityType: null == availabilityType ? _self.availabilityType : availabilityType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BookingHarvestLotModel {

 String get id; String? get seasonLabel; DateTime get expectedHarvestDate; double get expectedQuantityTon; double get reservedQuantityTon; double get availableQuantityTon; String get status;
/// Create a copy of BookingHarvestLotModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingHarvestLotModelCopyWith<BookingHarvestLotModel> get copyWith => _$BookingHarvestLotModelCopyWithImpl<BookingHarvestLotModel>(this as BookingHarvestLotModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingHarvestLotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonLabel, seasonLabel) || other.seasonLabel == seasonLabel)&&(identical(other.expectedHarvestDate, expectedHarvestDate) || other.expectedHarvestDate == expectedHarvestDate)&&(identical(other.expectedQuantityTon, expectedQuantityTon) || other.expectedQuantityTon == expectedQuantityTon)&&(identical(other.reservedQuantityTon, reservedQuantityTon) || other.reservedQuantityTon == reservedQuantityTon)&&(identical(other.availableQuantityTon, availableQuantityTon) || other.availableQuantityTon == availableQuantityTon)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,seasonLabel,expectedHarvestDate,expectedQuantityTon,reservedQuantityTon,availableQuantityTon,status);

@override
String toString() {
  return 'BookingHarvestLotModel(id: $id, seasonLabel: $seasonLabel, expectedHarvestDate: $expectedHarvestDate, expectedQuantityTon: $expectedQuantityTon, reservedQuantityTon: $reservedQuantityTon, availableQuantityTon: $availableQuantityTon, status: $status)';
}


}

/// @nodoc
abstract mixin class $BookingHarvestLotModelCopyWith<$Res>  {
  factory $BookingHarvestLotModelCopyWith(BookingHarvestLotModel value, $Res Function(BookingHarvestLotModel) _then) = _$BookingHarvestLotModelCopyWithImpl;
@useResult
$Res call({
 String id, String? seasonLabel, DateTime expectedHarvestDate, double expectedQuantityTon, double reservedQuantityTon, double availableQuantityTon, String status
});




}
/// @nodoc
class _$BookingHarvestLotModelCopyWithImpl<$Res>
    implements $BookingHarvestLotModelCopyWith<$Res> {
  _$BookingHarvestLotModelCopyWithImpl(this._self, this._then);

  final BookingHarvestLotModel _self;
  final $Res Function(BookingHarvestLotModel) _then;

/// Create a copy of BookingHarvestLotModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seasonLabel = freezed,Object? expectedHarvestDate = null,Object? expectedQuantityTon = null,Object? reservedQuantityTon = null,Object? availableQuantityTon = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonLabel: freezed == seasonLabel ? _self.seasonLabel : seasonLabel // ignore: cast_nullable_to_non_nullable
as String?,expectedHarvestDate: null == expectedHarvestDate ? _self.expectedHarvestDate : expectedHarvestDate // ignore: cast_nullable_to_non_nullable
as DateTime,expectedQuantityTon: null == expectedQuantityTon ? _self.expectedQuantityTon : expectedQuantityTon // ignore: cast_nullable_to_non_nullable
as double,reservedQuantityTon: null == reservedQuantityTon ? _self.reservedQuantityTon : reservedQuantityTon // ignore: cast_nullable_to_non_nullable
as double,availableQuantityTon: null == availableQuantityTon ? _self.availableQuantityTon : availableQuantityTon // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingHarvestLotModel].
extension BookingHarvestLotModelPatterns on BookingHarvestLotModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingHarvestLotModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingHarvestLotModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingHarvestLotModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingHarvestLotModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingHarvestLotModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingHarvestLotModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? seasonLabel,  DateTime expectedHarvestDate,  double expectedQuantityTon,  double reservedQuantityTon,  double availableQuantityTon,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingHarvestLotModel() when $default != null:
return $default(_that.id,_that.seasonLabel,_that.expectedHarvestDate,_that.expectedQuantityTon,_that.reservedQuantityTon,_that.availableQuantityTon,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? seasonLabel,  DateTime expectedHarvestDate,  double expectedQuantityTon,  double reservedQuantityTon,  double availableQuantityTon,  String status)  $default,) {final _that = this;
switch (_that) {
case _BookingHarvestLotModel():
return $default(_that.id,_that.seasonLabel,_that.expectedHarvestDate,_that.expectedQuantityTon,_that.reservedQuantityTon,_that.availableQuantityTon,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? seasonLabel,  DateTime expectedHarvestDate,  double expectedQuantityTon,  double reservedQuantityTon,  double availableQuantityTon,  String status)?  $default,) {final _that = this;
switch (_that) {
case _BookingHarvestLotModel() when $default != null:
return $default(_that.id,_that.seasonLabel,_that.expectedHarvestDate,_that.expectedQuantityTon,_that.reservedQuantityTon,_that.availableQuantityTon,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BookingHarvestLotModel implements BookingHarvestLotModel {
  const _BookingHarvestLotModel({required this.id, this.seasonLabel, required this.expectedHarvestDate, required this.expectedQuantityTon, required this.reservedQuantityTon, required this.availableQuantityTon, required this.status});
  

@override final  String id;
@override final  String? seasonLabel;
@override final  DateTime expectedHarvestDate;
@override final  double expectedQuantityTon;
@override final  double reservedQuantityTon;
@override final  double availableQuantityTon;
@override final  String status;

/// Create a copy of BookingHarvestLotModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingHarvestLotModelCopyWith<_BookingHarvestLotModel> get copyWith => __$BookingHarvestLotModelCopyWithImpl<_BookingHarvestLotModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingHarvestLotModel&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonLabel, seasonLabel) || other.seasonLabel == seasonLabel)&&(identical(other.expectedHarvestDate, expectedHarvestDate) || other.expectedHarvestDate == expectedHarvestDate)&&(identical(other.expectedQuantityTon, expectedQuantityTon) || other.expectedQuantityTon == expectedQuantityTon)&&(identical(other.reservedQuantityTon, reservedQuantityTon) || other.reservedQuantityTon == reservedQuantityTon)&&(identical(other.availableQuantityTon, availableQuantityTon) || other.availableQuantityTon == availableQuantityTon)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,seasonLabel,expectedHarvestDate,expectedQuantityTon,reservedQuantityTon,availableQuantityTon,status);

@override
String toString() {
  return 'BookingHarvestLotModel(id: $id, seasonLabel: $seasonLabel, expectedHarvestDate: $expectedHarvestDate, expectedQuantityTon: $expectedQuantityTon, reservedQuantityTon: $reservedQuantityTon, availableQuantityTon: $availableQuantityTon, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BookingHarvestLotModelCopyWith<$Res> implements $BookingHarvestLotModelCopyWith<$Res> {
  factory _$BookingHarvestLotModelCopyWith(_BookingHarvestLotModel value, $Res Function(_BookingHarvestLotModel) _then) = __$BookingHarvestLotModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? seasonLabel, DateTime expectedHarvestDate, double expectedQuantityTon, double reservedQuantityTon, double availableQuantityTon, String status
});




}
/// @nodoc
class __$BookingHarvestLotModelCopyWithImpl<$Res>
    implements _$BookingHarvestLotModelCopyWith<$Res> {
  __$BookingHarvestLotModelCopyWithImpl(this._self, this._then);

  final _BookingHarvestLotModel _self;
  final $Res Function(_BookingHarvestLotModel) _then;

/// Create a copy of BookingHarvestLotModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonLabel = freezed,Object? expectedHarvestDate = null,Object? expectedQuantityTon = null,Object? reservedQuantityTon = null,Object? availableQuantityTon = null,Object? status = null,}) {
  return _then(_BookingHarvestLotModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seasonLabel: freezed == seasonLabel ? _self.seasonLabel : seasonLabel // ignore: cast_nullable_to_non_nullable
as String?,expectedHarvestDate: null == expectedHarvestDate ? _self.expectedHarvestDate : expectedHarvestDate // ignore: cast_nullable_to_non_nullable
as DateTime,expectedQuantityTon: null == expectedQuantityTon ? _self.expectedQuantityTon : expectedQuantityTon // ignore: cast_nullable_to_non_nullable
as double,reservedQuantityTon: null == reservedQuantityTon ? _self.reservedQuantityTon : reservedQuantityTon // ignore: cast_nullable_to_non_nullable
as double,availableQuantityTon: null == availableQuantityTon ? _self.availableQuantityTon : availableQuantityTon // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BookingOrderRefModel {

 String get id; String get orderNumber; String get status;
/// Create a copy of BookingOrderRefModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingOrderRefModelCopyWith<BookingOrderRefModel> get copyWith => _$BookingOrderRefModelCopyWithImpl<BookingOrderRefModel>(this as BookingOrderRefModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingOrderRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status);

@override
String toString() {
  return 'BookingOrderRefModel(id: $id, orderNumber: $orderNumber, status: $status)';
}


}

/// @nodoc
abstract mixin class $BookingOrderRefModelCopyWith<$Res>  {
  factory $BookingOrderRefModelCopyWith(BookingOrderRefModel value, $Res Function(BookingOrderRefModel) _then) = _$BookingOrderRefModelCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String status
});




}
/// @nodoc
class _$BookingOrderRefModelCopyWithImpl<$Res>
    implements $BookingOrderRefModelCopyWith<$Res> {
  _$BookingOrderRefModelCopyWithImpl(this._self, this._then);

  final BookingOrderRefModel _self;
  final $Res Function(BookingOrderRefModel) _then;

/// Create a copy of BookingOrderRefModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingOrderRefModel].
extension BookingOrderRefModelPatterns on BookingOrderRefModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingOrderRefModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingOrderRefModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingOrderRefModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingOrderRefModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingOrderRefModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingOrderRefModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingOrderRefModel() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String status)  $default,) {final _that = this;
switch (_that) {
case _BookingOrderRefModel():
return $default(_that.id,_that.orderNumber,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderNumber,  String status)?  $default,) {final _that = this;
switch (_that) {
case _BookingOrderRefModel() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BookingOrderRefModel implements BookingOrderRefModel {
  const _BookingOrderRefModel({required this.id, required this.orderNumber, required this.status});
  

@override final  String id;
@override final  String orderNumber;
@override final  String status;

/// Create a copy of BookingOrderRefModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingOrderRefModelCopyWith<_BookingOrderRefModel> get copyWith => __$BookingOrderRefModelCopyWithImpl<_BookingOrderRefModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingOrderRefModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status);

@override
String toString() {
  return 'BookingOrderRefModel(id: $id, orderNumber: $orderNumber, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BookingOrderRefModelCopyWith<$Res> implements $BookingOrderRefModelCopyWith<$Res> {
  factory _$BookingOrderRefModelCopyWith(_BookingOrderRefModel value, $Res Function(_BookingOrderRefModel) _then) = __$BookingOrderRefModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String status
});




}
/// @nodoc
class __$BookingOrderRefModelCopyWithImpl<$Res>
    implements _$BookingOrderRefModelCopyWith<$Res> {
  __$BookingOrderRefModelCopyWithImpl(this._self, this._then);

  final _BookingOrderRefModel _self;
  final $Res Function(_BookingOrderRefModel) _then;

/// Create a copy of BookingOrderRefModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,}) {
  return _then(_BookingOrderRefModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BookingModel {

 String get id; String get bookingNumber; String get buyerId; String get supplierId; String get productId; String? get harvestLotId; String get productMode; double get quantity; String get unit; double get priceSnapshot; double get subtotalSnapshot; String get status; DateTime get expiresAt; DateTime? get expectedDeliveryDate; String? get notes; String? get orderId; DateTime? get confirmedAt; bool get isExpired; DateTime get createdAt; BookingUserModel get buyer; BookingUserModel get supplier; BookingProductModel get product; BookingHarvestLotModel? get harvestLot; BookingOrderRefModel? get order;
/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingModelCopyWith<BookingModel> get copyWith => _$BookingModelCopyWithImpl<BookingModel>(this as BookingModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingNumber, bookingNumber) || other.bookingNumber == bookingNumber)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.harvestLotId, harvestLotId) || other.harvestLotId == harvestLotId)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.priceSnapshot, priceSnapshot) || other.priceSnapshot == priceSnapshot)&&(identical(other.subtotalSnapshot, subtotalSnapshot) || other.subtotalSnapshot == subtotalSnapshot)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expectedDeliveryDate, expectedDeliveryDate) || other.expectedDeliveryDate == expectedDeliveryDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.supplier, supplier) || other.supplier == supplier)&&(identical(other.product, product) || other.product == product)&&(identical(other.harvestLot, harvestLot) || other.harvestLot == harvestLot)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,bookingNumber,buyerId,supplierId,productId,harvestLotId,productMode,quantity,unit,priceSnapshot,subtotalSnapshot,status,expiresAt,expectedDeliveryDate,notes,orderId,confirmedAt,isExpired,createdAt,buyer,supplier,product,harvestLot,order]);

@override
String toString() {
  return 'BookingModel(id: $id, bookingNumber: $bookingNumber, buyerId: $buyerId, supplierId: $supplierId, productId: $productId, harvestLotId: $harvestLotId, productMode: $productMode, quantity: $quantity, unit: $unit, priceSnapshot: $priceSnapshot, subtotalSnapshot: $subtotalSnapshot, status: $status, expiresAt: $expiresAt, expectedDeliveryDate: $expectedDeliveryDate, notes: $notes, orderId: $orderId, confirmedAt: $confirmedAt, isExpired: $isExpired, createdAt: $createdAt, buyer: $buyer, supplier: $supplier, product: $product, harvestLot: $harvestLot, order: $order)';
}


}

/// @nodoc
abstract mixin class $BookingModelCopyWith<$Res>  {
  factory $BookingModelCopyWith(BookingModel value, $Res Function(BookingModel) _then) = _$BookingModelCopyWithImpl;
@useResult
$Res call({
 String id, String bookingNumber, String buyerId, String supplierId, String productId, String? harvestLotId, String productMode, double quantity, String unit, double priceSnapshot, double subtotalSnapshot, String status, DateTime expiresAt, DateTime? expectedDeliveryDate, String? notes, String? orderId, DateTime? confirmedAt, bool isExpired, DateTime createdAt, BookingUserModel buyer, BookingUserModel supplier, BookingProductModel product, BookingHarvestLotModel? harvestLot, BookingOrderRefModel? order
});


$BookingUserModelCopyWith<$Res> get buyer;$BookingUserModelCopyWith<$Res> get supplier;$BookingProductModelCopyWith<$Res> get product;$BookingHarvestLotModelCopyWith<$Res>? get harvestLot;$BookingOrderRefModelCopyWith<$Res>? get order;

}
/// @nodoc
class _$BookingModelCopyWithImpl<$Res>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._self, this._then);

  final BookingModel _self;
  final $Res Function(BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookingNumber = null,Object? buyerId = null,Object? supplierId = null,Object? productId = null,Object? harvestLotId = freezed,Object? productMode = null,Object? quantity = null,Object? unit = null,Object? priceSnapshot = null,Object? subtotalSnapshot = null,Object? status = null,Object? expiresAt = null,Object? expectedDeliveryDate = freezed,Object? notes = freezed,Object? orderId = freezed,Object? confirmedAt = freezed,Object? isExpired = null,Object? createdAt = null,Object? buyer = null,Object? supplier = null,Object? product = null,Object? harvestLot = freezed,Object? order = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingNumber: null == bookingNumber ? _self.bookingNumber : bookingNumber // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,harvestLotId: freezed == harvestLotId ? _self.harvestLotId : harvestLotId // ignore: cast_nullable_to_non_nullable
as String?,productMode: null == productMode ? _self.productMode : productMode // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,priceSnapshot: null == priceSnapshot ? _self.priceSnapshot : priceSnapshot // ignore: cast_nullable_to_non_nullable
as double,subtotalSnapshot: null == subtotalSnapshot ? _self.subtotalSnapshot : subtotalSnapshot // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,expectedDeliveryDate: freezed == expectedDeliveryDate ? _self.expectedDeliveryDate : expectedDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as BookingUserModel,supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as BookingUserModel,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as BookingProductModel,harvestLot: freezed == harvestLot ? _self.harvestLot : harvestLot // ignore: cast_nullable_to_non_nullable
as BookingHarvestLotModel?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as BookingOrderRefModel?,
  ));
}
/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUserModelCopyWith<$Res> get buyer {
  
  return $BookingUserModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUserModelCopyWith<$Res> get supplier {
  
  return $BookingUserModelCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingProductModelCopyWith<$Res> get product {
  
  return $BookingProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingHarvestLotModelCopyWith<$Res>? get harvestLot {
    if (_self.harvestLot == null) {
    return null;
  }

  return $BookingHarvestLotModelCopyWith<$Res>(_self.harvestLot!, (value) {
    return _then(_self.copyWith(harvestLot: value));
  });
}/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingOrderRefModelCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $BookingOrderRefModelCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingModel].
extension BookingModelPatterns on BookingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookingNumber,  String buyerId,  String supplierId,  String productId,  String? harvestLotId,  String productMode,  double quantity,  String unit,  double priceSnapshot,  double subtotalSnapshot,  String status,  DateTime expiresAt,  DateTime? expectedDeliveryDate,  String? notes,  String? orderId,  DateTime? confirmedAt,  bool isExpired,  DateTime createdAt,  BookingUserModel buyer,  BookingUserModel supplier,  BookingProductModel product,  BookingHarvestLotModel? harvestLot,  BookingOrderRefModel? order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.bookingNumber,_that.buyerId,_that.supplierId,_that.productId,_that.harvestLotId,_that.productMode,_that.quantity,_that.unit,_that.priceSnapshot,_that.subtotalSnapshot,_that.status,_that.expiresAt,_that.expectedDeliveryDate,_that.notes,_that.orderId,_that.confirmedAt,_that.isExpired,_that.createdAt,_that.buyer,_that.supplier,_that.product,_that.harvestLot,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookingNumber,  String buyerId,  String supplierId,  String productId,  String? harvestLotId,  String productMode,  double quantity,  String unit,  double priceSnapshot,  double subtotalSnapshot,  String status,  DateTime expiresAt,  DateTime? expectedDeliveryDate,  String? notes,  String? orderId,  DateTime? confirmedAt,  bool isExpired,  DateTime createdAt,  BookingUserModel buyer,  BookingUserModel supplier,  BookingProductModel product,  BookingHarvestLotModel? harvestLot,  BookingOrderRefModel? order)  $default,) {final _that = this;
switch (_that) {
case _BookingModel():
return $default(_that.id,_that.bookingNumber,_that.buyerId,_that.supplierId,_that.productId,_that.harvestLotId,_that.productMode,_that.quantity,_that.unit,_that.priceSnapshot,_that.subtotalSnapshot,_that.status,_that.expiresAt,_that.expectedDeliveryDate,_that.notes,_that.orderId,_that.confirmedAt,_that.isExpired,_that.createdAt,_that.buyer,_that.supplier,_that.product,_that.harvestLot,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookingNumber,  String buyerId,  String supplierId,  String productId,  String? harvestLotId,  String productMode,  double quantity,  String unit,  double priceSnapshot,  double subtotalSnapshot,  String status,  DateTime expiresAt,  DateTime? expectedDeliveryDate,  String? notes,  String? orderId,  DateTime? confirmedAt,  bool isExpired,  DateTime createdAt,  BookingUserModel buyer,  BookingUserModel supplier,  BookingProductModel product,  BookingHarvestLotModel? harvestLot,  BookingOrderRefModel? order)?  $default,) {final _that = this;
switch (_that) {
case _BookingModel() when $default != null:
return $default(_that.id,_that.bookingNumber,_that.buyerId,_that.supplierId,_that.productId,_that.harvestLotId,_that.productMode,_that.quantity,_that.unit,_that.priceSnapshot,_that.subtotalSnapshot,_that.status,_that.expiresAt,_that.expectedDeliveryDate,_that.notes,_that.orderId,_that.confirmedAt,_that.isExpired,_that.createdAt,_that.buyer,_that.supplier,_that.product,_that.harvestLot,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _BookingModel implements BookingModel {
  const _BookingModel({required this.id, required this.bookingNumber, required this.buyerId, required this.supplierId, required this.productId, this.harvestLotId, required this.productMode, required this.quantity, required this.unit, required this.priceSnapshot, required this.subtotalSnapshot, required this.status, required this.expiresAt, this.expectedDeliveryDate, this.notes, this.orderId, this.confirmedAt, this.isExpired = false, required this.createdAt, required this.buyer, required this.supplier, required this.product, this.harvestLot, this.order});
  

@override final  String id;
@override final  String bookingNumber;
@override final  String buyerId;
@override final  String supplierId;
@override final  String productId;
@override final  String? harvestLotId;
@override final  String productMode;
@override final  double quantity;
@override final  String unit;
@override final  double priceSnapshot;
@override final  double subtotalSnapshot;
@override final  String status;
@override final  DateTime expiresAt;
@override final  DateTime? expectedDeliveryDate;
@override final  String? notes;
@override final  String? orderId;
@override final  DateTime? confirmedAt;
@override@JsonKey() final  bool isExpired;
@override final  DateTime createdAt;
@override final  BookingUserModel buyer;
@override final  BookingUserModel supplier;
@override final  BookingProductModel product;
@override final  BookingHarvestLotModel? harvestLot;
@override final  BookingOrderRefModel? order;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingModelCopyWith<_BookingModel> get copyWith => __$BookingModelCopyWithImpl<_BookingModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingNumber, bookingNumber) || other.bookingNumber == bookingNumber)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.harvestLotId, harvestLotId) || other.harvestLotId == harvestLotId)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.priceSnapshot, priceSnapshot) || other.priceSnapshot == priceSnapshot)&&(identical(other.subtotalSnapshot, subtotalSnapshot) || other.subtotalSnapshot == subtotalSnapshot)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expectedDeliveryDate, expectedDeliveryDate) || other.expectedDeliveryDate == expectedDeliveryDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.supplier, supplier) || other.supplier == supplier)&&(identical(other.product, product) || other.product == product)&&(identical(other.harvestLot, harvestLot) || other.harvestLot == harvestLot)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,bookingNumber,buyerId,supplierId,productId,harvestLotId,productMode,quantity,unit,priceSnapshot,subtotalSnapshot,status,expiresAt,expectedDeliveryDate,notes,orderId,confirmedAt,isExpired,createdAt,buyer,supplier,product,harvestLot,order]);

@override
String toString() {
  return 'BookingModel(id: $id, bookingNumber: $bookingNumber, buyerId: $buyerId, supplierId: $supplierId, productId: $productId, harvestLotId: $harvestLotId, productMode: $productMode, quantity: $quantity, unit: $unit, priceSnapshot: $priceSnapshot, subtotalSnapshot: $subtotalSnapshot, status: $status, expiresAt: $expiresAt, expectedDeliveryDate: $expectedDeliveryDate, notes: $notes, orderId: $orderId, confirmedAt: $confirmedAt, isExpired: $isExpired, createdAt: $createdAt, buyer: $buyer, supplier: $supplier, product: $product, harvestLot: $harvestLot, order: $order)';
}


}

/// @nodoc
abstract mixin class _$BookingModelCopyWith<$Res> implements $BookingModelCopyWith<$Res> {
  factory _$BookingModelCopyWith(_BookingModel value, $Res Function(_BookingModel) _then) = __$BookingModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookingNumber, String buyerId, String supplierId, String productId, String? harvestLotId, String productMode, double quantity, String unit, double priceSnapshot, double subtotalSnapshot, String status, DateTime expiresAt, DateTime? expectedDeliveryDate, String? notes, String? orderId, DateTime? confirmedAt, bool isExpired, DateTime createdAt, BookingUserModel buyer, BookingUserModel supplier, BookingProductModel product, BookingHarvestLotModel? harvestLot, BookingOrderRefModel? order
});


@override $BookingUserModelCopyWith<$Res> get buyer;@override $BookingUserModelCopyWith<$Res> get supplier;@override $BookingProductModelCopyWith<$Res> get product;@override $BookingHarvestLotModelCopyWith<$Res>? get harvestLot;@override $BookingOrderRefModelCopyWith<$Res>? get order;

}
/// @nodoc
class __$BookingModelCopyWithImpl<$Res>
    implements _$BookingModelCopyWith<$Res> {
  __$BookingModelCopyWithImpl(this._self, this._then);

  final _BookingModel _self;
  final $Res Function(_BookingModel) _then;

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingNumber = null,Object? buyerId = null,Object? supplierId = null,Object? productId = null,Object? harvestLotId = freezed,Object? productMode = null,Object? quantity = null,Object? unit = null,Object? priceSnapshot = null,Object? subtotalSnapshot = null,Object? status = null,Object? expiresAt = null,Object? expectedDeliveryDate = freezed,Object? notes = freezed,Object? orderId = freezed,Object? confirmedAt = freezed,Object? isExpired = null,Object? createdAt = null,Object? buyer = null,Object? supplier = null,Object? product = null,Object? harvestLot = freezed,Object? order = freezed,}) {
  return _then(_BookingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookingNumber: null == bookingNumber ? _self.bookingNumber : bookingNumber // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,harvestLotId: freezed == harvestLotId ? _self.harvestLotId : harvestLotId // ignore: cast_nullable_to_non_nullable
as String?,productMode: null == productMode ? _self.productMode : productMode // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,priceSnapshot: null == priceSnapshot ? _self.priceSnapshot : priceSnapshot // ignore: cast_nullable_to_non_nullable
as double,subtotalSnapshot: null == subtotalSnapshot ? _self.subtotalSnapshot : subtotalSnapshot // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,expectedDeliveryDate: freezed == expectedDeliveryDate ? _self.expectedDeliveryDate : expectedDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as BookingUserModel,supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as BookingUserModel,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as BookingProductModel,harvestLot: freezed == harvestLot ? _self.harvestLot : harvestLot // ignore: cast_nullable_to_non_nullable
as BookingHarvestLotModel?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as BookingOrderRefModel?,
  ));
}

/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUserModelCopyWith<$Res> get buyer {
  
  return $BookingUserModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUserModelCopyWith<$Res> get supplier {
  
  return $BookingUserModelCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingProductModelCopyWith<$Res> get product {
  
  return $BookingProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingHarvestLotModelCopyWith<$Res>? get harvestLot {
    if (_self.harvestLot == null) {
    return null;
  }

  return $BookingHarvestLotModelCopyWith<$Res>(_self.harvestLot!, (value) {
    return _then(_self.copyWith(harvestLot: value));
  });
}/// Create a copy of BookingModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingOrderRefModelCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $BookingOrderRefModelCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

/// @nodoc
mixin _$BookingListModel {

 List<BookingModel> get items; int get page; int get limit; int get total;
/// Create a copy of BookingListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingListModelCopyWith<BookingListModel> get copyWith => _$BookingListModelCopyWithImpl<BookingListModel>(this as BookingListModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingListModel&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),page,limit,total);

@override
String toString() {
  return 'BookingListModel(items: $items, page: $page, limit: $limit, total: $total)';
}


}

/// @nodoc
abstract mixin class $BookingListModelCopyWith<$Res>  {
  factory $BookingListModelCopyWith(BookingListModel value, $Res Function(BookingListModel) _then) = _$BookingListModelCopyWithImpl;
@useResult
$Res call({
 List<BookingModel> items, int page, int limit, int total
});




}
/// @nodoc
class _$BookingListModelCopyWithImpl<$Res>
    implements $BookingListModelCopyWith<$Res> {
  _$BookingListModelCopyWithImpl(this._self, this._then);

  final BookingListModel _self;
  final $Res Function(BookingListModel) _then;

/// Create a copy of BookingListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? page = null,Object? limit = null,Object? total = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BookingModel>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookingListModel].
extension BookingListModelPatterns on BookingListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingListModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingListModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BookingModel> items,  int page,  int limit,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingListModel() when $default != null:
return $default(_that.items,_that.page,_that.limit,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BookingModel> items,  int page,  int limit,  int total)  $default,) {final _that = this;
switch (_that) {
case _BookingListModel():
return $default(_that.items,_that.page,_that.limit,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BookingModel> items,  int page,  int limit,  int total)?  $default,) {final _that = this;
switch (_that) {
case _BookingListModel() when $default != null:
return $default(_that.items,_that.page,_that.limit,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _BookingListModel implements BookingListModel {
  const _BookingListModel({required final  List<BookingModel> items, required this.page, required this.limit, required this.total}): _items = items;
  

 final  List<BookingModel> _items;
@override List<BookingModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int page;
@override final  int limit;
@override final  int total;

/// Create a copy of BookingListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingListModelCopyWith<_BookingListModel> get copyWith => __$BookingListModelCopyWithImpl<_BookingListModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingListModel&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),page,limit,total);

@override
String toString() {
  return 'BookingListModel(items: $items, page: $page, limit: $limit, total: $total)';
}


}

/// @nodoc
abstract mixin class _$BookingListModelCopyWith<$Res> implements $BookingListModelCopyWith<$Res> {
  factory _$BookingListModelCopyWith(_BookingListModel value, $Res Function(_BookingListModel) _then) = __$BookingListModelCopyWithImpl;
@override @useResult
$Res call({
 List<BookingModel> items, int page, int limit, int total
});




}
/// @nodoc
class __$BookingListModelCopyWithImpl<$Res>
    implements _$BookingListModelCopyWith<$Res> {
  __$BookingListModelCopyWithImpl(this._self, this._then);

  final _BookingListModel _self;
  final $Res Function(_BookingListModel) _then;

/// Create a copy of BookingListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? page = null,Object? limit = null,Object? total = null,}) {
  return _then(_BookingListModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BookingModel>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$BookingCheckoutModel {

 BookingModel get booking; Map<String, dynamic> get checkout;
/// Create a copy of BookingCheckoutModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCheckoutModelCopyWith<BookingCheckoutModel> get copyWith => _$BookingCheckoutModelCopyWithImpl<BookingCheckoutModel>(this as BookingCheckoutModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingCheckoutModel&&(identical(other.booking, booking) || other.booking == booking)&&const DeepCollectionEquality().equals(other.checkout, checkout));
}


@override
int get hashCode => Object.hash(runtimeType,booking,const DeepCollectionEquality().hash(checkout));

@override
String toString() {
  return 'BookingCheckoutModel(booking: $booking, checkout: $checkout)';
}


}

/// @nodoc
abstract mixin class $BookingCheckoutModelCopyWith<$Res>  {
  factory $BookingCheckoutModelCopyWith(BookingCheckoutModel value, $Res Function(BookingCheckoutModel) _then) = _$BookingCheckoutModelCopyWithImpl;
@useResult
$Res call({
 BookingModel booking, Map<String, dynamic> checkout
});


$BookingModelCopyWith<$Res> get booking;

}
/// @nodoc
class _$BookingCheckoutModelCopyWithImpl<$Res>
    implements $BookingCheckoutModelCopyWith<$Res> {
  _$BookingCheckoutModelCopyWithImpl(this._self, this._then);

  final BookingCheckoutModel _self;
  final $Res Function(BookingCheckoutModel) _then;

/// Create a copy of BookingCheckoutModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? booking = null,Object? checkout = null,}) {
  return _then(_self.copyWith(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as BookingModel,checkout: null == checkout ? _self.checkout : checkout // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of BookingCheckoutModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingModelCopyWith<$Res> get booking {
  
  return $BookingModelCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingCheckoutModel].
extension BookingCheckoutModelPatterns on BookingCheckoutModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingCheckoutModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingCheckoutModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingCheckoutModel value)  $default,){
final _that = this;
switch (_that) {
case _BookingCheckoutModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingCheckoutModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookingCheckoutModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BookingModel booking,  Map<String, dynamic> checkout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingCheckoutModel() when $default != null:
return $default(_that.booking,_that.checkout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BookingModel booking,  Map<String, dynamic> checkout)  $default,) {final _that = this;
switch (_that) {
case _BookingCheckoutModel():
return $default(_that.booking,_that.checkout);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BookingModel booking,  Map<String, dynamic> checkout)?  $default,) {final _that = this;
switch (_that) {
case _BookingCheckoutModel() when $default != null:
return $default(_that.booking,_that.checkout);case _:
  return null;

}
}

}

/// @nodoc


class _BookingCheckoutModel implements BookingCheckoutModel {
  const _BookingCheckoutModel({required this.booking, required final  Map<String, dynamic> checkout}): _checkout = checkout;
  

@override final  BookingModel booking;
 final  Map<String, dynamic> _checkout;
@override Map<String, dynamic> get checkout {
  if (_checkout is EqualUnmodifiableMapView) return _checkout;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_checkout);
}


/// Create a copy of BookingCheckoutModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCheckoutModelCopyWith<_BookingCheckoutModel> get copyWith => __$BookingCheckoutModelCopyWithImpl<_BookingCheckoutModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingCheckoutModel&&(identical(other.booking, booking) || other.booking == booking)&&const DeepCollectionEquality().equals(other._checkout, _checkout));
}


@override
int get hashCode => Object.hash(runtimeType,booking,const DeepCollectionEquality().hash(_checkout));

@override
String toString() {
  return 'BookingCheckoutModel(booking: $booking, checkout: $checkout)';
}


}

/// @nodoc
abstract mixin class _$BookingCheckoutModelCopyWith<$Res> implements $BookingCheckoutModelCopyWith<$Res> {
  factory _$BookingCheckoutModelCopyWith(_BookingCheckoutModel value, $Res Function(_BookingCheckoutModel) _then) = __$BookingCheckoutModelCopyWithImpl;
@override @useResult
$Res call({
 BookingModel booking, Map<String, dynamic> checkout
});


@override $BookingModelCopyWith<$Res> get booking;

}
/// @nodoc
class __$BookingCheckoutModelCopyWithImpl<$Res>
    implements _$BookingCheckoutModelCopyWith<$Res> {
  __$BookingCheckoutModelCopyWithImpl(this._self, this._then);

  final _BookingCheckoutModel _self;
  final $Res Function(_BookingCheckoutModel) _then;

/// Create a copy of BookingCheckoutModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? booking = null,Object? checkout = null,}) {
  return _then(_BookingCheckoutModel(
booking: null == booking ? _self.booking : booking // ignore: cast_nullable_to_non_nullable
as BookingModel,checkout: null == checkout ? _self._checkout : checkout // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of BookingCheckoutModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingModelCopyWith<$Res> get booking {
  
  return $BookingModelCopyWith<$Res>(_self.booking, (value) {
    return _then(_self.copyWith(booking: value));
  });
}
}

// dart format on
