// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'negotiation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NegotiationModel {

 String get id; String? get orderId;@JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson) NegotiationOrderSummaryModel? get order; String get productId; String get buyerId; String get sellerId; dynamic get quantity; dynamic get pricePerUnit; dynamic get totalEstimate; String? get specifications; String get roomType; String get status; bool get isLocked; String? get rejectionReason; String? get closedBy; String get createdAt; String get updatedAt; NegotiationProductModel get product; NegotiationParticipantModel get buyer; NegotiationParticipantModel get seller; List<NegotiationMessageModel>? get messages; int? get messagesTotal;
/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationModelCopyWith<NegotiationModel> get copyWith => _$NegotiationModelCopyWithImpl<NegotiationModel>(this as NegotiationModel, _$identity);

  /// Serializes this NegotiationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.order, order) || other.order == order)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&const DeepCollectionEquality().equals(other.quantity, quantity)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.totalEstimate, totalEstimate)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.product, product) || other.product == product)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.seller, seller) || other.seller == seller)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.messagesTotal, messagesTotal) || other.messagesTotal == messagesTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderId,order,productId,buyerId,sellerId,const DeepCollectionEquality().hash(quantity),const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(totalEstimate),specifications,roomType,status,isLocked,rejectionReason,closedBy,createdAt,updatedAt,product,buyer,seller,const DeepCollectionEquality().hash(messages),messagesTotal]);

@override
String toString() {
  return 'NegotiationModel(id: $id, orderId: $orderId, order: $order, productId: $productId, buyerId: $buyerId, sellerId: $sellerId, quantity: $quantity, pricePerUnit: $pricePerUnit, totalEstimate: $totalEstimate, specifications: $specifications, roomType: $roomType, status: $status, isLocked: $isLocked, rejectionReason: $rejectionReason, closedBy: $closedBy, createdAt: $createdAt, updatedAt: $updatedAt, product: $product, buyer: $buyer, seller: $seller, messages: $messages, messagesTotal: $messagesTotal)';
}


}

/// @nodoc
abstract mixin class $NegotiationModelCopyWith<$Res>  {
  factory $NegotiationModelCopyWith(NegotiationModel value, $Res Function(NegotiationModel) _then) = _$NegotiationModelCopyWithImpl;
@useResult
$Res call({
 String id, String? orderId,@JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson) NegotiationOrderSummaryModel? order, String productId, String buyerId, String sellerId, dynamic quantity, dynamic pricePerUnit, dynamic totalEstimate, String? specifications, String roomType, String status, bool isLocked, String? rejectionReason, String? closedBy, String createdAt, String updatedAt, NegotiationProductModel product, NegotiationParticipantModel buyer, NegotiationParticipantModel seller, List<NegotiationMessageModel>? messages, int? messagesTotal
});


