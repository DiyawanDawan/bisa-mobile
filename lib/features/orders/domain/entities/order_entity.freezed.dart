// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderEntity {

 String get id; String get orderNumber; String? get checkoutBatchId; String? get checkoutBatchNumber; String get status; String get orderType; double get totalAmount; double get totalQuantity; double get subtotal; double get platformFee; double get logisticsFee; double get vatAmount; String? get specifications; Map<String, dynamic>? get shippingAddressSnapshot; DateTime get createdAt; List<OrderItemEntity> get items; OrderParticipantEntity get buyer; OrderParticipantEntity get seller; OrderTransactionEntity? get transaction; OrderShipmentEntity? get shipment; OrderShippingEntity? get orderShipping; OrderReviewEntity? get review;/// Data VA/QR/invoice dari backend jika pembayaran sudah diinisialisasi.
 Map<String, dynamic>? get pendingPayment; OrderDisputeEntity? get dispute; String? get negotiationId; bool get isDigitalSigned; DateTime? get buyerSignedAt; DateTime? get sellerSignedAt;
/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderEntityCopyWith<OrderEntity> get copyWith => _$OrderEntityCopyWithImpl<OrderEntity>(this as OrderEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.checkoutBatchId, checkoutBatchId) || other.checkoutBatchId == checkoutBatchId)&&(identical(other.checkoutBatchNumber, checkoutBatchNumber) || other.checkoutBatchNumber == checkoutBatchNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.logisticsFee, logisticsFee) || other.logisticsFee == logisticsFee)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&const DeepCollectionEquality().equals(other.shippingAddressSnapshot, shippingAddressSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.shipment, shipment) || other.shipment == shipment)&&(identical(other.orderShipping, orderShipping) || other.orderShipping == orderShipping)&&(identical(other.review, review) || other.review == review)&&const DeepCollectionEquality().equals(other.pendingPayment, pendingPayment)&&(identical(other.dispute, dispute) || other.dispute == dispute)&&(identical(other.negotiationId, negotiationId) || other.negotiationId == negotiationId)&&(identical(other.isDigitalSigned, isDigitalSigned) || other.isDigitalSigned == isDigitalSigned)&&(identical(other.buyerSignedAt, buyerSignedAt) || other.buyerSignedAt == buyerSignedAt)&&(identical(other.sellerSignedAt, sellerSignedAt) || other.sellerSignedAt == sellerSignedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,checkoutBatchId,checkoutBatchNumber,status,orderType,totalAmount,totalQuantity,subtotal,platformFee,logisticsFee,vatAmount,specifications,const DeepCollectionEquality().hash(shippingAddressSnapshot),createdAt,const DeepCollectionEquality().hash(items),buyer,seller,transaction,shipment,orderShipping,review,const DeepCollectionEquality().hash(pendingPayment),dispute,negotiationId,isDigitalSigned,buyerSignedAt,sellerSignedAt]);

@override
String toString() {
  return 'OrderEntity(id: $id, orderNumber: $orderNumber, checkoutBatchId: $checkoutBatchId, checkoutBatchNumber: $checkoutBatchNumber, status: $status, orderType: $orderType, totalAmount: $totalAmount, totalQuantity: $totalQuantity, subtotal: $subtotal, platformFee: $platformFee, logisticsFee: $logisticsFee, vatAmount: $vatAmount, specifications: $specifications, shippingAddressSnapshot: $shippingAddressSnapshot, createdAt: $createdAt, items: $items, buyer: $buyer, seller: $seller, transaction: $transaction, shipment: $shipment, orderShipping: $orderShipping, review: $review, pendingPayment: $pendingPayment, dispute: $dispute, negotiationId: $negotiationId, isDigitalSigned: $isDigitalSigned, buyerSignedAt: $buyerSignedAt, sellerSignedAt: $sellerSignedAt)';
}


}

/// @nodoc
abstract mixin class $OrderEntityCopyWith<$Res>  {
  factory $OrderEntityCopyWith(OrderEntity value, $Res Function(OrderEntity) _then) = _$OrderEntityCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String? checkoutBatchId, String? checkoutBatchNumber, String status, String orderType, double totalAmount, double totalQuantity, double subtotal, double platformFee, double logisticsFee, double vatAmount, String? specifications, Map<String, dynamic>? shippingAddressSnapshot, DateTime createdAt, List<OrderItemEntity> items, OrderParticipantEntity buyer, OrderParticipantEntity seller, OrderTransactionEntity? transaction, OrderShipmentEntity? shipment, OrderShippingEntity? orderShipping, OrderReviewEntity? review, Map<String, dynamic>? pendingPayment, OrderDisputeEntity? dispute, String? negotiationId, bool isDigitalSigned, DateTime? buyerSignedAt, DateTime? sellerSignedAt
});


