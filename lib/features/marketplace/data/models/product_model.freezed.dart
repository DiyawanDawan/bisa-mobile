// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductModel {

 String get id; String get name; String? get description; dynamic get pricePerUnit; dynamic get originalPrice; dynamic get stock; dynamic get minOrder; bool get allowsSample; dynamic get sampleMaxQty; dynamic get samplePricePerUnit; String get unit; String? get thumbnailUrl; String get biomassaType; String? get grade; String get province; String? get regency; bool get isCertified; bool get isIotMonitored; bool get isEscrowProtected; dynamic get averageRating; dynamic get totalReviews; dynamic get totalSold; String? get createdAt; ProductSellerModel get user; String get status; ProductTechnicalSpecModel? get technicalSpec; List<ProductImageModel>? get images; String get productMode; String? get fertilizerType; bool get isChemicalFree; String? get cropType; String? get categoryId; List<ProductSpecModel> get specs; String? get videoUrl; bool get isPromoted; String? get promotedUntil; int get promoImpressions; int get promoClicks;
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductModelCopyWith<ProductModel> get copyWith => _$ProductModelCopyWithImpl<ProductModel>(this as ProductModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.originalPrice, originalPrice)&&const DeepCollectionEquality().equals(other.stock, stock)&&const DeepCollectionEquality().equals(other.minOrder, minOrder)&&(identical(other.allowsSample, allowsSample) || other.allowsSample == allowsSample)&&const DeepCollectionEquality().equals(other.sampleMaxQty, sampleMaxQty)&&const DeepCollectionEquality().equals(other.samplePricePerUnit, samplePricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isCertified, isCertified) || other.isCertified == isCertified)&&(identical(other.isIotMonitored, isIotMonitored) || other.isIotMonitored == isIotMonitored)&&(identical(other.isEscrowProtected, isEscrowProtected) || other.isEscrowProtected == isEscrowProtected)&&const DeepCollectionEquality().equals(other.averageRating, averageRating)&&const DeepCollectionEquality().equals(other.totalReviews, totalReviews)&&const DeepCollectionEquality().equals(other.totalSold, totalSold)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.status, status) || other.status == status)&&(identical(other.technicalSpec, technicalSpec) || other.technicalSpec == technicalSpec)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.fertilizerType, fertilizerType) || other.fertilizerType == fertilizerType)&&(identical(other.isChemicalFree, isChemicalFree) || other.isChemicalFree == isChemicalFree)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.specs, specs)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.isPromoted, isPromoted) || other.isPromoted == isPromoted)&&(identical(other.promotedUntil, promotedUntil) || other.promotedUntil == promotedUntil)&&(identical(other.promoImpressions, promoImpressions) || other.promoImpressions == promoImpressions)&&(identical(other.promoClicks, promoClicks) || other.promoClicks == promoClicks));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(originalPrice),const DeepCollectionEquality().hash(stock),const DeepCollectionEquality().hash(minOrder),allowsSample,const DeepCollectionEquality().hash(sampleMaxQty),const DeepCollectionEquality().hash(samplePricePerUnit),unit,thumbnailUrl,biomassaType,grade,province,regency,isCertified,isIotMonitored,isEscrowProtected,const DeepCollectionEquality().hash(averageRating),const DeepCollectionEquality().hash(totalReviews),const DeepCollectionEquality().hash(totalSold),createdAt,user,status,technicalSpec,const DeepCollectionEquality().hash(images),productMode,fertilizerType,isChemicalFree,cropType,categoryId,const DeepCollectionEquality().hash(specs),videoUrl,isPromoted,promotedUntil,promoImpressions,promoClicks]);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, description: $description, pricePerUnit: $pricePerUnit, originalPrice: $originalPrice, stock: $stock, minOrder: $minOrder, allowsSample: $allowsSample, sampleMaxQty: $sampleMaxQty, samplePricePerUnit: $samplePricePerUnit, unit: $unit, thumbnailUrl: $thumbnailUrl, biomassaType: $biomassaType, grade: $grade, province: $province, regency: $regency, isCertified: $isCertified, isIotMonitored: $isIotMonitored, isEscrowProtected: $isEscrowProtected, averageRating: $averageRating, totalReviews: $totalReviews, totalSold: $totalSold, createdAt: $createdAt, user: $user, status: $status, technicalSpec: $technicalSpec, images: $images, productMode: $productMode, fertilizerType: $fertilizerType, isChemicalFree: $isChemicalFree, cropType: $cropType, categoryId: $categoryId, specs: $specs, videoUrl: $videoUrl, isPromoted: $isPromoted, promotedUntil: $promotedUntil, promoImpressions: $promoImpressions, promoClicks: $promoClicks)';
}


}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res>  {
  factory $ProductModelCopyWith(ProductModel value, $Res Function(ProductModel) _then) = _$ProductModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, dynamic pricePerUnit, dynamic originalPrice, dynamic stock, dynamic minOrder, bool allowsSample, dynamic sampleMaxQty, dynamic samplePricePerUnit, String unit, String? thumbnailUrl, String biomassaType, String? grade, String province, String? regency, bool isCertified, bool isIotMonitored, bool isEscrowProtected, dynamic averageRating, dynamic totalReviews, dynamic totalSold, String? createdAt, ProductSellerModel user, String status, ProductTechnicalSpecModel? technicalSpec, List<ProductImageModel>? images, String productMode, String? fertilizerType, bool isChemicalFree, String? cropType, String? categoryId, List<ProductSpecModel> specs, String? videoUrl, bool isPromoted, String? promotedUntil, int promoImpressions, int promoClicks
});


