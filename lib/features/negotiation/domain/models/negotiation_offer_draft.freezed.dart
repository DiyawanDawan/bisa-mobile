// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'negotiation_offer_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NegotiationOfferDraft {

 String get productId; String get productName; String? get productThumbnailUrl; String get sellerId; String get sellerName; String? get sellerCompanyName; String? get sellerAvatarUrl; bool get sellerIsVerified; String get unit; double get minOrder; double get stock; double get catalogPricePerUnit; double get quantity; double get offerPricePerUnit; String? get message; String? get localImagePath;
/// Create a copy of NegotiationOfferDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NegotiationOfferDraftCopyWith<NegotiationOfferDraft> get copyWith => _$NegotiationOfferDraftCopyWithImpl<NegotiationOfferDraft>(this as NegotiationOfferDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NegotiationOfferDraft&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productThumbnailUrl, productThumbnailUrl) || other.productThumbnailUrl == productThumbnailUrl)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.sellerCompanyName, sellerCompanyName) || other.sellerCompanyName == sellerCompanyName)&&(identical(other.sellerAvatarUrl, sellerAvatarUrl) || other.sellerAvatarUrl == sellerAvatarUrl)&&(identical(other.sellerIsVerified, sellerIsVerified) || other.sellerIsVerified == sellerIsVerified)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.catalogPricePerUnit, catalogPricePerUnit) || other.catalogPricePerUnit == catalogPricePerUnit)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.offerPricePerUnit, offerPricePerUnit) || other.offerPricePerUnit == offerPricePerUnit)&&(identical(other.message, message) || other.message == message)&&(identical(other.localImagePath, localImagePath) || other.localImagePath == localImagePath));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,productThumbnailUrl,sellerId,sellerName,sellerCompanyName,sellerAvatarUrl,sellerIsVerified,unit,minOrder,stock,catalogPricePerUnit,quantity,offerPricePerUnit,message,localImagePath);

@override
String toString() {
  return 'NegotiationOfferDraft(productId: $productId, productName: $productName, productThumbnailUrl: $productThumbnailUrl, sellerId: $sellerId, sellerName: $sellerName, sellerCompanyName: $sellerCompanyName, sellerAvatarUrl: $sellerAvatarUrl, sellerIsVerified: $sellerIsVerified, unit: $unit, minOrder: $minOrder, stock: $stock, catalogPricePerUnit: $catalogPricePerUnit, quantity: $quantity, offerPricePerUnit: $offerPricePerUnit, message: $message, localImagePath: $localImagePath)';
}


}

