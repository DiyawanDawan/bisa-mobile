// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'negotiation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NegotiationEntity {

 String get id; String? get orderId; NegotiationOrderSummaryEntity? get order; String get productId; String get buyerId; String get sellerId; double get quantity; double get pricePerUnit; double get totalEstimate; String? get specifications; String get roomType; String get status; bool get isLocked; String? get rejectionReason; String? get closedBy; DateTime get createdAt; DateTime get updatedAt; NegotiationProductEntity get product; NegotiationParticipantEntity get buyer; NegotiationParticipantEntity get seller; List<NegotiationMessageEntity>? get messages; int? get messagesTotal;
/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationEntityCopyWith<NegotiationEntity> get copyWith => _$NegotiationEntityCopyWithImpl<NegotiationEntity>(this as NegotiationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.order, order) || other.order == order)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.totalEstimate, totalEstimate) || other.totalEstimate == totalEstimate)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.product, product) || other.product == product)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.seller, seller) || other.seller == seller)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.messagesTotal, messagesTotal) || other.messagesTotal == messagesTotal));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,orderId,order,productId,buyerId,sellerId,quantity,pricePerUnit,totalEstimate,specifications,roomType,status,isLocked,rejectionReason,closedBy,createdAt,updatedAt,product,buyer,seller,const DeepCollectionEquality().hash(messages),messagesTotal]);

@override
String toString() {
  return 'NegotiationEntity(id: $id, orderId: $orderId, order: $order, productId: $productId, buyerId: $buyerId, sellerId: $sellerId, quantity: $quantity, pricePerUnit: $pricePerUnit, totalEstimate: $totalEstimate, specifications: $specifications, roomType: $roomType, status: $status, isLocked: $isLocked, rejectionReason: $rejectionReason, closedBy: $closedBy, createdAt: $createdAt, updatedAt: $updatedAt, product: $product, buyer: $buyer, seller: $seller, messages: $messages, messagesTotal: $messagesTotal)';
}


}