$OrderParticipantEntityCopyWith<$Res> get buyer;$OrderParticipantEntityCopyWith<$Res> get seller;$OrderTransactionEntityCopyWith<$Res>? get transaction;$OrderShipmentEntityCopyWith<$Res>? get shipment;$OrderShippingEntityCopyWith<$Res>? get orderShipping;$OrderReviewEntityCopyWith<$Res>? get review;

}
/// @nodoc
class _$OrderEntityCopyWithImpl<$Res>
    implements $OrderEntityCopyWith<$Res> {
  _$OrderEntityCopyWithImpl(this._self, this._then);

  final OrderEntity _self;
  final $Res Function(OrderEntity) _then;

/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? checkoutBatchId = freezed,Object? checkoutBatchNumber = freezed,Object? status = null,Object? orderType = null,Object? totalAmount = null,Object? totalQuantity = null,Object? subtotal = null,Object? platformFee = null,Object? logisticsFee = null,Object? vatAmount = null,Object? specifications = freezed,Object? shippingAddressSnapshot = freezed,Object? createdAt = null,Object? items = null,Object? buyer = null,Object? seller = null,Object? transaction = freezed,Object? shipment = freezed,Object? orderShipping = freezed,Object? review = freezed,Object? pendingPayment = freezed,Object? dispute = freezed,Object? negotiationId = freezed,Object? isDigitalSigned = null,Object? buyerSignedAt = freezed,Object? sellerSignedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,checkoutBatchId: freezed == checkoutBatchId ? _self.checkoutBatchId : checkoutBatchId // ignore: cast_nullable_to_non_nullable
as String?,checkoutBatchNumber: freezed == checkoutBatchNumber ? _self.checkoutBatchNumber : checkoutBatchNumber // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,logisticsFee: null == logisticsFee ? _self.logisticsFee : logisticsFee // ignore: cast_nullable_to_non_nullable
as double,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as double,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,shippingAddressSnapshot: freezed == shippingAddressSnapshot ? _self.shippingAddressSnapshot : shippingAddressSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemEntity>,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as OrderParticipantEntity,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as OrderParticipantEntity,transaction: freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as OrderTransactionEntity?,shipment: freezed == shipment ? _self.shipment : shipment // ignore: cast_nullable_to_non_nullable
as OrderShipmentEntity?,orderShipping: freezed == orderShipping ? _self.orderShipping : orderShipping // ignore: cast_nullable_to_non_nullable
as OrderShippingEntity?,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as OrderReviewEntity?,pendingPayment: freezed == pendingPayment ? _self.pendingPayment : pendingPayment // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,dispute: freezed == dispute ? _self.dispute : dispute // ignore: cast_nullable_to_non_nullable
as OrderDisputeEntity?,negotiationId: freezed == negotiationId ? _self.negotiationId : negotiationId // ignore: cast_nullable_to_non_nullable
as String?,isDigitalSigned: null == isDigitalSigned ? _self.isDigitalSigned : isDigitalSigned // ignore: cast_nullable_to_non_nullable
as bool,buyerSignedAt: freezed == buyerSignedAt ? _self.buyerSignedAt : buyerSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sellerSignedAt: freezed == sellerSignedAt ? _self.sellerSignedAt : sellerSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderParticipantEntityCopyWith<$Res> get buyer {
  
  return $OrderParticipantEntityCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderParticipantEntityCopyWith<$Res> get seller {
  
  return $OrderParticipantEntityCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderTransactionEntityCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $OrderTransactionEntityCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderShipmentEntityCopyWith<$Res>? get shipment {
    if (_self.shipment == null) {
    return null;
  }

  return $OrderShipmentEntityCopyWith<$Res>(_self.shipment!, (value) {
    return _then(_self.copyWith(shipment: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderShippingEntityCopyWith<$Res>? get orderShipping {
    if (_self.orderShipping == null) {
    return null;
  }

  return $OrderShippingEntityCopyWith<$Res>(_self.orderShipping!, (value) {
    return _then(_self.copyWith(orderShipping: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderReviewEntityCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $OrderReviewEntityCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderEntity].
extension OrderEntityPatterns on OrderEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String? checkoutBatchId,  String? checkoutBatchNumber,  String status,  String orderType,  double totalAmount,  double totalQuantity,  double subtotal,  double platformFee,  double logisticsFee,  double vatAmount,  String? specifications,  Map<String, dynamic>? shippingAddressSnapshot,  DateTime createdAt,  List<OrderItemEntity> items,  OrderParticipantEntity buyer,  OrderParticipantEntity seller,  OrderTransactionEntity? transaction,  OrderShipmentEntity? shipment,  OrderShippingEntity? orderShipping,  OrderReviewEntity? review,  Map<String, dynamic>? pendingPayment,  OrderDisputeEntity? dispute,  String? negotiationId,  bool isDigitalSigned,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderEntity() when $default != null:
return $default(_that.id,_that.orderNumber,_that.checkoutBatchId,_that.checkoutBatchNumber,_that.status,_that.orderType,_that.totalAmount,_that.totalQuantity,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.specifications,_that.shippingAddressSnapshot,_that.createdAt,_that.items,_that.buyer,_that.seller,_that.transaction,_that.shipment,_that.orderShipping,_that.review,_that.pendingPayment,_that.dispute,_that.negotiationId,_that.isDigitalSigned,_that.buyerSignedAt,_that.sellerSignedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String? checkoutBatchId,  String? checkoutBatchNumber,  String status,  String orderType,  double totalAmount,  double totalQuantity,  double subtotal,  double platformFee,  double logisticsFee,  double vatAmount,  String? specifications,  Map<String, dynamic>? shippingAddressSnapshot,  DateTime createdAt,  List<OrderItemEntity> items,  OrderParticipantEntity buyer,  OrderParticipantEntity seller,  OrderTransactionEntity? transaction,  OrderShipmentEntity? shipment,  OrderShippingEntity? orderShipping,  OrderReviewEntity? review,  Map<String, dynamic>? pendingPayment,  OrderDisputeEntity? dispute,  String? negotiationId,  bool isDigitalSigned,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderEntity():
return $default(_that.id,_that.orderNumber,_that.checkoutBatchId,_that.checkoutBatchNumber,_that.status,_that.orderType,_that.totalAmount,_that.totalQuantity,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.specifications,_that.shippingAddressSnapshot,_that.createdAt,_that.items,_that.buyer,_that.seller,_that.transaction,_that.shipment,_that.orderShipping,_that.review,_that.pendingPayment,_that.dispute,_that.negotiationId,_that.isDigitalSigned,_that.buyerSignedAt,_that.sellerSignedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderNumber,  String? checkoutBatchId,  String? checkoutBatchNumber,  String status,  String orderType,  double totalAmount,  double totalQuantity,  double subtotal,  double platformFee,  double logisticsFee,  double vatAmount,  String? specifications,  Map<String, dynamic>? shippingAddressSnapshot,  DateTime createdAt,  List<OrderItemEntity> items,  OrderParticipantEntity buyer,  OrderParticipantEntity seller,  OrderTransactionEntity? transaction,  OrderShipmentEntity? shipment,  OrderShippingEntity? orderShipping,  OrderReviewEntity? review,  Map<String, dynamic>? pendingPayment,  OrderDisputeEntity? dispute,  String? negotiationId,  bool isDigitalSigned,  DateTime? buyerSignedAt,  DateTime? sellerSignedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderEntity() when $default != null:
return $default(_that.id,_that.orderNumber,_that.checkoutBatchId,_that.checkoutBatchNumber,_that.status,_that.orderType,_that.totalAmount,_that.totalQuantity,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.specifications,_that.shippingAddressSnapshot,_that.createdAt,_that.items,_that.buyer,_that.seller,_that.transaction,_that.shipment,_that.orderShipping,_that.review,_that.pendingPayment,_that.dispute,_that.negotiationId,_that.isDigitalSigned,_that.buyerSignedAt,_that.sellerSignedAt);case _:
  return null;

}
}

}

/// @nodoc


class _OrderEntity extends OrderEntity {
  const _OrderEntity({required this.id, required this.orderNumber, this.checkoutBatchId, this.checkoutBatchNumber, required this.status, this.orderType = 'STANDARD', required this.totalAmount, required this.totalQuantity, required this.subtotal, required this.platformFee, this.logisticsFee = 0, required this.vatAmount, this.specifications, final  Map<String, dynamic>? shippingAddressSnapshot, required this.createdAt, required final  List<OrderItemEntity> items, required this.buyer, required this.seller, this.transaction, this.shipment, this.orderShipping, this.review, final  Map<String, dynamic>? pendingPayment, this.dispute, this.negotiationId, this.isDigitalSigned = false, this.buyerSignedAt, this.sellerSignedAt}): _shippingAddressSnapshot = shippingAddressSnapshot,_items = items,_pendingPayment = pendingPayment,super._();
  

@override final  String id;
@override final  String orderNumber;
@override final  String? checkoutBatchId;
@override final  String? checkoutBatchNumber;
@override final  String status;
@override@JsonKey() final  String orderType;
@override final  double totalAmount;
@override final  double totalQuantity;
@override final  double subtotal;
@override final  double platformFee;
@override@JsonKey() final  double logisticsFee;
@override final  double vatAmount;
@override final  String? specifications;
 final  Map<String, dynamic>? _shippingAddressSnapshot;
@override Map<String, dynamic>? get shippingAddressSnapshot {
  final value = _shippingAddressSnapshot;
  if (value == null) return null;
  if (_shippingAddressSnapshot is EqualUnmodifiableMapView) return _shippingAddressSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime createdAt;
 final  List<OrderItemEntity> _items;
@override List<OrderItemEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  OrderParticipantEntity buyer;
@override final  OrderParticipantEntity seller;
@override final  OrderTransactionEntity? transaction;
@override final  OrderShipmentEntity? shipment;
@override final  OrderShippingEntity? orderShipping;
@override final  OrderReviewEntity? review;
/// Data VA/QR/invoice dari backend jika pembayaran sudah diinisialisasi.
 final  Map<String, dynamic>? _pendingPayment;
/// Data VA/QR/invoice dari backend jika pembayaran sudah diinisialisasi.
@override Map<String, dynamic>? get pendingPayment {
  final value = _pendingPayment;
  if (value == null) return null;
  if (_pendingPayment is EqualUnmodifiableMapView) return _pendingPayment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  OrderDisputeEntity? dispute;
@override final  String? negotiationId;
@override@JsonKey() final  bool isDigitalSigned;
@override final  DateTime? buyerSignedAt;
@override final  DateTime? sellerSignedAt;

/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderEntityCopyWith<_OrderEntity> get copyWith => __$OrderEntityCopyWithImpl<_OrderEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.checkoutBatchId, checkoutBatchId) || other.checkoutBatchId == checkoutBatchId)&&(identical(other.checkoutBatchNumber, checkoutBatchNumber) || other.checkoutBatchNumber == checkoutBatchNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.logisticsFee, logisticsFee) || other.logisticsFee == logisticsFee)&&(identical(other.vatAmount, vatAmount) || other.vatAmount == vatAmount)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&const DeepCollectionEquality().equals(other._shippingAddressSnapshot, _shippingAddressSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.shipment, shipment) || other.shipment == shipment)&&(identical(other.orderShipping, orderShipping) || other.orderShipping == orderShipping)&&(identical(other.review, review) || other.review == review)&&const DeepCollectionEquality().equals(other._pendingPayment, _pendingPayment)&&(identical(other.dispute, dispute) || other.dispute == dispute)&&(identical(other.negotiationId, negotiationId) || other.negotiationId == negotiationId)&&(identical(other.isDigitalSigned, isDigitalSigned) || other.isDigitalSigned == isDigitalSigned)&&(identical(other.buyerSignedAt, buyerSignedAt) || other.buyerSignedAt == buyerSignedAt)&&(identical(other.sellerSignedAt, sellerSignedAt) || other.sellerSignedAt == sellerSignedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,checkoutBatchId,checkoutBatchNumber,status,orderType,totalAmount,totalQuantity,subtotal,platformFee,logisticsFee,vatAmount,specifications,const DeepCollectionEquality().hash(_shippingAddressSnapshot),createdAt,const DeepCollectionEquality().hash(_items),buyer,seller,transaction,shipment,orderShipping,review,const DeepCollectionEquality().hash(_pendingPayment),dispute,negotiationId,isDigitalSigned,buyerSignedAt,sellerSignedAt]);

@override
String toString() {
  return 'OrderEntity(id: $id, orderNumber: $orderNumber, checkoutBatchId: $checkoutBatchId, checkoutBatchNumber: $checkoutBatchNumber, status: $status, orderType: $orderType, totalAmount: $totalAmount, totalQuantity: $totalQuantity, subtotal: $subtotal, platformFee: $platformFee, logisticsFee: $logisticsFee, vatAmount: $vatAmount, specifications: $specifications, shippingAddressSnapshot: $shippingAddressSnapshot, createdAt: $createdAt, items: $items, buyer: $buyer, seller: $seller, transaction: $transaction, shipment: $shipment, orderShipping: $orderShipping, review: $review, pendingPayment: $pendingPayment, dispute: $dispute, negotiationId: $negotiationId, isDigitalSigned: $isDigitalSigned, buyerSignedAt: $buyerSignedAt, sellerSignedAt: $sellerSignedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderEntityCopyWith<$Res> implements $OrderEntityCopyWith<$Res> {
  factory _$OrderEntityCopyWith(_OrderEntity value, $Res Function(_OrderEntity) _then) = __$OrderEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String? checkoutBatchId, String? checkoutBatchNumber, String status, String orderType, double totalAmount, double totalQuantity, double subtotal, double platformFee, double logisticsFee, double vatAmount, String? specifications, Map<String, dynamic>? shippingAddressSnapshot, DateTime createdAt, List<OrderItemEntity> items, OrderParticipantEntity buyer, OrderParticipantEntity seller, OrderTransactionEntity? transaction, OrderShipmentEntity? shipment, OrderShippingEntity? orderShipping, OrderReviewEntity? review, Map<String, dynamic>? pendingPayment, OrderDisputeEntity? dispute, String? negotiationId, bool isDigitalSigned, DateTime? buyerSignedAt, DateTime? sellerSignedAt
});


@override $OrderParticipantEntityCopyWith<$Res> get buyer;@override $OrderParticipantEntityCopyWith<$Res> get seller;@override $OrderTransactionEntityCopyWith<$Res>? get transaction;@override $OrderShipmentEntityCopyWith<$Res>? get shipment;@override $OrderShippingEntityCopyWith<$Res>? get orderShipping;@override $OrderReviewEntityCopyWith<$Res>? get review;

}
/// @nodoc
class __$OrderEntityCopyWithImpl<$Res>
    implements _$OrderEntityCopyWith<$Res> {
  __$OrderEntityCopyWithImpl(this._self, this._then);

  final _OrderEntity _self;
  final $Res Function(_OrderEntity) _then;

/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? checkoutBatchId = freezed,Object? checkoutBatchNumber = freezed,Object? status = null,Object? orderType = null,Object? totalAmount = null,Object? totalQuantity = null,Object? subtotal = null,Object? platformFee = null,Object? logisticsFee = null,Object? vatAmount = null,Object? specifications = freezed,Object? shippingAddressSnapshot = freezed,Object? createdAt = null,Object? items = null,Object? buyer = null,Object? seller = null,Object? transaction = freezed,Object? shipment = freezed,Object? orderShipping = freezed,Object? review = freezed,Object? pendingPayment = freezed,Object? dispute = freezed,Object? negotiationId = freezed,Object? isDigitalSigned = null,Object? buyerSignedAt = freezed,Object? sellerSignedAt = freezed,}) {
  return _then(_OrderEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,checkoutBatchId: freezed == checkoutBatchId ? _self.checkoutBatchId : checkoutBatchId // ignore: cast_nullable_to_non_nullable
as String?,checkoutBatchNumber: freezed == checkoutBatchNumber ? _self.checkoutBatchNumber : checkoutBatchNumber // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,logisticsFee: null == logisticsFee ? _self.logisticsFee : logisticsFee // ignore: cast_nullable_to_non_nullable
as double,vatAmount: null == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as double,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,shippingAddressSnapshot: freezed == shippingAddressSnapshot ? _self._shippingAddressSnapshot : shippingAddressSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemEntity>,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as OrderParticipantEntity,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as OrderParticipantEntity,transaction: freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as OrderTransactionEntity?,shipment: freezed == shipment ? _self.shipment : shipment // ignore: cast_nullable_to_non_nullable
as OrderShipmentEntity?,orderShipping: freezed == orderShipping ? _self.orderShipping : orderShipping // ignore: cast_nullable_to_non_nullable
as OrderShippingEntity?,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as OrderReviewEntity?,pendingPayment: freezed == pendingPayment ? _self._pendingPayment : pendingPayment // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,dispute: freezed == dispute ? _self.dispute : dispute // ignore: cast_nullable_to_non_nullable
as OrderDisputeEntity?,negotiationId: freezed == negotiationId ? _self.negotiationId : negotiationId // ignore: cast_nullable_to_non_nullable
as String?,isDigitalSigned: null == isDigitalSigned ? _self.isDigitalSigned : isDigitalSigned // ignore: cast_nullable_to_non_nullable
as bool,buyerSignedAt: freezed == buyerSignedAt ? _self.buyerSignedAt : buyerSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sellerSignedAt: freezed == sellerSignedAt ? _self.sellerSignedAt : sellerSignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderParticipantEntityCopyWith<$Res> get buyer {
  
  return $OrderParticipantEntityCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderParticipantEntityCopyWith<$Res> get seller {
  
  return $OrderParticipantEntityCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderTransactionEntityCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $OrderTransactionEntityCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderShipmentEntityCopyWith<$Res>? get shipment {
    if (_self.shipment == null) {
    return null;
  }

  return $OrderShipmentEntityCopyWith<$Res>(_self.shipment!, (value) {
    return _then(_self.copyWith(shipment: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderShippingEntityCopyWith<$Res>? get orderShipping {
    if (_self.orderShipping == null) {
    return null;
  }

  return $OrderShippingEntityCopyWith<$Res>(_self.orderShipping!, (value) {
    return _then(_self.copyWith(orderShipping: value));
  });
}/// Create a copy of OrderEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderReviewEntityCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $OrderReviewEntityCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}
}

/// @nodoc
mixin _$OrderTransactionEntity {

 String get status; String? get paymentStatus; String? get paymentUrl; DateTime? get paidAt; String? get paymentChannelCode; String? get paymentChannelName; String? get paymentProofUrl;
/// Create a copy of OrderTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTransactionEntityCopyWith<OrderTransactionEntity> get copyWith => _$OrderTransactionEntityCopyWithImpl<OrderTransactionEntity>(this as OrderTransactionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTransactionEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paymentChannelCode, paymentChannelCode) || other.paymentChannelCode == paymentChannelCode)&&(identical(other.paymentChannelName, paymentChannelName) || other.paymentChannelName == paymentChannelName)&&(identical(other.paymentProofUrl, paymentProofUrl) || other.paymentProofUrl == paymentProofUrl));
}


@override
int get hashCode => Object.hash(runtimeType,status,paymentStatus,paymentUrl,paidAt,paymentChannelCode,paymentChannelName,paymentProofUrl);

@override
String toString() {
  return 'OrderTransactionEntity(status: $status, paymentStatus: $paymentStatus, paymentUrl: $paymentUrl, paidAt: $paidAt, paymentChannelCode: $paymentChannelCode, paymentChannelName: $paymentChannelName, paymentProofUrl: $paymentProofUrl)';
}


}

/// @nodoc
abstract mixin class $OrderTransactionEntityCopyWith<$Res>  {
  factory $OrderTransactionEntityCopyWith(OrderTransactionEntity value, $Res Function(OrderTransactionEntity) _then) = _$OrderTransactionEntityCopyWithImpl;
@useResult
$Res call({
 String status, String? paymentStatus, String? paymentUrl, DateTime? paidAt, String? paymentChannelCode, String? paymentChannelName, String? paymentProofUrl
});




}
/// @nodoc
class _$OrderTransactionEntityCopyWithImpl<$Res>
    implements $OrderTransactionEntityCopyWith<$Res> {
  _$OrderTransactionEntityCopyWithImpl(this._self, this._then);

  final OrderTransactionEntity _self;
  final $Res Function(OrderTransactionEntity) _then;

/// Create a copy of OrderTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? paymentStatus = freezed,Object? paymentUrl = freezed,Object? paidAt = freezed,Object? paymentChannelCode = freezed,Object? paymentChannelName = freezed,Object? paymentProofUrl = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentChannelCode: freezed == paymentChannelCode ? _self.paymentChannelCode : paymentChannelCode // ignore: cast_nullable_to_non_nullable
as String?,paymentChannelName: freezed == paymentChannelName ? _self.paymentChannelName : paymentChannelName // ignore: cast_nullable_to_non_nullable
as String?,paymentProofUrl: freezed == paymentProofUrl ? _self.paymentProofUrl : paymentProofUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderTransactionEntity].
extension OrderTransactionEntityPatterns on OrderTransactionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderTransactionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderTransactionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderTransactionEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderTransactionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderTransactionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderTransactionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? paymentStatus,  String? paymentUrl,  DateTime? paidAt,  String? paymentChannelCode,  String? paymentChannelName,  String? paymentProofUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderTransactionEntity() when $default != null:
return $default(_that.status,_that.paymentStatus,_that.paymentUrl,_that.paidAt,_that.paymentChannelCode,_that.paymentChannelName,_that.paymentProofUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? paymentStatus,  String? paymentUrl,  DateTime? paidAt,  String? paymentChannelCode,  String? paymentChannelName,  String? paymentProofUrl)  $default,) {final _that = this;
switch (_that) {
case _OrderTransactionEntity():
return $default(_that.status,_that.paymentStatus,_that.paymentUrl,_that.paidAt,_that.paymentChannelCode,_that.paymentChannelName,_that.paymentProofUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? paymentStatus,  String? paymentUrl,  DateTime? paidAt,  String? paymentChannelCode,  String? paymentChannelName,  String? paymentProofUrl)?  $default,) {final _that = this;
switch (_that) {
case _OrderTransactionEntity() when $default != null:
return $default(_that.status,_that.paymentStatus,_that.paymentUrl,_that.paidAt,_that.paymentChannelCode,_that.paymentChannelName,_that.paymentProofUrl);case _:
  return null;

}
}

}

/// @nodoc


class _OrderTransactionEntity implements OrderTransactionEntity {
  const _OrderTransactionEntity({required this.status, this.paymentStatus, this.paymentUrl, this.paidAt, this.paymentChannelCode, this.paymentChannelName, this.paymentProofUrl});
  

@override final  String status;
@override final  String? paymentStatus;
@override final  String? paymentUrl;
@override final  DateTime? paidAt;
@override final  String? paymentChannelCode;
@override final  String? paymentChannelName;
@override final  String? paymentProofUrl;

/// Create a copy of OrderTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderTransactionEntityCopyWith<_OrderTransactionEntity> get copyWith => __$OrderTransactionEntityCopyWithImpl<_OrderTransactionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderTransactionEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paymentChannelCode, paymentChannelCode) || other.paymentChannelCode == paymentChannelCode)&&(identical(other.paymentChannelName, paymentChannelName) || other.paymentChannelName == paymentChannelName)&&(identical(other.paymentProofUrl, paymentProofUrl) || other.paymentProofUrl == paymentProofUrl));
}


@override
int get hashCode => Object.hash(runtimeType,status,paymentStatus,paymentUrl,paidAt,paymentChannelCode,paymentChannelName,paymentProofUrl);

@override
String toString() {
  return 'OrderTransactionEntity(status: $status, paymentStatus: $paymentStatus, paymentUrl: $paymentUrl, paidAt: $paidAt, paymentChannelCode: $paymentChannelCode, paymentChannelName: $paymentChannelName, paymentProofUrl: $paymentProofUrl)';
}


}

/// @nodoc
abstract mixin class _$OrderTransactionEntityCopyWith<$Res> implements $OrderTransactionEntityCopyWith<$Res> {
  factory _$OrderTransactionEntityCopyWith(_OrderTransactionEntity value, $Res Function(_OrderTransactionEntity) _then) = __$OrderTransactionEntityCopyWithImpl;
@override @useResult
$Res call({
 String status, String? paymentStatus, String? paymentUrl, DateTime? paidAt, String? paymentChannelCode, String? paymentChannelName, String? paymentProofUrl
});




}
/// @nodoc
class __$OrderTransactionEntityCopyWithImpl<$Res>
    implements _$OrderTransactionEntityCopyWith<$Res> {
  __$OrderTransactionEntityCopyWithImpl(this._self, this._then);

  final _OrderTransactionEntity _self;
  final $Res Function(_OrderTransactionEntity) _then;

/// Create a copy of OrderTransactionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? paymentStatus = freezed,Object? paymentUrl = freezed,Object? paidAt = freezed,Object? paymentChannelCode = freezed,Object? paymentChannelName = freezed,Object? paymentProofUrl = freezed,}) {
  return _then(_OrderTransactionEntity(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentChannelCode: freezed == paymentChannelCode ? _self.paymentChannelCode : paymentChannelCode // ignore: cast_nullable_to_non_nullable
as String?,paymentChannelName: freezed == paymentChannelName ? _self.paymentChannelName : paymentChannelName // ignore: cast_nullable_to_non_nullable
as String?,paymentProofUrl: freezed == paymentProofUrl ? _self.paymentProofUrl : paymentProofUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$OrderReviewEntity {

 String get id; double get rating; String get comment;
/// Create a copy of OrderReviewEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderReviewEntityCopyWith<OrderReviewEntity> get copyWith => _$OrderReviewEntityCopyWithImpl<OrderReviewEntity>(this as OrderReviewEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderReviewEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}


@override
int get hashCode => Object.hash(runtimeType,id,rating,comment);

@override
String toString() {
  return 'OrderReviewEntity(id: $id, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $OrderReviewEntityCopyWith<$Res>  {
  factory $OrderReviewEntityCopyWith(OrderReviewEntity value, $Res Function(OrderReviewEntity) _then) = _$OrderReviewEntityCopyWithImpl;
@useResult
$Res call({
 String id, double rating, String comment
});




}
/// @nodoc
class _$OrderReviewEntityCopyWithImpl<$Res>
    implements $OrderReviewEntityCopyWith<$Res> {
  _$OrderReviewEntityCopyWithImpl(this._self, this._then);

  final OrderReviewEntity _self;
  final $Res Function(OrderReviewEntity) _then;

/// Create a copy of OrderReviewEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rating = null,Object? comment = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderReviewEntity].
extension OrderReviewEntityPatterns on OrderReviewEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderReviewEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderReviewEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderReviewEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderReviewEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderReviewEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderReviewEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  double rating,  String comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderReviewEntity() when $default != null:
return $default(_that.id,_that.rating,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  double rating,  String comment)  $default,) {final _that = this;
switch (_that) {
case _OrderReviewEntity():
return $default(_that.id,_that.rating,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  double rating,  String comment)?  $default,) {final _that = this;
switch (_that) {
case _OrderReviewEntity() when $default != null:
return $default(_that.id,_that.rating,_that.comment);case _:
  return null;

}
}

}

/// @nodoc


class _OrderReviewEntity implements OrderReviewEntity {
  const _OrderReviewEntity({required this.id, required this.rating, required this.comment});
  

@override final  String id;
@override final  double rating;
@override final  String comment;

/// Create a copy of OrderReviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderReviewEntityCopyWith<_OrderReviewEntity> get copyWith => __$OrderReviewEntityCopyWithImpl<_OrderReviewEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderReviewEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}


@override
int get hashCode => Object.hash(runtimeType,id,rating,comment);

@override
String toString() {
  return 'OrderReviewEntity(id: $id, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$OrderReviewEntityCopyWith<$Res> implements $OrderReviewEntityCopyWith<$Res> {
  factory _$OrderReviewEntityCopyWith(_OrderReviewEntity value, $Res Function(_OrderReviewEntity) _then) = __$OrderReviewEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, double rating, String comment
});




}
/// @nodoc
class __$OrderReviewEntityCopyWithImpl<$Res>
    implements _$OrderReviewEntityCopyWith<$Res> {
  __$OrderReviewEntityCopyWithImpl(this._self, this._then);

  final _OrderReviewEntity _self;
  final $Res Function(_OrderReviewEntity) _then;

/// Create a copy of OrderReviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rating = null,Object? comment = null,}) {
  return _then(_OrderReviewEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$OrderItemEntity {

 String get id; String get productId; String get productName; double get quantity; double get pricePerUnit; double get subtotal; String? get productUnit; String? get thumbnailUrl;
/// Create a copy of OrderItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemEntityCopyWith<OrderItemEntity> get copyWith => _$OrderItemEntityCopyWithImpl<OrderItemEntity>(this as OrderItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.productUnit, productUnit) || other.productUnit == productUnit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,quantity,pricePerUnit,subtotal,productUnit,thumbnailUrl);

@override
String toString() {
  return 'OrderItemEntity(id: $id, productId: $productId, productName: $productName, quantity: $quantity, pricePerUnit: $pricePerUnit, subtotal: $subtotal, productUnit: $productUnit, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $OrderItemEntityCopyWith<$Res>  {
  factory $OrderItemEntityCopyWith(OrderItemEntity value, $Res Function(OrderItemEntity) _then) = _$OrderItemEntityCopyWithImpl;
@useResult
$Res call({
 String id, String productId, String productName, double quantity, double pricePerUnit, double subtotal, String? productUnit, String? thumbnailUrl
});




}
/// @nodoc
class _$OrderItemEntityCopyWithImpl<$Res>
    implements $OrderItemEntityCopyWith<$Res> {
  _$OrderItemEntityCopyWithImpl(this._self, this._then);

  final OrderItemEntity _self;
  final $Res Function(OrderItemEntity) _then;

/// Create a copy of OrderItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? quantity = null,Object? pricePerUnit = null,Object? subtotal = null,Object? productUnit = freezed,Object? thumbnailUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,productUnit: freezed == productUnit ? _self.productUnit : productUnit // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItemEntity].
extension OrderItemEntityPatterns on OrderItemEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  String productName,  double quantity,  double pricePerUnit,  double subtotal,  String? productUnit,  String? thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemEntity() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.productUnit,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  String productName,  double quantity,  double pricePerUnit,  double subtotal,  String? productUnit,  String? thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _OrderItemEntity():
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.productUnit,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  String productName,  double quantity,  double pricePerUnit,  double subtotal,  String? productUnit,  String? thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemEntity() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.productUnit,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc


class _OrderItemEntity implements OrderItemEntity {
  const _OrderItemEntity({required this.id, required this.productId, required this.productName, required this.quantity, required this.pricePerUnit, required this.subtotal, this.productUnit, this.thumbnailUrl});
  

@override final  String id;
@override final  String productId;
@override final  String productName;
@override final  double quantity;
@override final  double pricePerUnit;
@override final  double subtotal;
@override final  String? productUnit;
@override final  String? thumbnailUrl;

/// Create a copy of OrderItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemEntityCopyWith<_OrderItemEntity> get copyWith => __$OrderItemEntityCopyWithImpl<_OrderItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.productUnit, productUnit) || other.productUnit == productUnit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,quantity,pricePerUnit,subtotal,productUnit,thumbnailUrl);

@override
String toString() {
  return 'OrderItemEntity(id: $id, productId: $productId, productName: $productName, quantity: $quantity, pricePerUnit: $pricePerUnit, subtotal: $subtotal, productUnit: $productUnit, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$OrderItemEntityCopyWith<$Res> implements $OrderItemEntityCopyWith<$Res> {
  factory _$OrderItemEntityCopyWith(_OrderItemEntity value, $Res Function(_OrderItemEntity) _then) = __$OrderItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, String productName, double quantity, double pricePerUnit, double subtotal, String? productUnit, String? thumbnailUrl
});




}
/// @nodoc
class __$OrderItemEntityCopyWithImpl<$Res>
    implements _$OrderItemEntityCopyWith<$Res> {
  __$OrderItemEntityCopyWithImpl(this._self, this._then);

  final _OrderItemEntity _self;
  final $Res Function(_OrderItemEntity) _then;

/// Create a copy of OrderItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? quantity = null,Object? pricePerUnit = null,Object? subtotal = null,Object? productUnit = freezed,Object? thumbnailUrl = freezed,}) {
  return _then(_OrderItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,productUnit: freezed == productUnit ? _self.productUnit : productUnit // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$OrderParticipantEntity {

 String get id; String get name; String? get email; String? get avatarUrl; String? get regency; bool get isVerified;
/// Create a copy of OrderParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderParticipantEntityCopyWith<OrderParticipantEntity> get copyWith => _$OrderParticipantEntityCopyWithImpl<OrderParticipantEntity>(this as OrderParticipantEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderParticipantEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,regency,isVerified);

@override
String toString() {
  return 'OrderParticipantEntity(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, regency: $regency, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $OrderParticipantEntityCopyWith<$Res>  {
  factory $OrderParticipantEntityCopyWith(OrderParticipantEntity value, $Res Function(OrderParticipantEntity) _then) = _$OrderParticipantEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? email, String? avatarUrl, String? regency, bool isVerified
});




}
/// @nodoc
class _$OrderParticipantEntityCopyWithImpl<$Res>
    implements $OrderParticipantEntityCopyWith<$Res> {
  _$OrderParticipantEntityCopyWithImpl(this._self, this._then);

  final OrderParticipantEntity _self;
  final $Res Function(OrderParticipantEntity) _then;

/// Create a copy of OrderParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? avatarUrl = freezed,Object? regency = freezed,Object? isVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderParticipantEntity].
extension OrderParticipantEntityPatterns on OrderParticipantEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderParticipantEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderParticipantEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderParticipantEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderParticipantEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderParticipantEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderParticipantEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? email,  String? avatarUrl,  String? regency,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderParticipantEntity() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.regency,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? email,  String? avatarUrl,  String? regency,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _OrderParticipantEntity():
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.regency,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? email,  String? avatarUrl,  String? regency,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _OrderParticipantEntity() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.regency,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc


class _OrderParticipantEntity implements OrderParticipantEntity {
  const _OrderParticipantEntity({required this.id, required this.name, this.email, this.avatarUrl, this.regency, this.isVerified = false});
  

@override final  String id;
@override final  String name;
@override final  String? email;
@override final  String? avatarUrl;
@override final  String? regency;
@override@JsonKey() final  bool isVerified;

/// Create a copy of OrderParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderParticipantEntityCopyWith<_OrderParticipantEntity> get copyWith => __$OrderParticipantEntityCopyWithImpl<_OrderParticipantEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderParticipantEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,regency,isVerified);

@override
String toString() {
  return 'OrderParticipantEntity(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, regency: $regency, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$OrderParticipantEntityCopyWith<$Res> implements $OrderParticipantEntityCopyWith<$Res> {
  factory _$OrderParticipantEntityCopyWith(_OrderParticipantEntity value, $Res Function(_OrderParticipantEntity) _then) = __$OrderParticipantEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? email, String? avatarUrl, String? regency, bool isVerified
});




}
/// @nodoc
class __$OrderParticipantEntityCopyWithImpl<$Res>
    implements _$OrderParticipantEntityCopyWith<$Res> {
  __$OrderParticipantEntityCopyWithImpl(this._self, this._then);

  final _OrderParticipantEntity _self;
  final $Res Function(_OrderParticipantEntity) _then;

/// Create a copy of OrderParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? avatarUrl = freezed,Object? regency = freezed,Object? isVerified = null,}) {
  return _then(_OrderParticipantEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$OrderShipmentEntity {

/// Nomor tracking BISA (TRK-{orderNumber}), dari backend.
 String? get trackingNumber; String? get vesselName; String? get originHub; String? get destinationHub; String? get awbNumber; String? get courierCode; String? get deliveryStatus; DateTime? get lastTrackedAt; double? get currentLat; double? get currentLng; DateTime? get updatedAt;
/// Create a copy of OrderShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderShipmentEntityCopyWith<OrderShipmentEntity> get copyWith => _$OrderShipmentEntityCopyWithImpl<OrderShipmentEntity>(this as OrderShipmentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderShipmentEntity&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.originHub, originHub) || other.originHub == originHub)&&(identical(other.destinationHub, destinationHub) || other.destinationHub == destinationHub)&&(identical(other.awbNumber, awbNumber) || other.awbNumber == awbNumber)&&(identical(other.courierCode, courierCode) || other.courierCode == courierCode)&&(identical(other.deliveryStatus, deliveryStatus) || other.deliveryStatus == deliveryStatus)&&(identical(other.lastTrackedAt, lastTrackedAt) || other.lastTrackedAt == lastTrackedAt)&&(identical(other.currentLat, currentLat) || other.currentLat == currentLat)&&(identical(other.currentLng, currentLng) || other.currentLng == currentLng)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,trackingNumber,vesselName,originHub,destinationHub,awbNumber,courierCode,deliveryStatus,lastTrackedAt,currentLat,currentLng,updatedAt);

@override
String toString() {
  return 'OrderShipmentEntity(trackingNumber: $trackingNumber, vesselName: $vesselName, originHub: $originHub, destinationHub: $destinationHub, awbNumber: $awbNumber, courierCode: $courierCode, deliveryStatus: $deliveryStatus, lastTrackedAt: $lastTrackedAt, currentLat: $currentLat, currentLng: $currentLng, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderShipmentEntityCopyWith<$Res>  {
  factory $OrderShipmentEntityCopyWith(OrderShipmentEntity value, $Res Function(OrderShipmentEntity) _then) = _$OrderShipmentEntityCopyWithImpl;
@useResult
$Res call({
 String? trackingNumber, String? vesselName, String? originHub, String? destinationHub, String? awbNumber, String? courierCode, String? deliveryStatus, DateTime? lastTrackedAt, double? currentLat, double? currentLng, DateTime? updatedAt
});




}
/// @nodoc
class _$OrderShipmentEntityCopyWithImpl<$Res>
    implements $OrderShipmentEntityCopyWith<$Res> {
  _$OrderShipmentEntityCopyWithImpl(this._self, this._then);

  final OrderShipmentEntity _self;
  final $Res Function(OrderShipmentEntity) _then;

/// Create a copy of OrderShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackingNumber = freezed,Object? vesselName = freezed,Object? originHub = freezed,Object? destinationHub = freezed,Object? awbNumber = freezed,Object? courierCode = freezed,Object? deliveryStatus = freezed,Object? lastTrackedAt = freezed,Object? currentLat = freezed,Object? currentLng = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,originHub: freezed == originHub ? _self.originHub : originHub // ignore: cast_nullable_to_non_nullable
as String?,destinationHub: freezed == destinationHub ? _self.destinationHub : destinationHub // ignore: cast_nullable_to_non_nullable
as String?,awbNumber: freezed == awbNumber ? _self.awbNumber : awbNumber // ignore: cast_nullable_to_non_nullable
as String?,courierCode: freezed == courierCode ? _self.courierCode : courierCode // ignore: cast_nullable_to_non_nullable
as String?,deliveryStatus: freezed == deliveryStatus ? _self.deliveryStatus : deliveryStatus // ignore: cast_nullable_to_non_nullable
as String?,lastTrackedAt: freezed == lastTrackedAt ? _self.lastTrackedAt : lastTrackedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentLat: freezed == currentLat ? _self.currentLat : currentLat // ignore: cast_nullable_to_non_nullable
as double?,currentLng: freezed == currentLng ? _self.currentLng : currentLng // ignore: cast_nullable_to_non_nullable
as double?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderShipmentEntity].
extension OrderShipmentEntityPatterns on OrderShipmentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderShipmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderShipmentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderShipmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderShipmentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderShipmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderShipmentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? trackingNumber,  String? vesselName,  String? originHub,  String? destinationHub,  String? awbNumber,  String? courierCode,  String? deliveryStatus,  DateTime? lastTrackedAt,  double? currentLat,  double? currentLng,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderShipmentEntity() when $default != null:
return $default(_that.trackingNumber,_that.vesselName,_that.originHub,_that.destinationHub,_that.awbNumber,_that.courierCode,_that.deliveryStatus,_that.lastTrackedAt,_that.currentLat,_that.currentLng,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? trackingNumber,  String? vesselName,  String? originHub,  String? destinationHub,  String? awbNumber,  String? courierCode,  String? deliveryStatus,  DateTime? lastTrackedAt,  double? currentLat,  double? currentLng,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderShipmentEntity():
return $default(_that.trackingNumber,_that.vesselName,_that.originHub,_that.destinationHub,_that.awbNumber,_that.courierCode,_that.deliveryStatus,_that.lastTrackedAt,_that.currentLat,_that.currentLng,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? trackingNumber,  String? vesselName,  String? originHub,  String? destinationHub,  String? awbNumber,  String? courierCode,  String? deliveryStatus,  DateTime? lastTrackedAt,  double? currentLat,  double? currentLng,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderShipmentEntity() when $default != null:
return $default(_that.trackingNumber,_that.vesselName,_that.originHub,_that.destinationHub,_that.awbNumber,_that.courierCode,_that.deliveryStatus,_that.lastTrackedAt,_that.currentLat,_that.currentLng,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _OrderShipmentEntity implements OrderShipmentEntity {
  const _OrderShipmentEntity({this.trackingNumber, this.vesselName, this.originHub, this.destinationHub, this.awbNumber, this.courierCode, this.deliveryStatus, this.lastTrackedAt, this.currentLat, this.currentLng, this.updatedAt});
  

/// Nomor tracking BISA (TRK-{orderNumber}), dari backend.
@override final  String? trackingNumber;
@override final  String? vesselName;
@override final  String? originHub;
@override final  String? destinationHub;
@override final  String? awbNumber;
@override final  String? courierCode;
@override final  String? deliveryStatus;
@override final  DateTime? lastTrackedAt;
@override final  double? currentLat;
@override final  double? currentLng;
@override final  DateTime? updatedAt;

/// Create a copy of OrderShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderShipmentEntityCopyWith<_OrderShipmentEntity> get copyWith => __$OrderShipmentEntityCopyWithImpl<_OrderShipmentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderShipmentEntity&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.originHub, originHub) || other.originHub == originHub)&&(identical(other.destinationHub, destinationHub) || other.destinationHub == destinationHub)&&(identical(other.awbNumber, awbNumber) || other.awbNumber == awbNumber)&&(identical(other.courierCode, courierCode) || other.courierCode == courierCode)&&(identical(other.deliveryStatus, deliveryStatus) || other.deliveryStatus == deliveryStatus)&&(identical(other.lastTrackedAt, lastTrackedAt) || other.lastTrackedAt == lastTrackedAt)&&(identical(other.currentLat, currentLat) || other.currentLat == currentLat)&&(identical(other.currentLng, currentLng) || other.currentLng == currentLng)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,trackingNumber,vesselName,originHub,destinationHub,awbNumber,courierCode,deliveryStatus,lastTrackedAt,currentLat,currentLng,updatedAt);

@override
String toString() {
  return 'OrderShipmentEntity(trackingNumber: $trackingNumber, vesselName: $vesselName, originHub: $originHub, destinationHub: $destinationHub, awbNumber: $awbNumber, courierCode: $courierCode, deliveryStatus: $deliveryStatus, lastTrackedAt: $lastTrackedAt, currentLat: $currentLat, currentLng: $currentLng, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderShipmentEntityCopyWith<$Res> implements $OrderShipmentEntityCopyWith<$Res> {
  factory _$OrderShipmentEntityCopyWith(_OrderShipmentEntity value, $Res Function(_OrderShipmentEntity) _then) = __$OrderShipmentEntityCopyWithImpl;
@override @useResult
$Res call({
 String? trackingNumber, String? vesselName, String? originHub, String? destinationHub, String? awbNumber, String? courierCode, String? deliveryStatus, DateTime? lastTrackedAt, double? currentLat, double? currentLng, DateTime? updatedAt
});




}
/// @nodoc
class __$OrderShipmentEntityCopyWithImpl<$Res>
    implements _$OrderShipmentEntityCopyWith<$Res> {
  __$OrderShipmentEntityCopyWithImpl(this._self, this._then);

  final _OrderShipmentEntity _self;
  final $Res Function(_OrderShipmentEntity) _then;

/// Create a copy of OrderShipmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackingNumber = freezed,Object? vesselName = freezed,Object? originHub = freezed,Object? destinationHub = freezed,Object? awbNumber = freezed,Object? courierCode = freezed,Object? deliveryStatus = freezed,Object? lastTrackedAt = freezed,Object? currentLat = freezed,Object? currentLng = freezed,Object? updatedAt = freezed,}) {
  return _then(_OrderShipmentEntity(
trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,originHub: freezed == originHub ? _self.originHub : originHub // ignore: cast_nullable_to_non_nullable
as String?,destinationHub: freezed == destinationHub ? _self.destinationHub : destinationHub // ignore: cast_nullable_to_non_nullable
as String?,awbNumber: freezed == awbNumber ? _self.awbNumber : awbNumber // ignore: cast_nullable_to_non_nullable
as String?,courierCode: freezed == courierCode ? _self.courierCode : courierCode // ignore: cast_nullable_to_non_nullable
as String?,deliveryStatus: freezed == deliveryStatus ? _self.deliveryStatus : deliveryStatus // ignore: cast_nullable_to_non_nullable
as String?,lastTrackedAt: freezed == lastTrackedAt ? _self.lastTrackedAt : lastTrackedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentLat: freezed == currentLat ? _self.currentLat : currentLat // ignore: cast_nullable_to_non_nullable
as double?,currentLng: freezed == currentLng ? _self.currentLng : currentLng // ignore: cast_nullable_to_non_nullable
as double?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$OrderShippingEntity {

 int? get originDestinationId; int? get destinationDestinationId; String? get originLabel; String? get destinationLabel; double? get weightGrams; String? get courierCode; String? get courierName; String? get serviceCode; String? get serviceName; String? get serviceDescription; double? get shippingCost; String? get etd; DateTime? get verifiedAt;
/// Create a copy of OrderShippingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderShippingEntityCopyWith<OrderShippingEntity> get copyWith => _$OrderShippingEntityCopyWithImpl<OrderShippingEntity>(this as OrderShippingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderShippingEntity&&(identical(other.originDestinationId, originDestinationId) || other.originDestinationId == originDestinationId)&&(identical(other.destinationDestinationId, destinationDestinationId) || other.destinationDestinationId == destinationDestinationId)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destinationLabel, destinationLabel) || other.destinationLabel == destinationLabel)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&(identical(other.courierCode, courierCode) || other.courierCode == courierCode)&&(identical(other.courierName, courierName) || other.courierName == courierName)&&(identical(other.serviceCode, serviceCode) || other.serviceCode == serviceCode)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.serviceDescription, serviceDescription) || other.serviceDescription == serviceDescription)&&(identical(other.shippingCost, shippingCost) || other.shippingCost == shippingCost)&&(identical(other.etd, etd) || other.etd == etd)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}


@override
int get hashCode => Object.hash(runtimeType,originDestinationId,destinationDestinationId,originLabel,destinationLabel,weightGrams,courierCode,courierName,serviceCode,serviceName,serviceDescription,shippingCost,etd,verifiedAt);

@override
String toString() {
  return 'OrderShippingEntity(originDestinationId: $originDestinationId, destinationDestinationId: $destinationDestinationId, originLabel: $originLabel, destinationLabel: $destinationLabel, weightGrams: $weightGrams, courierCode: $courierCode, courierName: $courierName, serviceCode: $serviceCode, serviceName: $serviceName, serviceDescription: $serviceDescription, shippingCost: $shippingCost, etd: $etd, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class $OrderShippingEntityCopyWith<$Res>  {
  factory $OrderShippingEntityCopyWith(OrderShippingEntity value, $Res Function(OrderShippingEntity) _then) = _$OrderShippingEntityCopyWithImpl;
@useResult
$Res call({
 int? originDestinationId, int? destinationDestinationId, String? originLabel, String? destinationLabel, double? weightGrams, String? courierCode, String? courierName, String? serviceCode, String? serviceName, String? serviceDescription, double? shippingCost, String? etd, DateTime? verifiedAt
});




}
/// @nodoc
class _$OrderShippingEntityCopyWithImpl<$Res>
    implements $OrderShippingEntityCopyWith<$Res> {
  _$OrderShippingEntityCopyWithImpl(this._self, this._then);

  final OrderShippingEntity _self;
  final $Res Function(OrderShippingEntity) _then;

/// Create a copy of OrderShippingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originDestinationId = freezed,Object? destinationDestinationId = freezed,Object? originLabel = freezed,Object? destinationLabel = freezed,Object? weightGrams = freezed,Object? courierCode = freezed,Object? courierName = freezed,Object? serviceCode = freezed,Object? serviceName = freezed,Object? serviceDescription = freezed,Object? shippingCost = freezed,Object? etd = freezed,Object? verifiedAt = freezed,}) {
  return _then(_self.copyWith(
originDestinationId: freezed == originDestinationId ? _self.originDestinationId : originDestinationId // ignore: cast_nullable_to_non_nullable
as int?,destinationDestinationId: freezed == destinationDestinationId ? _self.destinationDestinationId : destinationDestinationId // ignore: cast_nullable_to_non_nullable
as int?,originLabel: freezed == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String?,destinationLabel: freezed == destinationLabel ? _self.destinationLabel : destinationLabel // ignore: cast_nullable_to_non_nullable
as String?,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as double?,courierCode: freezed == courierCode ? _self.courierCode : courierCode // ignore: cast_nullable_to_non_nullable
as String?,courierName: freezed == courierName ? _self.courierName : courierName // ignore: cast_nullable_to_non_nullable
as String?,serviceCode: freezed == serviceCode ? _self.serviceCode : serviceCode // ignore: cast_nullable_to_non_nullable
as String?,serviceName: freezed == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String?,serviceDescription: freezed == serviceDescription ? _self.serviceDescription : serviceDescription // ignore: cast_nullable_to_non_nullable
as String?,shippingCost: freezed == shippingCost ? _self.shippingCost : shippingCost // ignore: cast_nullable_to_non_nullable
as double?,etd: freezed == etd ? _self.etd : etd // ignore: cast_nullable_to_non_nullable
as String?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderShippingEntity].
extension OrderShippingEntityPatterns on OrderShippingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderShippingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderShippingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderShippingEntity value)  $default,){
final _that = this;
switch (_that) {
case _OrderShippingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderShippingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _OrderShippingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? originDestinationId,  int? destinationDestinationId,  String? originLabel,  String? destinationLabel,  double? weightGrams,  String? courierCode,  String? courierName,  String? serviceCode,  String? serviceName,  String? serviceDescription,  double? shippingCost,  String? etd,  DateTime? verifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderShippingEntity() when $default != null:
return $default(_that.originDestinationId,_that.destinationDestinationId,_that.originLabel,_that.destinationLabel,_that.weightGrams,_that.courierCode,_that.courierName,_that.serviceCode,_that.serviceName,_that.serviceDescription,_that.shippingCost,_that.etd,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? originDestinationId,  int? destinationDestinationId,  String? originLabel,  String? destinationLabel,  double? weightGrams,  String? courierCode,  String? courierName,  String? serviceCode,  String? serviceName,  String? serviceDescription,  double? shippingCost,  String? etd,  DateTime? verifiedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderShippingEntity():
return $default(_that.originDestinationId,_that.destinationDestinationId,_that.originLabel,_that.destinationLabel,_that.weightGrams,_that.courierCode,_that.courierName,_that.serviceCode,_that.serviceName,_that.serviceDescription,_that.shippingCost,_that.etd,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? originDestinationId,  int? destinationDestinationId,  String? originLabel,  String? destinationLabel,  double? weightGrams,  String? courierCode,  String? courierName,  String? serviceCode,  String? serviceName,  String? serviceDescription,  double? shippingCost,  String? etd,  DateTime? verifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderShippingEntity() when $default != null:
return $default(_that.originDestinationId,_that.destinationDestinationId,_that.originLabel,_that.destinationLabel,_that.weightGrams,_that.courierCode,_that.courierName,_that.serviceCode,_that.serviceName,_that.serviceDescription,_that.shippingCost,_that.etd,_that.verifiedAt);case _:
  return null;

}
}

}

/// @nodoc


class _OrderShippingEntity implements OrderShippingEntity {
  const _OrderShippingEntity({this.originDestinationId, this.destinationDestinationId, this.originLabel, this.destinationLabel, this.weightGrams, this.courierCode, this.courierName, this.serviceCode, this.serviceName, this.serviceDescription, this.shippingCost, this.etd, this.verifiedAt});
  

@override final  int? originDestinationId;
@override final  int? destinationDestinationId;
@override final  String? originLabel;
@override final  String? destinationLabel;
@override final  double? weightGrams;
@override final  String? courierCode;
@override final  String? courierName;
@override final  String? serviceCode;
@override final  String? serviceName;
@override final  String? serviceDescription;
@override final  double? shippingCost;
@override final  String? etd;
@override final  DateTime? verifiedAt;

/// Create a copy of OrderShippingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderShippingEntityCopyWith<_OrderShippingEntity> get copyWith => __$OrderShippingEntityCopyWithImpl<_OrderShippingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderShippingEntity&&(identical(other.originDestinationId, originDestinationId) || other.originDestinationId == originDestinationId)&&(identical(other.destinationDestinationId, destinationDestinationId) || other.destinationDestinationId == destinationDestinationId)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destinationLabel, destinationLabel) || other.destinationLabel == destinationLabel)&&(identical(other.weightGrams, weightGrams) || other.weightGrams == weightGrams)&&(identical(other.courierCode, courierCode) || other.courierCode == courierCode)&&(identical(other.courierName, courierName) || other.courierName == courierName)&&(identical(other.serviceCode, serviceCode) || other.serviceCode == serviceCode)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.serviceDescription, serviceDescription) || other.serviceDescription == serviceDescription)&&(identical(other.shippingCost, shippingCost) || other.shippingCost == shippingCost)&&(identical(other.etd, etd) || other.etd == etd)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}


@override
int get hashCode => Object.hash(runtimeType,originDestinationId,destinationDestinationId,originLabel,destinationLabel,weightGrams,courierCode,courierName,serviceCode,serviceName,serviceDescription,shippingCost,etd,verifiedAt);

@override
String toString() {
  return 'OrderShippingEntity(originDestinationId: $originDestinationId, destinationDestinationId: $destinationDestinationId, originLabel: $originLabel, destinationLabel: $destinationLabel, weightGrams: $weightGrams, courierCode: $courierCode, courierName: $courierName, serviceCode: $serviceCode, serviceName: $serviceName, serviceDescription: $serviceDescription, shippingCost: $shippingCost, etd: $etd, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderShippingEntityCopyWith<$Res> implements $OrderShippingEntityCopyWith<$Res> {
  factory _$OrderShippingEntityCopyWith(_OrderShippingEntity value, $Res Function(_OrderShippingEntity) _then) = __$OrderShippingEntityCopyWithImpl;
@override @useResult
$Res call({
 int? originDestinationId, int? destinationDestinationId, String? originLabel, String? destinationLabel, double? weightGrams, String? courierCode, String? courierName, String? serviceCode, String? serviceName, String? serviceDescription, double? shippingCost, String? etd, DateTime? verifiedAt
});




}
/// @nodoc
class __$OrderShippingEntityCopyWithImpl<$Res>
    implements _$OrderShippingEntityCopyWith<$Res> {
  __$OrderShippingEntityCopyWithImpl(this._self, this._then);

  final _OrderShippingEntity _self;
  final $Res Function(_OrderShippingEntity) _then;

/// Create a copy of OrderShippingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originDestinationId = freezed,Object? destinationDestinationId = freezed,Object? originLabel = freezed,Object? destinationLabel = freezed,Object? weightGrams = freezed,Object? courierCode = freezed,Object? courierName = freezed,Object? serviceCode = freezed,Object? serviceName = freezed,Object? serviceDescription = freezed,Object? shippingCost = freezed,Object? etd = freezed,Object? verifiedAt = freezed,}) {
  return _then(_OrderShippingEntity(
originDestinationId: freezed == originDestinationId ? _self.originDestinationId : originDestinationId // ignore: cast_nullable_to_non_nullable
as int?,destinationDestinationId: freezed == destinationDestinationId ? _self.destinationDestinationId : destinationDestinationId // ignore: cast_nullable_to_non_nullable
as int?,originLabel: freezed == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String?,destinationLabel: freezed == destinationLabel ? _self.destinationLabel : destinationLabel // ignore: cast_nullable_to_non_nullable
as String?,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as double?,courierCode: freezed == courierCode ? _self.courierCode : courierCode // ignore: cast_nullable_to_non_nullable
as String?,courierName: freezed == courierName ? _self.courierName : courierName // ignore: cast_nullable_to_non_nullable
as String?,serviceCode: freezed == serviceCode ? _self.serviceCode : serviceCode // ignore: cast_nullable_to_non_nullable
as String?,serviceName: freezed == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String?,serviceDescription: freezed == serviceDescription ? _self.serviceDescription : serviceDescription // ignore: cast_nullable_to_non_nullable
as String?,shippingCost: freezed == shippingCost ? _self.shippingCost : shippingCost // ignore: cast_nullable_to_non_nullable
as double?,etd: freezed == etd ? _self.etd : etd // ignore: cast_nullable_to_non_nullable
as String?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
