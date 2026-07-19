// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingUserEntity {

 String get id; String get fullName; String? get avatarUrl; String? get companyName;
/// Create a copy of BookingUserEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingUserEntityCopyWith<BookingUserEntity> get copyWith => _$BookingUserEntityCopyWithImpl<BookingUserEntity>(this as BookingUserEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingUserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,companyName);

@override
String toString() {
  return 'BookingUserEntity(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class $BookingUserEntityCopyWith<$Res>  {
  factory $BookingUserEntityCopyWith(BookingUserEntity value, $Res Function(BookingUserEntity) _then) = _$BookingUserEntityCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? companyName
});




}
/// @nodoc
class _$BookingUserEntityCopyWithImpl<$Res>
    implements $BookingUserEntityCopyWith<$Res> {
  _$BookingUserEntityCopyWithImpl(this._self, this._then);

  final BookingUserEntity _self;
  final $Res Function(BookingUserEntity) _then;

/// Create a copy of BookingUserEntity
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


/// Adds pattern-matching-related methods to [BookingUserEntity].
extension BookingUserEntityPatterns on BookingUserEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingUserEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingUserEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingUserEntity value)  $default,){
final _that = this;
switch (_that) {
case _BookingUserEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingUserEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BookingUserEntity() when $default != null:
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
case _BookingUserEntity() when $default != null:
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
case _BookingUserEntity():
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
case _BookingUserEntity() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.companyName);case _:
  return null;

}
}

}

/// @nodoc


class _BookingUserEntity implements BookingUserEntity {
  const _BookingUserEntity({required this.id, required this.fullName, this.avatarUrl, this.companyName});
  

@override final  String id;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String? companyName;

/// Create a copy of BookingUserEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingUserEntityCopyWith<_BookingUserEntity> get copyWith => __$BookingUserEntityCopyWithImpl<_BookingUserEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingUserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,companyName);

@override
String toString() {
  return 'BookingUserEntity(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class _$BookingUserEntityCopyWith<$Res> implements $BookingUserEntityCopyWith<$Res> {
  factory _$BookingUserEntityCopyWith(_BookingUserEntity value, $Res Function(_BookingUserEntity) _then) = __$BookingUserEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? companyName
});




}
/// @nodoc
class __$BookingUserEntityCopyWithImpl<$Res>
    implements _$BookingUserEntityCopyWith<$Res> {
  __$BookingUserEntityCopyWithImpl(this._self, this._then);

  final _BookingUserEntity _self;
  final $Res Function(_BookingUserEntity) _then;

/// Create a copy of BookingUserEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? companyName = freezed,}) {
  return _then(_BookingUserEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$BookingProductEntity {

 String get id; String get name; String? get thumbnailUrl; String get productMode; String get unit; double get stock; double get reservedStock; double get availableStock; double get pricePerUnit; String get availabilityType;
/// Create a copy of BookingProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingProductEntityCopyWith<BookingProductEntity> get copyWith => _$BookingProductEntityCopyWithImpl<BookingProductEntity>(this as BookingProductEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.reservedStock, reservedStock) || other.reservedStock == reservedStock)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.availabilityType, availabilityType) || other.availabilityType == availabilityType));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnailUrl,productMode,unit,stock,reservedStock,availableStock,pricePerUnit,availabilityType);

@override
String toString() {
  return 'BookingProductEntity(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, productMode: $productMode, unit: $unit, stock: $stock, reservedStock: $reservedStock, availableStock: $availableStock, pricePerUnit: $pricePerUnit, availabilityType: $availabilityType)';
}


}

/// @nodoc
abstract mixin class $BookingProductEntityCopyWith<$Res>  {
  factory $BookingProductEntityCopyWith(BookingProductEntity value, $Res Function(BookingProductEntity) _then) = _$BookingProductEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? thumbnailUrl, String productMode, String unit, double stock, double reservedStock, double availableStock, double pricePerUnit, String availabilityType
});




}
/// @nodoc
class _$BookingProductEntityCopyWithImpl<$Res>
    implements $BookingProductEntityCopyWith<$Res> {
  _$BookingProductEntityCopyWithImpl(this._self, this._then);

  final BookingProductEntity _self;
  final $Res Function(BookingProductEntity) _then;

/// Create a copy of BookingProductEntity
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


/// Adds pattern-matching-related methods to [BookingProductEntity].
extension BookingProductEntityPatterns on BookingProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _BookingProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BookingProductEntity() when $default != null:
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
case _BookingProductEntity() when $default != null:
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
case _BookingProductEntity():
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
case _BookingProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.thumbnailUrl,_that.productMode,_that.unit,_that.stock,_that.reservedStock,_that.availableStock,_that.pricePerUnit,_that.availabilityType);case _:
  return null;

}
}

}