$NegotiationProductModelCopyWith<$Res> get product;$NegotiationParticipantModelCopyWith<$Res> get buyer;$NegotiationParticipantModelCopyWith<$Res> get seller;

}
/// @nodoc
class _$NegotiationModelCopyWithImpl<$Res>
    implements $NegotiationModelCopyWith<$Res> {
  _$NegotiationModelCopyWithImpl(this._self, this._then);

  final NegotiationModel _self;
  final $Res Function(NegotiationModel) _then;

/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orderId = freezed,Object? order = freezed,Object? productId = null,Object? buyerId = null,Object? sellerId = null,Object? quantity = freezed,Object? pricePerUnit = freezed,Object? totalEstimate = freezed,Object? specifications = freezed,Object? roomType = null,Object? status = null,Object? isLocked = null,Object? rejectionReason = freezed,Object? closedBy = freezed,Object? createdAt = null,Object? updatedAt = null,Object? product = null,Object? buyer = null,Object? seller = null,Object? messages = freezed,Object? messagesTotal = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as NegotiationOrderSummaryModel?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as dynamic,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,totalEstimate: freezed == totalEstimate ? _self.totalEstimate : totalEstimate // ignore: cast_nullable_to_non_nullable
as dynamic,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,roomType: null == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as NegotiationProductModel,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantModel,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantModel,messages: freezed == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<NegotiationMessageModel>?,messagesTotal: freezed == messagesTotal ? _self.messagesTotal : messagesTotal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationProductModelCopyWith<$Res> get product {
  
  return $NegotiationProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantModelCopyWith<$Res> get buyer {
  
  return $NegotiationParticipantModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantModelCopyWith<$Res> get seller {
  
  return $NegotiationParticipantModelCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}
}


/// Adds pattern-matching-related methods to [NegotiationModel].
extension NegotiationModelPatterns on NegotiationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationModel value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationModel value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? orderId, @JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson)  NegotiationOrderSummaryModel? order,  String productId,  String buyerId,  String sellerId,  dynamic quantity,  dynamic pricePerUnit,  dynamic totalEstimate,  String? specifications,  String roomType,  String status,  bool isLocked,  String? rejectionReason,  String? closedBy,  String createdAt,  String updatedAt,  NegotiationProductModel product,  NegotiationParticipantModel buyer,  NegotiationParticipantModel seller,  List<NegotiationMessageModel>? messages,  int? messagesTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? orderId, @JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson)  NegotiationOrderSummaryModel? order,  String productId,  String buyerId,  String sellerId,  dynamic quantity,  dynamic pricePerUnit,  dynamic totalEstimate,  String? specifications,  String roomType,  String status,  bool isLocked,  String? rejectionReason,  String? closedBy,  String createdAt,  String updatedAt,  NegotiationProductModel product,  NegotiationParticipantModel buyer,  NegotiationParticipantModel seller,  List<NegotiationMessageModel>? messages,  int? messagesTotal)  $default,) {final _that = this;
switch (_that) {
case _NegotiationModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? orderId, @JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson)  NegotiationOrderSummaryModel? order,  String productId,  String buyerId,  String sellerId,  dynamic quantity,  dynamic pricePerUnit,  dynamic totalEstimate,  String? specifications,  String roomType,  String status,  bool isLocked,  String? rejectionReason,  String? closedBy,  String createdAt,  String updatedAt,  NegotiationProductModel product,  NegotiationParticipantModel buyer,  NegotiationParticipantModel seller,  List<NegotiationMessageModel>? messages,  int? messagesTotal)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationModel() when $default != null:
return $default(_that.id,_that.orderId,_that.order,_that.productId,_that.buyerId,_that.sellerId,_that.quantity,_that.pricePerUnit,_that.totalEstimate,_that.specifications,_that.roomType,_that.status,_that.isLocked,_that.rejectionReason,_that.closedBy,_that.createdAt,_that.updatedAt,_that.product,_that.buyer,_that.seller,_that.messages,_that.messagesTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NegotiationModel extends NegotiationModel {
  const _NegotiationModel({required this.id, this.orderId, @JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson) this.order, required this.productId, required this.buyerId, required this.sellerId, required this.quantity, required this.pricePerUnit, required this.totalEstimate, this.specifications, this.roomType = 'NEGOTIATION', required this.status, required this.isLocked, this.rejectionReason, this.closedBy, required this.createdAt, required this.updatedAt, required this.product, required this.buyer, required this.seller, final  List<NegotiationMessageModel>? messages, this.messagesTotal}): _messages = messages,super._();
  factory _NegotiationModel.fromJson(Map<String, dynamic> json) => _$NegotiationModelFromJson(json);

@override final  String id;
@override final  String? orderId;
@override@JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson) final  NegotiationOrderSummaryModel? order;
@override final  String productId;
@override final  String buyerId;
@override final  String sellerId;
@override final  dynamic quantity;
@override final  dynamic pricePerUnit;
@override final  dynamic totalEstimate;
@override final  String? specifications;
@override@JsonKey() final  String roomType;
@override final  String status;
@override final  bool isLocked;
@override final  String? rejectionReason;
@override final  String? closedBy;
@override final  String createdAt;
@override final  String updatedAt;
@override final  NegotiationProductModel product;
@override final  NegotiationParticipantModel buyer;
@override final  NegotiationParticipantModel seller;
 final  List<NegotiationMessageModel>? _messages;
