// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_preview_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoicePreviewModel {

 String get negotiationId; InvoicePreviewProductModel get product; InvoicePreviewBuyerModel get buyer; dynamic get quantity; dynamic get pricePerUnit; dynamic get subtotal; dynamic get platformFee;@JsonKey(name: 'logisticsFee') dynamic get logisticsFee; dynamic get vatAmount; dynamic get totalAmount; String? get specifications;@JsonKey(name: 'buyerShippingSnapshot') Map<String, dynamic>? get shippingSnapshot;
/// Create a copy of InvoicePreviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicePreviewModelCopyWith<InvoicePreviewModel> get copyWith => _$InvoicePreviewModelCopyWithImpl<InvoicePreviewModel>(this as InvoicePreviewModel, _$identity);

  /// Serializes this InvoicePreviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicePreviewModel&&(identical(other.negotiationId, negotiationId) || other.negotiationId == negotiationId)&&(identical(other.product, product) || other.product == product)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&const DeepCollectionEquality().equals(other.quantity, quantity)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.subtotal, subtotal)&&const DeepCollectionEquality().equals(other.platformFee, platformFee)&&const DeepCollectionEquality().equals(other.logisticsFee, logisticsFee)&&const DeepCollectionEquality().equals(other.vatAmount, vatAmount)&&const DeepCollectionEquality().equals(other.totalAmount, totalAmount)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&const DeepCollectionEquality().equals(other.shippingSnapshot, shippingSnapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,negotiationId,product,buyer,const DeepCollectionEquality().hash(quantity),const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(subtotal),const DeepCollectionEquality().hash(platformFee),const DeepCollectionEquality().hash(logisticsFee),const DeepCollectionEquality().hash(vatAmount),const DeepCollectionEquality().hash(totalAmount),specifications,const DeepCollectionEquality().hash(shippingSnapshot));

@override
String toString() {
  return 'InvoicePreviewModel(negotiationId: $negotiationId, product: $product, buyer: $buyer, quantity: $quantity, pricePerUnit: $pricePerUnit, subtotal: $subtotal, platformFee: $platformFee, logisticsFee: $logisticsFee, vatAmount: $vatAmount, totalAmount: $totalAmount, specifications: $specifications, shippingSnapshot: $shippingSnapshot)';
}


}