/// @nodoc


class _BookingProductEntity implements BookingProductEntity {
  const _BookingProductEntity({required this.id, required this.name, this.thumbnailUrl, required this.productMode, required this.unit, required this.stock, this.reservedStock = 0, required this.availableStock, required this.pricePerUnit, required this.availabilityType});
  

@override final  String id;
@override final  String name;
@override final  String? thumbnailUrl;
@override final  String productMode;
@override final  String unit;
@override final  double stock;
@override@JsonKey() final  double reservedStock;
@override final  double availableStock;
@override final  double pricePerUnit;
@override final  String availabilityType;

/// Create a copy of BookingProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingProductEntityCopyWith<_BookingProductEntity> get copyWith => __$BookingProductEntityCopyWithImpl<_BookingProductEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.reservedStock, reservedStock) || other.reservedStock == reservedStock)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.availabilityType, availabilityType) || other.availabilityType == availabilityType));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnailUrl,productMode,unit,stock,reservedStock,availableStock,pricePerUnit,availabilityType);

@override
String toString() {
  return 'BookingProductEntity(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, productMode: $productMode, unit: $unit, stock: $stock, reservedStock: $reservedStock, availableStock: $availableStock, pricePerUnit: $pricePerUnit, availabilityType: $availabilityType)';
}


}