$ProductSellerModelCopyWith<$Res> get user;$ProductTechnicalSpecModelCopyWith<$Res>? get technicalSpec;

}
/// @nodoc
class _$ProductModelCopyWithImpl<$Res>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? pricePerUnit = freezed,Object? originalPrice = freezed,Object? stock = freezed,Object? minOrder = freezed,Object? allowsSample = null,Object? sampleMaxQty = freezed,Object? samplePricePerUnit = freezed,Object? unit = null,Object? thumbnailUrl = freezed,Object? biomassaType = null,Object? grade = freezed,Object? province = null,Object? regency = freezed,Object? isCertified = null,Object? isIotMonitored = null,Object? isEscrowProtected = null,Object? averageRating = freezed,Object? totalReviews = freezed,Object? totalSold = freezed,Object? createdAt = freezed,Object? user = null,Object? status = null,Object? technicalSpec = freezed,Object? images = freezed,Object? productMode = null,Object? fertilizerType = freezed,Object? isChemicalFree = null,Object? cropType = freezed,Object? categoryId = freezed,Object? specs = null,Object? videoUrl = freezed,Object? isPromoted = null,Object? promotedUntil = freezed,Object? promoImpressions = null,Object? promoClicks = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as dynamic,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as dynamic,minOrder: freezed == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as dynamic,allowsSample: null == allowsSample ? _self.allowsSample : allowsSample // ignore: cast_nullable_to_non_nullable
as bool,sampleMaxQty: freezed == sampleMaxQty ? _self.sampleMaxQty : sampleMaxQty // ignore: cast_nullable_to_non_nullable
as dynamic,samplePricePerUnit: freezed == samplePricePerUnit ? _self.samplePricePerUnit : samplePricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,biomassaType: null == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isCertified: null == isCertified ? _self.isCertified : isCertified // ignore: cast_nullable_to_non_nullable
as bool,isIotMonitored: null == isIotMonitored ? _self.isIotMonitored : isIotMonitored // ignore: cast_nullable_to_non_nullable
as bool,isEscrowProtected: null == isEscrowProtected ? _self.isEscrowProtected : isEscrowProtected // ignore: cast_nullable_to_non_nullable
as bool,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as dynamic,totalReviews: freezed == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as dynamic,totalSold: freezed == totalSold ? _self.totalSold : totalSold // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ProductSellerModel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,technicalSpec: freezed == technicalSpec ? _self.technicalSpec : technicalSpec // ignore: cast_nullable_to_non_nullable
as ProductTechnicalSpecModel?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageModel>?,productMode: null == productMode ? _self.productMode : productMode // ignore: cast_nullable_to_non_nullable
as String,fertilizerType: freezed == fertilizerType ? _self.fertilizerType : fertilizerType // ignore: cast_nullable_to_non_nullable
as String?,isChemicalFree: null == isChemicalFree ? _self.isChemicalFree : isChemicalFree // ignore: cast_nullable_to_non_nullable
as bool,cropType: freezed == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,specs: null == specs ? _self.specs : specs // ignore: cast_nullable_to_non_nullable
as List<ProductSpecModel>,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,isPromoted: null == isPromoted ? _self.isPromoted : isPromoted // ignore: cast_nullable_to_non_nullable
as bool,promotedUntil: freezed == promotedUntil ? _self.promotedUntil : promotedUntil // ignore: cast_nullable_to_non_nullable
as String?,promoImpressions: null == promoImpressions ? _self.promoImpressions : promoImpressions // ignore: cast_nullable_to_non_nullable
as int,promoClicks: null == promoClicks ? _self.promoClicks : promoClicks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductSellerModelCopyWith<$Res> get user {
  
  return $ProductSellerModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductTechnicalSpecModelCopyWith<$Res>? get technicalSpec {
    if (_self.technicalSpec == null) {
    return null;
  }

  return $ProductTechnicalSpecModelCopyWith<$Res>(_self.technicalSpec!, (value) {
    return _then(_self.copyWith(technicalSpec: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  dynamic pricePerUnit,  dynamic originalPrice,  dynamic stock,  dynamic minOrder,  bool allowsSample,  dynamic sampleMaxQty,  dynamic samplePricePerUnit,  String unit,  String? thumbnailUrl,  String biomassaType,  String? grade,  String province,  String? regency,  bool isCertified,  bool isIotMonitored,  bool isEscrowProtected,  dynamic averageRating,  dynamic totalReviews,  dynamic totalSold,  String? createdAt,  ProductSellerModel user,  String status,  ProductTechnicalSpecModel? technicalSpec,  List<ProductImageModel>? images,  String productMode,  String? fertilizerType,  bool isChemicalFree,  String? cropType,  String? categoryId,  List<ProductSpecModel> specs,  String? videoUrl,  bool isPromoted,  String? promotedUntil,  int promoImpressions,  int promoClicks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.pricePerUnit,_that.originalPrice,_that.stock,_that.minOrder,_that.allowsSample,_that.sampleMaxQty,_that.samplePricePerUnit,_that.unit,_that.thumbnailUrl,_that.biomassaType,_that.grade,_that.province,_that.regency,_that.isCertified,_that.isIotMonitored,_that.isEscrowProtected,_that.averageRating,_that.totalReviews,_that.totalSold,_that.createdAt,_that.user,_that.status,_that.technicalSpec,_that.images,_that.productMode,_that.fertilizerType,_that.isChemicalFree,_that.cropType,_that.categoryId,_that.specs,_that.videoUrl,_that.isPromoted,_that.promotedUntil,_that.promoImpressions,_that.promoClicks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  dynamic pricePerUnit,  dynamic originalPrice,  dynamic stock,  dynamic minOrder,  bool allowsSample,  dynamic sampleMaxQty,  dynamic samplePricePerUnit,  String unit,  String? thumbnailUrl,  String biomassaType,  String? grade,  String province,  String? regency,  bool isCertified,  bool isIotMonitored,  bool isEscrowProtected,  dynamic averageRating,  dynamic totalReviews,  dynamic totalSold,  String? createdAt,  ProductSellerModel user,  String status,  ProductTechnicalSpecModel? technicalSpec,  List<ProductImageModel>? images,  String productMode,  String? fertilizerType,  bool isChemicalFree,  String? cropType,  String? categoryId,  List<ProductSpecModel> specs,  String? videoUrl,  bool isPromoted,  String? promotedUntil,  int promoImpressions,  int promoClicks)  $default,) {final _that = this;
switch (_that) {
case _ProductModel():
return $default(_that.id,_that.name,_that.description,_that.pricePerUnit,_that.originalPrice,_that.stock,_that.minOrder,_that.allowsSample,_that.sampleMaxQty,_that.samplePricePerUnit,_that.unit,_that.thumbnailUrl,_that.biomassaType,_that.grade,_that.province,_that.regency,_that.isCertified,_that.isIotMonitored,_that.isEscrowProtected,_that.averageRating,_that.totalReviews,_that.totalSold,_that.createdAt,_that.user,_that.status,_that.technicalSpec,_that.images,_that.productMode,_that.fertilizerType,_that.isChemicalFree,_that.cropType,_that.categoryId,_that.specs,_that.videoUrl,_that.isPromoted,_that.promotedUntil,_that.promoImpressions,_that.promoClicks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  dynamic pricePerUnit,  dynamic originalPrice,  dynamic stock,  dynamic minOrder,  bool allowsSample,  dynamic sampleMaxQty,  dynamic samplePricePerUnit,  String unit,  String? thumbnailUrl,  String biomassaType,  String? grade,  String province,  String? regency,  bool isCertified,  bool isIotMonitored,  bool isEscrowProtected,  dynamic averageRating,  dynamic totalReviews,  dynamic totalSold,  String? createdAt,  ProductSellerModel user,  String status,  ProductTechnicalSpecModel? technicalSpec,  List<ProductImageModel>? images,  String productMode,  String? fertilizerType,  bool isChemicalFree,  String? cropType,  String? categoryId,  List<ProductSpecModel> specs,  String? videoUrl,  bool isPromoted,  String? promotedUntil,  int promoImpressions,  int promoClicks)?  $default,) {final _that = this;
switch (_that) {
case _ProductModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.pricePerUnit,_that.originalPrice,_that.stock,_that.minOrder,_that.allowsSample,_that.sampleMaxQty,_that.samplePricePerUnit,_that.unit,_that.thumbnailUrl,_that.biomassaType,_that.grade,_that.province,_that.regency,_that.isCertified,_that.isIotMonitored,_that.isEscrowProtected,_that.averageRating,_that.totalReviews,_that.totalSold,_that.createdAt,_that.user,_that.status,_that.technicalSpec,_that.images,_that.productMode,_that.fertilizerType,_that.isChemicalFree,_that.cropType,_that.categoryId,_that.specs,_that.videoUrl,_that.isPromoted,_that.promotedUntil,_that.promoImpressions,_that.promoClicks);case _:
  return null;

}
}

}

/// @nodoc


class _ProductModel extends ProductModel {
  const _ProductModel({required this.id, required this.name, this.description, required this.pricePerUnit, this.originalPrice, this.stock = 0, this.minOrder = 1, this.allowsSample = true, this.sampleMaxQty = 1, this.samplePricePerUnit, required this.unit, this.thumbnailUrl, required this.biomassaType, this.grade, required this.province, this.regency, this.isCertified = false, this.isIotMonitored = false, this.isEscrowProtected = false, this.averageRating = 0.0, this.totalReviews = 0, this.totalSold = 0, this.createdAt, required this.user, this.status = 'ACTIVE', this.technicalSpec, final  List<ProductImageModel>? images, this.productMode = 'BIOMASS_MATERIAL', this.fertilizerType, this.isChemicalFree = false, this.cropType, this.categoryId, final  List<ProductSpecModel> specs = const [], this.videoUrl, this.isPromoted = false, this.promotedUntil, this.promoImpressions = 0, this.promoClicks = 0}): _images = images,_specs = specs,super._();
  

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  dynamic pricePerUnit;
@override final  dynamic originalPrice;
@override@JsonKey() final  dynamic stock;
@override@JsonKey() final  dynamic minOrder;
@override@JsonKey() final  bool allowsSample;
@override@JsonKey() final  dynamic sampleMaxQty;
@override final  dynamic samplePricePerUnit;
@override final  String unit;
@override final  String? thumbnailUrl;
@override final  String biomassaType;
@override final  String? grade;
@override final  String province;
@override final  String? regency;
@override@JsonKey() final  bool isCertified;
@override@JsonKey() final  bool isIotMonitored;
@override@JsonKey() final  bool isEscrowProtected;
@override@JsonKey() final  dynamic averageRating;
@override@JsonKey() final  dynamic totalReviews;
@override@JsonKey() final  dynamic totalSold;
@override final  String? createdAt;
@override final  ProductSellerModel user;
@override@JsonKey() final  String status;
@override final  ProductTechnicalSpecModel? technicalSpec;
 final  List<ProductImageModel>? _images;
@override List<ProductImageModel>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  String productMode;
@override final  String? fertilizerType;
@override@JsonKey() final  bool isChemicalFree;
@override final  String? cropType;
@override final  String? categoryId;
 final  List<ProductSpecModel> _specs;
@override@JsonKey() List<ProductSpecModel> get specs {
  if (_specs is EqualUnmodifiableListView) return _specs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specs);
}

@override final  String? videoUrl;
@override@JsonKey() final  bool isPromoted;
@override final  String? promotedUntil;
@override@JsonKey() final  int promoImpressions;
@override@JsonKey() final  int promoClicks;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductModelCopyWith<_ProductModel> get copyWith => __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.pricePerUnit, pricePerUnit)&&const DeepCollectionEquality().equals(other.originalPrice, originalPrice)&&const DeepCollectionEquality().equals(other.stock, stock)&&const DeepCollectionEquality().equals(other.minOrder, minOrder)&&(identical(other.allowsSample, allowsSample) || other.allowsSample == allowsSample)&&const DeepCollectionEquality().equals(other.sampleMaxQty, sampleMaxQty)&&const DeepCollectionEquality().equals(other.samplePricePerUnit, samplePricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isCertified, isCertified) || other.isCertified == isCertified)&&(identical(other.isIotMonitored, isIotMonitored) || other.isIotMonitored == isIotMonitored)&&(identical(other.isEscrowProtected, isEscrowProtected) || other.isEscrowProtected == isEscrowProtected)&&const DeepCollectionEquality().equals(other.averageRating, averageRating)&&const DeepCollectionEquality().equals(other.totalReviews, totalReviews)&&const DeepCollectionEquality().equals(other.totalSold, totalSold)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.user, user) || other.user == user)&&(identical(other.status, status) || other.status == status)&&(identical(other.technicalSpec, technicalSpec) || other.technicalSpec == technicalSpec)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.fertilizerType, fertilizerType) || other.fertilizerType == fertilizerType)&&(identical(other.isChemicalFree, isChemicalFree) || other.isChemicalFree == isChemicalFree)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other._specs, _specs)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.isPromoted, isPromoted) || other.isPromoted == isPromoted)&&(identical(other.promotedUntil, promotedUntil) || other.promotedUntil == promotedUntil)&&(identical(other.promoImpressions, promoImpressions) || other.promoImpressions == promoImpressions)&&(identical(other.promoClicks, promoClicks) || other.promoClicks == promoClicks));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,const DeepCollectionEquality().hash(pricePerUnit),const DeepCollectionEquality().hash(originalPrice),const DeepCollectionEquality().hash(stock),const DeepCollectionEquality().hash(minOrder),allowsSample,const DeepCollectionEquality().hash(sampleMaxQty),const DeepCollectionEquality().hash(samplePricePerUnit),unit,thumbnailUrl,biomassaType,grade,province,regency,isCertified,isIotMonitored,isEscrowProtected,const DeepCollectionEquality().hash(averageRating),const DeepCollectionEquality().hash(totalReviews),const DeepCollectionEquality().hash(totalSold),createdAt,user,status,technicalSpec,const DeepCollectionEquality().hash(_images),productMode,fertilizerType,isChemicalFree,cropType,categoryId,const DeepCollectionEquality().hash(_specs),videoUrl,isPromoted,promotedUntil,promoImpressions,promoClicks]);

