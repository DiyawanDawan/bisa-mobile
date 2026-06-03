// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WalletTransactionModel {

 String get id; double get amount; double get sellerAmount; double get platformFee; String get status; String get type; String? get externalId; DateTime? get paidAt; DateTime? get escrowReleasedAt; DateTime get createdAt; Map<String, dynamic>? get order; String? get paymentMethod;
/// Create a copy of WalletTransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletTransactionModelCopyWith<WalletTransactionModel> get copyWith => _$WalletTransactionModelCopyWithImpl<WalletTransactionModel>(this as WalletTransactionModel, _$identity);

  /// Serializes this WalletTransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sellerAmount, sellerAmount) || other.sellerAmount == sellerAmount)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.escrowReleasedAt, escrowReleasedAt) || other.escrowReleasedAt == escrowReleasedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.order, order)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,sellerAmount,platformFee,status,type,externalId,paidAt,escrowReleasedAt,createdAt,const DeepCollectionEquality().hash(order),paymentMethod);

@override
String toString() {
  return 'WalletTransactionModel(id: $id, amount: $amount, sellerAmount: $sellerAmount, platformFee: $platformFee, status: $status, type: $type, externalId: $externalId, paidAt: $paidAt, escrowReleasedAt: $escrowReleasedAt, createdAt: $createdAt, order: $order, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class $WalletTransactionModelCopyWith<$Res>  {
  factory $WalletTransactionModelCopyWith(WalletTransactionModel value, $Res Function(WalletTransactionModel) _then) = _$WalletTransactionModelCopyWithImpl;
@useResult
$Res call({
 String id, double amount, double sellerAmount, double platformFee, String status, String type, String? externalId, DateTime? paidAt, DateTime? escrowReleasedAt, DateTime createdAt, Map<String, dynamic>? order, String? paymentMethod
});




}
/// @nodoc
class _$WalletTransactionModelCopyWithImpl<$Res>
    implements $WalletTransactionModelCopyWith<$Res> {
  _$WalletTransactionModelCopyWithImpl(this._self, this._then);

  final WalletTransactionModel _self;
  final $Res Function(WalletTransactionModel) _then;

/// Create a copy of WalletTransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? sellerAmount = null,Object? platformFee = null,Object? status = null,Object? type = null,Object? externalId = freezed,Object? paidAt = freezed,Object? escrowReleasedAt = freezed,Object? createdAt = null,Object? order = freezed,Object? paymentMethod = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,sellerAmount: null == sellerAmount ? _self.sellerAmount : sellerAmount // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,externalId: freezed == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,escrowReleasedAt: freezed == escrowReleasedAt ? _self.escrowReleasedAt : escrowReleasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletTransactionModel].
extension WalletTransactionModelPatterns on WalletTransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletTransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletTransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletTransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _WalletTransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletTransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _WalletTransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double amount,  double sellerAmount,  double platformFee,  String status,  String type,  String? externalId,  DateTime? paidAt,  DateTime? escrowReleasedAt,  DateTime createdAt,  Map<String, dynamic>? order,  String? paymentMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletTransactionModel() when $default != null:
return $default(_that.id,_that.amount,_that.sellerAmount,_that.platformFee,_that.status,_that.type,_that.externalId,_that.paidAt,_that.escrowReleasedAt,_that.createdAt,_that.order,_that.paymentMethod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double amount,  double sellerAmount,  double platformFee,  String status,  String type,  String? externalId,  DateTime? paidAt,  DateTime? escrowReleasedAt,  DateTime createdAt,  Map<String, dynamic>? order,  String? paymentMethod)  $default,) {final _that = this;
switch (_that) {
case _WalletTransactionModel():
return $default(_that.id,_that.amount,_that.sellerAmount,_that.platformFee,_that.status,_that.type,_that.externalId,_that.paidAt,_that.escrowReleasedAt,_that.createdAt,_that.order,_that.paymentMethod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double amount,  double sellerAmount,  double platformFee,  String status,  String type,  String? externalId,  DateTime? paidAt,  DateTime? escrowReleasedAt,  DateTime createdAt,  Map<String, dynamic>? order,  String? paymentMethod)?  $default,) {final _that = this;
switch (_that) {
case _WalletTransactionModel() when $default != null:
return $default(_that.id,_that.amount,_that.sellerAmount,_that.platformFee,_that.status,_that.type,_that.externalId,_that.paidAt,_that.escrowReleasedAt,_that.createdAt,_that.order,_that.paymentMethod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WalletTransactionModel extends WalletTransactionModel {
  const _WalletTransactionModel({this.id = '', this.amount = 0.0, this.sellerAmount = 0.0, this.platformFee = 0.0, this.status = 'PENDING', this.type = 'UNKNOWN', this.externalId, this.paidAt, this.escrowReleasedAt, required this.createdAt, final  Map<String, dynamic>? order, this.paymentMethod}): _order = order,super._();
  factory _WalletTransactionModel.fromJson(Map<String, dynamic> json) => _$WalletTransactionModelFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  double amount;
@override@JsonKey() final  double sellerAmount;
@override@JsonKey() final  double platformFee;
@override@JsonKey() final  String status;
@override@JsonKey() final  String type;
@override final  String? externalId;
@override final  DateTime? paidAt;
@override final  DateTime? escrowReleasedAt;
@override final  DateTime createdAt;
 final  Map<String, dynamic>? _order;
@override Map<String, dynamic>? get order {
  final value = _order;
  if (value == null) return null;
  if (_order is EqualUnmodifiableMapView) return _order;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? paymentMethod;

/// Create a copy of WalletTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletTransactionModelCopyWith<_WalletTransactionModel> get copyWith => __$WalletTransactionModelCopyWithImpl<_WalletTransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WalletTransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletTransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sellerAmount, sellerAmount) || other.sellerAmount == sellerAmount)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.status, status) || other.status == status)&&(identical(other.type, type) || other.type == type)&&(identical(other.externalId, externalId) || other.externalId == externalId)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.escrowReleasedAt, escrowReleasedAt) || other.escrowReleasedAt == escrowReleasedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._order, _order)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,sellerAmount,platformFee,status,type,externalId,paidAt,escrowReleasedAt,createdAt,const DeepCollectionEquality().hash(_order),paymentMethod);

@override
String toString() {
  return 'WalletTransactionModel(id: $id, amount: $amount, sellerAmount: $sellerAmount, platformFee: $platformFee, status: $status, type: $type, externalId: $externalId, paidAt: $paidAt, escrowReleasedAt: $escrowReleasedAt, createdAt: $createdAt, order: $order, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class _$WalletTransactionModelCopyWith<$Res> implements $WalletTransactionModelCopyWith<$Res> {
  factory _$WalletTransactionModelCopyWith(_WalletTransactionModel value, $Res Function(_WalletTransactionModel) _then) = __$WalletTransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, double amount, double sellerAmount, double platformFee, String status, String type, String? externalId, DateTime? paidAt, DateTime? escrowReleasedAt, DateTime createdAt, Map<String, dynamic>? order, String? paymentMethod
});




}
/// @nodoc
class __$WalletTransactionModelCopyWithImpl<$Res>
    implements _$WalletTransactionModelCopyWith<$Res> {
  __$WalletTransactionModelCopyWithImpl(this._self, this._then);

  final _WalletTransactionModel _self;
  final $Res Function(_WalletTransactionModel) _then;

/// Create a copy of WalletTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? sellerAmount = null,Object? platformFee = null,Object? status = null,Object? type = null,Object? externalId = freezed,Object? paidAt = freezed,Object? escrowReleasedAt = freezed,Object? createdAt = null,Object? order = freezed,Object? paymentMethod = freezed,}) {
  return _then(_WalletTransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,sellerAmount: null == sellerAmount ? _self.sellerAmount : sellerAmount // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,externalId: freezed == externalId ? _self.externalId : externalId // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,escrowReleasedAt: freezed == escrowReleasedAt ? _self.escrowReleasedAt : escrowReleasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,order: freezed == order ? _self._order : order // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