/// @nodoc
abstract mixin class $NegotiationEntityCopyWith<$Res>  {
  factory $NegotiationEntityCopyWith(NegotiationEntity value, $Res Function(NegotiationEntity) _then) = _$NegotiationEntityCopyWithImpl;
@useResult
$Res call({
 String id, String? orderId, NegotiationOrderSummaryEntity? order, String productId, String buyerId, String sellerId, double quantity, double pricePerUnit, double totalEstimate, String? specifications, String roomType, String status, bool isLocked, String? rejectionReason, String? closedBy, DateTime createdAt, DateTime updatedAt, NegotiationProductEntity product, NegotiationParticipantEntity buyer, NegotiationParticipantEntity seller, List<NegotiationMessageEntity>? messages, int? messagesTotal
});


$NegotiationProductEntityCopyWith<$Res> get product;$NegotiationParticipantEntityCopyWith<$Res> get buyer;$NegotiationParticipantEntityCopyWith<$Res> get seller;

}
/// @nodoc
class _$NegotiationEntityCopyWithImpl<$Res>
    implements $NegotiationEntityCopyWith<$Res> {
  _$NegotiationEntityCopyWithImpl(this._self, this._then);

  final NegotiationEntity _self;
  final $Res Function(NegotiationEntity) _then;

/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = freezed,Object? order = freezed,Object? productId = null,Object? buyerId = null,Object? sellerId = null,Object? quantity = null,Object? pricePerUnit = null,Object? totalEstimate = null,Object? specifications = freezed,Object? roomType = null,Object? status = null,Object? isLocked = null,Object? rejectionReason = freezed,Object? closedBy = freezed,Object? createdAt = null,Object? updatedAt = null,Object? product = null,Object? buyer = null,Object? seller = null,Object? messages = freezed,Object? messagesTotal = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as NegotiationOrderSummaryEntity?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,totalEstimate: null == totalEstimate ? _self.totalEstimate : totalEstimate // ignore: cast_nullable_to_non_nullable
as double,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,roomType: null == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as NegotiationProductEntity,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantEntity,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantEntity,messages: freezed == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<NegotiationMessageEntity>?,messagesTotal: freezed == messagesTotal ? _self.messagesTotal : messagesTotal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationProductEntityCopyWith<$Res> get product {
  
  return $NegotiationProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantEntityCopyWith<$Res> get buyer {
  
  return $NegotiationParticipantEntityCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantEntityCopyWith<$Res> get seller {
  
  return $NegotiationParticipantEntityCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}
}


/// Adds pattern-matching-related methods to [NegotiationEntity].
extension NegotiationEntityPatterns on NegotiationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationEntity value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? orderId,  NegotiationOrderSummaryEntity? order,  String productId,  String buyerId,  String sellerId,  double quantity,  double pricePerUnit,  double totalEstimate,  String? specifications,  String roomType,  String status,  bool isLocked,  String? rejectionReason,  String? closedBy,  DateTime createdAt,  DateTime updatedAt,  NegotiationProductEntity product,  NegotiationParticipantEntity buyer,  NegotiationParticipantEntity seller,  List<NegotiationMessageEntity>? messages,  int? messagesTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationEntity() when $default != null:
return $default(_that.id,_that.orderId,_that.order,_that.productId,_that.buyerId,_that.sellerId,_that.quantity,_that.pricePerUnit,_that.totalEstimate,_that.specifications,_that.roomType,_that.status,_that.isLocked,_that.rejectionReason,_that.closedBy,_that.createdAt,_that.updatedAt,_that.product,_that.buyer,_that.seller,_that.messages,_that.messagesTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? orderId,  NegotiationOrderSummaryEntity? order,  String productId,  String buyerId,  String sellerId,  double quantity,  double pricePerUnit,  double totalEstimate,  String? specifications,  String roomType,  String status,  bool isLocked,  String? rejectionReason,  String? closedBy,  DateTime createdAt,  DateTime updatedAt,  NegotiationProductEntity product,  NegotiationParticipantEntity buyer,  NegotiationParticipantEntity seller,  List<NegotiationMessageEntity>? messages,  int? messagesTotal)  $default,) {final _that = this;
switch (_that) {
case _NegotiationEntity():
return $default(_that.id,_that.orderId,_that.order,_that.productId,_that.buyerId,_that.sellerId,_that.quantity,_that.pricePerUnit,_that.totalEstimate,_that.specifications,_that.roomType,_that.status,_that.isLocked,_that.rejectionReason,_that.closedBy,_that.createdAt,_that.updatedAt,_that.product,_that.buyer,_that.seller,_that.messages,_that.messagesTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? orderId,  NegotiationOrderSummaryEntity? order,  String productId,  String buyerId,  String sellerId,  double quantity,  double pricePerUnit,  double totalEstimate,  String? specifications,  String roomType,  String status,  bool isLocked,  String? rejectionReason,  String? closedBy,  DateTime createdAt,  DateTime updatedAt,  NegotiationProductEntity product,  NegotiationParticipantEntity buyer,  NegotiationParticipantEntity seller,  List<NegotiationMessageEntity>? messages,  int? messagesTotal)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationEntity() when $default != null:
return $default(_that.id,_that.orderId,_that.order,_that.productId,_that.buyerId,_that.sellerId,_that.quantity,_that.pricePerUnit,_that.totalEstimate,_that.specifications,_that.roomType,_that.status,_that.isLocked,_that.rejectionReason,_that.closedBy,_that.createdAt,_that.updatedAt,_that.product,_that.buyer,_that.seller,_that.messages,_that.messagesTotal);case _:
  return null;

}
}

}

/// @nodoc


