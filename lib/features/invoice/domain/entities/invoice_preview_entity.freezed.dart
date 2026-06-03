// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_preview_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvoicePreviewEntity {

 String get negotiationId; String get productId; String get productName; String get productUnit; String? get productThumbnailUrl; String get buyerId; String get buyerName; String? get buyerCompanyName; double get quantity; double get pricePerUnit; double get subtotal; double get platformFee; double get logisticsFee; double get vatAmount; double get totalAmount; String? get specifications; Map<String, dynamic>? get shippingSnapshot;
/// Create a copy of InvoicePreviewEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicePreviewEntityCopyWith<InvoicePreviewEntity> get copyWith => _$InvoicePreviewEntityCopyWithImpl<InvoicePreviewEntity>(this as InvoicePreviewEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicePreviewEntity&&(identical(other.negotiationId, negotiationId) || other.negotiationId == negotiationId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productUnit, productUnit) || other.productUnit == productUnit)&&(identical(other.productThumbnailUrl, productThumbnailUrl) || other.productThumbnailUrl == productThumbnailUrl)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.buyerName, buyerName) || other.buyerName == buyerName)&&(identical(other.buyerCompanyName, buyerCompanyName) || other.buyerCompanyName == buyerCompanyName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.logisticsFee, logisticsFee) || other.logisticsFee == logisticsFee)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&const DeepCollectionEquality().equals(other.shippingSnapshot, shippingSnapshot));
}


@override
int get hashCode => Object.hash(runtimeType,negotiationId,productId,productName,productUnit,productThumbnailUrl,buyerId,buyerName,buyerCompanyName,quantity,pricePerUnit,subtotal,platformFee,logisticsFee,vatAmount,totalAmount,specifications,const DeepCollectionEquality().hash(shippingSnapshot));

@override
String toString() {
  return 'InvoicePreviewEntity(negotiationId: $negotiationId, productId: $productId, productName: $productName, productUnit: $productUnit, productThumbnailUrl: $productThumbnailUrl, buyerId: $buyerId, buyerName: $buyerName, buyerCompanyName: $buyerCompanyName, quantity: $quantity, pricePerUnit: $pricePerUnit, subtotal: $subtotal, platformFee: $platformFee, logisticsFee: $logisticsFee, vatAmount: $vatAmount, totalAmount: $totalAmount, specifications: $specifications, shippingSnapshot: $shippingSnapshot)';
}


}