/// @nodoc
abstract mixin class $InvoicePreviewModelCopyWith<$Res>  {
  factory $InvoicePreviewModelCopyWith(InvoicePreviewModel value, $Res Function(InvoicePreviewModel) _then) = _$InvoicePreviewModelCopyWithImpl;
@useResult
$Res call({
 String negotiationId, InvoicePreviewProductModel product, InvoicePreviewBuyerModel buyer, dynamic quantity, dynamic pricePerUnit, dynamic subtotal, dynamic platformFee,@JsonKey(name: 'logisticsFee') dynamic logisticsFee, dynamic vatAmount, dynamic totalAmount, String? specifications,@JsonKey(name: 'buyerShippingSnapshot') Map<String, dynamic>? shippingSnapshot
});


$InvoicePreviewProductModelCopyWith<$Res> get product;$InvoicePreviewBuyerModelCopyWith<$Res> get buyer;

}
/// @nodoc
class _$InvoicePreviewModelCopyWithImpl<$Res>
    implements $InvoicePreviewModelCopyWith<$Res> {
  _$InvoicePreviewModelCopyWithImpl(this._self, this._then);

  final InvoicePreviewModel _self;
  final $Res Function(InvoicePreviewModel) _then;

/// Create a copy of InvoicePreviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? negotiationId = null,Object? product = null,Object? buyer = null,Object? quantity = freezed,Object? pricePerUnit = freezed,Object? subtotal = freezed,Object? platformFee = freezed,Object? logisticsFee = freezed,Object? vatAmount = freezed,Object? totalAmount = freezed,Object? specifications = freezed,Object? shippingSnapshot = freezed,}) {
  return _then(_self.copyWith(
negotiationId: null == negotiationId ? _self.negotiationId : negotiationId // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as InvoicePreviewProductModel,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as InvoicePreviewBuyerModel,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as dynamic,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as dynamic,platformFee: freezed == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as dynamic,logisticsFee: freezed == logisticsFee ? _self.logisticsFee : logisticsFee // ignore: cast_nullable_to_non_nullable
as dynamic,vatAmount: freezed == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as dynamic,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as dynamic,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,shippingSnapshot: freezed == shippingSnapshot ? _self.shippingSnapshot : shippingSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of InvoicePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoicePreviewProductModelCopyWith<$Res> get product {
  
  return $InvoicePreviewProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of InvoicePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoicePreviewBuyerModelCopyWith<$Res> get buyer {
  
  return $InvoicePreviewBuyerModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}
}


/// Adds pattern-matching-related methods to [InvoicePreviewModel].
extension InvoicePreviewModelPatterns on InvoicePreviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoicePreviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoicePreviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoicePreviewModel value)  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoicePreviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String negotiationId,  InvoicePreviewProductModel product,  InvoicePreviewBuyerModel buyer,  dynamic quantity,  dynamic pricePerUnit,  dynamic subtotal,  dynamic platformFee, @JsonKey(name: 'logisticsFee')  dynamic logisticsFee,  dynamic vatAmount,  dynamic totalAmount,  String? specifications, @JsonKey(name: 'buyerShippingSnapshot')  Map<String, dynamic>? shippingSnapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoicePreviewModel() when $default != null:
return $default(_that.negotiationId,_that.product,_that.buyer,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.totalAmount,_that.specifications,_that.shippingSnapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String negotiationId,  InvoicePreviewProductModel product,  InvoicePreviewBuyerModel buyer,  dynamic quantity,  dynamic pricePerUnit,  dynamic subtotal,  dynamic platformFee, @JsonKey(name: 'logisticsFee')  dynamic logisticsFee,  dynamic vatAmount,  dynamic totalAmount,  String? specifications, @JsonKey(name: 'buyerShippingSnapshot')  Map<String, dynamic>? shippingSnapshot)  $default,) {final _that = this;
switch (_that) {
case _InvoicePreviewModel():
return $default(_that.negotiationId,_that.product,_that.buyer,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.totalAmount,_that.specifications,_that.shippingSnapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String negotiationId,  InvoicePreviewProductModel product,  InvoicePreviewBuyerModel buyer,  dynamic quantity,  dynamic pricePerUnit,  dynamic subtotal,  dynamic platformFee, @JsonKey(name: 'logisticsFee')  dynamic logisticsFee,  dynamic vatAmount,  dynamic totalAmount,  String? specifications, @JsonKey(name: 'buyerShippingSnapshot')  Map<String, dynamic>? shippingSnapshot)?  $default,) {final _that = this;
switch (_that) {
case _InvoicePreviewModel() when $default != null:
return $default(_that.negotiationId,_that.product,_that.buyer,_that.quantity,_that.pricePerUnit,_that.subtotal,_that.platformFee,_that.logisticsFee,_that.vatAmount,_that.totalAmount,_that.specifications,_that.shippingSnapshot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoicePreviewModel extends InvoicePreviewModel {
  const _InvoicePreviewModel({required this.negotiationId, required this.product, required this.buyer, required this.quantity, required this.pricePerUnit, required this.subtotal, required this.platformFee, @JsonKey(name: 'logisticsFee') this.logisticsFee, required this.vatAmount, required this.totalAmount, this.specifications, @JsonKey(name: 'buyerShippingSnapshot') final  Map<String, dynamic>? shippingSnapshot}): _shippingSnapshot = shippingSnapshot,super._();
  factory _InvoicePreviewModel.fromJson(Map<String, dynamic> json) => _$InvoicePreviewModelFromJson(json);

@override final  String negotiationId;
@override final  InvoicePreviewProductModel product;
@override final  InvoicePreviewBuyerModel buyer;
@override final  dynamic quantity;
@override final  dynamic pricePerUnit;
@override final  dynamic subtotal;
@override final  dynamic platformFee;
@override@JsonKey(name: 'logisticsFee') final  dynamic logisticsFee;
@override final  dynamic vatAmount;
@override final  dynamic totalAmount;
@override final  String? specifications;
 final  Map<String, dynamic>? _shippingSnapshot;
@override@JsonKey(name: 'buyerShippingSnapshot') Map<String, dynamic>? get shippingSnapshot {
  final value = _shippingSnapshot;
  if (value == null) return null;
  if (_shippingSnapshot is EqualUnmodifiableMapView) return _shippingSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of InvoicePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoicePreviewModelCopyWith<_InvoicePreviewModel> get copyWith => __$InvoicePreviewModelCopyWithImpl<_InvoicePreviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoicePreviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoicePreviewModel&&(identical(other.negotiationId, negotiationId) || other.negotiationId == negotiationId)&&(identical(other.product, product) || other.product == product)&&(identical(other.buyer, buyer) || other.buyer == buyer)&&const DeepCollectionEquality().equals(other.quantity, quantity)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.subtotal, subtotal)&&const DeepCollectionEquality().equals(other.platformFee, platformFee)&&const DeepCollectionEquality().equals(other.logisticsFee, logisticsFee)&&const DeepCollectionEquality().equals(other.vatAmount, vatAmount)&&const DeepCollectionEquality().equals(other.totalAmount, totalAmount)&&(identical(other.specifications, specifications) || other.specifications == specifications)&&const DeepCollectionEquality().equals(other._shippingSnapshot, _shippingSnapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,negotiationId,product,buyer,const DeepCollectionEquality().hash(quantity),const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(subtotal),const DeepCollectionEquality().hash(platformFee),const DeepCollectionEquality().hash(logisticsFee),const DeepCollectionEquality().hash(vatAmount),const DeepCollectionEquality().hash(totalAmount),specifications,const DeepCollectionEquality().hash(_shippingSnapshot));

@override
String toString() {
  return 'InvoicePreviewModel(negotiationId: $negotiationId, product: $product, buyer: $buyer, quantity: $quantity, pricePerUnit: $pricePerUnit, subtotal: $subtotal, platformFee: $platformFee, logisticsFee: $logisticsFee, vatAmount: $vatAmount, totalAmount: $totalAmount, specifications: $specifications, shippingSnapshot: $shippingSnapshot)';
}


}

/// @nodoc
abstract mixin class _$InvoicePreviewModelCopyWith<$Res> implements $InvoicePreviewModelCopyWith<$Res> {
  factory _$InvoicePreviewModelCopyWith(_InvoicePreviewModel value, $Res Function(_InvoicePreviewModel) _then) = __$InvoicePreviewModelCopyWithImpl;
@override @useResult
$Res call({
 String negotiationId, InvoicePreviewProductModel product, InvoicePreviewBuyerModel buyer, dynamic quantity, dynamic pricePerUnit, dynamic subtotal, dynamic platformFee,@JsonKey(name: 'logisticsFee') dynamic logisticsFee, dynamic vatAmount, dynamic totalAmount, String? specifications,@JsonKey(name: 'buyerShippingSnapshot') Map<String, dynamic>? shippingSnapshot
});


@override $InvoicePreviewProductModelCopyWith<$Res> get product;@override $InvoicePreviewBuyerModelCopyWith<$Res> get buyer;

}
/// @nodoc
class __$InvoicePreviewModelCopyWithImpl<$Res>
    implements _$InvoicePreviewModelCopyWith<$Res> {
  __$InvoicePreviewModelCopyWithImpl(this._self, this._then);

  final _InvoicePreviewModel _self;
  final $Res Function(_InvoicePreviewModel) _then;

/// Create a copy of InvoicePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? negotiationId = null,Object? product = null,Object? buyer = null,Object? quantity = freezed,Object? pricePerUnit = freezed,Object? subtotal = freezed,Object? platformFee = freezed,Object? logisticsFee = freezed,Object? vatAmount = freezed,Object? totalAmount = freezed,Object? specifications = freezed,Object? shippingSnapshot = freezed,}) {
  return _then(_InvoicePreviewModel(
negotiationId: null == negotiationId ? _self.negotiationId : negotiationId // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as InvoicePreviewProductModel,buyer: null == buyer ? _self.buyer : buyer // ignore: cast_nullable_to_non_nullable
as InvoicePreviewBuyerModel,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as dynamic,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,subtotal: freezed == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as dynamic,platformFee: freezed == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as dynamic,logisticsFee: freezed == logisticsFee ? _self.logisticsFee : logisticsFee // ignore: cast_nullable_to_non_nullable
as dynamic,vatAmount: freezed == vatAmount ? _self.vatAmount : vatAmount // ignore: cast_nullable_to_non_nullable
as dynamic,totalAmount: freezed == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as dynamic,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,shippingSnapshot: freezed == shippingSnapshot ? _self._shippingSnapshot : shippingSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of InvoicePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoicePreviewProductModelCopyWith<$Res> get product {
  
  return $InvoicePreviewProductModelCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of InvoicePreviewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoicePreviewBuyerModelCopyWith<$Res> get buyer {
  
  return $InvoicePreviewBuyerModelCopyWith<$Res>(_self.buyer, (value) {
    return _then(_self.copyWith(buyer: value));
  });
}
}


/// @nodoc
mixin _$InvoicePreviewProductModel {

 String get id; String get name; String get unit; String? get thumbnailUrl; dynamic get pricePerUnit; dynamic get stock; dynamic get minOrder;
/// Create a copy of InvoicePreviewProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicePreviewProductModelCopyWith<InvoicePreviewProductModel> get copyWith => _$InvoicePreviewProductModelCopyWithImpl<InvoicePreviewProductModel>(this as InvoicePreviewProductModel, _$identity);

  /// Serializes this InvoicePreviewProductModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicePreviewProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.stock, stock)&&const DeepCollectionEquality().equals(other.minOrder, minOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unit,thumbnailUrl,const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(stock),const DeepCollectionEquality().hash(minOrder));

@override
String toString() {
  return 'InvoicePreviewProductModel(id: $id, name: $name, unit: $unit, thumbnailUrl: $thumbnailUrl, pricePerUnit: $pricePerUnit, stock: $stock, minOrder: $minOrder)';
}


}

/// @nodoc
abstract mixin class $InvoicePreviewProductModelCopyWith<$Res>  {
  factory $InvoicePreviewProductModelCopyWith(InvoicePreviewProductModel value, $Res Function(InvoicePreviewProductModel) _then) = _$InvoicePreviewProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String unit, String? thumbnailUrl, dynamic pricePerUnit, dynamic stock, dynamic minOrder
});




}
/// @nodoc
class _$InvoicePreviewProductModelCopyWithImpl<$Res>
    implements $InvoicePreviewProductModelCopyWith<$Res> {
  _$InvoicePreviewProductModelCopyWithImpl(this._self, this._then);

  final InvoicePreviewProductModel _self;
  final $Res Function(InvoicePreviewProductModel) _then;

/// Create a copy of InvoicePreviewProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? thumbnailUrl = freezed,Object? pricePerUnit = freezed,Object? stock = freezed,Object? minOrder = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as dynamic,minOrder: freezed == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoicePreviewProductModel].
extension InvoicePreviewProductModelPatterns on InvoicePreviewProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoicePreviewProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoicePreviewProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoicePreviewProductModel value)  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoicePreviewProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  String? thumbnailUrl,  dynamic pricePerUnit,  dynamic stock,  dynamic minOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoicePreviewProductModel() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.thumbnailUrl,_that.pricePerUnit,_that.stock,_that.minOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String unit,  String? thumbnailUrl,  dynamic pricePerUnit,  dynamic stock,  dynamic minOrder)  $default,) {final _that = this;
switch (_that) {
case _InvoicePreviewProductModel():
return $default(_that.id,_that.name,_that.unit,_that.thumbnailUrl,_that.pricePerUnit,_that.stock,_that.minOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String unit,  String? thumbnailUrl,  dynamic pricePerUnit,  dynamic stock,  dynamic minOrder)?  $default,) {final _that = this;
switch (_that) {
case _InvoicePreviewProductModel() when $default != null:
return $default(_that.id,_that.name,_that.unit,_that.thumbnailUrl,_that.pricePerUnit,_that.stock,_that.minOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoicePreviewProductModel implements InvoicePreviewProductModel {
  const _InvoicePreviewProductModel({required this.id, required this.name, required this.unit, this.thumbnailUrl, this.pricePerUnit = 0, this.stock = 0, this.minOrder = 1});
  factory _InvoicePreviewProductModel.fromJson(Map<String, dynamic> json) => _$InvoicePreviewProductModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String unit;
@override final  String? thumbnailUrl;
@override@JsonKey() final  dynamic pricePerUnit;
@override@JsonKey() final  dynamic stock;
@override@JsonKey() final  dynamic minOrder;

/// Create a copy of InvoicePreviewProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoicePreviewProductModelCopyWith<_InvoicePreviewProductModel> get copyWith => __$InvoicePreviewProductModelCopyWithImpl<_InvoicePreviewProductModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoicePreviewProductModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoicePreviewProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.stock, stock)&&const DeepCollectionEquality().equals(other.minOrder, minOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,unit,thumbnailUrl,const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(stock),const DeepCollectionEquality().hash(minOrder));

@override
String toString() {
  return 'InvoicePreviewProductModel(id: $id, name: $name, unit: $unit, thumbnailUrl: $thumbnailUrl, pricePerUnit: $pricePerUnit, stock: $stock, minOrder: $minOrder)';
}


}

/// @nodoc
abstract mixin class _$InvoicePreviewProductModelCopyWith<$Res> implements $InvoicePreviewProductModelCopyWith<$Res> {
  factory _$InvoicePreviewProductModelCopyWith(_InvoicePreviewProductModel value, $Res Function(_InvoicePreviewProductModel) _then) = __$InvoicePreviewProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String unit, String? thumbnailUrl, dynamic pricePerUnit, dynamic stock, dynamic minOrder
});




}
/// @nodoc
class __$InvoicePreviewProductModelCopyWithImpl<$Res>
    implements _$InvoicePreviewProductModelCopyWith<$Res> {
  __$InvoicePreviewProductModelCopyWithImpl(this._self, this._then);

  final _InvoicePreviewProductModel _self;
  final $Res Function(_InvoicePreviewProductModel) _then;

/// Create a copy of InvoicePreviewProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? unit = null,Object? thumbnailUrl = freezed,Object? pricePerUnit = freezed,Object? stock = freezed,Object? minOrder = freezed,}) {
  return _then(_InvoicePreviewProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as dynamic,minOrder: freezed == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}


/// @nodoc
mixin _$InvoicePreviewBuyerModel {

 String get id;@JsonKey(name: 'fullName') String get name; InvoicePreviewBuyerProfileModel? get profile;
/// Create a copy of InvoicePreviewBuyerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicePreviewBuyerModelCopyWith<InvoicePreviewBuyerModel> get copyWith => _$InvoicePreviewBuyerModelCopyWithImpl<InvoicePreviewBuyerModel>(this as InvoicePreviewBuyerModel, _$identity);

  /// Serializes this InvoicePreviewBuyerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicePreviewBuyerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profile);

@override
String toString() {
  return 'InvoicePreviewBuyerModel(id: $id, name: $name, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $InvoicePreviewBuyerModelCopyWith<$Res>  {
  factory $InvoicePreviewBuyerModelCopyWith(InvoicePreviewBuyerModel value, $Res Function(InvoicePreviewBuyerModel) _then) = _$InvoicePreviewBuyerModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'fullName') String name, InvoicePreviewBuyerProfileModel? profile
});


$InvoicePreviewBuyerProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class _$InvoicePreviewBuyerModelCopyWithImpl<$Res>
    implements $InvoicePreviewBuyerModelCopyWith<$Res> {
  _$InvoicePreviewBuyerModelCopyWithImpl(this._self, this._then);

  final InvoicePreviewBuyerModel _self;
  final $Res Function(InvoicePreviewBuyerModel) _then;

/// Create a copy of InvoicePreviewBuyerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? profile = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as InvoicePreviewBuyerProfileModel?,
  ));
}
/// Create a copy of InvoicePreviewBuyerModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoicePreviewBuyerProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $InvoicePreviewBuyerProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [InvoicePreviewBuyerModel].
extension InvoicePreviewBuyerModelPatterns on InvoicePreviewBuyerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoicePreviewBuyerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoicePreviewBuyerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoicePreviewBuyerModel value)  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewBuyerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoicePreviewBuyerModel value)?  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewBuyerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'fullName')  String name,  InvoicePreviewBuyerProfileModel? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoicePreviewBuyerModel() when $default != null:
return $default(_that.id,_that.name,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'fullName')  String name,  InvoicePreviewBuyerProfileModel? profile)  $default,) {final _that = this;
switch (_that) {
case _InvoicePreviewBuyerModel():
return $default(_that.id,_that.name,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'fullName')  String name,  InvoicePreviewBuyerProfileModel? profile)?  $default,) {final _that = this;
switch (_that) {
case _InvoicePreviewBuyerModel() when $default != null:
return $default(_that.id,_that.name,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoicePreviewBuyerModel implements InvoicePreviewBuyerModel {
  const _InvoicePreviewBuyerModel({required this.id, @JsonKey(name: 'fullName') required this.name, this.profile});
  factory _InvoicePreviewBuyerModel.fromJson(Map<String, dynamic> json) => _$InvoicePreviewBuyerModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'fullName') final  String name;
@override final  InvoicePreviewBuyerProfileModel? profile;

/// Create a copy of InvoicePreviewBuyerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoicePreviewBuyerModelCopyWith<_InvoicePreviewBuyerModel> get copyWith => __$InvoicePreviewBuyerModelCopyWithImpl<_InvoicePreviewBuyerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoicePreviewBuyerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoicePreviewBuyerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profile);

@override
String toString() {
  return 'InvoicePreviewBuyerModel(id: $id, name: $name, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$InvoicePreviewBuyerModelCopyWith<$Res> implements $InvoicePreviewBuyerModelCopyWith<$Res> {
  factory _$InvoicePreviewBuyerModelCopyWith(_InvoicePreviewBuyerModel value, $Res Function(_InvoicePreviewBuyerModel) _then) = __$InvoicePreviewBuyerModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'fullName') String name, InvoicePreviewBuyerProfileModel? profile
});


@override $InvoicePreviewBuyerProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class __$InvoicePreviewBuyerModelCopyWithImpl<$Res>
    implements _$InvoicePreviewBuyerModelCopyWith<$Res> {
  __$InvoicePreviewBuyerModelCopyWithImpl(this._self, this._then);

  final _InvoicePreviewBuyerModel _self;
  final $Res Function(_InvoicePreviewBuyerModel) _then;

/// Create a copy of InvoicePreviewBuyerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? profile = freezed,}) {
  return _then(_InvoicePreviewBuyerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as InvoicePreviewBuyerProfileModel?,
  ));
}

/// Create a copy of InvoicePreviewBuyerModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InvoicePreviewBuyerProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $InvoicePreviewBuyerProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$InvoicePreviewBuyerProfileModel {

 String? get companyName;
/// Create a copy of InvoicePreviewBuyerProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoicePreviewBuyerProfileModelCopyWith<InvoicePreviewBuyerProfileModel> get copyWith => _$InvoicePreviewBuyerProfileModelCopyWithImpl<InvoicePreviewBuyerProfileModel>(this as InvoicePreviewBuyerProfileModel, _$identity);

  /// Serializes this InvoicePreviewBuyerProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoicePreviewBuyerProfileModel&&(identical(other.companyName, companyName) || other.companyName == companyName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName);

@override
String toString() {
  return 'InvoicePreviewBuyerProfileModel(companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class $InvoicePreviewBuyerProfileModelCopyWith<$Res>  {
  factory $InvoicePreviewBuyerProfileModelCopyWith(InvoicePreviewBuyerProfileModel value, $Res Function(InvoicePreviewBuyerProfileModel) _then) = _$InvoicePreviewBuyerProfileModelCopyWithImpl;
@useResult
$Res call({
 String? companyName
});




}
/// @nodoc
class _$InvoicePreviewBuyerProfileModelCopyWithImpl<$Res>
    implements $InvoicePreviewBuyerProfileModelCopyWith<$Res> {
  _$InvoicePreviewBuyerProfileModelCopyWithImpl(this._self, this._then);

  final InvoicePreviewBuyerProfileModel _self;
  final $Res Function(InvoicePreviewBuyerProfileModel) _then;

/// Create a copy of InvoicePreviewBuyerProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = freezed,}) {
  return _then(_self.copyWith(
companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoicePreviewBuyerProfileModel].
extension InvoicePreviewBuyerProfileModelPatterns on InvoicePreviewBuyerProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoicePreviewBuyerProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoicePreviewBuyerProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoicePreviewBuyerProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewBuyerProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoicePreviewBuyerProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _InvoicePreviewBuyerProfileModel() when $default != null:
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
case _InvoicePreviewBuyerProfileModel() when $default != null:
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
case _InvoicePreviewBuyerProfileModel():
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
case _InvoicePreviewBuyerProfileModel() when $default != null:
return $default(_that.companyName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoicePreviewBuyerProfileModel implements InvoicePreviewBuyerProfileModel {
  const _InvoicePreviewBuyerProfileModel({this.companyName});
  factory _InvoicePreviewBuyerProfileModel.fromJson(Map<String, dynamic> json) => _$InvoicePreviewBuyerProfileModelFromJson(json);

@override final  String? companyName;

/// Create a copy of InvoicePreviewBuyerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoicePreviewBuyerProfileModelCopyWith<_InvoicePreviewBuyerProfileModel> get copyWith => __$InvoicePreviewBuyerProfileModelCopyWithImpl<_InvoicePreviewBuyerProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoicePreviewBuyerProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoicePreviewBuyerProfileModel&&(identical(other.companyName, companyName) || other.companyName == companyName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName);

@override
String toString() {
  return 'InvoicePreviewBuyerProfileModel(companyName: $companyName)';
}


}

/// @nodoc
abstract mixin class _$InvoicePreviewBuyerProfileModelCopyWith<$Res> implements $InvoicePreviewBuyerProfileModelCopyWith<$Res> {
  factory _$InvoicePreviewBuyerProfileModelCopyWith(_InvoicePreviewBuyerProfileModel value, $Res Function(_InvoicePreviewBuyerProfileModel) _then) = __$InvoicePreviewBuyerProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String? companyName
});




}
/// @nodoc
class __$InvoicePreviewBuyerProfileModelCopyWithImpl<$Res>
    implements _$InvoicePreviewBuyerProfileModelCopyWith<$Res> {
  __$InvoicePreviewBuyerProfileModelCopyWithImpl(this._self, this._then);

  final _InvoicePreviewBuyerProfileModel _self;
  final $Res Function(_InvoicePreviewBuyerProfileModel) _then;

/// Create a copy of InvoicePreviewBuyerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = freezed,}) {
  return _then(_InvoicePreviewBuyerProfileModel(
companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