class _NegotiationEntity implements NegotiationEntity {
  const _NegotiationEntity({required this.id, this.orderId, this.order, required this.productId, required this.buyerId, required this.sellerId, required this.quantity, required this.pricePerUnit, required this.totalEstimate, this.specifications, this.roomType = 'NEGOTIATION', required this.status, required this.isLocked, this.rejectionReason, this.closedBy, required this.createdAt, required this.updatedAt, required this.product, required this.buyer, required this.seller, final  List<NegotiationMessageEntity>? messages, this.messagesTotal}): _messages = messages;
  

@override final  String id;
@override final  String? orderId;
@override final  NegotiationOrderSummaryEntity? order;
@override final  String productId;
@override final  String buyerId;
@override final  String sellerId;
@override final  double quantity;
@override final  double pricePerUnit;
@override final  double totalEstimate;
@override final  String? specifications;
@override@JsonKey() final  String roomType;
@override final  String status;
@override final  bool isLocked;
@override final  String? rejectionReason;
@override final  String? closedBy;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  NegotiationProductEntity product;
@override final  NegotiationParticipantEntity buyer;
@override final  NegotiationParticipantEntity seller;
 final  List<NegotiationMessageEntity>? _messages;
@override List<NegotiationMessageEntity>? get messages {
  final value = _messages;
  if (value == null) return null;
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? messagesTotal;

/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationEntityCopyWith<_NegotiationEntity> get copyWith => __$NegotiationEntityCopyWithImpl<_NegotiationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.order, order) || other.order == order)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.totalEstimate, totalEstimate) || other.totalEstimate == totalEstimate)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.product, product) || other.product == product)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.seller, seller) || other.seller == seller)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.messagesTotal, messagesTotal) || other.messagesTotal == messagesTotal));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,orderId,order,productId,buyerId,sellerId,quantity,pricePerUnit,totalEstimate,specifications,roomType,status,isLocked,rejectionReason,closedBy,createdAt,updatedAt,product,buyer,seller,const DeepCollectionEquality().hash(_messages),messagesTotal]);

@override
String toString() {
  return 'NegotiationEntity(id: $id, orderId: $orderId, order: $order, productId: $productId, buyerId: $buyerId, sellerId: $sellerId, quantity: $quantity, pricePerUnit: $pricePerUnit, totalEstimate: $totalEstimate, specifications: $specifications, roomType: $roomType, status: $status, isLocked: $isLocked, rejectionReason: $rejectionReason, closedBy: $closedBy, createdAt: $createdAt, updatedAt: $updatedAt, product: $product, buyer: $buyer, seller: $seller, messages: $messages, messagesTotal: $messagesTotal)';
}


}

/// @nodoc
abstract mixin class _$NegotiationEntityCopyWith<$Res> implements $NegotiationEntityCopyWith<$Res> {
  factory _$NegotiationEntityCopyWith(_NegotiationEntity value, $Res Function(_NegotiationEntity) _then) = __$NegotiationEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String? orderId, NegotiationOrderSummaryEntity? order, String productId, String buyerId, String sellerId, double quantity, double pricePerUnit, double totalEstimate, String? specifications, String roomType, String status, bool isLocked, String? rejectionReason, String? closedBy, DateTime createdAt, DateTime updatedAt, NegotiationProductEntity product, NegotiationParticipantEntity buyer, NegotiationParticipantEntity seller, List<NegotiationMessageEntity>? messages, int? messagesTotal
});


