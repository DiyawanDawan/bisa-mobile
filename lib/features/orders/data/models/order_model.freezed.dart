// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderModel {

 String get id; String get orderNumber; String? get checkoutBatchId;@JsonKey(name: 'checkoutBatchNumber') String? get checkoutBatchNumber; String get status; String get orderType; dynamic get totalAmount; dynamic get totalQuantity; dynamic get subtotal; dynamic get platformFee;@JsonKey(name: 'logisticsFee') dynamic get logisticsFee; dynamic get vatAmount; String? get specifications; Map<String, dynamic>? get shippingAddressSnapshot; String get createdAt; List<OrderItemModel> get items; OrderParticipantModel get buyer; OrderParticipantModel get seller; OrderTransactionModel? get transaction; OrderShipmentModel? get shipment; OrderShippingModel? get orderShipping; OrderReviewModel? get review; Map<String, dynamic>? get pendingPayment; Map<String, dynamic>? get dispute; String? get negotiationId; bool get isDigitalSigned; String? get buyerSignedAt; String? get sellerSignedAt;
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderModelCopyWith<OrderModel> get copyWith => _$OrderModelCopyWithImpl<OrderModel>(this as OrderModel, _$identity);

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.checkoutBatchId, checkoutBatchId) || other.checkoutBatchId == checkoutBatchId)&&(identical(other.checkoutBatchNumber, checkoutBatchNumber) || other.checkoutBatchNumber == checkoutBatchNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&const DeepCollectionEquality().equals(other.totalAmount, totalAmount)&&const DeepCollectionEquality().equals(other.totalQuantity, totalQuantity)&&const DeepCollectionEquality().equals(other.subtotal, subtotal)&&const DeepCollectionEquality().equals(other.platformFee, platformFee)&&const DeepCollectionEquality().equals(other.logisticsFee, logisticsFee)&&const DeepCollectionEquality().equals(other.vatAmount, vatAmount)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&const DeepCollectionEquality().equals(other.shippingAddressSnapshot, shippingAddressSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.shipment, shipment) || other.shipment == shipment)&&(identical(other.orderShipping, orderShipping) || other.orderShipping == orderShipping)&&(identical(other.review, review) || other.review == review)&&const DeepCollectionEquality().equals(other.pendingPayment, pendingPayment)&&const DeepCollectionEquality().equals(other.dispute, dispute)&&(identical(other.negotiationId, negotiationId) || other.negotiationId == negotiationId)&&(identical(other.isDigitalSigned, isDigitalSigned) || other.isDigitalSigned == isDigitalSigned)&&(identical(other.buyerSignedAt, buyerSignedAt) || other.buyerSignedAt == buyerSignedAt)&&(identical(other.sellerSignedAt, sellerSignedAt) || other.sellerSignedAt == sellerSignedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,checkoutBatchId,checkoutBatchNumber,status,orderType,const DeepCollectionEquality().hash(totalAmount),const DeepCollectionEquality().hash(totalQuantity),const DeepCollectionEquality().hash(subtotal),const DeepCollectionEquality().hash(platformFee),const DeepCollectionEquality().hash(logisticsFee),const DeepCollectionEquality().hash(vatAmount),specifications,const DeepCollectionEquality().hash(shippingAddressSnapshot),createdAt,const DeepCollectionEquality().hash(items),buyer,seller,transaction,shipment,orderShipping,review,const DeepCollectionEquality().hash(pendingPayment),const DeepCollectionEquality().hash(dispute),negotiationId,isDigitalSigned,buyerSignedAt,sellerSignedAt]);

@override
String toString() {
  return 'OrderModel(id: $id, orderNumber: $orderNumber, checkoutBatchId: $checkoutBatchId, checkoutBatchNumber: $checkoutBatchNumber, status: $status, orderType: $orderType, totalAmount: $totalAmount, totalQuantity: $totalQuantity, subtotal: $subtotal, platformFee: $platformFee, logisticsFee: $logisticsFee, vatAmount: $vatAmount, specifications: $specifications, shippingAddressSnapshot: $shippingAddressSnapshot, createdAt: $createdAt, items: $items, buyer: $buyer, seller: $seller, transaction: $transaction, shipment: $shipment, orderShipping: $orderShipping, review: $review, pendingPayment: $pendingPayment, dispute: $dispute, negotiationId: $negotiationId, isDigitalSigned: $isDigitalSigned, buyerSignedAt: $buyerSignedAt, sellerSignedAt: $sellerSignedAt)';
}


}