@override
String toString() {
  return 'ProductModel(id: $id, name: $name, description: $description, pricePerUnit: $pricePerUnit, originalPrice: $originalPrice, stock: $stock, minOrder: $minOrder, allowsSample: $allowsSample, sampleMaxQty: $sampleMaxQty, samplePricePerUnit: $samplePricePerUnit, unit: $unit, thumbnailUrl: $thumbnailUrl, biomassaType: $biomassaType, grade: $grade, province: $province, regency: $regency, isCertified: $isCertified, isIotMonitored: $isIotMonitored, isEscrowProtected: $isEscrowProtected, averageRating: $averageRating, totalReviews: $totalReviews, totalSold: $totalSold, createdAt: $createdAt, user: $user, status: $status, technicalSpec: $technicalSpec, images: $images, productMode: $productMode, fertilizerType: $fertilizerType, isChemicalFree: $isChemicalFree, cropType: $cropType, categoryId: $categoryId, specs: $specs, videoUrl: $videoUrl, isPromoted: $isPromoted, promotedUntil: $promotedUntil, promoImpressions: $promoImpressions, promoClicks: $promoClicks)';
}


}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res> implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(_ProductModel value, $Res Function(_ProductModel) _then) = __$ProductModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, dynamic pricePerUnit, dynamic originalPrice, dynamic stock, dynamic minOrder, bool allowsSample, dynamic sampleMaxQty, dynamic samplePricePerUnit, String unit, String? thumbnailUrl, String biomassaType, String? grade, String province, String? regency, bool isCertified, bool isIotMonitored, bool isEscrowProtected, dynamic averageRating, dynamic totalReviews, dynamic totalSold, String? createdAt, ProductSellerModel user, String status, ProductTechnicalSpecModel? technicalSpec, List<ProductImageModel>? images, String productMode, String? fertilizerType, bool isChemicalFree, String? cropType, String? categoryId, List<ProductSpecModel> specs, String? videoUrl, bool isPromoted, String? promotedUntil, int promoImpressions, int promoClicks
});