@override $NegotiationProductEntityCopyWith<$Res> get product;@override $NegotiationParticipantEntityCopyWith<$Res> get buyer;@override $NegotiationParticipantEntityCopyWith<$Res> get seller;

}
/// @nodoc
class __$NegotiationEntityCopyWithImpl<$Res>
    implements _$NegotiationEntityCopyWith<$Res> {
  __$NegotiationEntityCopyWithImpl(this._self, this._then);

  final _NegotiationEntity _self;
  final $Res Function(_NegotiationEntity) _then;

/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = freezed,Object? order = freezed,Object? productId = null,Object? buyerId = null,Object? sellerId = null,Object? quantity = null,Object? pricePerUnit = null,Object? totalEstimate = null,Object? specifications = freezed,Object? roomType = null,Object? status = null,Object? isLocked = null,Object? rejectionReason = freezed,Object? closedBy = freezed,Object? createdAt = null,Object? updatedAt = null,Object? product = null,Object? buyer = null,Object? seller = null,Object? messages = freezed,Object? messagesTotal = freezed,}) {
  return _then(_NegotiationEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as NegotiationOrderSummaryEntity?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,totalEstimate: null == totalEstimate ? _self.totalEstimate : totalEstimate // ignore: cast_nullable_to_non_nullable
as double,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,roomType: null == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as NegotiationProductEntity,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantEntity,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantEntity,messages: freezed == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<NegotiationMessageEntity>?,messagesTotal: freezed == messagesTotal ? _self.messagesTotal : messagesTotal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationProductEntityCopyWith<$Res> get product {
  
  return $NegotiationProductEntityCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantEntityCopyWith<$Res> get buyer {
  
  return $NegotiationParticipantEntityCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of NegotiationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantEntityCopyWith<$Res> get seller {
  
  return $NegotiationParticipantEntityCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}
}

/// @nodoc
mixin _$NegotiationProductEntity {

 String get id; String get name; String? get thumbnailUrl; double get pricePerUnit; String get unit; double get minOrder; String? get description; String? get biomassaType; String? get regency; String? get province; String? get status;
/// Create a copy of NegotiationProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationProductEntityCopyWith<NegotiationProductEntity> get copyWith => _$NegotiationProductEntityCopyWithImpl<NegotiationProductEntity>(this as NegotiationProductEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.description, description) || other.description == description)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.province, province) || other.province == province)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnailUrl,pricePerUnit,unit,minOrder,description,biomassaType,regency,province,status);

@override
String toString() {
  return 'NegotiationProductEntity(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, pricePerUnit: $pricePerUnit, unit: $unit, minOrder: $minOrder, description: $description, biomassaType: $biomassaType, regency: $regency, province: $province, status: $status)';
}


}

/// @nodoc
abstract mixin class $NegotiationProductEntityCopyWith<$Res>  {
  factory $NegotiationProductEntityCopyWith(NegotiationProductEntity value, $Res Function(NegotiationProductEntity) _then) = _$NegotiationProductEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? thumbnailUrl, double pricePerUnit, String unit, double minOrder, String? description, String? biomassaType, String? regency, String? province, String? status
});




}
/// @nodoc
class _$NegotiationProductEntityCopyWithImpl<$Res>
    implements $NegotiationProductEntityCopyWith<$Res> {
  _$NegotiationProductEntityCopyWithImpl(this._self, this._then);

  final NegotiationProductEntity _self;
  final $Res Function(NegotiationProductEntity) _then;

/// Create a copy of NegotiationProductEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? thumbnailUrl = freezed,Object? pricePerUnit = null,Object? unit = null,Object? minOrder = null,Object? description = freezed,Object? biomassaType = freezed,Object? regency = freezed,Object? province = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,minOrder: null == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,biomassaType: freezed == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NegotiationProductEntity].
extension NegotiationProductEntityPatterns on NegotiationProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationProductEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? thumbnailUrl,  double pricePerUnit,  String unit,  double minOrder,  String? description,  String? biomassaType,  String? regency,  String? province,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.thumbnailUrl,_that.pricePerUnit,_that.unit,_that.minOrder,_that.description,_that.biomassaType,_that.regency,_that.province,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? thumbnailUrl,  double pricePerUnit,  String unit,  double minOrder,  String? description,  String? biomassaType,  String? regency,  String? province,  String? status)  $default,) {final _that = this;
switch (_that) {
case _NegotiationProductEntity():
return $default(_that.id,_that.name,_that.thumbnailUrl,_that.pricePerUnit,_that.unit,_that.minOrder,_that.description,_that.biomassaType,_that.regency,_that.province,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? thumbnailUrl,  double pricePerUnit,  String unit,  double minOrder,  String? description,  String? biomassaType,  String? regency,  String? province,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.thumbnailUrl,_that.pricePerUnit,_that.unit,_that.minOrder,_that.description,_that.biomassaType,_that.regency,_that.province,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _NegotiationProductEntity implements NegotiationProductEntity {
  const _NegotiationProductEntity({required this.id, required this.name, this.thumbnailUrl, required this.pricePerUnit, required this.unit, this.minOrder = 1, this.description, this.biomassaType, this.regency, this.province, this.status});
  

@override final  String id;
@override final  String name;
@override final  String? thumbnailUrl;
@override final  double pricePerUnit;
@override final  String unit;
@override@JsonKey() final  double minOrder;
@override final  String? description;
@override final  String? biomassaType;
@override final  String? regency;
@override final  String? province;
@override final  String? status;

/// Create a copy of NegotiationProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationProductEntityCopyWith<_NegotiationProductEntity> get copyWith => __$NegotiationProductEntityCopyWithImpl<_NegotiationProductEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.description, description) || other.description == description)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.province, province) || other.province == province)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnailUrl,pricePerUnit,unit,minOrder,description,biomassaType,regency,province,status);

@override
String toString() {
  return 'NegotiationProductEntity(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, pricePerUnit: $pricePerUnit, unit: $unit, minOrder: $minOrder, description: $description, biomassaType: $biomassaType, regency: $regency, province: $province, status: $status)';
}


}

/// @nodoc
abstract mixin class _$NegotiationProductEntityCopyWith<$Res> implements $NegotiationProductEntityCopyWith<$Res> {
  factory _$NegotiationProductEntityCopyWith(_NegotiationProductEntity value, $Res Function(_NegotiationProductEntity) _then) = __$NegotiationProductEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? thumbnailUrl, double pricePerUnit, String unit, double minOrder, String? description, String? biomassaType, String? regency, String? province, String? status
});




}
/// @nodoc
class __$NegotiationProductEntityCopyWithImpl<$Res>
    implements _$NegotiationProductEntityCopyWith<$Res> {
  __$NegotiationProductEntityCopyWithImpl(this._self, this._then);

  final _NegotiationProductEntity _self;
  final $Res Function(_NegotiationProductEntity) _then;

/// Create a copy of NegotiationProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? thumbnailUrl = freezed,Object? pricePerUnit = null,Object? unit = null,Object? minOrder = null,Object? description = freezed,Object? biomassaType = freezed,Object? regency = freezed,Object? province = freezed,Object? status = freezed,}) {
  return _then(_NegotiationProductEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,minOrder: null == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,biomassaType: freezed == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$NegotiationParticipantEntity {

 String get id; String get name; String? get avatarUrl; String? get companyName;
/// Create a copy of NegotiationParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationParticipantEntityCopyWith<NegotiationParticipantEntity> get copyWith => _$NegotiationParticipantEntityCopyWithImpl<NegotiationParticipantEntity>(this as NegotiationParticipantEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationParticipantEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,companyName);

@override
String toString() {
  return 'NegotiationParticipantEntity(id: $id, name: $name, avatarUrl: $avatarUrl, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class $NegotiationParticipantEntityCopyWith<$Res>  {
  factory $NegotiationParticipantEntityCopyWith(NegotiationParticipantEntity value, $Res Function(NegotiationParticipantEntity) _then) = _$NegotiationParticipantEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? avatarUrl, String? companyName
});




}
/// @nodoc
class _$NegotiationParticipantEntityCopyWithImpl<$Res>
    implements $NegotiationParticipantEntityCopyWith<$Res> {
  _$NegotiationParticipantEntityCopyWithImpl(this._self, this._then);

  final NegotiationParticipantEntity _self;
  final $Res Function(NegotiationParticipantEntity) _then;

/// Create a copy of NegotiationParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? companyName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NegotiationParticipantEntity].
extension NegotiationParticipantEntityPatterns on NegotiationParticipantEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationParticipantEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationParticipantEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationParticipantEntity value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationParticipantEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationParticipantEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationParticipantEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  String? companyName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationParticipantEntity() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.companyName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  String? companyName)  $default,) {final _that = this;
switch (_that) {
case _NegotiationParticipantEntity():
return $default(_that.id,_that.name,_that.avatarUrl,_that.companyName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? avatarUrl,  String? companyName)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationParticipantEntity() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.companyName);case _:
  return null;

}
}

}