@override List<NegotiationMessageModel>? get messages {
  final value = _messages;
  if (value == null) return null;
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? messagesTotal;

/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationModelCopyWith<_NegotiationModel> get copyWith => __$NegotiationModelCopyWithImpl<_NegotiationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NegotiationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.order, order) || other.order == order)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.buyerId, buyerId) || other.buyerId == buyerId)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&const DeepCollectionEquality().equals(other.quantity, quantity)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.totalEstimate, totalEstimate)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&(identical(other.roomType, roomType) || other.roomType == roomType)&&(identical(other.status, status) || other.status == status)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.closedBy, closedBy) || other.closedBy == closedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.product, product) || other.product == product)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&(identical(other.seller, seller) || other.seller == seller)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.messagesTotal, messagesTotal) || other.messagesTotal == messagesTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,orderId,order,productId,buyerId,sellerId,const DeepCollectionEquality().hash(quantity),const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(totalEstimate),specifications,roomType,status,isLocked,rejectionReason,closedBy,createdAt,updatedAt,product,buyer,seller,const DeepCollectionEquality().hash(_messages),messagesTotal]);

@override
String toString() {
  return 'NegotiationModel(id: $id, orderId: $orderId, order: $order, productId: $productId, buyerId: $buyerId, sellerId: $sellerId, quantity: $quantity, pricePerUnit: $pricePerUnit, totalEstimate: $totalEstimate, specifications: $specifications, roomType: $roomType, status: $status, isLocked: $isLocked, rejectionReason: $rejectionReason, closedBy: $closedBy, createdAt: $createdAt, updatedAt: $updatedAt, product: $product, buyer: $buyer, seller: $seller, messages: $messages, messagesTotal: $messagesTotal)';
}


}

/// @nodoc
abstract mixin class _$NegotiationModelCopyWith<$Res> implements $NegotiationModelCopyWith<$Res> {
  factory _$NegotiationModelCopyWith(_NegotiationModel value, $Res Function(_NegotiationModel) _then) = __$NegotiationModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? orderId,@JsonKey(fromJson: negotiationOrderFromJson, toJson: negotiationOrderToJson) NegotiationOrderSummaryModel? order, String productId, String buyerId, String sellerId, dynamic quantity, dynamic pricePerUnit, dynamic totalEstimate, String? specifications, String roomType, String status, bool isLocked, String? rejectionReason, String? closedBy, String createdAt, String updatedAt, NegotiationProductModel product, NegotiationParticipantModel buyer, NegotiationParticipantModel seller, List<NegotiationMessageModel>? messages, int? messagesTotal
});