/// @nodoc
abstract mixin class _$BookingProductEntityCopyWith<$Res> implements $BookingProductEntityCopyWith<$Res> {
  factory _$BookingProductEntityCopyWith(_BookingProductEntity value, $Res Function(_BookingProductEntity) _then) = __$BookingProductEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? thumbnailUrl, String productMode, String unit, double stock, double reservedStock, double availableStock, double pricePerUnit, String availabilityType
});




}
/// @nodoc
class __$BookingProductEntityCopyWithImpl<$Res>
    implements _$BookingProductEntityCopyWith<$Res> {
  __$BookingProductEntityCopyWithImpl(this._self, this._then);

  final _BookingProductEntity _self;
  final $Res Function(_BookingProductEntity) _then;

/// Create a copy of BookingProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? thumbnailUrl = freezed,Object? productMode = null,Object? unit = null,Object? stock = null,Object? reservedStock = null,Object? availableStock = null,Object? pricePerUnit = null,Object? availabilityType = null,}) {
  return _then(_BookingProductEntity(
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
mixin _$BookingHarvestLotEntity {

 String get id; String? get seasonLabel; DateTime get expectedHarvestDate; double get expectedQuantityTon; double get reservedQuantityTon; double get availableQuantityTon; String get status;
/// Create a copy of BookingHarvestLotEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingHarvestLotEntityCopyWith<BookingHarvestLotEntity> get copyWith => _$BookingHarvestLotEntityCopyWithImpl<BookingHarvestLotEntity>(this as BookingHarvestLotEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingHarvestLotEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonLabel, seasonLabel) || other.seasonLabel == seasonLabel)&&(identical(other.expectedHarvestDate, expectedHarvestDate) || other.expectedHarvestDate == expectedHarvestDate)&&(identical(other.expectedQuantityTon, expectedQuantityTon) || other.expectedQuantityTon == expectedQuantityTon)&&(identical(other.reservedQuantityTon, reservedQuantityTon) || other.reservedQuantityTon == reservedQuantityTon)&&(identical(other.availableQuantityTon, availableQuantityTon) || other.availableQuantityTon == availableQuantityTon)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,seasonLabel,expectedHarvestDate,expectedQuantityTon,reservedQuantityTon,availableQuantityTon,status);

@override
String toString() {
  return 'BookingHarvestLotEntity(id: $id, seasonLabel: $seasonLabel, expectedHarvestDate: $expectedHarvestDate, expectedQuantityTon: $expectedQuantityTon, reservedQuantityTon: $reservedQuantityTon, availableQuantityTon: $availableQuantityTon, status: $status)';
}


}

/// @nodoc
abstract mixin class $BookingHarvestLotEntityCopyWith<$Res>  {
  factory $BookingHarvestLotEntityCopyWith(BookingHarvestLotEntity value, $Res Function(BookingHarvestLotEntity) _then) = _$BookingHarvestLotEntityCopyWithImpl;
@useResult
$Res call({
 String id, String? seasonLabel, DateTime expectedHarvestDate, double expectedQuantityTon, double reservedQuantityTon, double availableQuantityTon, String status
});




}
/// @nodoc
class _$BookingHarvestLotEntityCopyWithImpl<$Res>
    implements $BookingHarvestLotEntityCopyWith<$Res> {
  _$BookingHarvestLotEntityCopyWithImpl(this._self, this._then);

  final BookingHarvestLotEntity _self;
  final $Res Function(BookingHarvestLotEntity) _then;

/// Create a copy of BookingHarvestLotEntity
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


/// Adds pattern-matching-related methods to [BookingHarvestLotEntity].
extension BookingHarvestLotEntityPatterns on BookingHarvestLotEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingHarvestLotEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingHarvestLotEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingHarvestLotEntity value)  $default,){
final _that = this;
switch (_that) {
case _BookingHarvestLotEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingHarvestLotEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BookingHarvestLotEntity() when $default != null:
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
case _BookingHarvestLotEntity() when $default != null:
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
case _BookingHarvestLotEntity():
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
case _BookingHarvestLotEntity() when $default != null:
return $default(_that.id,_that.seasonLabel,_that.expectedHarvestDate,_that.expectedQuantityTon,_that.reservedQuantityTon,_that.availableQuantityTon,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BookingHarvestLotEntity implements BookingHarvestLotEntity {
  const _BookingHarvestLotEntity({required this.id, this.seasonLabel, required this.expectedHarvestDate, required this.expectedQuantityTon, this.reservedQuantityTon = 0, required this.availableQuantityTon, required this.status});
  

@override final  String id;
@override final  String? seasonLabel;
@override final  DateTime expectedHarvestDate;
@override final  double expectedQuantityTon;
@override@JsonKey() final  double reservedQuantityTon;
@override final  double availableQuantityTon;
@override final  String status;

/// Create a copy of BookingHarvestLotEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingHarvestLotEntityCopyWith<_BookingHarvestLotEntity> get copyWith => __$BookingHarvestLotEntityCopyWithImpl<_BookingHarvestLotEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingHarvestLotEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.seasonLabel, seasonLabel) || other.seasonLabel == seasonLabel)&&(identical(other.expectedHarvestDate, expectedHarvestDate) || other.expectedHarvestDate == expectedHarvestDate)&&(identical(other.expectedQuantityTon, expectedQuantityTon) || other.expectedQuantityTon == expectedQuantityTon)&&(identical(other.reservedQuantityTon, reservedQuantityTon) || other.reservedQuantityTon == reservedQuantityTon)&&(identical(other.availableQuantityTon, availableQuantityTon) || other.availableQuantityTon == availableQuantityTon)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,seasonLabel,expectedHarvestDate,expectedQuantityTon,reservedQuantityTon,availableQuantityTon,status);

@override
String toString() {
  return 'BookingHarvestLotEntity(id: $id, seasonLabel: $seasonLabel, expectedHarvestDate: $expectedHarvestDate, expectedQuantityTon: $expectedQuantityTon, reservedQuantityTon: $reservedQuantityTon, availableQuantityTon: $availableQuantityTon, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BookingHarvestLotEntityCopyWith<$Res> implements $BookingHarvestLotEntityCopyWith<$Res> {
  factory _$BookingHarvestLotEntityCopyWith(_BookingHarvestLotEntity value, $Res Function(_BookingHarvestLotEntity) _then) = __$BookingHarvestLotEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String? seasonLabel, DateTime expectedHarvestDate, double expectedQuantityTon, double reservedQuantityTon, double availableQuantityTon, String status
});




}
/// @nodoc
class __$BookingHarvestLotEntityCopyWithImpl<$Res>
    implements _$BookingHarvestLotEntityCopyWith<$Res> {
  __$BookingHarvestLotEntityCopyWithImpl(this._self, this._then);

  final _BookingHarvestLotEntity _self;
  final $Res Function(_BookingHarvestLotEntity) _then;

/// Create a copy of BookingHarvestLotEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seasonLabel = freezed,Object? expectedHarvestDate = null,Object? expectedQuantityTon = null,Object? reservedQuantityTon = null,Object? availableQuantityTon = null,Object? status = null,}) {
  return _then(_BookingHarvestLotEntity(
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
mixin _$BookingOrderRefEntity {

 String get id; String get orderNumber; String get status;
/// Create a copy of BookingOrderRefEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingOrderRefEntityCopyWith<BookingOrderRefEntity> get copyWith => _$BookingOrderRefEntityCopyWithImpl<BookingOrderRefEntity>(this as BookingOrderRefEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingOrderRefEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status);

@override
String toString() {
  return 'BookingOrderRefEntity(id: $id, orderNumber: $orderNumber, status: $status)';
}


}

/// @nodoc
abstract mixin class $BookingOrderRefEntityCopyWith<$Res>  {
  factory $BookingOrderRefEntityCopyWith(BookingOrderRefEntity value, $Res Function(BookingOrderRefEntity) _then) = _$BookingOrderRefEntityCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String status
});




}
/// @nodoc
class _$BookingOrderRefEntityCopyWithImpl<$Res>
    implements $BookingOrderRefEntityCopyWith<$Res> {
  _$BookingOrderRefEntityCopyWithImpl(this._self, this._then);

  final BookingOrderRefEntity _self;
  final $Res Function(BookingOrderRefEntity) _then;

/// Create a copy of BookingOrderRefEntity
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


/// Adds pattern-matching-related methods to [BookingOrderRefEntity].
extension BookingOrderRefEntityPatterns on BookingOrderRefEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingOrderRefEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingOrderRefEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingOrderRefEntity value)  $default,){
final _that = this;
switch (_that) {
case _BookingOrderRefEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingOrderRefEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BookingOrderRefEntity() when $default != null:
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
case _BookingOrderRefEntity() when $default != null:
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
case _BookingOrderRefEntity():
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
case _BookingOrderRefEntity() when $default != null:
return $default(_that.id,_that.orderNumber,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BookingOrderRefEntity implements BookingOrderRefEntity {
  const _BookingOrderRefEntity({required this.id, required this.orderNumber, required this.status});
  

@override final  String id;
@override final  String orderNumber;
@override final  String status;

/// Create a copy of BookingOrderRefEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingOrderRefEntityCopyWith<_BookingOrderRefEntity> get copyWith => __$BookingOrderRefEntityCopyWithImpl<_BookingOrderRefEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingOrderRefEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,orderNumber,status);

@override
String toString() {
  return 'BookingOrderRefEntity(id: $id, orderNumber: $orderNumber, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BookingOrderRefEntityCopyWith<$Res> implements $BookingOrderRefEntityCopyWith<$Res> {
  factory _$BookingOrderRefEntityCopyWith(_BookingOrderRefEntity value, $Res Function(_BookingOrderRefEntity) _then) = __$BookingOrderRefEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String status
});




}
/// @nodoc
class __$BookingOrderRefEntityCopyWithImpl<$Res>
    implements _$BookingOrderRefEntityCopyWith<$Res> {
  __$BookingOrderRefEntityCopyWithImpl(this._self, this._then);

  final _BookingOrderRefEntity _self;
  final $Res Function(_BookingOrderRefEntity) _then;

/// Create a copy of BookingOrderRefEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? status = null,}) {
  return _then(_BookingOrderRefEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BookingEntity {

 String get id; String get bookingNumber; String get buyerId; String get supplierId; String get productId; String? get harvestLotId; String get productMode; double get quantity; String get unit; double get priceSnapshot; double get subtotalSnapshot; String get status; DateTime get expiresAt; DateTime? get expectedDeliveryDate; String? get notes; String? get orderId; DateTime? get confirmedAt; bool get isExpired; DateTime get createdAt; BookingUserEntity get buyer; BookingUserEntity get supplier; BookingProductEntity get product; BookingHarvestLotEntity? get harvestLot; BookingOrderRefEntity? get order;
/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingEntityCopyWith<BookingEntity> get copyWith => _$BookingEntityCopyWithImpl<BookingEntity>(this as BookingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingNumber, bookingNumber) || other.bookingNumber == bookingNumber)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.harvestLotId, harvestLotId) || other.harvestLotId == harvestLotId)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.priceSnapshot, priceSnapshot) || other.priceSnapshot == priceSnapshot)&&(identical(other.subtotalSnapshot, subtotalSnapshot) || other.subtotalSnapshot == subtotalSnapshot)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expectedDeliveryDate, expectedDeliveryDate) || other.expectedDeliveryDate == expectedDeliveryDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.supplier, supplier) || other.supplier == supplier)&&(identical(other.product, product) || other.product == product)&&(identical(other.harvestLot, harvestLot) || other.harvestLot == harvestLot)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,bookingNumber,buyerId,supplierId,productId,harvestLotId,productMode,quantity,unit,priceSnapshot,subtotalSnapshot,status,expiresAt,expectedDeliveryDate,notes,orderId,confirmedAt,isExpired,createdAt,buyer,supplier,product,harvestLot,order]);