/// @nodoc


class _NegotiationParticipantEntity implements NegotiationParticipantEntity {
  const _NegotiationParticipantEntity({required this.id, required this.name, this.avatarUrl, this.companyName});
  

@override final  String id;
@override final  String name;
@override final  String? avatarUrl;
@override final  String? companyName;

/// Create a copy of NegotiationParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationParticipantEntityCopyWith<_NegotiationParticipantEntity> get copyWith => __$NegotiationParticipantEntityCopyWithImpl<_NegotiationParticipantEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationParticipantEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.companyName, companyName) || other.companyName == companyName));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,companyName);

@override
String toString() {
  return 'NegotiationParticipantEntity(id: $id, name: $name, avatarUrl: $avatarUrl, companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class _$NegotiationParticipantEntityCopyWith<$Res> implements $NegotiationParticipantEntityCopyWith<$Res> {
  factory _$NegotiationParticipantEntityCopyWith(_NegotiationParticipantEntity value, $Res Function(_NegotiationParticipantEntity) _then) = __$NegotiationParticipantEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? avatarUrl, String? companyName
});




}
/// @nodoc
class __$NegotiationParticipantEntityCopyWithImpl<$Res>
    implements _$NegotiationParticipantEntityCopyWith<$Res> {
  __$NegotiationParticipantEntityCopyWithImpl(this._self, this._then);

  final _NegotiationParticipantEntity _self;
  final $Res Function(_NegotiationParticipantEntity) _then;

/// Create a copy of NegotiationParticipantEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? companyName = freezed,}) {
  return _then(_NegotiationParticipantEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$NegotiationMessageEntity {

 String get id; String get senderId; String get content; String? get attachmentUrl; bool get isSystemMessage; bool get isRead; bool get isDeleted; DateTime? get editedAt; DateTime get createdAt;
/// Create a copy of NegotiationMessageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationMessageEntityCopyWith<NegotiationMessageEntity> get copyWith => _$NegotiationMessageEntityCopyWithImpl<NegotiationMessageEntity>(this as NegotiationMessageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationMessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.isSystemMessage, isSystemMessage) || other.isSystemMessage == isSystemMessage)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,senderId,content,attachmentUrl,isSystemMessage,isRead,isDeleted,editedAt,createdAt);

@override
String toString() {
  return 'NegotiationMessageEntity(id: $id, senderId: $senderId, content: $content, attachmentUrl: $attachmentUrl, isSystemMessage: $isSystemMessage, isRead: $isRead, isDeleted: $isDeleted, editedAt: $editedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NegotiationMessageEntityCopyWith<$Res>  {
  factory $NegotiationMessageEntityCopyWith(NegotiationMessageEntity value, $Res Function(NegotiationMessageEntity) _then) = _$NegotiationMessageEntityCopyWithImpl;
@useResult
$Res call({
 String id, String senderId, String content, String? attachmentUrl, bool isSystemMessage, bool isRead, bool isDeleted, DateTime? editedAt, DateTime createdAt
});




}
/// @nodoc
class _$NegotiationMessageEntityCopyWithImpl<$Res>
    implements $NegotiationMessageEntityCopyWith<$Res> {
  _$NegotiationMessageEntityCopyWithImpl(this._self, this._then);

  final NegotiationMessageEntity _self;
  final $Res Function(NegotiationMessageEntity) _then;

/// Create a copy of NegotiationMessageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? senderId = null,Object? content = null,Object? attachmentUrl = freezed,Object? isSystemMessage = null,Object? isRead = null,Object? isDeleted = null,Object? editedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,isSystemMessage: null == isSystemMessage ? _self.isSystemMessage : isSystemMessage // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NegotiationMessageEntity].
extension NegotiationMessageEntityPatterns on NegotiationMessageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationMessageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationMessageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationMessageEntity value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationMessageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationMessageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationMessageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String senderId,  String content,  String? attachmentUrl,  bool isSystemMessage,  bool isRead,  bool isDeleted,  DateTime? editedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationMessageEntity() when $default != null:
return $default(_that.id,_that.senderId,_that.content,_that.attachmentUrl,_that.isSystemMessage,_that.isRead,_that.isDeleted,_that.editedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String senderId,  String content,  String? attachmentUrl,  bool isSystemMessage,  bool isRead,  bool isDeleted,  DateTime? editedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _NegotiationMessageEntity():
return $default(_that.id,_that.senderId,_that.content,_that.attachmentUrl,_that.isSystemMessage,_that.isRead,_that.isDeleted,_that.editedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String senderId,  String content,  String? attachmentUrl,  bool isSystemMessage,  bool isRead,  bool isDeleted,  DateTime? editedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationMessageEntity() when $default != null:
return $default(_that.id,_that.senderId,_that.content,_that.attachmentUrl,_that.isSystemMessage,_that.isRead,_that.isDeleted,_that.editedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _NegotiationMessageEntity implements NegotiationMessageEntity {
  const _NegotiationMessageEntity({required this.id, required this.senderId, required this.content, this.attachmentUrl, required this.isSystemMessage, required this.isRead, this.isDeleted = false, this.editedAt, required this.createdAt});
  

@override final  String id;
@override final  String senderId;
@override final  String content;
@override final  String? attachmentUrl;
@override final  bool isSystemMessage;
@override final  bool isRead;
@override@JsonKey() final  bool isDeleted;
@override final  DateTime? editedAt;
@override final  DateTime createdAt;

/// Create a copy of NegotiationMessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationMessageEntityCopyWith<_NegotiationMessageEntity> get copyWith => __$NegotiationMessageEntityCopyWithImpl<_NegotiationMessageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationMessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.isSystemMessage, isSystemMessage) || other.isSystemMessage == isSystemMessage)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,senderId,content,attachmentUrl,isSystemMessage,isRead,isDeleted,editedAt,createdAt);

@override
String toString() {
  return 'NegotiationMessageEntity(id: $id, senderId: $senderId, content: $content, attachmentUrl: $attachmentUrl, isSystemMessage: $isSystemMessage, isRead: $isRead, isDeleted: $isDeleted, editedAt: $editedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NegotiationMessageEntityCopyWith<$Res> implements $NegotiationMessageEntityCopyWith<$Res> {
  factory _$NegotiationMessageEntityCopyWith(_NegotiationMessageEntity value, $Res Function(_NegotiationMessageEntity) _then) = __$NegotiationMessageEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String senderId, String content, String? attachmentUrl, bool isSystemMessage, bool isRead, bool isDeleted, DateTime? editedAt, DateTime createdAt
});




}
/// @nodoc
class __$NegotiationMessageEntityCopyWithImpl<$Res>
    implements _$NegotiationMessageEntityCopyWith<$Res> {
  __$NegotiationMessageEntityCopyWithImpl(this._self, this._then);

  final _NegotiationMessageEntity _self;
  final $Res Function(_NegotiationMessageEntity) _then;

/// Create a copy of NegotiationMessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? senderId = null,Object? content = null,Object? attachmentUrl = freezed,Object? isSystemMessage = null,Object? isRead = null,Object? isDeleted = null,Object? editedAt = freezed,Object? createdAt = null,}) {
  return _then(_NegotiationMessageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,isSystemMessage: null == isSystemMessage ? _self.isSystemMessage : isSystemMessage // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