@override $NegotiationProductModelCopyWith<$Res> get product;@override $NegotiationParticipantModelCopyWith<$Res> get buyer;@override $NegotiationParticipantModelCopyWith<$Res> get seller;

}
/// @nodoc
class __$NegotiationModelCopyWithImpl<$Res>
    implements _$NegotiationModelCopyWith<$Res> {
  __$NegotiationModelCopyWithImpl(this._self, this._then);

  final _NegotiationModel _self;
  final $Res Function(_NegotiationModel) _then;

/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orderId = freezed,Object? order = freezed,Object? productId = null,Object? buyerId = null,Object? sellerId = null,Object? quantity = freezed,Object? pricePerUnit = freezed,Object? totalEstimate = freezed,Object? specifications = freezed,Object? roomType = null,Object? status = null,Object? isLocked = null,Object? rejectionReason = freezed,Object? closedBy = freezed,Object? createdAt = null,Object? updatedAt = null,Object? product = null,Object? buyer = null,Object? seller = null,Object? messages = freezed,Object? messagesTotal = freezed,}) {
  return _then(_NegotiationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orderId: freezed == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as NegotiationOrderSummaryModel?,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,buyerId: null == buyerId ? _self.buyerId : buyerId // ignore: cast_nullable_to_non_nullable
as String,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as dynamic,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,totalEstimate: freezed == totalEstimate ? _self.totalEstimate : totalEstimate // ignore: cast_nullable_to_non_nullable
as dynamic,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,roomType: null == roomType ? _self.roomType : roomType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,closedBy: freezed == closedBy ? _self.closedBy : closedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as NegotiationProductModel,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantModel,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantModel,messages: freezed == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<NegotiationMessageModel>?,messagesTotal: freezed == messagesTotal ? _self.messagesTotal : messagesTotal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationProductModelCopyWith<$Res> get product {
  
  return $NegotiationProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantModelCopyWith<$Res> get buyer {
  
  return $NegotiationParticipantModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}/// Create a copy of NegotiationModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantModelCopyWith<$Res> get seller {
  
  return $NegotiationParticipantModelCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}
}


/// @nodoc
mixin _$NegotiationProductModel {

 String get id; String get name; String? get thumbnailUrl; dynamic get pricePerUnit; String get unit; dynamic get minOrder; String? get description; String? get biomassaType; String? get regency; String? get province; String? get status;
/// Create a copy of NegotiationProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationProductModelCopyWith<NegotiationProductModel> get copyWith => _$NegotiationProductModelCopyWithImpl<NegotiationProductModel>(this as NegotiationProductModel, _$identity);

  /// Serializes this NegotiationProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other.minOrder, minOrder)&&(identical(other.description, description) || other.description == description)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.province, province) || other.province == province)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnailUrl,const DeepCollectionEquality().hash(pricePerUnit),unit,const DeepCollectionEquality().hash(minOrder),description,biomassaType,regency,province,status);

@override
String toString() {
  return 'NegotiationProductModel(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, pricePerUnit: $pricePerUnit, unit: $unit, minOrder: $minOrder, description: $description, biomassaType: $biomassaType, regency: $regency, province: $province, status: $status)';
}


}

/// @nodoc
abstract mixin class $NegotiationProductModelCopyWith<$Res>  {
  factory $NegotiationProductModelCopyWith(NegotiationProductModel value, $Res Function(NegotiationProductModel) _then) = _$NegotiationProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? thumbnailUrl, dynamic pricePerUnit, String unit, dynamic minOrder, String? description, String? biomassaType, String? regency, String? province, String? status
});




}
/// @nodoc
class _$NegotiationProductModelCopyWithImpl<$Res>
    implements $NegotiationProductModelCopyWith<$Res> {
  _$NegotiationProductModelCopyWithImpl(this._self, this._then);

  final NegotiationProductModel _self;
  final $Res Function(NegotiationProductModel) _then;

/// Create a copy of NegotiationProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? thumbnailUrl = freezed,Object? pricePerUnit = freezed,Object? unit = null,Object? minOrder = freezed,Object? description = freezed,Object? biomassaType = freezed,Object? regency = freezed,Object? province = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,minOrder: freezed == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,biomassaType: freezed == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NegotiationProductModel].
extension NegotiationProductModelPatterns on NegotiationProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationProductModel value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? thumbnailUrl,  dynamic pricePerUnit,  String unit,  dynamic minOrder,  String? description,  String? biomassaType,  String? regency,  String? province,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationProductModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? thumbnailUrl,  dynamic pricePerUnit,  String unit,  dynamic minOrder,  String? description,  String? biomassaType,  String? regency,  String? province,  String? status)  $default,) {final _that = this;
switch (_that) {
case _NegotiationProductModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? thumbnailUrl,  dynamic pricePerUnit,  String unit,  dynamic minOrder,  String? description,  String? biomassaType,  String? regency,  String? province,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationProductModel() when $default != null:
return $default(_that.id,_that.name,_that.thumbnailUrl,_that.pricePerUnit,_that.unit,_that.minOrder,_that.description,_that.biomassaType,_that.regency,_that.province,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NegotiationProductModel extends NegotiationProductModel {
  const _NegotiationProductModel({required this.id, required this.name, this.thumbnailUrl, required this.pricePerUnit, required this.unit, this.minOrder = 1, this.description, this.biomassaType, this.regency, this.province, this.status}): super._();
  factory _NegotiationProductModel.fromJson(Map<String, dynamic> json) => _$NegotiationProductModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? thumbnailUrl;
@override final  dynamic pricePerUnit;
@override final  String unit;
@override@JsonKey() final  dynamic minOrder;
@override final  String? description;
@override final  String? biomassaType;
@override final  String? regency;
@override final  String? province;
@override final  String? status;

/// Create a copy of NegotiationProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationProductModelCopyWith<_NegotiationProductModel> get copyWith => __$NegotiationProductModelCopyWithImpl<_NegotiationProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NegotiationProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&const DeepCollectionEquality().equals(other.minOrder, minOrder)&&(identical(other.description, description) || other.description == description)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.province, province) || other.province == province)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,thumbnailUrl,const DeepCollectionEquality().hash(pricePerUnit),unit,const DeepCollectionEquality().hash(minOrder),description,biomassaType,regency,province,status);

@override
String toString() {
  return 'NegotiationProductModel(id: $id, name: $name, thumbnailUrl: $thumbnailUrl, pricePerUnit: $pricePerUnit, unit: $unit, minOrder: $minOrder, description: $description, biomassaType: $biomassaType, regency: $regency, province: $province, status: $status)';
}


}

/// @nodoc
abstract mixin class _$NegotiationProductModelCopyWith<$Res> implements $NegotiationProductModelCopyWith<$Res> {
  factory _$NegotiationProductModelCopyWith(_NegotiationProductModel value, $Res Function(_NegotiationProductModel) _then) = __$NegotiationProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? thumbnailUrl, dynamic pricePerUnit, String unit, dynamic minOrder, String? description, String? biomassaType, String? regency, String? province, String? status
});




}
/// @nodoc
class __$NegotiationProductModelCopyWithImpl<$Res>
    implements _$NegotiationProductModelCopyWith<$Res> {
  __$NegotiationProductModelCopyWithImpl(this._self, this._then);

  final _NegotiationProductModel _self;
  final $Res Function(_NegotiationProductModel) _then;

/// Create a copy of NegotiationProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? thumbnailUrl = freezed,Object? pricePerUnit = freezed,Object? unit = null,Object? minOrder = freezed,Object? description = freezed,Object? biomassaType = freezed,Object? regency = freezed,Object? province = freezed,Object? status = freezed,}) {
  return _then(_NegotiationProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,minOrder: freezed == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,biomassaType: freezed == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String?,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,province: freezed == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NegotiationParticipantModel {

 String get id;@JsonKey(name: 'fullName') String get name; String? get avatarUrl;@JsonKey(name: 'profile') NegotiationParticipantProfileModel? get profile;
/// Create a copy of NegotiationParticipantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationParticipantModelCopyWith<NegotiationParticipantModel> get copyWith => _$NegotiationParticipantModelCopyWithImpl<NegotiationParticipantModel>(this as NegotiationParticipantModel, _$identity);

  /// Serializes this NegotiationParticipantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,profile);

@override
String toString() {
  return 'NegotiationParticipantModel(id: $id, name: $name, avatarUrl: $avatarUrl, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $NegotiationParticipantModelCopyWith<$Res>  {
  factory $NegotiationParticipantModelCopyWith(NegotiationParticipantModel value, $Res Function(NegotiationParticipantModel) _then) = _$NegotiationParticipantModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'fullName') String name, String? avatarUrl,@JsonKey(name: 'profile') NegotiationParticipantProfileModel? profile
});


$NegotiationParticipantProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class _$NegotiationParticipantModelCopyWithImpl<$Res>
    implements $NegotiationParticipantModelCopyWith<$Res> {
  _$NegotiationParticipantModelCopyWithImpl(this._self, this._then);

  final NegotiationParticipantModel _self;
  final $Res Function(NegotiationParticipantModel) _then;

/// Create a copy of NegotiationParticipantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? profile = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantProfileModel?,
  ));
}
/// Create a copy of NegotiationParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $NegotiationParticipantProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [NegotiationParticipantModel].
extension NegotiationParticipantModelPatterns on NegotiationParticipantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationParticipantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationParticipantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationParticipantModel value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationParticipantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationParticipantModel value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationParticipantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'fullName')  String name,  String? avatarUrl, @JsonKey(name: 'profile')  NegotiationParticipantProfileModel? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationParticipantModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'fullName')  String name,  String? avatarUrl, @JsonKey(name: 'profile')  NegotiationParticipantProfileModel? profile)  $default,) {final _that = this;
switch (_that) {
case _NegotiationParticipantModel():
return $default(_that.id,_that.name,_that.avatarUrl,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'fullName')  String name,  String? avatarUrl, @JsonKey(name: 'profile')  NegotiationParticipantProfileModel? profile)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationParticipantModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NegotiationParticipantModel extends NegotiationParticipantModel {
  const _NegotiationParticipantModel({required this.id, @JsonKey(name: 'fullName') required this.name, this.avatarUrl, @JsonKey(name: 'profile') this.profile}): super._();
  factory _NegotiationParticipantModel.fromJson(Map<String, dynamic> json) => _$NegotiationParticipantModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'fullName') final  String name;
@override final  String? avatarUrl;
@override@JsonKey(name: 'profile') final  NegotiationParticipantProfileModel? profile;

/// Create a copy of NegotiationParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationParticipantModelCopyWith<_NegotiationParticipantModel> get copyWith => __$NegotiationParticipantModelCopyWithImpl<_NegotiationParticipantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NegotiationParticipantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,profile);

@override
String toString() {
  return 'NegotiationParticipantModel(id: $id, name: $name, avatarUrl: $avatarUrl, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$NegotiationParticipantModelCopyWith<$Res> implements $NegotiationParticipantModelCopyWith<$Res> {
  factory _$NegotiationParticipantModelCopyWith(_NegotiationParticipantModel value, $Res Function(_NegotiationParticipantModel) _then) = __$NegotiationParticipantModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'fullName') String name, String? avatarUrl,@JsonKey(name: 'profile') NegotiationParticipantProfileModel? profile
});