@override $ProductSellerModelCopyWith<$Res> get user;@override $ProductTechnicalSpecModelCopyWith<$Res>? get technicalSpec;

}
/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? pricePerUnit = freezed,Object? originalPrice = freezed,Object? stock = freezed,Object? minOrder = freezed,Object? allowsSample = null,Object? sampleMaxQty = freezed,Object? samplePricePerUnit = freezed,Object? unit = null,Object? thumbnailUrl = freezed,Object? biomassaType = null,Object? grade = freezed,Object? province = null,Object? regency = freezed,Object? isCertified = null,Object? isIotMonitored = null,Object? isEscrowProtected = null,Object? averageRating = freezed,Object? totalReviews = freezed,Object? totalSold = freezed,Object? createdAt = freezed,Object? user = null,Object? status = null,Object? technicalSpec = freezed,Object? images = freezed,Object? productMode = null,Object? fertilizerType = freezed,Object? isChemicalFree = null,Object? cropType = freezed,Object? categoryId = freezed,Object? specs = null,Object? videoUrl = freezed,Object? isPromoted = null,Object? promotedUntil = freezed,Object? promoImpressions = null,Object? promoClicks = null,}) {
  return _then(_ProductModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: freezed == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as dynamic,stock: freezed == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as dynamic,minOrder: freezed == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as dynamic,allowsSample: null == allowsSample ? _self.allowsSample : allowsSample // ignore: cast_nullable_to_non_nullable
as bool,sampleMaxQty: freezed == sampleMaxQty ? _self.sampleMaxQty : sampleMaxQty // ignore: cast_nullable_to_non_nullable
as dynamic,samplePricePerUnit: freezed == samplePricePerUnit ? _self.samplePricePerUnit : samplePricePerUnit // ignore: cast_nullable_to_non_nullable
as dynamic,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,biomassaType: null == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isCertified: null == isCertified ? _self.isCertified : isCertified // ignore: cast_nullable_to_non_nullable
as bool,isIotMonitored: null == isIotMonitored ? _self.isIotMonitored : isIotMonitored // ignore: cast_nullable_to_non_nullable
as bool,isEscrowProtected: null == isEscrowProtected ? _self.isEscrowProtected : isEscrowProtected // ignore: cast_nullable_to_non_nullable
as bool,averageRating: freezed == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as dynamic,totalReviews: freezed == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as dynamic,totalSold: freezed == totalSold ? _self.totalSold : totalSold // ignore: cast_nullable_to_non_nullable
as dynamic,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as ProductSellerModel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,technicalSpec: freezed == technicalSpec ? _self.technicalSpec : technicalSpec // ignore: cast_nullable_to_non_nullable
as ProductTechnicalSpecModel?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageModel>?,productMode: null == productMode ? _self.productMode : productMode // ignore: cast_nullable_to_non_nullable
as String,fertilizerType: freezed == fertilizerType ? _self.fertilizerType : fertilizerType // ignore: cast_nullable_to_non_nullable
as String?,isChemicalFree: null == isChemicalFree ? _self.isChemicalFree : isChemicalFree // ignore: cast_nullable_to_non_nullable
as bool,cropType: freezed == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,specs: null == specs ? _self._specs : specs // ignore: cast_nullable_to_non_nullable
as List<ProductSpecModel>,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,isPromoted: null == isPromoted ? _self.isPromoted : isPromoted // ignore: cast_nullable_to_non_nullable
as bool,promotedUntil: freezed == promotedUntil ? _self.promotedUntil : promotedUntil // ignore: cast_nullable_to_non_nullable
as String?,promoImpressions: null == promoImpressions ? _self.promoImpressions : promoImpressions // ignore: cast_nullable_to_non_nullable
as int,promoClicks: null == promoClicks ? _self.promoClicks : promoClicks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductSellerModelCopyWith<$Res> get user {
  
  return $ProductSellerModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of ProductModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductTechnicalSpecModelCopyWith<$Res>? get technicalSpec {
    if (_self.technicalSpec == null) {
    return null;
  }

  return $ProductTechnicalSpecModelCopyWith<$Res>(_self.technicalSpec!, (value) {
    return _then(_self.copyWith(technicalSpec: value));
  });
}
}


/// @nodoc
mixin _$ProductSellerModel {

 String get id;@JsonKey(name: 'fullName') String get name; String? get avatarUrl;@JsonKey(name: 'profile') ProductSellerProfileModel? get profile;@JsonKey(name: 'isVerified', defaultValue: false) bool get isVerified;
/// Create a copy of ProductSellerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSellerModelCopyWith<ProductSellerModel> get copyWith => _$ProductSellerModelCopyWithImpl<ProductSellerModel>(this as ProductSellerModel, _$identity);

  /// Serializes this ProductSellerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSellerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,profile,isVerified);

@override
String toString() {
  return 'ProductSellerModel(id: $id, name: $name, avatarUrl: $avatarUrl, profile: $profile, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $ProductSellerModelCopyWith<$Res>  {
  factory $ProductSellerModelCopyWith(ProductSellerModel value, $Res Function(ProductSellerModel) _then) = _$ProductSellerModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'fullName') String name, String? avatarUrl,@JsonKey(name: 'profile') ProductSellerProfileModel? profile,@JsonKey(name: 'isVerified', defaultValue: false) bool isVerified
});


$ProductSellerProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class _$ProductSellerModelCopyWithImpl<$Res>
    implements $ProductSellerModelCopyWith<$Res> {
  _$ProductSellerModelCopyWithImpl(this._self, this._then);

  final ProductSellerModel _self;
  final $Res Function(ProductSellerModel) _then;

/// Create a copy of ProductSellerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? profile = freezed,Object? isVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProductSellerProfileModel?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ProductSellerModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductSellerProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProductSellerProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductSellerModel].
extension ProductSellerModelPatterns on ProductSellerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSellerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSellerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSellerModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductSellerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSellerModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSellerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'fullName')  String name,  String? avatarUrl, @JsonKey(name: 'profile')  ProductSellerProfileModel? profile, @JsonKey(name: 'isVerified', defaultValue: false)  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSellerModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.profile,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'fullName')  String name,  String? avatarUrl, @JsonKey(name: 'profile')  ProductSellerProfileModel? profile, @JsonKey(name: 'isVerified', defaultValue: false)  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _ProductSellerModel():
return $default(_that.id,_that.name,_that.avatarUrl,_that.profile,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'fullName')  String name,  String? avatarUrl, @JsonKey(name: 'profile')  ProductSellerProfileModel? profile, @JsonKey(name: 'isVerified', defaultValue: false)  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _ProductSellerModel() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.profile,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSellerModel extends ProductSellerModel {
  const _ProductSellerModel({required this.id, @JsonKey(name: 'fullName') required this.name, this.avatarUrl, @JsonKey(name: 'profile') this.profile, @JsonKey(name: 'isVerified', defaultValue: false) this.isVerified = false}): super._();
  factory _ProductSellerModel.fromJson(Map<String, dynamic> json) => _$ProductSellerModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'fullName') final  String name;