/// @nodoc
abstract mixin class $NegotiationOfferDraftCopyWith<$Res>  {
  factory $NegotiationOfferDraftCopyWith(NegotiationOfferDraft value, $Res Function(NegotiationOfferDraft) _then) = _$NegotiationOfferDraftCopyWithImpl;
@useResult
$Res call({
 String productId, String productName, String? productThumbnailUrl, String sellerId, String sellerName, String? sellerCompanyName, String? sellerAvatarUrl, bool sellerIsVerified, String unit, double minOrder, double stock, double catalogPricePerUnit, double quantity, double offerPricePerUnit, String? message, String? localImagePath
});




}
/// @nodoc
class _$NegotiationOfferDraftCopyWithImpl<$Res>
    implements $NegotiationOfferDraftCopyWith<$Res> {
  _$NegotiationOfferDraftCopyWithImpl(this._self, this._then);

  final NegotiationOfferDraft _self;
  final $Res Function(NegotiationOfferDraft) _then;

/// Create a copy of NegotiationOfferDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? productThumbnailUrl = freezed,Object? sellerId = null,Object? sellerName = null,Object? sellerCompanyName = freezed,Object? sellerAvatarUrl = freezed,Object? sellerIsVerified = null,Object? unit = null,Object? minOrder = null,Object? stock = null,Object? catalogPricePerUnit = null,Object? quantity = null,Object? offerPricePerUnit = null,Object? message = freezed,Object? localImagePath = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productThumbnailUrl: freezed == productThumbnailUrl ? _self.productThumbnailUrl : productThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,sellerName: null == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String,sellerCompanyName: freezed == sellerCompanyName ? _self.sellerCompanyName : sellerCompanyName // ignore: cast_nullable_to_non_nullable
as String?,sellerAvatarUrl: freezed == sellerAvatarUrl ? _self.sellerAvatarUrl : sellerAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,sellerIsVerified: null == sellerIsVerified ? _self.sellerIsVerified : sellerIsVerified // ignore: cast_nullable_to_non_nullable
as bool,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,minOrder: null == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,catalogPricePerUnit: null == catalogPricePerUnit ? _self.catalogPricePerUnit : catalogPricePerUnit // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,offerPricePerUnit: null == offerPricePerUnit ? _self.offerPricePerUnit : offerPricePerUnit // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,localImagePath: freezed == localImagePath ? _self.localImagePath : localImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NegotiationOfferDraft].
extension NegotiationOfferDraftPatterns on NegotiationOfferDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NegotiationOfferDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NegotiationOfferDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NegotiationOfferDraft value)  $default,){
final _that = this;
switch (_that) {
case _NegotiationOfferDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NegotiationOfferDraft value)?  $default,){
final _that = this;
switch (_that) {
case _NegotiationOfferDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String productName,  String? productThumbnailUrl,  String sellerId,  String sellerName,  String? sellerCompanyName,  String? sellerAvatarUrl,  bool sellerIsVerified,  String unit,  double minOrder,  double stock,  double catalogPricePerUnit,  double quantity,  double offerPricePerUnit,  String? message,  String? localImagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NegotiationOfferDraft() when $default != null:
return $default(_that.productId,_that.productName,_that.productThumbnailUrl,_that.sellerId,_that.sellerName,_that.sellerCompanyName,_that.sellerAvatarUrl,_that.sellerIsVerified,_that.unit,_that.minOrder,_that.stock,_that.catalogPricePerUnit,_that.quantity,_that.offerPricePerUnit,_that.message,_that.localImagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String productName,  String? productThumbnailUrl,  String sellerId,  String sellerName,  String? sellerCompanyName,  String? sellerAvatarUrl,  bool sellerIsVerified,  String unit,  double minOrder,  double stock,  double catalogPricePerUnit,  double quantity,  double offerPricePerUnit,  String? message,  String? localImagePath)  $default,) {final _that = this;
switch (_that) {
case _NegotiationOfferDraft():
return $default(_that.productId,_that.productName,_that.productThumbnailUrl,_that.sellerId,_that.sellerName,_that.sellerCompanyName,_that.sellerAvatarUrl,_that.sellerIsVerified,_that.unit,_that.minOrder,_that.stock,_that.catalogPricePerUnit,_that.quantity,_that.offerPricePerUnit,_that.message,_that.localImagePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String productName,  String? productThumbnailUrl,  String sellerId,  String sellerName,  String? sellerCompanyName,  String? sellerAvatarUrl,  bool sellerIsVerified,  String unit,  double minOrder,  double stock,  double catalogPricePerUnit,  double quantity,  double offerPricePerUnit,  String? message,  String? localImagePath)?  $default,) {final _that = this;
switch (_that) {
case _NegotiationOfferDraft() when $default != null:
return $default(_that.productId,_that.productName,_that.productThumbnailUrl,_that.sellerId,_that.sellerName,_that.sellerCompanyName,_that.sellerAvatarUrl,_that.sellerIsVerified,_that.unit,_that.minOrder,_that.stock,_that.catalogPricePerUnit,_that.quantity,_that.offerPricePerUnit,_that.message,_that.localImagePath);case _:
  return null;

}
}

}

/// @nodoc


class _NegotiationOfferDraft extends NegotiationOfferDraft {
  const _NegotiationOfferDraft({required this.productId, required this.productName, this.productThumbnailUrl, required this.sellerId, required this.sellerName, this.sellerCompanyName, this.sellerAvatarUrl, this.sellerIsVerified = false, required this.unit, required this.minOrder, required this.stock, required this.catalogPricePerUnit, required this.quantity, required this.offerPricePerUnit, this.message, this.localImagePath}): super._();
  

@override final  String productId;
@override final  String productName;
@override final  String? productThumbnailUrl;
@override final  String sellerId;
@override final  String sellerName;
@override final  String? sellerCompanyName;
@override final  String? sellerAvatarUrl;
@override@JsonKey() final  bool sellerIsVerified;
@override final  String unit;
@override final  double minOrder;
@override final  double stock;
@override final  double catalogPricePerUnit;
@override final  double quantity;
@override final  double offerPricePerUnit;
@override final  String? message;
@override final  String? localImagePath;

/// Create a copy of NegotiationOfferDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NegotiationOfferDraftCopyWith<_NegotiationOfferDraft> get copyWith => __$NegotiationOfferDraftCopyWithImpl<_NegotiationOfferDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NegotiationOfferDraft&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productThumbnailUrl, productThumbnailUrl) || other.productThumbnailUrl == productThumbnailUrl)&&(identical(other.sellerId, sellerId) || other.sellerId == sellerId)&&(identical(other.sellerName, sellerName) || other.sellerName == sellerName)&&(identical(other.sellerCompanyName, sellerCompanyName) || other.sellerCompanyName == sellerCompanyName)&&(identical(other.sellerAvatarUrl, sellerAvatarUrl) || other.sellerAvatarUrl == sellerAvatarUrl)&&(identical(other.sellerIsVerified, sellerIsVerified) || other.sellerIsVerified == sellerIsVerified)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.catalogPricePerUnit, catalogPricePerUnit) || other.catalogPricePerUnit == catalogPricePerUnit)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.offerPricePerUnit, offerPricePerUnit) || other.offerPricePerUnit == offerPricePerUnit)&&(identical(other.message, message) || other.message == message)&&(identical(other.localImagePath, localImagePath) || other.localImagePath == localImagePath));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,productThumbnailUrl,sellerId,sellerName,sellerCompanyName,sellerAvatarUrl,sellerIsVerified,unit,minOrder,stock,catalogPricePerUnit,quantity,offerPricePerUnit,message,localImagePath);

@override
String toString() {
  return 'NegotiationOfferDraft(productId: $productId, productName: $productName, productThumbnailUrl: $productThumbnailUrl, sellerId: $sellerId, sellerName: $sellerName, sellerCompanyName: $sellerCompanyName, sellerAvatarUrl: $sellerAvatarUrl, sellerIsVerified: $sellerIsVerified, unit: $unit, minOrder: $minOrder, stock: $stock, catalogPricePerUnit: $catalogPricePerUnit, quantity: $quantity, offerPricePerUnit: $offerPricePerUnit, message: $message, localImagePath: $localImagePath)';
}


}

/// @nodoc
abstract mixin class _$NegotiationOfferDraftCopyWith<$Res> implements $NegotiationOfferDraftCopyWith<$Res> {
  factory _$NegotiationOfferDraftCopyWith(_NegotiationOfferDraft value, $Res Function(_NegotiationOfferDraft) _then) = __$NegotiationOfferDraftCopyWithImpl;
@override @useResult
$Res call({
 String productId, String productName, String? productThumbnailUrl, String sellerId, String sellerName, String? sellerCompanyName, String? sellerAvatarUrl, bool sellerIsVerified, String unit, double minOrder, double stock, double catalogPricePerUnit, double quantity, double offerPricePerUnit, String? message, String? localImagePath
});




}
/// @nodoc
class __$NegotiationOfferDraftCopyWithImpl<$Res>
    implements _$NegotiationOfferDraftCopyWith<$Res> {
  __$NegotiationOfferDraftCopyWithImpl(this._self, this._then);

  final _NegotiationOfferDraft _self;
  final $Res Function(_NegotiationOfferDraft) _then;

/// Create a copy of NegotiationOfferDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? productThumbnailUrl = freezed,Object? sellerId = null,Object? sellerName = null,Object? sellerCompanyName = freezed,Object? sellerAvatarUrl = freezed,Object? sellerIsVerified = null,Object? unit = null,Object? minOrder = null,Object? stock = null,Object? catalogPricePerUnit = null,Object? quantity = null,Object? offerPricePerUnit = null,Object? message = freezed,Object? localImagePath = freezed,}) {
  return _then(_NegotiationOfferDraft(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productThumbnailUrl: freezed == productThumbnailUrl ? _self.productThumbnailUrl : productThumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,sellerId: null == sellerId ? _self.sellerId : sellerId // ignore: cast_nullable_to_non_nullable
as String,sellerName: null == sellerName ? _self.sellerName : sellerName // ignore: cast_nullable_to_non_nullable
as String,sellerCompanyName: freezed == sellerCompanyName ? _self.sellerCompanyName : sellerCompanyName // ignore: cast_nullable_to_non_nullable
as String?,sellerAvatarUrl: freezed == sellerAvatarUrl ? _self.sellerAvatarUrl : sellerAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,sellerIsVerified: null == sellerIsVerified ? _self.sellerIsVerified : sellerIsVerified // ignore: cast_nullable_to_non_nullable
as bool,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,minOrder: null == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as double,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,catalogPricePerUnit: null == catalogPricePerUnit ? _self.catalogPricePerUnit : catalogPricePerUnit // ignore: cast_nullable_to_non_nullable
as double,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,offerPricePerUnit: null == offerPricePerUnit ? _self.offerPricePerUnit : offerPricePerUnit // ignore: cast_nullable_to_non_nullable
as double,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,localImagePath: freezed == localImagePath ? _self.localImagePath : localImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