@override $NegotiationParticipantProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class __$NegotiationParticipantModelCopyWithImpl<$Res>
    implements _$NegotiationParticipantModelCopyWith<$Res> {
  __$NegotiationParticipantModelCopyWithImpl(this._self, this._then);

  final _NegotiationParticipantModel _self;
  final $Res Function(_NegotiationParticipantModel) _then;

/// Create a copy of NegotiationParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? profile = freezed,}) {
  return _then(_NegotiationParticipantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as NegotiationParticipantProfileModel?,
  ));
}

/// Create a copy of NegotiationParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NegotiationParticipantProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $NegotiationParticipantProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$NegotiationParticipantProfileModel {

 String? get companyName;
/// Create a copy of NegotiationParticipantProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationParticipantProfileModelCopyWith<NegotiationParticipantProfileModel> get copyWith => _$NegotiationParticipantProfileModelCopyWithImpl<NegotiationParticipantProfileModel>(this as NegotiationParticipantProfileModel, _$identity);

  /// Serializes this NegotiationParticipantProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationParticipantProfileModel&&(identical(other.companyName, companyName) || other.companyName == companyName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName);

@override
String toString() {
  return 'NegotiationParticipantProfileModel(companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class $NegotiationParticipantProfileModelCopyWith<$Res>  {
  factory $NegotiationParticipantProfileModelCopyWith(NegotiationParticipantProfileModel value, $Res Function(NegotiationParticipantProfileModel) _then) = _$NegotiationParticipantProfileModelCopyWithImpl;
@useResult
$Res call({
 String? companyName
});




}
/// @nodoc
class _$NegotiationParticipantProfileModelCopyWithImpl<$Res>
    implements $NegotiationParticipantProfileModelCopyWith<$Res> {
  _$NegotiationParticipantProfileModelCopyWithImpl(this._self, this._then);

  final NegotiationParticipantProfileModel _self;
  final $Res Function(NegotiationParticipantProfileModel) _then;

/// Create a copy of NegotiationParticipantProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = freezed,}) {
  return _then(_self.copyWith(
companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NegotiationParticipantProfileModel].
extension NegotiationParticipantProfileModelPatterns on NegotiationParticipantProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationParticipantProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationParticipantProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationParticipantProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationParticipantProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationParticipantProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationParticipantProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? companyName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationParticipantProfileModel() when $default != null:
return $default(_that.companyName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? companyName)  $default,) {final _that = this;
switch (_that) {
case _NegotiationParticipantProfileModel():
return $default(_that.companyName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? companyName)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationParticipantProfileModel() when $default != null:
return $default(_that.companyName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NegotiationParticipantProfileModel implements NegotiationParticipantProfileModel {
  const _NegotiationParticipantProfileModel({this.companyName});
  factory _NegotiationParticipantProfileModel.fromJson(Map<String, dynamic> json) => _$NegotiationParticipantProfileModelFromJson(json);

@override final  String? companyName;

/// Create a copy of NegotiationParticipantProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationParticipantProfileModelCopyWith<_NegotiationParticipantProfileModel> get copyWith => __$NegotiationParticipantProfileModelCopyWithImpl<_NegotiationParticipantProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NegotiationParticipantProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationParticipantProfileModel&&(identical(other.companyName, companyName) || other.companyName == companyName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName);

@override
String toString() {
  return 'NegotiationParticipantProfileModel(companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class _$NegotiationParticipantProfileModelCopyWith<$Res> implements $NegotiationParticipantProfileModelCopyWith<$Res> {
  factory _$NegotiationParticipantProfileModelCopyWith(_NegotiationParticipantProfileModel value, $Res Function(_NegotiationParticipantProfileModel) _then) = __$NegotiationParticipantProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String? companyName
});




}
/// @nodoc
class __$NegotiationParticipantProfileModelCopyWithImpl<$Res>
    implements _$NegotiationParticipantProfileModelCopyWith<$Res> {
  __$NegotiationParticipantProfileModelCopyWithImpl(this._self, this._then);

  final _NegotiationParticipantProfileModel _self;
  final $Res Function(_NegotiationParticipantProfileModel) _then;

/// Create a copy of NegotiationParticipantProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = freezed,}) {
  return _then(_NegotiationParticipantProfileModel(
companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NegotiationMessageModel {

 String get id; String get senderId; String get content; String? get attachmentUrl; bool get isSystemMessage; bool get isRead; bool get isDeleted; String? get editedAt; String get createdAt;
/// Create a copy of NegotiationMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationMessageModelCopyWith<NegotiationMessageModel> get copyWith => _$NegotiationMessageModelCopyWithImpl<NegotiationMessageModel>(this as NegotiationMessageModel, _$identity);

  /// Serializes this NegotiationMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.isSystemMessage, isSystemMessage) || other.isSystemMessage == isSystemMessage)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,senderId,content,attachmentUrl,isSystemMessage,isRead,isDeleted,editedAt,createdAt);

@override
String toString() {
  return 'NegotiationMessageModel(id: $id, senderId: $senderId, content: $content, attachmentUrl: $attachmentUrl, isSystemMessage: $isSystemMessage, isRead: $isRead, isDeleted: $isDeleted, editedAt: $editedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $NegotiationMessageModelCopyWith<$Res>  {
  factory $NegotiationMessageModelCopyWith(NegotiationMessageModel value, $Res Function(NegotiationMessageModel) _then) = _$NegotiationMessageModelCopyWithImpl;
@useResult
$Res call({
 String id, String senderId, String content, String? attachmentUrl, bool isSystemMessage, bool isRead, bool isDeleted, String? editedAt, String createdAt
});




}
/// @nodoc
class _$NegotiationMessageModelCopyWithImpl<$Res>
    implements $NegotiationMessageModelCopyWith<$Res> {
  _$NegotiationMessageModelCopyWithImpl(this._self, this._then);

  final NegotiationMessageModel _self;
  final $Res Function(NegotiationMessageModel) _then;

/// Create a copy of NegotiationMessageModel
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
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NegotiationMessageModel].
extension NegotiationMessageModelPatterns on NegotiationMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String senderId,  String content,  String? attachmentUrl,  bool isSystemMessage,  bool isRead,  bool isDeleted,  String? editedAt,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationMessageModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String senderId,  String content,  String? attachmentUrl,  bool isSystemMessage,  bool isRead,  bool isDeleted,  String? editedAt,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _NegotiationMessageModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String senderId,  String content,  String? attachmentUrl,  bool isSystemMessage,  bool isRead,  bool isDeleted,  String? editedAt,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationMessageModel() when $default != null:
return $default(_that.id,_that.senderId,_that.content,_that.attachmentUrl,_that.isSystemMessage,_that.isRead,_that.isDeleted,_that.editedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NegotiationMessageModel extends NegotiationMessageModel {
  const _NegotiationMessageModel({required this.id, required this.senderId, required this.content, this.attachmentUrl, this.isSystemMessage = false, this.isRead = false, this.isDeleted = false, this.editedAt, required this.createdAt}): super._();
  factory _NegotiationMessageModel.fromJson(Map<String, dynamic> json) => _$NegotiationMessageModelFromJson(json);

@override final  String id;
@override final  String senderId;
@override final  String content;
@override final  String? attachmentUrl;
@override@JsonKey() final  bool isSystemMessage;
@override@JsonKey() final  bool isRead;
@override@JsonKey() final  bool isDeleted;
@override final  String? editedAt;
@override final  String createdAt;

/// Create a copy of NegotiationMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationMessageModelCopyWith<_NegotiationMessageModel> get copyWith => __$NegotiationMessageModelCopyWithImpl<_NegotiationMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NegotiationMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationMessageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.content, content) || other.content == content)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&(identical(other.isSystemMessage, isSystemMessage) || other.isSystemMessage == isSystemMessage)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,senderId,content,attachmentUrl,isSystemMessage,isRead,isDeleted,editedAt,createdAt);

@override
String toString() {
  return 'NegotiationMessageModel(id: $id, senderId: $senderId, content: $content, attachmentUrl: $attachmentUrl, isSystemMessage: $isSystemMessage, isRead: $isRead, isDeleted: $isDeleted, editedAt: $editedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NegotiationMessageModelCopyWith<$Res> implements $NegotiationMessageModelCopyWith<$Res> {
  factory _$NegotiationMessageModelCopyWith(_NegotiationMessageModel value, $Res Function(_NegotiationMessageModel) _then) = __$NegotiationMessageModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String senderId, String content, String? attachmentUrl, bool isSystemMessage, bool isRead, bool isDeleted, String? editedAt, String createdAt
});




}
/// @nodoc
class __$NegotiationMessageModelCopyWithImpl<$Res>
    implements _$NegotiationMessageModelCopyWith<$Res> {
  __$NegotiationMessageModelCopyWithImpl(this._self, this._then);

  final _NegotiationMessageModel _self;
  final $Res Function(_NegotiationMessageModel) _then;

/// Create a copy of NegotiationMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? senderId = null,Object? content = null,Object? attachmentUrl = freezed,Object? isSystemMessage = null,Object? isRead = null,Object? isDeleted = null,Object? editedAt = freezed,Object? createdAt = null,}) {
  return _then(_NegotiationMessageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,isSystemMessage: null == isSystemMessage ? _self.isSystemMessage : isSystemMessage // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