@override
String toString() {
  return 'BookingEntity(id: $id, bookingNumber: $bookingNumber, buyerId: $buyerId, supplierId: $supplierId, productId: $productId, harvestLotId: $harvestLotId, productMode: $productMode, quantity: $quantity, unit: $unit, priceSnapshot: $priceSnapshot, subtotalSnapshot: $subtotalSnapshot, status: $status, expiresAt: $expiresAt, expectedDeliveryDate: $expectedDeliveryDate, notes: $notes, orderId: $orderId, confirmedAt: $confirmedAt, isExpired: $isExpired, createdAt: $createdAt, buyer: $buyer, supplier: $supplier, product: $product, harvestLot: $harvestLot, order: $order)';
}


}

/// @nodoc
abstract mixin class $BookingEntityCopyWith<$Res>  {
  factory $BookingEntityCopyWith(BookingEntity value, $Res Function(BookingEntity) _then) = _$BookingEntityCopyWithImpl;
@useResult
$Res call({
 String id, String bookingNumber, String buyerId, String supplierId, String productId, String? harvestLotId, String productMode, double quantity, String unit, double priceSnapshot, double subtotalSnapshot, String status, DateTime expiresAt, DateTime? expectedDeliveryDate, String? notes, String? orderId, DateTime? confirmedAt, bool isExpired, DateTime createdAt, BookingUserEntity buyer, BookingUserEntity supplier, BookingProductEntity product, BookingHarvestLotEntity? harvestLot, BookingOrderRefEntity? order
});


$BookingUserEntityCopyWith<$Res> get buyer;$BookingUserEntityCopyWith<$Res> get supplier;$BookingProductEntityCopyWith<$Res> get product;$BookingHarvestLotEntityCopyWith<$Res>? get harvestLot;$BookingOrderRefEntityCopyWith<$Res>? get order;

}
/// @nodoc
class _$BookingEntityCopyWithImpl<$Res>
    implements $BookingEntityCopyWith<$Res> {
  _$BookingEntityCopyWithImpl(this._self, this._then);

  final BookingEntity _self;
  final $Res Function(BookingEntity) _then;

/// Create a copy of BookingEntity
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
as BookingUserEntity,supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as BookingUserEntity,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as BookingProductEntity,harvestLot: freezed == harvestLot ? _self.harvestLot : harvestLot // ignore: cast_nullable_to_non_nullable
as BookingHarvestLotEntity?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as BookingOrderRefEntity?,
  ));
}
/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUserEntityCopyWith<$Res> get buyer {
  
  return $BookingUserEntityCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUserEntityCopyWith<$Res> get supplier {
  
  return $BookingUserEntityCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingProductEntityCopyWith<$Res> get product {
  
  return $BookingProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingHarvestLotEntityCopyWith<$Res>? get harvestLot {
    if (_self.harvestLot == null) {
    return null;
  }

  return $BookingHarvestLotEntityCopyWith<$Res>(_self.harvestLot!, (value) {
    return _then(_self.copyWith(harvestLot: value));
  });
}/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingOrderRefEntityCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $BookingOrderRefEntityCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingEntity].
extension BookingEntityPatterns on BookingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingEntity value)  $default,){
final _that = this;
switch (_that) {
case _BookingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BookingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookingNumber,  String buyerId,  String supplierId,  String productId,  String? harvestLotId,  String productMode,  double quantity,  String unit,  double priceSnapshot,  double subtotalSnapshot,  String status,  DateTime expiresAt,  DateTime? expectedDeliveryDate,  String? notes,  String? orderId,  DateTime? confirmedAt,  bool isExpired,  DateTime createdAt,  BookingUserEntity buyer,  BookingUserEntity supplier,  BookingProductEntity product,  BookingHarvestLotEntity? harvestLot,  BookingOrderRefEntity? order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookingNumber,  String buyerId,  String supplierId,  String productId,  String? harvestLotId,  String productMode,  double quantity,  String unit,  double priceSnapshot,  double subtotalSnapshot,  String status,  DateTime expiresAt,  DateTime? expectedDeliveryDate,  String? notes,  String? orderId,  DateTime? confirmedAt,  bool isExpired,  DateTime createdAt,  BookingUserEntity buyer,  BookingUserEntity supplier,  BookingProductEntity product,  BookingHarvestLotEntity? harvestLot,  BookingOrderRefEntity? order)  $default,) {final _that = this;
switch (_that) {
case _BookingEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookingNumber,  String buyerId,  String supplierId,  String productId,  String? harvestLotId,  String productMode,  double quantity,  String unit,  double priceSnapshot,  double subtotalSnapshot,  String status,  DateTime expiresAt,  DateTime? expectedDeliveryDate,  String? notes,  String? orderId,  DateTime? confirmedAt,  bool isExpired,  DateTime createdAt,  BookingUserEntity buyer,  BookingUserEntity supplier,  BookingProductEntity product,  BookingHarvestLotEntity? harvestLot,  BookingOrderRefEntity? order)?  $default,) {final _that = this;
switch (_that) {
case _BookingEntity() when $default != null:
return $default(_that.id,_that.bookingNumber,_that.buyerId,_that.supplierId,_that.productId,_that.harvestLotId,_that.productMode,_that.quantity,_that.unit,_that.priceSnapshot,_that.subtotalSnapshot,_that.status,_that.expiresAt,_that.expectedDeliveryDate,_that.notes,_that.orderId,_that.confirmedAt,_that.isExpired,_that.createdAt,_that.buyer,_that.supplier,_that.product,_that.harvestLot,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _BookingEntity extends BookingEntity {
  const _BookingEntity({required this.id, required this.bookingNumber, required this.buyerId, required this.supplierId, required this.productId, this.harvestLotId, required this.productMode, required this.quantity, required this.unit, required this.priceSnapshot, required this.subtotalSnapshot, required this.status, required this.expiresAt, this.expectedDeliveryDate, this.notes, this.orderId, this.confirmedAt, this.isExpired = false, required this.createdAt, required this.buyer, required this.supplier, required this.product, this.harvestLot, this.order}): super._();
  

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
@override final  BookingUserEntity buyer;
@override final  BookingUserEntity supplier;
@override final  BookingProductEntity product;
@override final  BookingHarvestLotEntity? harvestLot;
@override final  BookingOrderRefEntity? order;

/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingEntityCopyWith<_BookingEntity> get copyWith => __$BookingEntityCopyWithImpl<_BookingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bookingNumber, bookingNumber) || other.bookingNumber == bookingNumber)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.harvestLotId, harvestLotId) || other.harvestLotId == harvestLotId)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.priceSnapshot, priceSnapshot) || other.priceSnapshot == priceSnapshot)&&(identical(other.subtotalSnapshot, subtotalSnapshot) || other.subtotalSnapshot == subtotalSnapshot)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.expectedDeliveryDate, expectedDeliveryDate) || other.expectedDeliveryDate == expectedDeliveryDate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.supplier, supplier) || other.supplier == supplier)&&(identical(other.product, product) || other.product == product)&&(identical(other.harvestLot, harvestLot) || other.harvestLot == harvestLot)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,bookingNumber,buyerId,supplierId,productId,harvestLotId,productMode,quantity,unit,priceSnapshot,subtotalSnapshot,status,expiresAt,expectedDeliveryDate,notes,orderId,confirmedAt,isExpired,createdAt,buyer,supplier,product,harvestLot,order]);

