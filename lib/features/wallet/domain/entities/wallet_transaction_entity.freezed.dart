// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_transaction_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletTransactionEntity {

 String get id; double get amount; double get sellerAmount; double get platformFee; WalletTransactionStatus get status; WalletTransactionType get type; String? get externalId; DateTime? get paidAt; DateTime? get escrowReleasedAt; DateTime get createdAt; String? get orderNumber; String? get paymentMethod;
/// Create a copy of WalletTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTransactionEntityCopyWith<WalletTransactionEntity> get copyWith => _$WalletTransactionEntityCopyWithImpl<WalletTransactionEntity>(this as WalletTransactionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sellerAmount, sellerAmount) || other.sellerAmount == sellerAmount)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.escrowReleasedAt, escrowReleasedAt) || other.escrowReleasedAt == escrowReleasedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}


@override
int get hashCode => Object.hash(runtimeType,id,amount,sellerAmount,platformFee,status,type,externalId,paidAt,escrowReleasedAt,createdAt,orderNumber,paymentMethod);

@override
String toString() {
  return 'WalletTransactionEntity(id: $id, amount: $amount, sellerAmount: $sellerAmount, platformFee: $platformFee, status: $status, type: $type, externalId: $externalId, paidAt: $paidAt, escrowReleasedAt: $escrowReleasedAt, createdAt: $createdAt, orderNumber: $orderNumber, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class $WalletTransactionEntityCopyWith<$Res>  {
  factory $WalletTransactionEntityCopyWith(WalletTransactionEntity value, $Res Function(WalletTransactionEntity) _then) = _$WalletTransactionEntityCopyWithImpl;
@useResult
$Res call({
 String id, double amount, double sellerAmount, double platformFee, WalletTransactionStatus status, WalletTransactionType type, String? externalId, DateTime? paidAt, DateTime? escrowReleasedAt, DateTime createdAt, String? orderNumber, String? paymentMethod
});




}
/// @nodoc
class _$WalletTransactionEntityCopyWithImpl<$Res>
    implements $WalletTransactionEntityCopyWith<$Res> {
  _$WalletTransactionEntityCopyWithImpl(this._self, this._then);

  final WalletTransactionEntity _self;
  final $Res Function(WalletTransactionEntity) _then;

/// Create a copy of WalletTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? sellerAmount = null,Object? platformFee = null,Object? status = null,Object? type = null,Object? externalId = freezed,Object? paidAt = freezed,Object? escrowReleasedAt = freezed,Object? createdAt = null,Object? orderNumber = freezed,Object? paymentMethod = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,sellerAmount: null == sellerAmount ? _self.sellerAmount : sellerAmount // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WalletTransactionStatus,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletTransactionType,externalId: freezed == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,escrowReleasedAt: freezed == escrowReleasedAt ? _self.escrowReleasedAt : escrowReleasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,orderNumber: freezed == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletTransactionEntity].
extension WalletTransactionEntityPatterns on WalletTransactionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTransactionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTransactionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTransactionEntity value)  $default,){
final _that = this;
switch (_that) {
case _WalletTransactionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTransactionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTransactionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double amount,  double sellerAmount,  double platformFee,  WalletTransactionStatus status,  WalletTransactionType type,  String? externalId,  DateTime? paidAt,  DateTime? escrowReleasedAt,  DateTime createdAt,  String? orderNumber,  String? paymentMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTransactionEntity() when $default != null:
return $default(_that.id,_that.amount,_that.sellerAmount,_that.platformFee,_that.status,_that.type,_that.externalId,_that.paidAt,_that.escrowReleasedAt,_that.createdAt,_that.orderNumber,_that.paymentMethod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double amount,  double sellerAmount,  double platformFee,  WalletTransactionStatus status,  WalletTransactionType type,  String? externalId,  DateTime? paidAt,  DateTime? escrowReleasedAt,  DateTime createdAt,  String? orderNumber,  String? paymentMethod)  $default,) {final _that = this;
switch (_that) {
case _WalletTransactionEntity():
return $default(_that.id,_that.amount,_that.sellerAmount,_that.platformFee,_that.status,_that.type,_that.externalId,_that.paidAt,_that.escrowReleasedAt,_that.createdAt,_that.orderNumber,_that.paymentMethod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double amount,  double sellerAmount,  double platformFee,  WalletTransactionStatus status,  WalletTransactionType type,  String? externalId,  DateTime? paidAt,  DateTime? escrowReleasedAt,  DateTime createdAt,  String? orderNumber,  String? paymentMethod)?  $default,) {final _that = this;
switch (_that) {
case _WalletTransactionEntity() when $default != null:
return $default(_that.id,_that.amount,_that.sellerAmount,_that.platformFee,_that.status,_that.type,_that.externalId,_that.paidAt,_that.escrowReleasedAt,_that.createdAt,_that.orderNumber,_that.paymentMethod);case _:
  return null;

}
}

}

/// @nodoc


class _WalletTransactionEntity implements WalletTransactionEntity {
  const _WalletTransactionEntity({required this.id, required this.amount, required this.sellerAmount, required this.platformFee, required this.status, required this.type, this.externalId, this.paidAt, this.escrowReleasedAt, required this.createdAt, this.orderNumber, this.paymentMethod});
  

@override final  String id;
@override final  double amount;
@override final  double sellerAmount;
@override final  double platformFee;
@override final  WalletTransactionStatus status;
@override final  WalletTransactionType type;
@override final  String? externalId;
@override final  DateTime? paidAt;
@override final  DateTime? escrowReleasedAt;
@override final  DateTime createdAt;
@override final  String? orderNumber;
@override final  String? paymentMethod;

/// Create a copy of WalletTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTransactionEntityCopyWith<_WalletTransactionEntity> get copyWith => __$WalletTransactionEntityCopyWithImpl<_WalletTransactionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTransactionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sellerAmount, sellerAmount) || other.sellerAmount == sellerAmount)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.escrowReleasedAt, escrowReleasedAt) || other.escrowReleasedAt == escrowReleasedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}


@override
int get hashCode => Object.hash(runtimeType,id,amount,sellerAmount,platformFee,status,type,externalId,paidAt,escrowReleasedAt,createdAt,orderNumber,paymentMethod);

@override
String toString() {
  return 'WalletTransactionEntity(id: $id, amount: $amount, sellerAmount: $sellerAmount, platformFee: $platformFee, status: $status, type: $type, externalId: $externalId, paidAt: $paidAt, escrowReleasedAt: $escrowReleasedAt, createdAt: $createdAt, orderNumber: $orderNumber, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class _$WalletTransactionEntityCopyWith<$Res> implements $WalletTransactionEntityCopyWith<$Res> {
  factory _$WalletTransactionEntityCopyWith(_WalletTransactionEntity value, $Res Function(_WalletTransactionEntity) _then) = __$WalletTransactionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, double amount, double sellerAmount, double platformFee, WalletTransactionStatus status, WalletTransactionType type, String? externalId, DateTime? paidAt, DateTime? escrowReleasedAt, DateTime createdAt, String? orderNumber, String? paymentMethod
});




}
/// @nodoc
class __$WalletTransactionEntityCopyWithImpl<$Res>
    implements _$WalletTransactionEntityCopyWith<$Res> {
  __$WalletTransactionEntityCopyWithImpl(this._self, this._then);

  final _WalletTransactionEntity _self;
  final $Res Function(_WalletTransactionEntity) _then;

/// Create a copy of WalletTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? sellerAmount = null,Object? platformFee = null,Object? status = null,Object? type = null,Object? externalId = freezed,Object? paidAt = freezed,Object? escrowReleasedAt = freezed,Object? createdAt = null,Object? orderNumber = freezed,Object? paymentMethod = freezed,}) {
  return _then(_WalletTransactionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,sellerAmount: null == sellerAmount ? _self.sellerAmount : sellerAmount // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WalletTransactionStatus,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WalletTransactionType,externalId: freezed == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,escrowReleasedAt: freezed == escrowReleasedAt ? _self.escrowReleasedAt : escrowReleasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,orderNumber: freezed == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