/// @nodoc
abstract mixin class $InvoicePreviewEntityCopyWith<$Res>  {
  factory $InvoicePreviewEntityCopyWith(InvoicePreviewEntity value, $Res Function(InvoicePreviewEntity) _then) = _$InvoicePreviewEntityCopyWithImpl;
@useResult
$Res call({
 String negotiationId, String productId, String productName, String productUnit, String? productThumbnailUrl, String buyerId, String buyerName, String? buyerCompanyName, double quantity, double pricePerUnit, double subtotal, double platformFee, double logisticsFee, double vatAmount, double totalAmount, String? specifications, Map<String, dynamic>? shippingSnapshot
});




}
/// @nodoc
class _$InvoicePreviewEntityCopyWithImpl<$Res>
    implements $InvoicePreviewEntityCopyWith<$Res> {
  _$InvoicePreviewEntityCopyWithImpl(this._self, this._then);

  final InvoicePreviewEntity _self;
  final $Res Function(InvoicePreviewEntity) _then;

/// Create a copy of InvoicePreviewEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? negotiationId = null,Object? productId = null,Object? productName = null,Object? productUnit = null,Object? productThumbnailUrl = freezed,Object? buyerId = null,Object? buyerName = null,Object? buyerCompanyName = freezed,Object? quantity = null,Object? pricePerUnit = null,Object? subtotal = null,Object? platformFee = null,Object? logisticsFee = null,Object? vatAmount = null,Object? totalAmount = null,Object? specifications = freezed,Object? shippingSnapshot = freezed,}) {
  return _then(_self.copyWith(
negotiationId: null == negotiationId ? _self.negotiationId : negotiationId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productUnit: null == productUnit ? _self.productUnit : productUnit // ignore: cast_nullable_to_non_nullable
as String,productThumbnailUrl: freezed == productThumbnailUrl ? _self.productThumbnailUrl : productThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,buyerName: null == buyerName ? _self.buyerName : buyerName // ignore: cast_nullable_to_non_nullable
as String,buyerCompanyName: freezed == buyerCompanyName ? _self.buyerCompanyName : buyerCompanyName // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,logisticsFee: null == logisticsFee ? _self.logisticsFee : logisticsFee // ignore: cast_nullable_to_non_nullable
as double,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,shippingSnapshot: freezed == shippingSnapshot ? _self.shippingSnapshot : shippingSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoicePreviewEntity].
extension InvoicePreviewEntityPatterns on InvoicePreviewEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoicePreviewEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoicePreviewEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoicePreviewEntity value)  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoicePreviewEntity value)?  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String negotiationId,  String productId,  String productName,  String productUnit,  String? productThumbnailUrl,  String buyerId,  String buyerName,  String? buyerCompanyName,  double quantity,  double pricePerUnit,  double subtotal,  double platformFee,  double logisticsFee,  double vatAmount,  double totalAmount,  String? specifications,  Map<String, dynamic>? shippingSnapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoicePreviewEntity() when $default != null:
return $default(_that.negotiationId,_that.productId,_that.productName,_that.productUnit,_that.productThumbnailUrl,_that.buyerId,_that.buyerName,_that.buyerCompanyName,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.totalAmount,_that.specifications,_that.shippingSnapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String negotiationId,  String productId,  String productName,  String productUnit,  String? productThumbnailUrl,  String buyerId,  String buyerName,  String? buyerCompanyName,  double quantity,  double pricePerUnit,  double subtotal,  double platformFee,  double logisticsFee,  double vatAmount,  double totalAmount,  String? specifications,  Map<String, dynamic>? shippingSnapshot)  $default,) {final _that = this;
switch (_that) {
case _InvoicePreviewEntity():
return $default(_that.negotiationId,_that.productId,_that.productName,_that.productUnit,_that.productThumbnailUrl,_that.buyerId,_that.buyerName,_that.buyerCompanyName,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.totalAmount,_that.specifications,_that.shippingSnapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String negotiationId,  String productId,  String productName,  String productUnit,  String? productThumbnailUrl,  String buyerId,  String buyerName,  String? buyerCompanyName,  double quantity,  double pricePerUnit,  double subtotal,  double platformFee,  double logisticsFee,  double vatAmount,  double totalAmount,  String? specifications,  Map<String, dynamic>? shippingSnapshot)?  $default,) {final _that = this;
switch (_that) {
case _InvoicePreviewEntity() when $default != null:
return $default(_that.negotiationId,_that.productId,_that.productName,_that.productUnit,_that.productThumbnailUrl,_that.buyerId,_that.buyerName,_that.buyerCompanyName,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.totalAmount,_that.specifications,_that.shippingSnapshot);case _:
  return null;

}
}

}

/// @nodoc


class _InvoicePreviewEntity implements InvoicePreviewEntity {
  const _InvoicePreviewEntity({required this.negotiationId, required this.productId, required this.productName, required this.productUnit, this.productThumbnailUrl, required this.buyerId, required this.buyerName, this.buyerCompanyName, required this.quantity, required this.pricePerUnit, required this.subtotal, required this.platformFee, this.logisticsFee = 0, required this.vatAmount, required this.totalAmount, this.specifications, final  Map<String, dynamic>? shippingSnapshot}): _shippingSnapshot = shippingSnapshot;
  

@override final  String negotiationId;
@override final  String productId;
@override final  String productName;
@override final  String productUnit;
@override final  String? productThumbnailUrl;
@override final  String buyerId;
@override final  String buyerName;
@override final  String? buyerCompanyName;
@override final  double quantity;
@override final  double pricePerUnit;
@override final  double subtotal;
@override final  double platformFee;
@override@JsonKey() final  double logisticsFee;
@override final  double vatAmount;
@override final  double totalAmount;
@override final  String? specifications;
 final  Map<String, dynamic>? _shippingSnapshot;
@override Map<String, dynamic>? get shippingSnapshot {
  final value = _shippingSnapshot;
  if (value == null) return null;
  if (_shippingSnapshot is EqualUnmodifiableMapView) return _shippingSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of InvoicePreviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoicePreviewEntityCopyWith<_InvoicePreviewEntity> get copyWith => __$InvoicePreviewEntityCopyWithImpl<_InvoicePreviewEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoicePreviewEntity&&(identical(other.negotiationId, negotiationId) || other.negotiationId == negotiationId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productUnit, productUnit) || other.productUnit == productUnit)&&(identical(other.productThumbnailUrl, productThumbnailUrl) || other.productThumbnailUrl == productThumbnailUrl)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.buyerName, buyerName) || other.buyerName == buyerName)&&(identical(other.buyerCompanyName, buyerCompanyName) || other.buyerCompanyName == buyerCompanyName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.logisticsFee, logisticsFee) || other.logisticsFee == logisticsFee)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&const DeepCollectionEquality().equals(other._shippingSnapshot, _shippingSnapshot));
}