@override final  String? avatarUrl;
@override@JsonKey(name: 'profile') final  ProductSellerProfileModel? profile;
@override@JsonKey(name: 'isVerified', defaultValue: false) final  bool isVerified;

/// Create a copy of ProductSellerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSellerModelCopyWith<_ProductSellerModel> get copyWith => __$ProductSellerModelCopyWithImpl<_ProductSellerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSellerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSellerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,profile,isVerified);

@override
String toString() {
  return 'ProductSellerModel(id: $id, name: $name, avatarUrl: $avatarUrl, profile: $profile, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$ProductSellerModelCopyWith<$Res> implements $ProductSellerModelCopyWith<$Res> {
  factory _$ProductSellerModelCopyWith(_ProductSellerModel value, $Res Function(_ProductSellerModel) _then) = __$ProductSellerModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'fullName') String name, String? avatarUrl,@JsonKey(name: 'profile') ProductSellerProfileModel? profile,@JsonKey(name: 'isVerified', defaultValue: false) bool isVerified
});


@override $ProductSellerProfileModelCopyWith<$Res>? get profile;

}
/// @nodoc
class __$ProductSellerModelCopyWithImpl<$Res>
    implements _$ProductSellerModelCopyWith<$Res> {
  __$ProductSellerModelCopyWithImpl(this._self, this._then);

  final _ProductSellerModel _self;
  final $Res Function(_ProductSellerModel) _then;

/// Create a copy of ProductSellerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? profile = freezed,Object? isVerified = null,}) {
  return _then(_ProductSellerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProductSellerProfileModel?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ProductSellerModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductSellerProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProductSellerProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$ProductSellerProfileModel {

 String? get companyName; int? get rajaongkirOriginId; String? get rajaongkirOriginLabel;
/// Create a copy of ProductSellerProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSellerProfileModelCopyWith<ProductSellerProfileModel> get copyWith => _$ProductSellerProfileModelCopyWithImpl<ProductSellerProfileModel>(this as ProductSellerProfileModel, _$identity);

  /// Serializes this ProductSellerProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSellerProfileModel&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.rajaongkirOriginId, rajaongkirOriginId) || other.rajaongkirOriginId == rajaongkirOriginId)&&(identical(other.rajaongkirOriginLabel, rajaongkirOriginLabel) || other.rajaongkirOriginLabel == rajaongkirOriginLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,rajaongkirOriginId,rajaongkirOriginLabel);

@override
String toString() {
  return 'ProductSellerProfileModel(companyName: $companyName, rajaongkirOriginId: $rajaongkirOriginId, rajaongkirOriginLabel: $rajaongkirOriginLabel)';
}


}

/// @nodoc
abstract mixin class $ProductSellerProfileModelCopyWith<$Res>  {
  factory $ProductSellerProfileModelCopyWith(ProductSellerProfileModel value, $Res Function(ProductSellerProfileModel) _then) = _$ProductSellerProfileModelCopyWithImpl;
@useResult
$Res call({
 String? companyName, int? rajaongkirOriginId, String? rajaongkirOriginLabel
});




}
/// @nodoc
class _$ProductSellerProfileModelCopyWithImpl<$Res>
    implements $ProductSellerProfileModelCopyWith<$Res> {
  _$ProductSellerProfileModelCopyWithImpl(this._self, this._then);

  final ProductSellerProfileModel _self;
  final $Res Function(ProductSellerProfileModel) _then;

/// Create a copy of ProductSellerProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = freezed,Object? rajaongkirOriginId = freezed,Object? rajaongkirOriginLabel = freezed,}) {
  return _then(_self.copyWith(
companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,rajaongkirOriginId: freezed == rajaongkirOriginId ? _self.rajaongkirOriginId : rajaongkirOriginId // ignore: cast_nullable_to_non_nullable
as int?,rajaongkirOriginLabel: freezed == rajaongkirOriginLabel ? _self.rajaongkirOriginLabel : rajaongkirOriginLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSellerProfileModel].
extension ProductSellerProfileModelPatterns on ProductSellerProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSellerProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSellerProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSellerProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductSellerProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSellerProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSellerProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? companyName,  int? rajaongkirOriginId,  String? rajaongkirOriginLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSellerProfileModel() when $default != null:
return $default(_that.companyName,_that.rajaongkirOriginId,_that.rajaongkirOriginLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? companyName,  int? rajaongkirOriginId,  String? rajaongkirOriginLabel)  $default,) {final _that = this;
switch (_that) {
case _ProductSellerProfileModel():
return $default(_that.companyName,_that.rajaongkirOriginId,_that.rajaongkirOriginLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? companyName,  int? rajaongkirOriginId,  String? rajaongkirOriginLabel)?  $default,) {final _that = this;
switch (_that) {
case _ProductSellerProfileModel() when $default != null:
return $default(_that.companyName,_that.rajaongkirOriginId,_that.rajaongkirOriginLabel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductSellerProfileModel implements ProductSellerProfileModel {
  const _ProductSellerProfileModel({this.companyName, this.rajaongkirOriginId, this.rajaongkirOriginLabel});
  factory _ProductSellerProfileModel.fromJson(Map<String, dynamic> json) => _$ProductSellerProfileModelFromJson(json);

@override final  String? companyName;
@override final  int? rajaongkirOriginId;
@override final  String? rajaongkirOriginLabel;

/// Create a copy of ProductSellerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSellerProfileModelCopyWith<_ProductSellerProfileModel> get copyWith => __$ProductSellerProfileModelCopyWithImpl<_ProductSellerProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductSellerProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSellerProfileModel&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.rajaongkirOriginId, rajaongkirOriginId) || other.rajaongkirOriginId == rajaongkirOriginId)&&(identical(other.rajaongkirOriginLabel, rajaongkirOriginLabel) || other.rajaongkirOriginLabel == rajaongkirOriginLabel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,rajaongkirOriginId,rajaongkirOriginLabel);

@override
String toString() {
  return 'ProductSellerProfileModel(companyName: $companyName, rajaongkirOriginId: $rajaongkirOriginId, rajaongkirOriginLabel: $rajaongkirOriginLabel)';
}


}

/// @nodoc
abstract mixin class _$ProductSellerProfileModelCopyWith<$Res> implements $ProductSellerProfileModelCopyWith<$Res> {
  factory _$ProductSellerProfileModelCopyWith(_ProductSellerProfileModel value, $Res Function(_ProductSellerProfileModel) _then) = __$ProductSellerProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String? companyName, int? rajaongkirOriginId, String? rajaongkirOriginLabel
});




}
/// @nodoc
class __$ProductSellerProfileModelCopyWithImpl<$Res>
    implements _$ProductSellerProfileModelCopyWith<$Res> {
  __$ProductSellerProfileModelCopyWithImpl(this._self, this._then);

  final _ProductSellerProfileModel _self;
  final $Res Function(_ProductSellerProfileModel) _then;

/// Create a copy of ProductSellerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = freezed,Object? rajaongkirOriginId = freezed,Object? rajaongkirOriginLabel = freezed,}) {
  return _then(_ProductSellerProfileModel(
companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,rajaongkirOriginId: freezed == rajaongkirOriginId ? _self.rajaongkirOriginId : rajaongkirOriginId // ignore: cast_nullable_to_non_nullable
as int?,rajaongkirOriginLabel: freezed == rajaongkirOriginLabel ? _self.rajaongkirOriginLabel : rajaongkirOriginLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProductTechnicalSpecModel {

 dynamic get moistureContent; dynamic get carbonPurity; dynamic get productionCapacity; dynamic get surfaceArea; dynamic get phLevel; String? get density; dynamic get carbonOffsetPerTon; dynamic get grossWeightPerSak; dynamic get netWeightPerSak; String? get bagDimension;
/// Create a copy of ProductTechnicalSpecModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductTechnicalSpecModelCopyWith<ProductTechnicalSpecModel> get copyWith => _$ProductTechnicalSpecModelCopyWithImpl<ProductTechnicalSpecModel>(this as ProductTechnicalSpecModel, _$identity);

  /// Serializes this ProductTechnicalSpecModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductTechnicalSpecModel&&const DeepCollectionEquality().equals(other.moistureContent, moistureContent)&&const DeepCollectionEquality().equals(other.carbonPurity, carbonPurity)&&const DeepCollectionEquality().equals(other.productionCapacity, productionCapacity)&&const DeepCollectionEquality().equals(other.surfaceArea, surfaceArea)&&const DeepCollectionEquality().equals(other.phLevel, phLevel)&&(identical(other.density, density) || other.density == density)&&const DeepCollectionEquality().equals(other.carbonOffsetPerTon, carbonOffsetPerTon)&&const DeepCollectionEquality().equals(other.grossWeightPerSak, grossWeightPerSak)&&const DeepCollectionEquality().equals(other.netWeightPerSak, netWeightPerSak)&&(identical(other.bagDimension, bagDimension) || other.bagDimension == bagDimension));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(moistureContent),const DeepCollectionEquality().hash(carbonPurity),const DeepCollectionEquality().hash(productionCapacity),const DeepCollectionEquality().hash(surfaceArea),const DeepCollectionEquality().hash(phLevel),density,const DeepCollectionEquality().hash(carbonOffsetPerTon),const DeepCollectionEquality().hash(grossWeightPerSak),const DeepCollectionEquality().hash(netWeightPerSak),bagDimension);

@override
String toString() {
  return 'ProductTechnicalSpecModel(moistureContent: $moistureContent, carbonPurity: $carbonPurity, productionCapacity: $productionCapacity, surfaceArea: $surfaceArea, phLevel: $phLevel, density: $density, carbonOffsetPerTon: $carbonOffsetPerTon, grossWeightPerSak: $grossWeightPerSak, netWeightPerSak: $netWeightPerSak, bagDimension: $bagDimension)';
}


}

/// @nodoc
abstract mixin class $ProductTechnicalSpecModelCopyWith<$Res>  {
  factory $ProductTechnicalSpecModelCopyWith(ProductTechnicalSpecModel value, $Res Function(ProductTechnicalSpecModel) _then) = _$ProductTechnicalSpecModelCopyWithImpl;
@useResult
$Res call({
 dynamic moistureContent, dynamic carbonPurity, dynamic productionCapacity, dynamic surfaceArea, dynamic phLevel, String? density, dynamic carbonOffsetPerTon, dynamic grossWeightPerSak, dynamic netWeightPerSak, String? bagDimension
});




}
/// @nodoc
class _$ProductTechnicalSpecModelCopyWithImpl<$Res>
    implements $ProductTechnicalSpecModelCopyWith<$Res> {
  _$ProductTechnicalSpecModelCopyWithImpl(this._self, this._then);

  final ProductTechnicalSpecModel _self;
  final $Res Function(ProductTechnicalSpecModel) _then;

/// Create a copy of ProductTechnicalSpecModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? moistureContent = freezed,Object? carbonPurity = freezed,Object? productionCapacity = freezed,Object? surfaceArea = freezed,Object? phLevel = freezed,Object? density = freezed,Object? carbonOffsetPerTon = freezed,Object? grossWeightPerSak = freezed,Object? netWeightPerSak = freezed,Object? bagDimension = freezed,}) {
  return _then(_self.copyWith(
moistureContent: freezed == moistureContent ? _self.moistureContent : moistureContent // ignore: cast_nullable_to_non_nullable
as dynamic,carbonPurity: freezed == carbonPurity ? _self.carbonPurity : carbonPurity // ignore: cast_nullable_to_non_nullable
as dynamic,productionCapacity: freezed == productionCapacity ? _self.productionCapacity : productionCapacity // ignore: cast_nullable_to_non_nullable
as dynamic,surfaceArea: freezed == surfaceArea ? _self.surfaceArea : surfaceArea // ignore: cast_nullable_to_non_nullable
as dynamic,phLevel: freezed == phLevel ? _self.phLevel : phLevel // ignore: cast_nullable_to_non_nullable
as dynamic,density: freezed == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as String?,carbonOffsetPerTon: freezed == carbonOffsetPerTon ? _self.carbonOffsetPerTon : carbonOffsetPerTon // ignore: cast_nullable_to_non_nullable
as dynamic,grossWeightPerSak: freezed == grossWeightPerSak ? _self.grossWeightPerSak : grossWeightPerSak // ignore: cast_nullable_to_non_nullable
as dynamic,netWeightPerSak: freezed == netWeightPerSak ? _self.netWeightPerSak : netWeightPerSak // ignore: cast_nullable_to_non_nullable
as dynamic,bagDimension: freezed == bagDimension ? _self.bagDimension : bagDimension // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductTechnicalSpecModel].
extension ProductTechnicalSpecModelPatterns on ProductTechnicalSpecModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductTechnicalSpecModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductTechnicalSpecModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductTechnicalSpecModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductTechnicalSpecModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductTechnicalSpecModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductTechnicalSpecModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( dynamic moistureContent,  dynamic carbonPurity,  dynamic productionCapacity,  dynamic surfaceArea,  dynamic phLevel,  String? density,  dynamic carbonOffsetPerTon,  dynamic grossWeightPerSak,  dynamic netWeightPerSak,  String? bagDimension)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductTechnicalSpecModel() when $default != null:
return $default(_that.moistureContent,_that.carbonPurity,_that.productionCapacity,_that.surfaceArea,_that.phLevel,_that.density,_that.carbonOffsetPerTon,_that.grossWeightPerSak,_that.netWeightPerSak,_that.bagDimension);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( dynamic moistureContent,  dynamic carbonPurity,  dynamic productionCapacity,  dynamic surfaceArea,  dynamic phLevel,  String? density,  dynamic carbonOffsetPerTon,  dynamic grossWeightPerSak,  dynamic netWeightPerSak,  String? bagDimension)  $default,) {final _that = this;
switch (_that) {
case _ProductTechnicalSpecModel():
return $default(_that.moistureContent,_that.carbonPurity,_that.productionCapacity,_that.surfaceArea,_that.phLevel,_that.density,_that.carbonOffsetPerTon,_that.grossWeightPerSak,_that.netWeightPerSak,_that.bagDimension);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( dynamic moistureContent,  dynamic carbonPurity,  dynamic productionCapacity,  dynamic surfaceArea,  dynamic phLevel,  String? density,  dynamic carbonOffsetPerTon,  dynamic grossWeightPerSak,  dynamic netWeightPerSak,  String? bagDimension)?  $default,) {final _that = this;
switch (_that) {
case _ProductTechnicalSpecModel() when $default != null:
return $default(_that.moistureContent,_that.carbonPurity,_that.productionCapacity,_that.surfaceArea,_that.phLevel,_that.density,_that.carbonOffsetPerTon,_that.grossWeightPerSak,_that.netWeightPerSak,_that.bagDimension);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductTechnicalSpecModel extends ProductTechnicalSpecModel {
  const _ProductTechnicalSpecModel({this.moistureContent, this.carbonPurity, this.productionCapacity, this.surfaceArea, this.phLevel, this.density, this.carbonOffsetPerTon, this.grossWeightPerSak, this.netWeightPerSak, this.bagDimension}): super._();
  factory _ProductTechnicalSpecModel.fromJson(Map<String, dynamic> json) => _$ProductTechnicalSpecModelFromJson(json);

@override final  dynamic moistureContent;
@override final  dynamic carbonPurity;
@override final  dynamic productionCapacity;
@override final  dynamic surfaceArea;
@override final  dynamic phLevel;
@override final  String? density;
@override final  dynamic carbonOffsetPerTon;
@override final  dynamic grossWeightPerSak;
@override final  dynamic netWeightPerSak;
@override final  String? bagDimension;

/// Create a copy of ProductTechnicalSpecModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductTechnicalSpecModelCopyWith<_ProductTechnicalSpecModel> get copyWith => __$ProductTechnicalSpecModelCopyWithImpl<_ProductTechnicalSpecModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductTechnicalSpecModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductTechnicalSpecModel&&const DeepCollectionEquality().equals(other.moistureContent, moistureContent)&&const DeepCollectionEquality().equals(other.carbonPurity, carbonPurity)&&const DeepCollectionEquality().equals(other.productionCapacity, productionCapacity)&&const DeepCollectionEquality().equals(other.surfaceArea, surfaceArea)&&const DeepCollectionEquality().equals(other.phLevel, phLevel)&&(identical(other.density, density) || other.density == density)&&const DeepCollectionEquality().equals(other.carbonOffsetPerTon, carbonOffsetPerTon)&&const DeepCollectionEquality().equals(other.grossWeightPerSak, grossWeightPerSak)&&const DeepCollectionEquality().equals(other.netWeightPerSak, netWeightPerSak)&&(identical(other.bagDimension, bagDimension) || other.bagDimension == bagDimension));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(moistureContent),const DeepCollectionEquality().hash(carbonPurity),const DeepCollectionEquality().hash(productionCapacity),const DeepCollectionEquality().hash(surfaceArea),const DeepCollectionEquality().hash(phLevel),density,const DeepCollectionEquality().hash(carbonOffsetPerTon),const DeepCollectionEquality().hash(grossWeightPerSak),const DeepCollectionEquality().hash(netWeightPerSak),bagDimension);

@override
String toString() {
  return 'ProductTechnicalSpecModel(moistureContent: $moistureContent, carbonPurity: $carbonPurity, productionCapacity: $productionCapacity, surfaceArea: $surfaceArea, phLevel: $phLevel, density: $density, carbonOffsetPerTon: $carbonOffsetPerTon, grossWeightPerSak: $grossWeightPerSak, netWeightPerSak: $netWeightPerSak, bagDimension: $bagDimension)';
}


}

/// @nodoc
abstract mixin class _$ProductTechnicalSpecModelCopyWith<$Res> implements $ProductTechnicalSpecModelCopyWith<$Res> {
  factory _$ProductTechnicalSpecModelCopyWith(_ProductTechnicalSpecModel value, $Res Function(_ProductTechnicalSpecModel) _then) = __$ProductTechnicalSpecModelCopyWithImpl;
@override @useResult
$Res call({
 dynamic moistureContent, dynamic carbonPurity, dynamic productionCapacity, dynamic surfaceArea, dynamic phLevel, String? density, dynamic carbonOffsetPerTon, dynamic grossWeightPerSak, dynamic netWeightPerSak, String? bagDimension
});




}
/// @nodoc
class __$ProductTechnicalSpecModelCopyWithImpl<$Res>
    implements _$ProductTechnicalSpecModelCopyWith<$Res> {
  __$ProductTechnicalSpecModelCopyWithImpl(this._self, this._then);

  final _ProductTechnicalSpecModel _self;
  final $Res Function(_ProductTechnicalSpecModel) _then;

/// Create a copy of ProductTechnicalSpecModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? moistureContent = freezed,Object? carbonPurity = freezed,Object? productionCapacity = freezed,Object? surfaceArea = freezed,Object? phLevel = freezed,Object? density = freezed,Object? carbonOffsetPerTon = freezed,Object? grossWeightPerSak = freezed,Object? netWeightPerSak = freezed,Object? bagDimension = freezed,}) {
  return _then(_ProductTechnicalSpecModel(
moistureContent: freezed == moistureContent ? _self.moistureContent : moistureContent // ignore: cast_nullable_to_non_nullable
as dynamic,carbonPurity: freezed == carbonPurity ? _self.carbonPurity : carbonPurity // ignore: cast_nullable_to_non_nullable
as dynamic,productionCapacity: freezed == productionCapacity ? _self.productionCapacity : productionCapacity // ignore: cast_nullable_to_non_nullable
as dynamic,surfaceArea: freezed == surfaceArea ? _self.surfaceArea : surfaceArea // ignore: cast_nullable_to_non_nullable
as dynamic,phLevel: freezed == phLevel ? _self.phLevel : phLevel // ignore: cast_nullable_to_non_nullable
as dynamic,density: freezed == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as String?,carbonOffsetPerTon: freezed == carbonOffsetPerTon ? _self.carbonOffsetPerTon : carbonOffsetPerTon // ignore: cast_nullable_to_non_nullable
as dynamic,grossWeightPerSak: freezed == grossWeightPerSak ? _self.grossWeightPerSak : grossWeightPerSak // ignore: cast_nullable_to_non_nullable
as dynamic,netWeightPerSak: freezed == netWeightPerSak ? _self.netWeightPerSak : netWeightPerSak // ignore: cast_nullable_to_non_nullable
as dynamic,bagDimension: freezed == bagDimension ? _self.bagDimension : bagDimension // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProductImageModel {

 String get id; String get url; bool get isPrimary; int get order;
/// Create a copy of ProductImageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductImageModelCopyWith<ProductImageModel> get copyWith => _$ProductImageModelCopyWithImpl<ProductImageModel>(this as ProductImageModel, _$identity);

  /// Serializes this ProductImageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,isPrimary,order);

@override
String toString() {
  return 'ProductImageModel(id: $id, url: $url, isPrimary: $isPrimary, order: $order)';
}


}

/// @nodoc
abstract mixin class $ProductImageModelCopyWith<$Res>  {
  factory $ProductImageModelCopyWith(ProductImageModel value, $Res Function(ProductImageModel) _then) = _$ProductImageModelCopyWithImpl;
@useResult
$Res call({
 String id, String url, bool isPrimary, int order
});




}
/// @nodoc
class _$ProductImageModelCopyWithImpl<$Res>
    implements $ProductImageModelCopyWith<$Res> {
  _$ProductImageModelCopyWithImpl(this._self, this._then);

  final ProductImageModel _self;
  final $Res Function(ProductImageModel) _then;

/// Create a copy of ProductImageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? isPrimary = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductImageModel].
extension ProductImageModelPatterns on ProductImageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductImageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductImageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductImageModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductImageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductImageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductImageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String url,  bool isPrimary,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductImageModel() when $default != null:
return $default(_that.id,_that.url,_that.isPrimary,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String url,  bool isPrimary,  int order)  $default,) {final _that = this;
switch (_that) {
case _ProductImageModel():
return $default(_that.id,_that.url,_that.isPrimary,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String url,  bool isPrimary,  int order)?  $default,) {final _that = this;
switch (_that) {
case _ProductImageModel() when $default != null:
return $default(_that.id,_that.url,_that.isPrimary,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductImageModel extends ProductImageModel {
  const _ProductImageModel({required this.id, required this.url, this.isPrimary = false, this.order = 0}): super._();
  factory _ProductImageModel.fromJson(Map<String, dynamic> json) => _$ProductImageModelFromJson(json);

@override final  String id;
@override final  String url;
@override@JsonKey() final  bool isPrimary;
@override@JsonKey() final  int order;

/// Create a copy of ProductImageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductImageModelCopyWith<_ProductImageModel> get copyWith => __$ProductImageModelCopyWithImpl<_ProductImageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductImageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,url,isPrimary,order);

@override
String toString() {
  return 'ProductImageModel(id: $id, url: $url, isPrimary: $isPrimary, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ProductImageModelCopyWith<$Res> implements $ProductImageModelCopyWith<$Res> {
  factory _$ProductImageModelCopyWith(_ProductImageModel value, $Res Function(_ProductImageModel) _then) = __$ProductImageModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, bool isPrimary, int order
});




}
/// @nodoc
class __$ProductImageModelCopyWithImpl<$Res>
    implements _$ProductImageModelCopyWith<$Res> {
  __$ProductImageModelCopyWithImpl(this._self, this._then);

  final _ProductImageModel _self;
  final $Res Function(_ProductImageModel) _then;

/// Create a copy of ProductImageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? isPrimary = null,Object? order = null,}) {
  return _then(_ProductImageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