@override
String toString() {
  return 'BookingEntity(id: $id, bookingNumber: $bookingNumber, buyerId: $buyerId, supplierId: $supplierId, productId: $productId, harvestLotId: $harvestLotId, productMode: $productMode, quantity: $quantity, unit: $unit, priceSnapshot: $priceSnapshot, subtotalSnapshot: $subtotalSnapshot, status: $status, expiresAt: $expiresAt, expectedDeliveryDate: $expectedDeliveryDate, notes: $notes, orderId: $orderId, confirmedAt: $confirmedAt, isExpired: $isExpired, createdAt: $createdAt, buyer: $buyer, supplier: $supplier, product: $product, harvestLot: $harvestLot, order: $order)';
}


}

/// @nodoc
abstract mixin class _$BookingEntityCopyWith<$Res> implements $BookingEntityCopyWith<$Res> {
  factory _$BookingEntityCopyWith(_BookingEntity value, $Res Function(_BookingEntity) _then) = __$BookingEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookingNumber, String buyerId, String supplierId, String productId, String? harvestLotId, String productMode, double quantity, String unit, double priceSnapshot, double subtotalSnapshot, String status, DateTime expiresAt, DateTime? expectedDeliveryDate, String? notes, String? orderId, DateTime? confirmedAt, bool isExpired, DateTime createdAt, BookingUserEntity buyer, BookingUserEntity supplier, BookingProductEntity product, BookingHarvestLotEntity? harvestLot, BookingOrderRefEntity? order
});