@override
int get hashCode => Object.hash(runtimeType,negotiationId,productId,productName,productUnit,productThumbnailUrl,buyerId,buyerName,buyerCompanyName,quantity,pricePerUnit,subtotal,platformFee,logisticsFee,vatAmount,totalAmount,specifications,const DeepCollectionEquality().hash(_shippingSnapshot));

@override
String toString() {
  return 'InvoicePreviewEntity(negotiationId: $negotiationId, productId: $productId, productName: $productName, productUnit: $productUnit, productThumbnailUrl: $productThumbnailUrl, buyerId: $buyerId, buyerName: $buyerName, buyerCompanyName: $buyerCompanyName, quantity: $quantity, pricePerUnit: $pricePerUnit, subtotal: $subtotal, platformFee: $platformFee, logisticsFee: $logisticsFee, vatAmount: $vatAmount, totalAmount: $totalAmount, specifications: $specifications, shippingSnapshot: $shippingSnapshot)';
}


}

/// @nodoc
abstract mixin class _$InvoicePreviewEntityCopyWith<$Res> implements $InvoicePreviewEntityCopyWith<$Res> {
  factory _$InvoicePreviewEntityCopyWith(_InvoicePreviewEntity value, $Res Function(_InvoicePreviewEntity) _then) = __$InvoicePreviewEntityCopyWithImpl;
@override @useResult
$Res call({
 String negotiationId, String productId, String productName, String productUnit, String? productThumbnailUrl, String buyerId, String buyerName, String? buyerCompanyName, double quantity, double pricePerUnit, double subtotal, double platformFee, double logisticsFee, double vatAmount, double totalAmount, String? specifications, Map<String, dynamic>? shippingSnapshot
});




}
/// @nodoc
class __$InvoicePreviewEntityCopyWithImpl<$Res>
    implements _$InvoicePreviewEntityCopyWith<$Res> {
  __$InvoicePreviewEntityCopyWithImpl(this._self, this._then);

  final _InvoicePreviewEntity _self;
  final $Res Function(_InvoicePreviewEntity) _then;

/// Create a copy of InvoicePreviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? negotiationId = null,Object? productId = null,Object? productName = null,Object? productUnit = null,Object? productThumbnailUrl = freezed,Object? buyerId = null,Object? buyerName = null,Object? buyerCompanyName = freezed,Object? quantity = null,Object? pricePerUnit = null,Object? subtotal = null,Object? platformFee = null,Object? logisticsFee = null,Object? vatAmount = null,Object? totalAmount = null,Object? specifications = freezed,Object? shippingSnapshot = freezed,}) {
  return _then(_InvoicePreviewEntity(
negotiationId: null == negotiationId ? _self.negotiationId : negotiationId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productUnit: null == productUnit ? _self.productUnit : productUnit // ignore: cast_nullable_to_non_nullable
as String,productThumbnailUrl: freezed == productThumbnailUrl ? _self.productThumbnailUrl : productThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,buyerName: null == buyerName ? _self.buyerName : buyerName // ignore: cast_nullable_to_non_nullable
as String,buyerCompanyName: freezed == buyerCompanyName ? _self.buyerCompanyName : buyerCompanyName // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,logisticsFee: null == logisticsFee ? _self.logisticsFee : logisticsFee // ignore: cast_nullable_to_non_nullable
as double,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,shippingSnapshot: freezed == shippingSnapshot ? _self._shippingSnapshot : shippingSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