/// @nodoc
abstract mixin class $OrderModelCopyWith<$Res>  {
  factory $OrderModelCopyWith(OrderModel value, $Res Function(OrderModel) _then) = _$OrderModelCopyWithImpl;
@useResult
$Res call({
 String id, String orderNumber, String? checkoutBatchId,@JsonKey(name: 'checkoutBatchNumber') String? checkoutBatchNumber, String status, String orderType, dynamic totalAmount, dynamic totalQuantity, dynamic subtotal, dynamic platformFee,@JsonKey(name: 'logisticsFee') dynamic logisticsFee, dynamic vatAmount, String? specifications, Map<String, dynamic>? shippingAddressSnapshot, String createdAt, List<OrderItemModel> items, OrderParticipantModel buyer, OrderParticipantModel seller, OrderTransactionModel? transaction, OrderShipmentModel? shipment, OrderShippingModel? orderShipping, OrderReviewModel? review, Map<String, dynamic>? pendingPayment, Map<String, dynamic>? dispute, String? negotiationId, bool isDigitalSigned, String? buyerSignedAt, String? sellerSignedAt
});


$OrderParticipantModelCopyWith<$Res> get buyer;$OrderParticipantModelCopyWith<$Res> get seller;$OrderTransactionModelCopyWith<$Res>? get transaction;$OrderShipmentModelCopyWith<$Res>? get shipment;$OrderShippingModelCopyWith<$Res>? get orderShipping;$OrderReviewModelCopyWith<$Res>? get review;

}
/// @nodoc
class _$OrderModelCopyWithImpl<$Res>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._self, this._then);

  final OrderModel _self;
  final $Res Function(OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderNumber = null,Object? checkoutBatchId = freezed,Object? checkoutBatchNumber = freezed,Object? status = null,Object? orderType = null,Object? totalAmount = freezed,Object? totalQuantity = freezed,Object? subtotal = freezed,Object? platformFee = freezed,Object? logisticsFee = freezed,Object? vatAmount = freezed,Object? specifications = freezed,Object? shippingAddressSnapshot = freezed,Object? createdAt = null,Object? items = null,Object? buyer = null,Object? seller = null,Object? transaction = freezed,Object? shipment = freezed,Object? orderShipping = freezed,Object? review = freezed,Object? pendingPayment = freezed,Object? dispute = freezed,Object? negotiationId = freezed,Object? isDigitalSigned = null,Object? buyerSignedAt = freezed,Object? sellerSignedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,checkoutBatchId: freezed == checkoutBatchId ? _self.checkoutBatchId : checkoutBatchId // ignore: cast_nullable_to_non_nullable
as String?,checkoutBatchNumber: freezed == checkoutBatchNumber ? _self.checkoutBatchNumber : checkoutBatchNumber // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as dynamic,totalQuantity: freezed == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as dynamic,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as dynamic,platformFee: freezed == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as dynamic,logisticsFee: freezed == logisticsFee ? _self.logisticsFee : logisticsFee // ignore: cast_nullable_to_non_nullable
as dynamic,vatAmount: freezed == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as dynamic,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,shippingAddressSnapshot: freezed == shippingAddressSnapshot ? _self.shippingAddressSnapshot : shippingAddressSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemModel>,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as OrderParticipantModel,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as OrderParticipantModel,transaction: freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as OrderTransactionModel?,shipment: freezed == shipment ? _self.shipment : shipment // ignore: cast_nullable_to_non_nullable
as OrderShipmentModel?,orderShipping: freezed == orderShipping ? _self.orderShipping : orderShipping // ignore: cast_nullable_to_non_nullable
as OrderShippingModel?,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as OrderReviewModel?,pendingPayment: freezed == pendingPayment ? _self.pendingPayment : pendingPayment // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,dispute: freezed == dispute ? _self.dispute : dispute // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,negotiationId: freezed == negotiationId ? _self.negotiationId : negotiationId // ignore: cast_nullable_to_non_nullable
as String?,isDigitalSigned: null == isDigitalSigned ? _self.isDigitalSigned : isDigitalSigned // ignore: cast_nullable_to_non_nullable
as bool,buyerSignedAt: freezed == buyerSignedAt ? _self.buyerSignedAt : buyerSignedAt // ignore: cast_nullable_to_non_nullable
as String?,sellerSignedAt: freezed == sellerSignedAt ? _self.sellerSignedAt : sellerSignedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderParticipantModelCopyWith<$Res> get buyer {
  
  return $OrderParticipantModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderParticipantModelCopyWith<$Res> get seller {
  
  return $OrderParticipantModelCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderTransactionModelCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $OrderTransactionModelCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderShipmentModelCopyWith<$Res>? get shipment {
    if (_self.shipment == null) {
    return null;
  }

  return $OrderShipmentModelCopyWith<$Res>(_self.shipment!, (value) {
    return _then(_self.copyWith(shipment: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderShippingModelCopyWith<$Res>? get orderShipping {
    if (_self.orderShipping == null) {
    return null;
  }

  return $OrderShippingModelCopyWith<$Res>(_self.orderShipping!, (value) {
    return _then(_self.copyWith(orderShipping: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderReviewModelCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $OrderReviewModelCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderModel].
extension OrderModelPatterns on OrderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String? checkoutBatchId, @JsonKey(name: 'checkoutBatchNumber')  String? checkoutBatchNumber,  String status,  String orderType,  dynamic totalAmount,  dynamic totalQuantity,  dynamic subtotal,  dynamic platformFee, @JsonKey(name: 'logisticsFee')  dynamic logisticsFee,  dynamic vatAmount,  String? specifications,  Map<String, dynamic>? shippingAddressSnapshot,  String createdAt,  List<OrderItemModel> items,  OrderParticipantModel buyer,  OrderParticipantModel seller,  OrderTransactionModel? transaction,  OrderShipmentModel? shipment,  OrderShippingModel? orderShipping,  OrderReviewModel? review,  Map<String, dynamic>? pendingPayment,  Map<String, dynamic>? dispute,  String? negotiationId,  bool isDigitalSigned,  String? buyerSignedAt,  String? sellerSignedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orderNumber,  String? checkoutBatchId, @JsonKey(name: 'checkoutBatchNumber')  String? checkoutBatchNumber,  String status,  String orderType,  dynamic totalAmount,  dynamic totalQuantity,  dynamic subtotal,  dynamic platformFee, @JsonKey(name: 'logisticsFee')  dynamic logisticsFee,  dynamic vatAmount,  String? specifications,  Map<String, dynamic>? shippingAddressSnapshot,  String createdAt,  List<OrderItemModel> items,  OrderParticipantModel buyer,  OrderParticipantModel seller,  OrderTransactionModel? transaction,  OrderShipmentModel? shipment,  OrderShippingModel? orderShipping,  OrderReviewModel? review,  Map<String, dynamic>? pendingPayment,  Map<String, dynamic>? dispute,  String? negotiationId,  bool isDigitalSigned,  String? buyerSignedAt,  String? sellerSignedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orderNumber,  String? checkoutBatchId, @JsonKey(name: 'checkoutBatchNumber')  String? checkoutBatchNumber,  String status,  String orderType,  dynamic totalAmount,  dynamic totalQuantity,  dynamic subtotal,  dynamic platformFee, @JsonKey(name: 'logisticsFee')  dynamic logisticsFee,  dynamic vatAmount,  String? specifications,  Map<String, dynamic>? shippingAddressSnapshot,  String createdAt,  List<OrderItemModel> items,  OrderParticipantModel buyer,  OrderParticipantModel seller,  OrderTransactionModel? transaction,  OrderShipmentModel? shipment,  OrderShippingModel? orderShipping,  OrderReviewModel? review,  Map<String, dynamic>? pendingPayment,  Map<String, dynamic>? dispute,  String? negotiationId,  bool isDigitalSigned,  String? buyerSignedAt,  String? sellerSignedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderModel() when $default != null:
return $default(_that.id,_that.orderNumber,_that.checkoutBatchId,_that.checkoutBatchNumber,_that.status,_that.orderType,_that.totalAmount,_that.totalQuantity,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.specifications,_that.shippingAddressSnapshot,_that.createdAt,_that.items,_that.buyer,_that.seller,_that.transaction,_that.shipment,_that.orderShipping,_that.review,_that.pendingPayment,_that.dispute,_that.negotiationId,_that.isDigitalSigned,_that.buyerSignedAt,_that.sellerSignedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderModel extends OrderModel {
  const _OrderModel({required this.id, required this.orderNumber, this.checkoutBatchId, @JsonKey(name: 'checkoutBatchNumber') this.checkoutBatchNumber, required this.status, this.orderType = 'STANDARD', required this.totalAmount, required this.totalQuantity, required this.subtotal, required this.platformFee, @JsonKey(name: 'logisticsFee') this.logisticsFee, required this.vatAmount, this.specifications, final  Map<String, dynamic>? shippingAddressSnapshot, required this.createdAt, required final  List<OrderItemModel> items, required this.buyer, required this.seller, this.transaction, this.shipment, this.orderShipping, this.review, final  Map<String, dynamic>? pendingPayment, final  Map<String, dynamic>? dispute, this.negotiationId, this.isDigitalSigned = false, this.buyerSignedAt, this.sellerSignedAt}): _shippingAddressSnapshot = shippingAddressSnapshot,_items = items,_pendingPayment = pendingPayment,_dispute = dispute,super._();
  factory _OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

@override final  String id;
@override final  String orderNumber;
@override final  String? checkoutBatchId;
@override@JsonKey(name: 'checkoutBatchNumber') final  String? checkoutBatchNumber;
@override final  String status;
@override@JsonKey() final  String orderType;
@override final  dynamic totalAmount;
@override final  dynamic totalQuantity;
@override final  dynamic subtotal;
@override final  dynamic platformFee;
@override@JsonKey(name: 'logisticsFee') final  dynamic logisticsFee;
@override final  dynamic vatAmount;
@override final  String? specifications;
 final  Map<String, dynamic>? _shippingAddressSnapshot;
@override Map<String, dynamic>? get shippingAddressSnapshot {
  final value = _shippingAddressSnapshot;
  if (value == null) return null;
  if (_shippingAddressSnapshot is EqualUnmodifiableMapView) return _shippingAddressSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String createdAt;
 final  List<OrderItemModel> _items;
@override List<OrderItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  OrderParticipantModel buyer;
@override final  OrderParticipantModel seller;
@override final  OrderTransactionModel? transaction;
@override final  OrderShipmentModel? shipment;
@override final  OrderShippingModel? orderShipping;
@override final  OrderReviewModel? review;
 final  Map<String, dynamic>? _pendingPayment;
@override Map<String, dynamic>? get pendingPayment {
  final value = _pendingPayment;
  if (value == null) return null;
  if (_pendingPayment is EqualUnmodifiableMapView) return _pendingPayment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _dispute;
@override Map<String, dynamic>? get dispute {
  final value = _dispute;
  if (value == null) return null;
  if (_dispute is EqualUnmodifiableMapView) return _dispute;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? negotiationId;
@override@JsonKey() final  bool isDigitalSigned;
@override final  String? buyerSignedAt;
@override final  String? sellerSignedAt;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderModelCopyWith<_OrderModel> get copyWith => __$OrderModelCopyWithImpl<_OrderModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.checkoutBatchId, checkoutBatchId) || other.checkoutBatchId == checkoutBatchId)&&(identical(other.checkoutBatchNumber, checkoutBatchNumber) || other.checkoutBatchNumber == checkoutBatchNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&const DeepCollectionEquality().equals(other.totalAmount, totalAmount)&&const DeepCollectionEquality().equals(other.totalQuantity, totalQuantity)&&const DeepCollectionEquality().equals(other.subtotal, subtotal)&&const DeepCollectionEquality().equals(other.platformFee, platformFee)&&const DeepCollectionEquality().equals(other.logisticsFee, logisticsFee)&&const DeepCollectionEquality().equals(other.vatAmount, vatAmount)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&const DeepCollectionEquality().equals(other._shippingAddressSnapshot, _shippingAddressSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.transaction, transaction) || other.transaction == transaction)&&(identical(other.shipment, shipment) || other.shipment == shipment)&&(identical(other.orderShipping, orderShipping) || other.orderShipping == orderShipping)&&(identical(other.review, review) || other.review == review)&&const DeepCollectionEquality().equals(other._pendingPayment, _pendingPayment)&&const DeepCollectionEquality().equals(other._dispute, _dispute)&&(identical(other.negotiationId, negotiationId) || other.negotiationId == negotiationId)&&(identical(other.isDigitalSigned, isDigitalSigned) || other.isDigitalSigned == isDigitalSigned)&&(identical(other.buyerSignedAt, buyerSignedAt) || other.buyerSignedAt == buyerSignedAt)&&(identical(other.sellerSignedAt, sellerSignedAt) || other.sellerSignedAt == sellerSignedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderNumber,checkoutBatchId,checkoutBatchNumber,status,orderType,const DeepCollectionEquality().hash(totalAmount),const DeepCollectionEquality().hash(totalQuantity),const DeepCollectionEquality().hash(subtotal),const DeepCollectionEquality().hash(platformFee),const DeepCollectionEquality().hash(logisticsFee),const DeepCollectionEquality().hash(vatAmount),specifications,const DeepCollectionEquality().hash(_shippingAddressSnapshot),createdAt,const DeepCollectionEquality().hash(_items),buyer,seller,transaction,shipment,orderShipping,review,const DeepCollectionEquality().hash(_pendingPayment),const DeepCollectionEquality().hash(_dispute),negotiationId,isDigitalSigned,buyerSignedAt,sellerSignedAt]);

@override
String toString() {
  return 'OrderModel(id: $id, orderNumber: $orderNumber, checkoutBatchId: $checkoutBatchId, checkoutBatchNumber: $checkoutBatchNumber, status: $status, orderType: $orderType, totalAmount: $totalAmount, totalQuantity: $totalQuantity, subtotal: $subtotal, platformFee: $platformFee, logisticsFee: $logisticsFee, vatAmount: $vatAmount, specifications: $specifications, shippingAddressSnapshot: $shippingAddressSnapshot, createdAt: $createdAt, items: $items, buyer: $buyer, seller: $seller, transaction: $transaction, shipment: $shipment, orderShipping: $orderShipping, review: $review, pendingPayment: $pendingPayment, dispute: $dispute, negotiationId: $negotiationId, isDigitalSigned: $isDigitalSigned, buyerSignedAt: $buyerSignedAt, sellerSignedAt: $sellerSignedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderModelCopyWith<$Res> implements $OrderModelCopyWith<$Res> {
  factory _$OrderModelCopyWith(_OrderModel value, $Res Function(_OrderModel) _then) = __$OrderModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String orderNumber, String? checkoutBatchId,@JsonKey(name: 'checkoutBatchNumber') String? checkoutBatchNumber, String status, String orderType, dynamic totalAmount, dynamic totalQuantity, dynamic subtotal, dynamic platformFee,@JsonKey(name: 'logisticsFee') dynamic logisticsFee, dynamic vatAmount, String? specifications, Map<String, dynamic>? shippingAddressSnapshot, String createdAt, List<OrderItemModel> items, OrderParticipantModel buyer, OrderParticipantModel seller, OrderTransactionModel? transaction, OrderShipmentModel? shipment, OrderShippingModel? orderShipping, OrderReviewModel? review, Map<String, dynamic>? pendingPayment, Map<String, dynamic>? dispute, String? negotiationId, bool isDigitalSigned, String? buyerSignedAt, String? sellerSignedAt
});


@override $OrderParticipantModelCopyWith<$Res> get buyer;@override $OrderParticipantModelCopyWith<$Res> get seller;@override $OrderTransactionModelCopyWith<$Res>? get transaction;@override $OrderShipmentModelCopyWith<$Res>? get shipment;@override $OrderShippingModelCopyWith<$Res>? get orderShipping;@override $OrderReviewModelCopyWith<$Res>? get review;

}
/// @nodoc
class __$OrderModelCopyWithImpl<$Res>
    implements _$OrderModelCopyWith<$Res> {
  __$OrderModelCopyWithImpl(this._self, this._then);

  final _OrderModel _self;
  final $Res Function(_OrderModel) _then;

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderNumber = null,Object? checkoutBatchId = freezed,Object? checkoutBatchNumber = freezed,Object? status = null,Object? orderType = null,Object? totalAmount = freezed,Object? totalQuantity = freezed,Object? subtotal = freezed,Object? platformFee = freezed,Object? logisticsFee = freezed,Object? vatAmount = freezed,Object? specifications = freezed,Object? shippingAddressSnapshot = freezed,Object? createdAt = null,Object? items = null,Object? buyer = null,Object? seller = null,Object? transaction = freezed,Object? shipment = freezed,Object? orderShipping = freezed,Object? review = freezed,Object? pendingPayment = freezed,Object? dispute = freezed,Object? negotiationId = freezed,Object? isDigitalSigned = null,Object? buyerSignedAt = freezed,Object? sellerSignedAt = freezed,}) {
  return _then(_OrderModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,checkoutBatchId: freezed == checkoutBatchId ? _self.checkoutBatchId : checkoutBatchId // ignore: cast_nullable_to_non_nullable
as String?,checkoutBatchNumber: freezed == checkoutBatchNumber ? _self.checkoutBatchNumber : checkoutBatchNumber // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as String,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as dynamic,totalQuantity: freezed == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as dynamic,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as dynamic,platformFee: freezed == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as dynamic,logisticsFee: freezed == logisticsFee ? _self.logisticsFee : logisticsFee // ignore: cast_nullable_to_non_nullable
as dynamic,vatAmount: freezed == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as dynamic,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,shippingAddressSnapshot: freezed == shippingAddressSnapshot ? _self._shippingAddressSnapshot : shippingAddressSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItemModel>,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as OrderParticipantModel,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as OrderParticipantModel,transaction: freezed == transaction ? _self.transaction : transaction // ignore: cast_nullable_to_non_nullable
as OrderTransactionModel?,shipment: freezed == shipment ? _self.shipment : shipment // ignore: cast_nullable_to_non_nullable
as OrderShipmentModel?,orderShipping: freezed == orderShipping ? _self.orderShipping : orderShipping // ignore: cast_nullable_to_non_nullable
as OrderShippingModel?,review: freezed == review ? _self.review : review // ignore: cast_nullable_to_non_nullable
as OrderReviewModel?,pendingPayment: freezed == pendingPayment ? _self._pendingPayment : pendingPayment // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,dispute: freezed == dispute ? _self._dispute : dispute // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,negotiationId: freezed == negotiationId ? _self.negotiationId : negotiationId // ignore: cast_nullable_to_non_nullable
as String?,isDigitalSigned: null == isDigitalSigned ? _self.isDigitalSigned : isDigitalSigned // ignore: cast_nullable_to_non_nullable
as bool,buyerSignedAt: freezed == buyerSignedAt ? _self.buyerSignedAt : buyerSignedAt // ignore: cast_nullable_to_non_nullable
as String?,sellerSignedAt: freezed == sellerSignedAt ? _self.sellerSignedAt : sellerSignedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderParticipantModelCopyWith<$Res> get buyer {
  
  return $OrderParticipantModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderParticipantModelCopyWith<$Res> get seller {
  
  return $OrderParticipantModelCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderTransactionModelCopyWith<$Res>? get transaction {
    if (_self.transaction == null) {
    return null;
  }

  return $OrderTransactionModelCopyWith<$Res>(_self.transaction!, (value) {
    return _then(_self.copyWith(transaction: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderShipmentModelCopyWith<$Res>? get shipment {
    if (_self.shipment == null) {
    return null;
  }

  return $OrderShipmentModelCopyWith<$Res>(_self.shipment!, (value) {
    return _then(_self.copyWith(shipment: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderShippingModelCopyWith<$Res>? get orderShipping {
    if (_self.orderShipping == null) {
    return null;
  }

  return $OrderShippingModelCopyWith<$Res>(_self.orderShipping!, (value) {
    return _then(_self.copyWith(orderShipping: value));
  });
}/// Create a copy of OrderModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderReviewModelCopyWith<$Res>? get review {
    if (_self.review == null) {
    return null;
  }

  return $OrderReviewModelCopyWith<$Res>(_self.review!, (value) {
    return _then(_self.copyWith(review: value));
  });
}
}


/// @nodoc
mixin _$OrderItemModel {

 String get id; String get productId; dynamic get quantity; dynamic get pricePerUnit; dynamic get subtotal; OrderItemProductModel get product;
/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemModelCopyWith<OrderItemModel> get copyWith => _$OrderItemModelCopyWithImpl<OrderItemModel>(this as OrderItemModel, _$identity);

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&const DeepCollectionEquality().equals(other.quantity, quantity)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.subtotal, subtotal)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,const DeepCollectionEquality().hash(quantity),const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(subtotal),product);

@override
String toString() {
  return 'OrderItemModel(id: $id, productId: $productId, quantity: $quantity, pricePerUnit: $pricePerUnit, subtotal: $subtotal, product: $product)';
}


}

/// @nodoc
abstract mixin class $OrderItemModelCopyWith<$Res>  {
  factory $OrderItemModelCopyWith(OrderItemModel value, $Res Function(OrderItemModel) _then) = _$OrderItemModelCopyWithImpl;
@useResult
$Res call({
 String id, String productId, dynamic quantity, dynamic pricePerUnit, dynamic subtotal, OrderItemProductModel product
});


$OrderItemProductModelCopyWith<$Res> get product;

}
/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._self, this._then);

  final OrderItemModel _self;
  final $Res Function(OrderItemModel) _then;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? quantity = freezed,Object? pricePerUnit = freezed,Object? subtotal = freezed,Object? product = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as dynamic,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as dynamic,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as OrderItemProductModel,
  ));
}
/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderItemProductModelCopyWith<$Res> get product {
  
  return $OrderItemProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrderItemModel].
extension OrderItemModelPatterns on OrderItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String productId,  dynamic quantity,  dynamic pricePerUnit,  dynamic subtotal,  OrderItemProductModel product)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
return $default(_that.id,_that.productId,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.product);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String productId,  dynamic quantity,  dynamic pricePerUnit,  dynamic subtotal,  OrderItemProductModel product)  $default,) {final _that = this;
switch (_that) {
case _OrderItemModel():
return $default(_that.id,_that.productId,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.product);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String productId,  dynamic quantity,  dynamic pricePerUnit,  dynamic subtotal,  OrderItemProductModel product)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemModel() when $default != null:
return $default(_that.id,_that.productId,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.product);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItemModel extends OrderItemModel {
  const _OrderItemModel({required this.id, required this.productId, required this.quantity, required this.pricePerUnit, required this.subtotal, required this.product}): super._();
  factory _OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);

@override final  String id;
@override final  String productId;
@override final  dynamic quantity;
@override final  dynamic pricePerUnit;
@override final  dynamic subtotal;
@override final  OrderItemProductModel product;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemModelCopyWith<_OrderItemModel> get copyWith => __$OrderItemModelCopyWithImpl<_OrderItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&const DeepCollectionEquality().equals(other.quantity, quantity)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.subtotal, subtotal)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,const DeepCollectionEquality().hash(quantity),const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(subtotal),product);

@override
String toString() {
  return 'OrderItemModel(id: $id, productId: $productId, quantity: $quantity, pricePerUnit: $pricePerUnit, subtotal: $subtotal, product: $product)';
}


}

/// @nodoc
abstract mixin class _$OrderItemModelCopyWith<$Res> implements $OrderItemModelCopyWith<$Res> {
  factory _$OrderItemModelCopyWith(_OrderItemModel value, $Res Function(_OrderItemModel) _then) = __$OrderItemModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String productId, dynamic quantity, dynamic pricePerUnit, dynamic subtotal, OrderItemProductModel product
});


@override $OrderItemProductModelCopyWith<$Res> get product;

}
/// @nodoc
class __$OrderItemModelCopyWithImpl<$Res>
    implements _$OrderItemModelCopyWith<$Res> {
  __$OrderItemModelCopyWithImpl(this._self, this._then);

  final _OrderItemModel _self;
  final $Res Function(_OrderItemModel) _then;

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? quantity = freezed,Object? pricePerUnit = freezed,Object? subtotal = freezed,Object? product = null,}) {
  return _then(_OrderItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as dynamic,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as dynamic,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as OrderItemProductModel,
  ));
}

/// Create a copy of OrderItemModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderItemProductModelCopyWith<$Res> get product {
  
  return $OrderItemProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// @nodoc
mixin _$OrderItemProductModel {

 String get name; String? get unit; String? get thumbnailUrl;
/// Create a copy of OrderItemProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemProductModelCopyWith<OrderItemProductModel> get copyWith => _$OrderItemProductModelCopyWithImpl<OrderItemProductModel>(this as OrderItemProductModel, _$identity);

  /// Serializes this OrderItemProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItemProductModel&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,unit,thumbnailUrl);

@override
String toString() {
  return 'OrderItemProductModel(name: $name, unit: $unit, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $OrderItemProductModelCopyWith<$Res>  {
  factory $OrderItemProductModelCopyWith(OrderItemProductModel value, $Res Function(OrderItemProductModel) _then) = _$OrderItemProductModelCopyWithImpl;
@useResult
$Res call({
 String name, String? unit, String? thumbnailUrl
});




}
/// @nodoc
class _$OrderItemProductModelCopyWithImpl<$Res>
    implements $OrderItemProductModelCopyWith<$Res> {
  _$OrderItemProductModelCopyWithImpl(this._self, this._then);

  final OrderItemProductModel _self;
  final $Res Function(OrderItemProductModel) _then;

/// Create a copy of OrderItemProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? unit = freezed,Object? thumbnailUrl = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItemProductModel].
extension OrderItemProductModelPatterns on OrderItemProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItemProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItemProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItemProductModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderItemProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItemProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItemProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? unit,  String? thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItemProductModel() when $default != null:
return $default(_that.name,_that.unit,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? unit,  String? thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _OrderItemProductModel():
return $default(_that.name,_that.unit,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? unit,  String? thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _OrderItemProductModel() when $default != null:
return $default(_that.name,_that.unit,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItemProductModel implements OrderItemProductModel {
  const _OrderItemProductModel({required this.name, this.unit, this.thumbnailUrl});
  factory _OrderItemProductModel.fromJson(Map<String, dynamic> json) => _$OrderItemProductModelFromJson(json);

@override final  String name;
@override final  String? unit;
@override final  String? thumbnailUrl;

/// Create a copy of OrderItemProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemProductModelCopyWith<_OrderItemProductModel> get copyWith => __$OrderItemProductModelCopyWithImpl<_OrderItemProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItemProductModel&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,unit,thumbnailUrl);

@override
String toString() {
  return 'OrderItemProductModel(name: $name, unit: $unit, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$OrderItemProductModelCopyWith<$Res> implements $OrderItemProductModelCopyWith<$Res> {
  factory _$OrderItemProductModelCopyWith(_OrderItemProductModel value, $Res Function(_OrderItemProductModel) _then) = __$OrderItemProductModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String? unit, String? thumbnailUrl
});




}
/// @nodoc
class __$OrderItemProductModelCopyWithImpl<$Res>
    implements _$OrderItemProductModelCopyWith<$Res> {
  __$OrderItemProductModelCopyWithImpl(this._self, this._then);

  final _OrderItemProductModel _self;
  final $Res Function(_OrderItemProductModel) _then;

/// Create a copy of OrderItemProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? unit = freezed,Object? thumbnailUrl = freezed,}) {
  return _then(_OrderItemProductModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OrderParticipantModel {

 String? get id;@JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson) String get name; String? get email; String? get avatarUrl; String? get regency; Map<String, dynamic>? get verification;
/// Create a copy of OrderParticipantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderParticipantModelCopyWith<OrderParticipantModel> get copyWith => _$OrderParticipantModelCopyWithImpl<OrderParticipantModel>(this as OrderParticipantModel, _$identity);

  /// Serializes this OrderParticipantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.regency, regency) || other.regency == regency)&&const DeepCollectionEquality().equals(other.verification, verification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,regency,const DeepCollectionEquality().hash(verification));

@override
String toString() {
  return 'OrderParticipantModel(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, regency: $regency, verification: $verification)';
}


}

/// @nodoc
abstract mixin class $OrderParticipantModelCopyWith<$Res>  {
  factory $OrderParticipantModelCopyWith(OrderParticipantModel value, $Res Function(OrderParticipantModel) _then) = _$OrderParticipantModelCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson) String name, String? email, String? avatarUrl, String? regency, Map<String, dynamic>? verification
});




}
/// @nodoc
class _$OrderParticipantModelCopyWithImpl<$Res>
    implements $OrderParticipantModelCopyWith<$Res> {
  _$OrderParticipantModelCopyWithImpl(this._self, this._then);

  final OrderParticipantModel _self;
  final $Res Function(OrderParticipantModel) _then;

/// Create a copy of OrderParticipantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? email = freezed,Object? avatarUrl = freezed,Object? regency = freezed,Object? verification = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,verification: freezed == verification ? _self.verification : verification // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderParticipantModel].
extension OrderParticipantModelPatterns on OrderParticipantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderParticipantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderParticipantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderParticipantModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderParticipantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderParticipantModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderParticipantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson)  String name,  String? email,  String? avatarUrl,  String? regency,  Map<String, dynamic>? verification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderParticipantModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.regency,_that.verification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson)  String name,  String? email,  String? avatarUrl,  String? regency,  Map<String, dynamic>? verification)  $default,) {final _that = this;
switch (_that) {
case _OrderParticipantModel():
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.regency,_that.verification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson)  String name,  String? email,  String? avatarUrl,  String? regency,  Map<String, dynamic>? verification)?  $default,) {final _that = this;
switch (_that) {
case _OrderParticipantModel() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.avatarUrl,_that.regency,_that.verification);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderParticipantModel extends OrderParticipantModel {
  const _OrderParticipantModel({this.id, @JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson) required this.name, this.email, this.avatarUrl, this.regency, final  Map<String, dynamic>? verification}): _verification = verification,super._();
  factory _OrderParticipantModel.fromJson(Map<String, dynamic> json) => _$OrderParticipantModelFromJson(json);

@override final  String? id;
@override@JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson) final  String name;
@override final  String? email;
@override final  String? avatarUrl;
@override final  String? regency;
 final  Map<String, dynamic>? _verification;
@override Map<String, dynamic>? get verification {
  final value = _verification;
  if (value == null) return null;
  if (_verification is EqualUnmodifiableMapView) return _verification;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of OrderParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderParticipantModelCopyWith<_OrderParticipantModel> get copyWith => __$OrderParticipantModelCopyWithImpl<_OrderParticipantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderParticipantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.regency, regency) || other.regency == regency)&&const DeepCollectionEquality().equals(other._verification, _verification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,avatarUrl,regency,const DeepCollectionEquality().hash(_verification));

@override
String toString() {
  return 'OrderParticipantModel(id: $id, name: $name, email: $email, avatarUrl: $avatarUrl, regency: $regency, verification: $verification)';
}


}

/// @nodoc
abstract mixin class _$OrderParticipantModelCopyWith<$Res> implements $OrderParticipantModelCopyWith<$Res> {
  factory _$OrderParticipantModelCopyWith(_OrderParticipantModel value, $Res Function(_OrderParticipantModel) _then) = __$OrderParticipantModelCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson) String name, String? email, String? avatarUrl, String? regency, Map<String, dynamic>? verification
});




}
/// @nodoc
class __$OrderParticipantModelCopyWithImpl<$Res>
    implements _$OrderParticipantModelCopyWith<$Res> {
  __$OrderParticipantModelCopyWithImpl(this._self, this._then);

  final _OrderParticipantModel _self;
  final $Res Function(_OrderParticipantModel) _then;

/// Create a copy of OrderParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? email = freezed,Object? avatarUrl = freezed,Object? regency = freezed,Object? verification = freezed,}) {
  return _then(_OrderParticipantModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,verification: freezed == verification ? _self._verification : verification // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$OrderTransactionModel {

 String get status; String? get paymentStatus; String? get paymentUrl; String? get paidAt; Map<String, dynamic>? get paymentChannel;
/// Create a copy of OrderTransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderTransactionModelCopyWith<OrderTransactionModel> get copyWith => _$OrderTransactionModelCopyWithImpl<OrderTransactionModel>(this as OrderTransactionModel, _$identity);

  /// Serializes this OrderTransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderTransactionModel&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&const DeepCollectionEquality().equals(other.paymentChannel, paymentChannel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,paymentStatus,paymentUrl,paidAt,const DeepCollectionEquality().hash(paymentChannel));

@override
String toString() {
  return 'OrderTransactionModel(status: $status, paymentStatus: $paymentStatus, paymentUrl: $paymentUrl, paidAt: $paidAt, paymentChannel: $paymentChannel)';
}


}

/// @nodoc
abstract mixin class $OrderTransactionModelCopyWith<$Res>  {
  factory $OrderTransactionModelCopyWith(OrderTransactionModel value, $Res Function(OrderTransactionModel) _then) = _$OrderTransactionModelCopyWithImpl;
@useResult
$Res call({
 String status, String? paymentStatus, String? paymentUrl, String? paidAt, Map<String, dynamic>? paymentChannel
});




}
/// @nodoc
class _$OrderTransactionModelCopyWithImpl<$Res>
    implements $OrderTransactionModelCopyWith<$Res> {
  _$OrderTransactionModelCopyWithImpl(this._self, this._then);

  final OrderTransactionModel _self;
  final $Res Function(OrderTransactionModel) _then;

/// Create a copy of OrderTransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? paymentStatus = freezed,Object? paymentUrl = freezed,Object? paidAt = freezed,Object? paymentChannel = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,paymentChannel: freezed == paymentChannel ? _self.paymentChannel : paymentChannel // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderTransactionModel].
extension OrderTransactionModelPatterns on OrderTransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderTransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderTransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderTransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderTransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderTransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderTransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? paymentStatus,  String? paymentUrl,  String? paidAt,  Map<String, dynamic>? paymentChannel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderTransactionModel() when $default != null:
return $default(_that.status,_that.paymentStatus,_that.paymentUrl,_that.paidAt,_that.paymentChannel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? paymentStatus,  String? paymentUrl,  String? paidAt,  Map<String, dynamic>? paymentChannel)  $default,) {final _that = this;
switch (_that) {
case _OrderTransactionModel():
return $default(_that.status,_that.paymentStatus,_that.paymentUrl,_that.paidAt,_that.paymentChannel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? paymentStatus,  String? paymentUrl,  String? paidAt,  Map<String, dynamic>? paymentChannel)?  $default,) {final _that = this;
switch (_that) {
case _OrderTransactionModel() when $default != null:
return $default(_that.status,_that.paymentStatus,_that.paymentUrl,_that.paidAt,_that.paymentChannel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderTransactionModel extends OrderTransactionModel {
  const _OrderTransactionModel({required this.status, this.paymentStatus, this.paymentUrl, this.paidAt, final  Map<String, dynamic>? paymentChannel}): _paymentChannel = paymentChannel,super._();
  factory _OrderTransactionModel.fromJson(Map<String, dynamic> json) => _$OrderTransactionModelFromJson(json);

@override final  String status;
@override final  String? paymentStatus;
@override final  String? paymentUrl;
@override final  String? paidAt;
 final  Map<String, dynamic>? _paymentChannel;
@override Map<String, dynamic>? get paymentChannel {
  final value = _paymentChannel;
  if (value == null) return null;
  if (_paymentChannel is EqualUnmodifiableMapView) return _paymentChannel;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of OrderTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderTransactionModelCopyWith<_OrderTransactionModel> get copyWith => __$OrderTransactionModelCopyWithImpl<_OrderTransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderTransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderTransactionModel&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentUrl, paymentUrl) || other.paymentUrl == paymentUrl)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&const DeepCollectionEquality().equals(other._paymentChannel, _paymentChannel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,paymentStatus,paymentUrl,paidAt,const DeepCollectionEquality().hash(_paymentChannel));

@override
String toString() {
  return 'OrderTransactionModel(status: $status, paymentStatus: $paymentStatus, paymentUrl: $paymentUrl, paidAt: $paidAt, paymentChannel: $paymentChannel)';
}


}

/// @nodoc
abstract mixin class _$OrderTransactionModelCopyWith<$Res> implements $OrderTransactionModelCopyWith<$Res> {
  factory _$OrderTransactionModelCopyWith(_OrderTransactionModel value, $Res Function(_OrderTransactionModel) _then) = __$OrderTransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String status, String? paymentStatus, String? paymentUrl, String? paidAt, Map<String, dynamic>? paymentChannel
});




}
/// @nodoc
class __$OrderTransactionModelCopyWithImpl<$Res>
    implements _$OrderTransactionModelCopyWith<$Res> {
  __$OrderTransactionModelCopyWithImpl(this._self, this._then);

  final _OrderTransactionModel _self;
  final $Res Function(_OrderTransactionModel) _then;

/// Create a copy of OrderTransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? paymentStatus = freezed,Object? paymentUrl = freezed,Object? paidAt = freezed,Object? paymentChannel = freezed,}) {
  return _then(_OrderTransactionModel(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String?,paymentUrl: freezed == paymentUrl ? _self.paymentUrl : paymentUrl // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as String?,paymentChannel: freezed == paymentChannel ? _self._paymentChannel : paymentChannel // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$OrderShipmentModel {

 String? get trackingNumber; String? get vesselName; String? get originHub; String? get destinationHub; String? get awbNumber; String? get courierCode; String? get deliveryStatus; String? get lastTrackedAt; dynamic get currentLat; dynamic get currentLng; String? get updatedAt;
/// Create a copy of OrderShipmentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderShipmentModelCopyWith<OrderShipmentModel> get copyWith => _$OrderShipmentModelCopyWithImpl<OrderShipmentModel>(this as OrderShipmentModel, _$identity);

  /// Serializes this OrderShipmentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderShipmentModel&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.originHub, originHub) || other.originHub == originHub)&&(identical(other.destinationHub, destinationHub) || other.destinationHub == destinationHub)&&(identical(other.awbNumber, awbNumber) || other.awbNumber == awbNumber)&&(identical(other.courierCode, courierCode) || other.courierCode == courierCode)&&(identical(other.deliveryStatus, deliveryStatus) || other.deliveryStatus == deliveryStatus)&&(identical(other.lastTrackedAt, lastTrackedAt) || other.lastTrackedAt == lastTrackedAt)&&const DeepCollectionEquality().equals(other.currentLat, currentLat)&&const DeepCollectionEquality().equals(other.currentLng, currentLng)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trackingNumber,vesselName,originHub,destinationHub,awbNumber,courierCode,deliveryStatus,lastTrackedAt,const DeepCollectionEquality().hash(currentLat),const DeepCollectionEquality().hash(currentLng),updatedAt);

@override
String toString() {
  return 'OrderShipmentModel(trackingNumber: $trackingNumber, vesselName: $vesselName, originHub: $originHub, destinationHub: $destinationHub, awbNumber: $awbNumber, courierCode: $courierCode, deliveryStatus: $deliveryStatus, lastTrackedAt: $lastTrackedAt, currentLat: $currentLat, currentLng: $currentLng, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OrderShipmentModelCopyWith<$Res>  {
  factory $OrderShipmentModelCopyWith(OrderShipmentModel value, $Res Function(OrderShipmentModel) _then) = _$OrderShipmentModelCopyWithImpl;
@useResult
$Res call({
 String? trackingNumber, String? vesselName, String? originHub, String? destinationHub, String? awbNumber, String? courierCode, String? deliveryStatus, String? lastTrackedAt, dynamic currentLat, dynamic currentLng, String? updatedAt
});




}
/// @nodoc
class _$OrderShipmentModelCopyWithImpl<$Res>
    implements $OrderShipmentModelCopyWith<$Res> {
  _$OrderShipmentModelCopyWithImpl(this._self, this._then);

  final OrderShipmentModel _self;
  final $Res Function(OrderShipmentModel) _then;

/// Create a copy of OrderShipmentModel
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
as String?,currentLat: freezed == currentLat ? _self.currentLat : currentLat // ignore: cast_nullable_to_non_nullable
as dynamic,currentLng: freezed == currentLng ? _self.currentLng : currentLng // ignore: cast_nullable_to_non_nullable
as dynamic,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderShipmentModel].
extension OrderShipmentModelPatterns on OrderShipmentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderShipmentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderShipmentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderShipmentModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderShipmentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderShipmentModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderShipmentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? trackingNumber,  String? vesselName,  String? originHub,  String? destinationHub,  String? awbNumber,  String? courierCode,  String? deliveryStatus,  String? lastTrackedAt,  dynamic currentLat,  dynamic currentLng,  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderShipmentModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? trackingNumber,  String? vesselName,  String? originHub,  String? destinationHub,  String? awbNumber,  String? courierCode,  String? deliveryStatus,  String? lastTrackedAt,  dynamic currentLat,  dynamic currentLng,  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderShipmentModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? trackingNumber,  String? vesselName,  String? originHub,  String? destinationHub,  String? awbNumber,  String? courierCode,  String? deliveryStatus,  String? lastTrackedAt,  dynamic currentLat,  dynamic currentLng,  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderShipmentModel() when $default != null:
return $default(_that.trackingNumber,_that.vesselName,_that.originHub,_that.destinationHub,_that.awbNumber,_that.courierCode,_that.deliveryStatus,_that.lastTrackedAt,_that.currentLat,_that.currentLng,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderShipmentModel extends OrderShipmentModel {
  const _OrderShipmentModel({this.trackingNumber, this.vesselName, this.originHub, this.destinationHub, this.awbNumber, this.courierCode, this.deliveryStatus, this.lastTrackedAt, this.currentLat, this.currentLng, this.updatedAt}): super._();
  factory _OrderShipmentModel.fromJson(Map<String, dynamic> json) => _$OrderShipmentModelFromJson(json);

@override final  String? trackingNumber;
@override final  String? vesselName;
@override final  String? originHub;
@override final  String? destinationHub;
@override final  String? awbNumber;
@override final  String? courierCode;
@override final  String? deliveryStatus;
@override final  String? lastTrackedAt;
@override final  dynamic currentLat;
@override final  dynamic currentLng;
@override final  String? updatedAt;

/// Create a copy of OrderShipmentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderShipmentModelCopyWith<_OrderShipmentModel> get copyWith => __$OrderShipmentModelCopyWithImpl<_OrderShipmentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderShipmentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderShipmentModel&&(identical(other.trackingNumber, trackingNumber) || other.trackingNumber == trackingNumber)&&(identical(other.vesselName, vesselName) || other.vesselName == vesselName)&&(identical(other.originHub, originHub) || other.originHub == originHub)&&(identical(other.destinationHub, destinationHub) || other.destinationHub == destinationHub)&&(identical(other.awbNumber, awbNumber) || other.awbNumber == awbNumber)&&(identical(other.courierCode, courierCode) || other.courierCode == courierCode)&&(identical(other.deliveryStatus, deliveryStatus) || other.deliveryStatus == deliveryStatus)&&(identical(other.lastTrackedAt, lastTrackedAt) || other.lastTrackedAt == lastTrackedAt)&&const DeepCollectionEquality().equals(other.currentLat, currentLat)&&const DeepCollectionEquality().equals(other.currentLng, currentLng)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trackingNumber,vesselName,originHub,destinationHub,awbNumber,courierCode,deliveryStatus,lastTrackedAt,const DeepCollectionEquality().hash(currentLat),const DeepCollectionEquality().hash(currentLng),updatedAt);

@override
String toString() {
  return 'OrderShipmentModel(trackingNumber: $trackingNumber, vesselName: $vesselName, originHub: $originHub, destinationHub: $destinationHub, awbNumber: $awbNumber, courierCode: $courierCode, deliveryStatus: $deliveryStatus, lastTrackedAt: $lastTrackedAt, currentLat: $currentLat, currentLng: $currentLng, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderShipmentModelCopyWith<$Res> implements $OrderShipmentModelCopyWith<$Res> {
  factory _$OrderShipmentModelCopyWith(_OrderShipmentModel value, $Res Function(_OrderShipmentModel) _then) = __$OrderShipmentModelCopyWithImpl;
@override @useResult
$Res call({
 String? trackingNumber, String? vesselName, String? originHub, String? destinationHub, String? awbNumber, String? courierCode, String? deliveryStatus, String? lastTrackedAt, dynamic currentLat, dynamic currentLng, String? updatedAt
});




}
/// @nodoc
class __$OrderShipmentModelCopyWithImpl<$Res>
    implements _$OrderShipmentModelCopyWith<$Res> {
  __$OrderShipmentModelCopyWithImpl(this._self, this._then);

  final _OrderShipmentModel _self;
  final $Res Function(_OrderShipmentModel) _then;

/// Create a copy of OrderShipmentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackingNumber = freezed,Object? vesselName = freezed,Object? originHub = freezed,Object? destinationHub = freezed,Object? awbNumber = freezed,Object? courierCode = freezed,Object? deliveryStatus = freezed,Object? lastTrackedAt = freezed,Object? currentLat = freezed,Object? currentLng = freezed,Object? updatedAt = freezed,}) {
  return _then(_OrderShipmentModel(
trackingNumber: freezed == trackingNumber ? _self.trackingNumber : trackingNumber // ignore: cast_nullable_to_non_nullable
as String?,vesselName: freezed == vesselName ? _self.vesselName : vesselName // ignore: cast_nullable_to_non_nullable
as String?,originHub: freezed == originHub ? _self.originHub : originHub // ignore: cast_nullable_to_non_nullable
as String?,destinationHub: freezed == destinationHub ? _self.destinationHub : destinationHub // ignore: cast_nullable_to_non_nullable
as String?,awbNumber: freezed == awbNumber ? _self.awbNumber : awbNumber // ignore: cast_nullable_to_non_nullable
as String?,courierCode: freezed == courierCode ? _self.courierCode : courierCode // ignore: cast_nullable_to_non_nullable
as String?,deliveryStatus: freezed == deliveryStatus ? _self.deliveryStatus : deliveryStatus // ignore: cast_nullable_to_non_nullable
as String?,lastTrackedAt: freezed == lastTrackedAt ? _self.lastTrackedAt : lastTrackedAt // ignore: cast_nullable_to_non_nullable
as String?,currentLat: freezed == currentLat ? _self.currentLat : currentLat // ignore: cast_nullable_to_non_nullable
as dynamic,currentLng: freezed == currentLng ? _self.currentLng : currentLng // ignore: cast_nullable_to_non_nullable
as dynamic,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OrderShippingModel {

 dynamic get originDestinationId; dynamic get destinationDestinationId; String? get originLabel; String? get destinationLabel; dynamic get weightGrams; String? get courierCode; String? get courierName; String? get serviceCode; String? get serviceName; String? get serviceDescription; dynamic get shippingCost; String? get etd; String? get verifiedAt;
/// Create a copy of OrderShippingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderShippingModelCopyWith<OrderShippingModel> get copyWith => _$OrderShippingModelCopyWithImpl<OrderShippingModel>(this as OrderShippingModel, _$identity);

  /// Serializes this OrderShippingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderShippingModel&&const DeepCollectionEquality().equals(other.originDestinationId, originDestinationId)&&const DeepCollectionEquality().equals(other.destinationDestinationId, destinationDestinationId)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destinationLabel, destinationLabel) || other.destinationLabel == destinationLabel)&&const DeepCollectionEquality().equals(other.weightGrams, weightGrams)&&(identical(other.courierCode, courierCode) || other.courierCode == courierCode)&&(identical(other.courierName, courierName) || other.courierName == courierName)&&(identical(other.serviceCode, serviceCode) || other.serviceCode == serviceCode)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.serviceDescription, serviceDescription) || other.serviceDescription == serviceDescription)&&const DeepCollectionEquality().equals(other.shippingCost, shippingCost)&&(identical(other.etd, etd) || other.etd == etd)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(originDestinationId),const DeepCollectionEquality().hash(destinationDestinationId),originLabel,destinationLabel,const DeepCollectionEquality().hash(weightGrams),courierCode,courierName,serviceCode,serviceName,serviceDescription,const DeepCollectionEquality().hash(shippingCost),etd,verifiedAt);

@override
String toString() {
  return 'OrderShippingModel(originDestinationId: $originDestinationId, destinationDestinationId: $destinationDestinationId, originLabel: $originLabel, destinationLabel: $destinationLabel, weightGrams: $weightGrams, courierCode: $courierCode, courierName: $courierName, serviceCode: $serviceCode, serviceName: $serviceName, serviceDescription: $serviceDescription, shippingCost: $shippingCost, etd: $etd, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class $OrderShippingModelCopyWith<$Res>  {
  factory $OrderShippingModelCopyWith(OrderShippingModel value, $Res Function(OrderShippingModel) _then) = _$OrderShippingModelCopyWithImpl;
@useResult
$Res call({
 dynamic originDestinationId, dynamic destinationDestinationId, String? originLabel, String? destinationLabel, dynamic weightGrams, String? courierCode, String? courierName, String? serviceCode, String? serviceName, String? serviceDescription, dynamic shippingCost, String? etd, String? verifiedAt
});




}
/// @nodoc
class _$OrderShippingModelCopyWithImpl<$Res>
    implements $OrderShippingModelCopyWith<$Res> {
  _$OrderShippingModelCopyWithImpl(this._self, this._then);

  final OrderShippingModel _self;
  final $Res Function(OrderShippingModel) _then;

/// Create a copy of OrderShippingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originDestinationId = freezed,Object? destinationDestinationId = freezed,Object? originLabel = freezed,Object? destinationLabel = freezed,Object? weightGrams = freezed,Object? courierCode = freezed,Object? courierName = freezed,Object? serviceCode = freezed,Object? serviceName = freezed,Object? serviceDescription = freezed,Object? shippingCost = freezed,Object? etd = freezed,Object? verifiedAt = freezed,}) {
  return _then(_self.copyWith(
originDestinationId: freezed == originDestinationId ? _self.originDestinationId : originDestinationId // ignore: cast_nullable_to_non_nullable
as dynamic,destinationDestinationId: freezed == destinationDestinationId ? _self.destinationDestinationId : destinationDestinationId // ignore: cast_nullable_to_non_nullable
as dynamic,originLabel: freezed == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String?,destinationLabel: freezed == destinationLabel ? _self.destinationLabel : destinationLabel // ignore: cast_nullable_to_non_nullable
as String?,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as dynamic,courierCode: freezed == courierCode ? _self.courierCode : courierCode // ignore: cast_nullable_to_non_nullable
as String?,courierName: freezed == courierName ? _self.courierName : courierName // ignore: cast_nullable_to_non_nullable
as String?,serviceCode: freezed == serviceCode ? _self.serviceCode : serviceCode // ignore: cast_nullable_to_non_nullable
as String?,serviceName: freezed == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String?,serviceDescription: freezed == serviceDescription ? _self.serviceDescription : serviceDescription // ignore: cast_nullable_to_non_nullable
as String?,shippingCost: freezed == shippingCost ? _self.shippingCost : shippingCost // ignore: cast_nullable_to_non_nullable
as dynamic,etd: freezed == etd ? _self.etd : etd // ignore: cast_nullable_to_non_nullable
as String?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderShippingModel].
extension OrderShippingModelPatterns on OrderShippingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderShippingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderShippingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderShippingModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderShippingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderShippingModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderShippingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( dynamic originDestinationId,  dynamic destinationDestinationId,  String? originLabel,  String? destinationLabel,  dynamic weightGrams,  String? courierCode,  String? courierName,  String? serviceCode,  String? serviceName,  String? serviceDescription,  dynamic shippingCost,  String? etd,  String? verifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderShippingModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( dynamic originDestinationId,  dynamic destinationDestinationId,  String? originLabel,  String? destinationLabel,  dynamic weightGrams,  String? courierCode,  String? courierName,  String? serviceCode,  String? serviceName,  String? serviceDescription,  dynamic shippingCost,  String? etd,  String? verifiedAt)  $default,) {final _that = this;
switch (_that) {
case _OrderShippingModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( dynamic originDestinationId,  dynamic destinationDestinationId,  String? originLabel,  String? destinationLabel,  dynamic weightGrams,  String? courierCode,  String? courierName,  String? serviceCode,  String? serviceName,  String? serviceDescription,  dynamic shippingCost,  String? etd,  String? verifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _OrderShippingModel() when $default != null:
return $default(_that.originDestinationId,_that.destinationDestinationId,_that.originLabel,_that.destinationLabel,_that.weightGrams,_that.courierCode,_that.courierName,_that.serviceCode,_that.serviceName,_that.serviceDescription,_that.shippingCost,_that.etd,_that.verifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderShippingModel extends OrderShippingModel {
  const _OrderShippingModel({this.originDestinationId, this.destinationDestinationId, this.originLabel, this.destinationLabel, this.weightGrams, this.courierCode, this.courierName, this.serviceCode, this.serviceName, this.serviceDescription, this.shippingCost, this.etd, this.verifiedAt}): super._();
  factory _OrderShippingModel.fromJson(Map<String, dynamic> json) => _$OrderShippingModelFromJson(json);

@override final  dynamic originDestinationId;
@override final  dynamic destinationDestinationId;
@override final  String? originLabel;
@override final  String? destinationLabel;
@override final  dynamic weightGrams;
@override final  String? courierCode;
@override final  String? courierName;
@override final  String? serviceCode;
@override final  String? serviceName;
@override final  String? serviceDescription;
@override final  dynamic shippingCost;
@override final  String? etd;
@override final  String? verifiedAt;

/// Create a copy of OrderShippingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderShippingModelCopyWith<_OrderShippingModel> get copyWith => __$OrderShippingModelCopyWithImpl<_OrderShippingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderShippingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderShippingModel&&const DeepCollectionEquality().equals(other.originDestinationId, originDestinationId)&&const DeepCollectionEquality().equals(other.destinationDestinationId, destinationDestinationId)&&(identical(other.originLabel, originLabel) || other.originLabel == originLabel)&&(identical(other.destinationLabel, destinationLabel) || other.destinationLabel == destinationLabel)&&const DeepCollectionEquality().equals(other.weightGrams, weightGrams)&&(identical(other.courierCode, courierCode) || other.courierCode == courierCode)&&(identical(other.courierName, courierName) || other.courierName == courierName)&&(identical(other.serviceCode, serviceCode) || other.serviceCode == serviceCode)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.serviceDescription, serviceDescription) || other.serviceDescription == serviceDescription)&&const DeepCollectionEquality().equals(other.shippingCost, shippingCost)&&(identical(other.etd, etd) || other.etd == etd)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(originDestinationId),const DeepCollectionEquality().hash(destinationDestinationId),originLabel,destinationLabel,const DeepCollectionEquality().hash(weightGrams),courierCode,courierName,serviceCode,serviceName,serviceDescription,const DeepCollectionEquality().hash(shippingCost),etd,verifiedAt);

@override
String toString() {
  return 'OrderShippingModel(originDestinationId: $originDestinationId, destinationDestinationId: $destinationDestinationId, originLabel: $originLabel, destinationLabel: $destinationLabel, weightGrams: $weightGrams, courierCode: $courierCode, courierName: $courierName, serviceCode: $serviceCode, serviceName: $serviceName, serviceDescription: $serviceDescription, shippingCost: $shippingCost, etd: $etd, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class _$OrderShippingModelCopyWith<$Res> implements $OrderShippingModelCopyWith<$Res> {
  factory _$OrderShippingModelCopyWith(_OrderShippingModel value, $Res Function(_OrderShippingModel) _then) = __$OrderShippingModelCopyWithImpl;
@override @useResult
$Res call({
 dynamic originDestinationId, dynamic destinationDestinationId, String? originLabel, String? destinationLabel, dynamic weightGrams, String? courierCode, String? courierName, String? serviceCode, String? serviceName, String? serviceDescription, dynamic shippingCost, String? etd, String? verifiedAt
});




}
/// @nodoc
class __$OrderShippingModelCopyWithImpl<$Res>
    implements _$OrderShippingModelCopyWith<$Res> {
  __$OrderShippingModelCopyWithImpl(this._self, this._then);

  final _OrderShippingModel _self;
  final $Res Function(_OrderShippingModel) _then;

/// Create a copy of OrderShippingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originDestinationId = freezed,Object? destinationDestinationId = freezed,Object? originLabel = freezed,Object? destinationLabel = freezed,Object? weightGrams = freezed,Object? courierCode = freezed,Object? courierName = freezed,Object? serviceCode = freezed,Object? serviceName = freezed,Object? serviceDescription = freezed,Object? shippingCost = freezed,Object? etd = freezed,Object? verifiedAt = freezed,}) {
  return _then(_OrderShippingModel(
originDestinationId: freezed == originDestinationId ? _self.originDestinationId : originDestinationId // ignore: cast_nullable_to_non_nullable
as dynamic,destinationDestinationId: freezed == destinationDestinationId ? _self.destinationDestinationId : destinationDestinationId // ignore: cast_nullable_to_non_nullable
as dynamic,originLabel: freezed == originLabel ? _self.originLabel : originLabel // ignore: cast_nullable_to_non_nullable
as String?,destinationLabel: freezed == destinationLabel ? _self.destinationLabel : destinationLabel // ignore: cast_nullable_to_non_nullable
as String?,weightGrams: freezed == weightGrams ? _self.weightGrams : weightGrams // ignore: cast_nullable_to_non_nullable
as dynamic,courierCode: freezed == courierCode ? _self.courierCode : courierCode // ignore: cast_nullable_to_non_nullable
as String?,courierName: freezed == courierName ? _self.courierName : courierName // ignore: cast_nullable_to_non_nullable
as String?,serviceCode: freezed == serviceCode ? _self.serviceCode : serviceCode // ignore: cast_nullable_to_non_nullable
as String?,serviceName: freezed == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String?,serviceDescription: freezed == serviceDescription ? _self.serviceDescription : serviceDescription // ignore: cast_nullable_to_non_nullable
as String?,shippingCost: freezed == shippingCost ? _self.shippingCost : shippingCost // ignore: cast_nullable_to_non_nullable
as dynamic,etd: freezed == etd ? _self.etd : etd // ignore: cast_nullable_to_non_nullable
as String?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OrderReviewModel {

 String get id; dynamic get rating; String get comment;
/// Create a copy of OrderReviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderReviewModelCopyWith<OrderReviewModel> get copyWith => _$OrderReviewModelCopyWithImpl<OrderReviewModel>(this as OrderReviewModel, _$identity);

  /// Serializes this OrderReviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderReviewModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.rating, rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(rating),comment);

@override
String toString() {
  return 'OrderReviewModel(id: $id, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $OrderReviewModelCopyWith<$Res>  {
  factory $OrderReviewModelCopyWith(OrderReviewModel value, $Res Function(OrderReviewModel) _then) = _$OrderReviewModelCopyWithImpl;
@useResult
$Res call({
 String id, dynamic rating, String comment
});




}
/// @nodoc
class _$OrderReviewModelCopyWithImpl<$Res>
    implements $OrderReviewModelCopyWith<$Res> {
  _$OrderReviewModelCopyWithImpl(this._self, this._then);

  final OrderReviewModel _self;
  final $Res Function(OrderReviewModel) _then;

/// Create a copy of OrderReviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? rating = freezed,Object? comment = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as dynamic,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderReviewModel].
extension OrderReviewModelPatterns on OrderReviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderReviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderReviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderReviewModel value)  $default,){
final _that = this;
switch (_that) {
case _OrderReviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderReviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _OrderReviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  dynamic rating,  String comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderReviewModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  dynamic rating,  String comment)  $default,) {final _that = this;
switch (_that) {
case _OrderReviewModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  dynamic rating,  String comment)?  $default,) {final _that = this;
switch (_that) {
case _OrderReviewModel() when $default != null:
return $default(_that.id,_that.rating,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderReviewModel extends OrderReviewModel {
  const _OrderReviewModel({required this.id, required this.rating, required this.comment}): super._();
  factory _OrderReviewModel.fromJson(Map<String, dynamic> json) => _$OrderReviewModelFromJson(json);

@override final  String id;
@override final  dynamic rating;
@override final  String comment;

/// Create a copy of OrderReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderReviewModelCopyWith<_OrderReviewModel> get copyWith => __$OrderReviewModelCopyWithImpl<_OrderReviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderReviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderReviewModel&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.rating, rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(rating),comment);

@override
String toString() {
  return 'OrderReviewModel(id: $id, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$OrderReviewModelCopyWith<$Res> implements $OrderReviewModelCopyWith<$Res> {
  factory _$OrderReviewModelCopyWith(_OrderReviewModel value, $Res Function(_OrderReviewModel) _then) = __$OrderReviewModelCopyWithImpl;
@override @useResult
$Res call({
 String id, dynamic rating, String comment
});




}
/// @nodoc
class __$OrderReviewModelCopyWithImpl<$Res>
    implements _$OrderReviewModelCopyWith<$Res> {
  __$OrderReviewModelCopyWithImpl(this._self, this._then);

  final _OrderReviewModel _self;
  final $Res Function(_OrderReviewModel) _then;

/// Create a copy of OrderReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? rating = freezed,Object? comment = null,}) {
  return _then(_OrderReviewModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as dynamic,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