@override $BookingUserEntityCopyWith<$Res> get buyer;@override $BookingUserEntityCopyWith<$Res> get supplier;@override $BookingProductEntityCopyWith<$Res> get product;@override $BookingHarvestLotEntityCopyWith<$Res>? get harvestLot;@override $BookingOrderRefEntityCopyWith<$Res>? get order;

}
/// @nodoc
class __$BookingEntityCopyWithImpl<$Res>
    implements _$BookingEntityCopyWith<$Res> {
  __$BookingEntityCopyWithImpl(this._self, this._then);

  final _BookingEntity _self;
  final $Res Function(_BookingEntity) _then;

/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookingNumber = null,Object? buyerId = null,Object? supplierId = null,Object? productId = null,Object? harvestLotId = freezed,Object? productMode = null,Object? quantity = null,Object? unit = null,Object? priceSnapshot = null,Object? subtotalSnapshot = null,Object? status = null,Object? expiresAt = null,Object? expectedDeliveryDate = freezed,Object? notes = freezed,Object? orderId = freezed,Object? confirmedAt = freezed,Object? isExpired = null,Object? createdAt = null,Object? buyer = null,Object? supplier = null,Object? product = null,Object? harvestLot = freezed,Object? order = freezed,}) {
  return _then(_BookingEntity(
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
as BookingUserEntity,supplier: null == supplier ? _self.supplier : supplier // ignore: cast_nullable_to_non_nullable
as BookingUserEntity,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as BookingProductEntity,harvestLot: freezed == harvestLot ? _self.harvestLot : harvestLot // ignore: cast_nullable_to_non_nullable
as BookingHarvestLotEntity?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as BookingOrderRefEntity?,
  ));
}

/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUserEntityCopyWith<$Res> get buyer {
  
  return $BookingUserEntityCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingUserEntityCopyWith<$Res> get supplier {
  
  return $BookingUserEntityCopyWith<$Res>(_self.supplier, (value) {
    return _then(_self.copyWith(supplier: value));
  });
}/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingProductEntityCopyWith<$Res> get product {
  
  return $BookingProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingHarvestLotEntityCopyWith<$Res>? get harvestLot {
    if (_self.harvestLot == null) {
    return null;
  }

  return $BookingHarvestLotEntityCopyWith<$Res>(_self.harvestLot!, (value) {
    return _then(_self.copyWith(harvestLot: value));
  });
}/// Create a copy of BookingEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookingOrderRefEntityCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $BookingOrderRefEntityCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

// dart format on
