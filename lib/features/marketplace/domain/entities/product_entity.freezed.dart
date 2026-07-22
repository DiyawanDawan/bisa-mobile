// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductEntity {

 String get id; String get name; String? get description; double get pricePerUnit; double? get originalPrice; double get stock; double get reservedStock; double get availableStock; bool get canBook; double get minOrder; bool get allowsSample; double get sampleMaxQty; double? get samplePricePerUnit; String get unit; String? get thumbnailUrl; String get biomassaType; String? get grade; String get province; String? get regency; bool get isCertified; bool get isIotMonitored; bool get isEscrowProtected; double get averageRating; int get totalReviews; int get totalSold; String get status; DateTime get createdAt; ProductSellerEntity get seller; ProductTechnicalSpecEntity? get technicalSpec; List<ProductImageEntity>? get images; String get productMode; String? get fertilizerType; bool get isChemicalFree; String? get cropType; String get availabilityType; DateTime? get nextHarvestDate; double? get nextHarvestQtyTon; int? get shelfLifeDays; double? get landAreaHa; String? get categoryId; List<ProductSpecEntity> get specs; String? get videoUrl; bool get isPromoted; DateTime? get promotedUntil; int get promoImpressions; int get promoClicks; List<ProductCertificateEntity> get certificates;
/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductEntityCopyWith<ProductEntity> get copyWith => _$ProductEntityCopyWithImpl<ProductEntity>(this as ProductEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.reservedStock, reservedStock) || other.reservedStock == reservedStock)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.canBook, canBook) || other.canBook == canBook)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.allowsSample, allowsSample) || other.allowsSample == allowsSample)&&(identical(other.sampleMaxQty, sampleMaxQty) || other.sampleMaxQty == sampleMaxQty)&&(identical(other.samplePricePerUnit, samplePricePerUnit) || other.samplePricePerUnit == samplePricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isCertified, isCertified) || other.isCertified == isCertified)&&(identical(other.isIotMonitored, isIotMonitored) || other.isIotMonitored == isIotMonitored)&&(identical(other.isEscrowProtected, isEscrowProtected) || other.isEscrowProtected == isEscrowProtected)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.totalSold, totalSold) || other.totalSold == totalSold)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.technicalSpec, technicalSpec) || other.technicalSpec == technicalSpec)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.fertilizerType, fertilizerType) || other.fertilizerType == fertilizerType)&&(identical(other.isChemicalFree, isChemicalFree) || other.isChemicalFree == isChemicalFree)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.availabilityType, availabilityType) || other.availabilityType == availabilityType)&&(identical(other.nextHarvestDate, nextHarvestDate) || other.nextHarvestDate == nextHarvestDate)&&(identical(other.nextHarvestQtyTon, nextHarvestQtyTon) || other.nextHarvestQtyTon == nextHarvestQtyTon)&&(identical(other.shelfLifeDays, shelfLifeDays) || other.shelfLifeDays == shelfLifeDays)&&(identical(other.landAreaHa, landAreaHa) || other.landAreaHa == landAreaHa)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other.specs, specs)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.isPromoted, isPromoted) || other.isPromoted == isPromoted)&&(identical(other.promotedUntil, promotedUntil) || other.promotedUntil == promotedUntil)&&(identical(other.promoImpressions, promoImpressions) || other.promoImpressions == promoImpressions)&&(identical(other.promoClicks, promoClicks) || other.promoClicks == promoClicks)&&const DeepCollectionEquality().equals(other.certificates, certificates));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,pricePerUnit,originalPrice,stock,reservedStock,availableStock,canBook,minOrder,allowsSample,sampleMaxQty,samplePricePerUnit,unit,thumbnailUrl,biomassaType,grade,province,regency,isCertified,isIotMonitored,isEscrowProtected,averageRating,totalReviews,totalSold,status,createdAt,seller,technicalSpec,const DeepCollectionEquality().hash(images),productMode,fertilizerType,isChemicalFree,cropType,availabilityType,nextHarvestDate,nextHarvestQtyTon,shelfLifeDays,landAreaHa,categoryId,const DeepCollectionEquality().hash(specs),videoUrl,isPromoted,promotedUntil,promoImpressions,promoClicks,const DeepCollectionEquality().hash(certificates)]);

@override
String toString() {
  return 'ProductEntity(id: $id, name: $name, description: $description, pricePerUnit: $pricePerUnit, originalPrice: $originalPrice, stock: $stock, reservedStock: $reservedStock, availableStock: $availableStock, canBook: $canBook, minOrder: $minOrder, allowsSample: $allowsSample, sampleMaxQty: $sampleMaxQty, samplePricePerUnit: $samplePricePerUnit, unit: $unit, thumbnailUrl: $thumbnailUrl, biomassaType: $biomassaType, grade: $grade, province: $province, regency: $regency, isCertified: $isCertified, isIotMonitored: $isIotMonitored, isEscrowProtected: $isEscrowProtected, averageRating: $averageRating, totalReviews: $totalReviews, totalSold: $totalSold, status: $status, createdAt: $createdAt, seller: $seller, technicalSpec: $technicalSpec, images: $images, productMode: $productMode, fertilizerType: $fertilizerType, isChemicalFree: $isChemicalFree, cropType: $cropType, availabilityType: $availabilityType, nextHarvestDate: $nextHarvestDate, nextHarvestQtyTon: $nextHarvestQtyTon, shelfLifeDays: $shelfLifeDays, landAreaHa: $landAreaHa, categoryId: $categoryId, specs: $specs, videoUrl: $videoUrl, isPromoted: $isPromoted, promotedUntil: $promotedUntil, promoImpressions: $promoImpressions, promoClicks: $promoClicks, certificates: $certificates)';
}


}

/// @nodoc
abstract mixin class $ProductEntityCopyWith<$Res>  {
  factory $ProductEntityCopyWith(ProductEntity value, $Res Function(ProductEntity) _then) = _$ProductEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, double pricePerUnit, double? originalPrice, double stock, double reservedStock, double availableStock, bool canBook, double minOrder, bool allowsSample, double sampleMaxQty, double? samplePricePerUnit, String unit, String? thumbnailUrl, String biomassaType, String? grade, String province, String? regency, bool isCertified, bool isIotMonitored, bool isEscrowProtected, double averageRating, int totalReviews, int totalSold, String status, DateTime createdAt, ProductSellerEntity seller, ProductTechnicalSpecEntity? technicalSpec, List<ProductImageEntity>? images, String productMode, String? fertilizerType, bool isChemicalFree, String? cropType, String availabilityType, DateTime? nextHarvestDate, double? nextHarvestQtyTon, int? shelfLifeDays, double? landAreaHa, String? categoryId, List<ProductSpecEntity> specs, String? videoUrl, bool isPromoted, DateTime? promotedUntil, int promoImpressions, int promoClicks, List<ProductCertificateEntity> certificates
});


$ProductSellerEntityCopyWith<$Res> get seller;$ProductTechnicalSpecEntityCopyWith<$Res>? get technicalSpec;

}
/// @nodoc
class _$ProductEntityCopyWithImpl<$Res>
    implements $ProductEntityCopyWith<$Res> {
  _$ProductEntityCopyWithImpl(this._self, this._then);

  final ProductEntity _self;
  final $Res Function(ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? pricePerUnit = null,Object? originalPrice = freezed,Object? stock = null,Object? reservedStock = null,Object? availableStock = null,Object? canBook = null,Object? minOrder = null,Object? allowsSample = null,Object? sampleMaxQty = null,Object? samplePricePerUnit = freezed,Object? unit = null,Object? thumbnailUrl = freezed,Object? biomassaType = null,Object? grade = freezed,Object? province = null,Object? regency = freezed,Object? isCertified = null,Object? isIotMonitored = null,Object? isEscrowProtected = null,Object? averageRating = null,Object? totalReviews = null,Object? totalSold = null,Object? status = null,Object? createdAt = null,Object? seller = null,Object? technicalSpec = freezed,Object? images = freezed,Object? productMode = null,Object? fertilizerType = freezed,Object? isChemicalFree = null,Object? cropType = freezed,Object? availabilityType = null,Object? nextHarvestDate = freezed,Object? nextHarvestQtyTon = freezed,Object? shelfLifeDays = freezed,Object? landAreaHa = freezed,Object? categoryId = freezed,Object? specs = null,Object? videoUrl = freezed,Object? isPromoted = null,Object? promotedUntil = freezed,Object? promoImpressions = null,Object? promoClicks = null,Object? certificates = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,reservedStock: null == reservedStock ? _self.reservedStock : reservedStock // ignore: cast_nullable_to_non_nullable
as double,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as double,canBook: null == canBook ? _self.canBook : canBook // ignore: cast_nullable_to_non_nullable
as bool,minOrder: null == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as double,allowsSample: null == allowsSample ? _self.allowsSample : allowsSample // ignore: cast_nullable_to_non_nullable
as bool,sampleMaxQty: null == sampleMaxQty ? _self.sampleMaxQty : sampleMaxQty // ignore: cast_nullable_to_non_nullable
as double,samplePricePerUnit: freezed == samplePricePerUnit ? _self.samplePricePerUnit : samplePricePerUnit // ignore: cast_nullable_to_non_nullable
as double?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,biomassaType: null == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isCertified: null == isCertified ? _self.isCertified : isCertified // ignore: cast_nullable_to_non_nullable
as bool,isIotMonitored: null == isIotMonitored ? _self.isIotMonitored : isIotMonitored // ignore: cast_nullable_to_non_nullable
as bool,isEscrowProtected: null == isEscrowProtected ? _self.isEscrowProtected : isEscrowProtected // ignore: cast_nullable_to_non_nullable
as bool,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,totalSold: null == totalSold ? _self.totalSold : totalSold // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as ProductSellerEntity,technicalSpec: freezed == technicalSpec ? _self.technicalSpec : technicalSpec // ignore: cast_nullable_to_non_nullable
as ProductTechnicalSpecEntity?,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageEntity>?,productMode: null == productMode ? _self.productMode : productMode // ignore: cast_nullable_to_non_nullable
as String,fertilizerType: freezed == fertilizerType ? _self.fertilizerType : fertilizerType // ignore: cast_nullable_to_non_nullable
as String?,isChemicalFree: null == isChemicalFree ? _self.isChemicalFree : isChemicalFree // ignore: cast_nullable_to_non_nullable
as bool,cropType: freezed == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String?,availabilityType: null == availabilityType ? _self.availabilityType : availabilityType // ignore: cast_nullable_to_non_nullable
as String,nextHarvestDate: freezed == nextHarvestDate ? _self.nextHarvestDate : nextHarvestDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextHarvestQtyTon: freezed == nextHarvestQtyTon ? _self.nextHarvestQtyTon : nextHarvestQtyTon // ignore: cast_nullable_to_non_nullable
as double?,shelfLifeDays: freezed == shelfLifeDays ? _self.shelfLifeDays : shelfLifeDays // ignore: cast_nullable_to_non_nullable
as int?,landAreaHa: freezed == landAreaHa ? _self.landAreaHa : landAreaHa // ignore: cast_nullable_to_non_nullable
as double?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,specs: null == specs ? _self.specs : specs // ignore: cast_nullable_to_non_nullable
as List<ProductSpecEntity>,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,isPromoted: null == isPromoted ? _self.isPromoted : isPromoted // ignore: cast_nullable_to_non_nullable
as bool,promotedUntil: freezed == promotedUntil ? _self.promotedUntil : promotedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,promoImpressions: null == promoImpressions ? _self.promoImpressions : promoImpressions // ignore: cast_nullable_to_non_nullable
as int,promoClicks: null == promoClicks ? _self.promoClicks : promoClicks // ignore: cast_nullable_to_non_nullable
as int,certificates: null == certificates ? _self.certificates : certificates // ignore: cast_nullable_to_non_nullable
as List<ProductCertificateEntity>,
  ));
}
/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductSellerEntityCopyWith<$Res> get seller {
  
  return $ProductSellerEntityCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductTechnicalSpecEntityCopyWith<$Res>? get technicalSpec {
    if (_self.technicalSpec == null) {
    return null;
  }

  return $ProductTechnicalSpecEntityCopyWith<$Res>(_self.technicalSpec!, (value) {
    return _then(_self.copyWith(technicalSpec: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductEntity].
extension ProductEntityPatterns on ProductEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  double pricePerUnit,  double? originalPrice,  double stock,  double reservedStock,  double availableStock,  bool canBook,  double minOrder,  bool allowsSample,  double sampleMaxQty,  double? samplePricePerUnit,  String unit,  String? thumbnailUrl,  String biomassaType,  String? grade,  String province,  String? regency,  bool isCertified,  bool isIotMonitored,  bool isEscrowProtected,  double averageRating,  int totalReviews,  int totalSold,  String status,  DateTime createdAt,  ProductSellerEntity seller,  ProductTechnicalSpecEntity? technicalSpec,  List<ProductImageEntity>? images,  String productMode,  String? fertilizerType,  bool isChemicalFree,  String? cropType,  String availabilityType,  DateTime? nextHarvestDate,  double? nextHarvestQtyTon,  int? shelfLifeDays,  double? landAreaHa,  String? categoryId,  List<ProductSpecEntity> specs,  String? videoUrl,  bool isPromoted,  DateTime? promotedUntil,  int promoImpressions,  int promoClicks,  List<ProductCertificateEntity> certificates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.pricePerUnit,_that.originalPrice,_that.stock,_that.reservedStock,_that.availableStock,_that.canBook,_that.minOrder,_that.allowsSample,_that.sampleMaxQty,_that.samplePricePerUnit,_that.unit,_that.thumbnailUrl,_that.biomassaType,_that.grade,_that.province,_that.regency,_that.isCertified,_that.isIotMonitored,_that.isEscrowProtected,_that.averageRating,_that.totalReviews,_that.totalSold,_that.status,_that.createdAt,_that.seller,_that.technicalSpec,_that.images,_that.productMode,_that.fertilizerType,_that.isChemicalFree,_that.cropType,_that.availabilityType,_that.nextHarvestDate,_that.nextHarvestQtyTon,_that.shelfLifeDays,_that.landAreaHa,_that.categoryId,_that.specs,_that.videoUrl,_that.isPromoted,_that.promotedUntil,_that.promoImpressions,_that.promoClicks,_that.certificates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  double pricePerUnit,  double? originalPrice,  double stock,  double reservedStock,  double availableStock,  bool canBook,  double minOrder,  bool allowsSample,  double sampleMaxQty,  double? samplePricePerUnit,  String unit,  String? thumbnailUrl,  String biomassaType,  String? grade,  String province,  String? regency,  bool isCertified,  bool isIotMonitored,  bool isEscrowProtected,  double averageRating,  int totalReviews,  int totalSold,  String status,  DateTime createdAt,  ProductSellerEntity seller,  ProductTechnicalSpecEntity? technicalSpec,  List<ProductImageEntity>? images,  String productMode,  String? fertilizerType,  bool isChemicalFree,  String? cropType,  String availabilityType,  DateTime? nextHarvestDate,  double? nextHarvestQtyTon,  int? shelfLifeDays,  double? landAreaHa,  String? categoryId,  List<ProductSpecEntity> specs,  String? videoUrl,  bool isPromoted,  DateTime? promotedUntil,  int promoImpressions,  int promoClicks,  List<ProductCertificateEntity> certificates)  $default,) {final _that = this;
switch (_that) {
case _ProductEntity():
return $default(_that.id,_that.name,_that.description,_that.pricePerUnit,_that.originalPrice,_that.stock,_that.reservedStock,_that.availableStock,_that.canBook,_that.minOrder,_that.allowsSample,_that.sampleMaxQty,_that.samplePricePerUnit,_that.unit,_that.thumbnailUrl,_that.biomassaType,_that.grade,_that.province,_that.regency,_that.isCertified,_that.isIotMonitored,_that.isEscrowProtected,_that.averageRating,_that.totalReviews,_that.totalSold,_that.status,_that.createdAt,_that.seller,_that.technicalSpec,_that.images,_that.productMode,_that.fertilizerType,_that.isChemicalFree,_that.cropType,_that.availabilityType,_that.nextHarvestDate,_that.nextHarvestQtyTon,_that.shelfLifeDays,_that.landAreaHa,_that.categoryId,_that.specs,_that.videoUrl,_that.isPromoted,_that.promotedUntil,_that.promoImpressions,_that.promoClicks,_that.certificates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  double pricePerUnit,  double? originalPrice,  double stock,  double reservedStock,  double availableStock,  bool canBook,  double minOrder,  bool allowsSample,  double sampleMaxQty,  double? samplePricePerUnit,  String unit,  String? thumbnailUrl,  String biomassaType,  String? grade,  String province,  String? regency,  bool isCertified,  bool isIotMonitored,  bool isEscrowProtected,  double averageRating,  int totalReviews,  int totalSold,  String status,  DateTime createdAt,  ProductSellerEntity seller,  ProductTechnicalSpecEntity? technicalSpec,  List<ProductImageEntity>? images,  String productMode,  String? fertilizerType,  bool isChemicalFree,  String? cropType,  String availabilityType,  DateTime? nextHarvestDate,  double? nextHarvestQtyTon,  int? shelfLifeDays,  double? landAreaHa,  String? categoryId,  List<ProductSpecEntity> specs,  String? videoUrl,  bool isPromoted,  DateTime? promotedUntil,  int promoImpressions,  int promoClicks,  List<ProductCertificateEntity> certificates)?  $default,) {final _that = this;
switch (_that) {
case _ProductEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.pricePerUnit,_that.originalPrice,_that.stock,_that.reservedStock,_that.availableStock,_that.canBook,_that.minOrder,_that.allowsSample,_that.sampleMaxQty,_that.samplePricePerUnit,_that.unit,_that.thumbnailUrl,_that.biomassaType,_that.grade,_that.province,_that.regency,_that.isCertified,_that.isIotMonitored,_that.isEscrowProtected,_that.averageRating,_that.totalReviews,_that.totalSold,_that.status,_that.createdAt,_that.seller,_that.technicalSpec,_that.images,_that.productMode,_that.fertilizerType,_that.isChemicalFree,_that.cropType,_that.availabilityType,_that.nextHarvestDate,_that.nextHarvestQtyTon,_that.shelfLifeDays,_that.landAreaHa,_that.categoryId,_that.specs,_that.videoUrl,_that.isPromoted,_that.promotedUntil,_that.promoImpressions,_that.promoClicks,_that.certificates);case _:
  return null;

}
}

}

/// @nodoc


class _ProductEntity extends ProductEntity {
  const _ProductEntity({required this.id, required this.name, required this.description, required this.pricePerUnit, this.originalPrice, required this.stock, this.reservedStock = 0, this.availableStock = 0, this.canBook = true, required this.minOrder, this.allowsSample = true, this.sampleMaxQty = 1, this.samplePricePerUnit, required this.unit, this.thumbnailUrl, required this.biomassaType, this.grade, required this.province, this.regency, required this.isCertified, required this.isIotMonitored, required this.isEscrowProtected, required this.averageRating, required this.totalReviews, this.totalSold = 0, required this.status, required this.createdAt, required this.seller, this.technicalSpec, final  List<ProductImageEntity>? images, this.productMode = 'BIOMASS_MATERIAL', this.fertilizerType, this.isChemicalFree = false, this.cropType, this.availabilityType = 'READY', this.nextHarvestDate, this.nextHarvestQtyTon, this.shelfLifeDays, this.landAreaHa, this.categoryId, final  List<ProductSpecEntity> specs = const [], this.videoUrl, this.isPromoted = false, this.promotedUntil, this.promoImpressions = 0, this.promoClicks = 0, final  List<ProductCertificateEntity> certificates = const []}): _images = images,_specs = specs,_certificates = certificates,super._();
  

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  double pricePerUnit;
@override final  double? originalPrice;
@override final  double stock;
@override@JsonKey() final  double reservedStock;
@override@JsonKey() final  double availableStock;
@override@JsonKey() final  bool canBook;
@override final  double minOrder;
@override@JsonKey() final  bool allowsSample;
@override@JsonKey() final  double sampleMaxQty;
@override final  double? samplePricePerUnit;
@override final  String unit;
@override final  String? thumbnailUrl;
@override final  String biomassaType;
@override final  String? grade;
@override final  String province;
@override final  String? regency;
@override final  bool isCertified;
@override final  bool isIotMonitored;
@override final  bool isEscrowProtected;
@override final  double averageRating;
@override final  int totalReviews;
@override@JsonKey() final  int totalSold;
@override final  String status;
@override final  DateTime createdAt;
@override final  ProductSellerEntity seller;
@override final  ProductTechnicalSpecEntity? technicalSpec;
 final  List<ProductImageEntity>? _images;
@override List<ProductImageEntity>? get images {
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
@override@JsonKey() final  String availabilityType;
@override final  DateTime? nextHarvestDate;
@override final  double? nextHarvestQtyTon;
@override final  int? shelfLifeDays;
@override final  double? landAreaHa;
@override final  String? categoryId;
 final  List<ProductSpecEntity> _specs;
@override@JsonKey() List<ProductSpecEntity> get specs {
  if (_specs is EqualUnmodifiableListView) return _specs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specs);
}

@override final  String? videoUrl;
@override@JsonKey() final  bool isPromoted;
@override final  DateTime? promotedUntil;
@override@JsonKey() final  int promoImpressions;
@override@JsonKey() final  int promoClicks;
 final  List<ProductCertificateEntity> _certificates;
@override@JsonKey() List<ProductCertificateEntity> get certificates {
  if (_certificates is EqualUnmodifiableListView) return _certificates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_certificates);
}


/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductEntityCopyWith<_ProductEntity> get copyWith => __$ProductEntityCopyWithImpl<_ProductEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.reservedStock, reservedStock) || other.reservedStock == reservedStock)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.canBook, canBook) || other.canBook == canBook)&&(identical(other.minOrder, minOrder) || other.minOrder == minOrder)&&(identical(other.allowsSample, allowsSample) || other.allowsSample == allowsSample)&&(identical(other.sampleMaxQty, sampleMaxQty) || other.sampleMaxQty == sampleMaxQty)&&(identical(other.samplePricePerUnit, samplePricePerUnit) || other.samplePricePerUnit == samplePricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.biomassaType, biomassaType) || other.biomassaType == biomassaType)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.province, province) || other.province == province)&&(identical(other.regency, regency) || other.regency == regency)&&(identical(other.isCertified, isCertified) || other.isCertified == isCertified)&&(identical(other.isIotMonitored, isIotMonitored) || other.isIotMonitored == isIotMonitored)&&(identical(other.isEscrowProtected, isEscrowProtected) || other.isEscrowProtected == isEscrowProtected)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.totalReviews, totalReviews) || other.totalReviews == totalReviews)&&(identical(other.totalSold, totalSold) || other.totalSold == totalSold)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.seller, seller) || other.seller == seller)&&(identical(other.technicalSpec, technicalSpec) || other.technicalSpec == technicalSpec)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.productMode, productMode) || other.productMode == productMode)&&(identical(other.fertilizerType, fertilizerType) || other.fertilizerType == fertilizerType)&&(identical(other.isChemicalFree, isChemicalFree) || other.isChemicalFree == isChemicalFree)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.availabilityType, availabilityType) || other.availabilityType == availabilityType)&&(identical(other.nextHarvestDate, nextHarvestDate) || other.nextHarvestDate == nextHarvestDate)&&(identical(other.nextHarvestQtyTon, nextHarvestQtyTon) || other.nextHarvestQtyTon == nextHarvestQtyTon)&&(identical(other.shelfLifeDays, shelfLifeDays) || other.shelfLifeDays == shelfLifeDays)&&(identical(other.landAreaHa, landAreaHa) || other.landAreaHa == landAreaHa)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&const DeepCollectionEquality().equals(other._specs, _specs)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.isPromoted, isPromoted) || other.isPromoted == isPromoted)&&(identical(other.promotedUntil, promotedUntil) || other.promotedUntil == promotedUntil)&&(identical(other.promoImpressions, promoImpressions) || other.promoImpressions == promoImpressions)&&(identical(other.promoClicks, promoClicks) || other.promoClicks == promoClicks)&&const DeepCollectionEquality().equals(other._certificates, _certificates));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,pricePerUnit,originalPrice,stock,reservedStock,availableStock,canBook,minOrder,allowsSample,sampleMaxQty,samplePricePerUnit,unit,thumbnailUrl,biomassaType,grade,province,regency,isCertified,isIotMonitored,isEscrowProtected,averageRating,totalReviews,totalSold,status,createdAt,seller,technicalSpec,const DeepCollectionEquality().hash(_images),productMode,fertilizerType,isChemicalFree,cropType,availabilityType,nextHarvestDate,nextHarvestQtyTon,shelfLifeDays,landAreaHa,categoryId,const DeepCollectionEquality().hash(_specs),videoUrl,isPromoted,promotedUntil,promoImpressions,promoClicks,const DeepCollectionEquality().hash(_certificates)]);

@override
String toString() {
  return 'ProductEntity(id: $id, name: $name, description: $description, pricePerUnit: $pricePerUnit, originalPrice: $originalPrice, stock: $stock, reservedStock: $reservedStock, availableStock: $availableStock, canBook: $canBook, minOrder: $minOrder, allowsSample: $allowsSample, sampleMaxQty: $sampleMaxQty, samplePricePerUnit: $samplePricePerUnit, unit: $unit, thumbnailUrl: $thumbnailUrl, biomassaType: $biomassaType, grade: $grade, province: $province, regency: $regency, isCertified: $isCertified, isIotMonitored: $isIotMonitored, isEscrowProtected: $isEscrowProtected, averageRating: $averageRating, totalReviews: $totalReviews, totalSold: $totalSold, status: $status, createdAt: $createdAt, seller: $seller, technicalSpec: $technicalSpec, images: $images, productMode: $productMode, fertilizerType: $fertilizerType, isChemicalFree: $isChemicalFree, cropType: $cropType, availabilityType: $availabilityType, nextHarvestDate: $nextHarvestDate, nextHarvestQtyTon: $nextHarvestQtyTon, shelfLifeDays: $shelfLifeDays, landAreaHa: $landAreaHa, categoryId: $categoryId, specs: $specs, videoUrl: $videoUrl, isPromoted: $isPromoted, promotedUntil: $promotedUntil, promoImpressions: $promoImpressions, promoClicks: $promoClicks, certificates: $certificates)';
}


}

/// @nodoc
abstract mixin class _$ProductEntityCopyWith<$Res> implements $ProductEntityCopyWith<$Res> {
  factory _$ProductEntityCopyWith(_ProductEntity value, $Res Function(_ProductEntity) _then) = __$ProductEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, double pricePerUnit, double? originalPrice, double stock, double reservedStock, double availableStock, bool canBook, double minOrder, bool allowsSample, double sampleMaxQty, double? samplePricePerUnit, String unit, String? thumbnailUrl, String biomassaType, String? grade, String province, String? regency, bool isCertified, bool isIotMonitored, bool isEscrowProtected, double averageRating, int totalReviews, int totalSold, String status, DateTime createdAt, ProductSellerEntity seller, ProductTechnicalSpecEntity? technicalSpec, List<ProductImageEntity>? images, String productMode, String? fertilizerType, bool isChemicalFree, String? cropType, String availabilityType, DateTime? nextHarvestDate, double? nextHarvestQtyTon, int? shelfLifeDays, double? landAreaHa, String? categoryId, List<ProductSpecEntity> specs, String? videoUrl, bool isPromoted, DateTime? promotedUntil, int promoImpressions, int promoClicks, List<ProductCertificateEntity> certificates
});


@override $ProductSellerEntityCopyWith<$Res> get seller;@override $ProductTechnicalSpecEntityCopyWith<$Res>? get technicalSpec;

}
/// @nodoc
class __$ProductEntityCopyWithImpl<$Res>
    implements _$ProductEntityCopyWith<$Res> {
  __$ProductEntityCopyWithImpl(this._self, this._then);

  final _ProductEntity _self;
  final $Res Function(_ProductEntity) _then;

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? pricePerUnit = null,Object? originalPrice = freezed,Object? stock = null,Object? reservedStock = null,Object? availableStock = null,Object? canBook = null,Object? minOrder = null,Object? allowsSample = null,Object? sampleMaxQty = null,Object? samplePricePerUnit = freezed,Object? unit = null,Object? thumbnailUrl = freezed,Object? biomassaType = null,Object? grade = freezed,Object? province = null,Object? regency = freezed,Object? isCertified = null,Object? isIotMonitored = null,Object? isEscrowProtected = null,Object? averageRating = null,Object? totalReviews = null,Object? totalSold = null,Object? status = null,Object? createdAt = null,Object? seller = null,Object? technicalSpec = freezed,Object? images = freezed,Object? productMode = null,Object? fertilizerType = freezed,Object? isChemicalFree = null,Object? cropType = freezed,Object? availabilityType = null,Object? nextHarvestDate = freezed,Object? nextHarvestQtyTon = freezed,Object? shelfLifeDays = freezed,Object? landAreaHa = freezed,Object? categoryId = freezed,Object? specs = null,Object? videoUrl = freezed,Object? isPromoted = null,Object? promotedUntil = freezed,Object? promoImpressions = null,Object? promoClicks = null,Object? certificates = null,}) {
  return _then(_ProductEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as double,reservedStock: null == reservedStock ? _self.reservedStock : reservedStock // ignore: cast_nullable_to_non_nullable
as double,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as double,canBook: null == canBook ? _self.canBook : canBook // ignore: cast_nullable_to_non_nullable
as bool,minOrder: null == minOrder ? _self.minOrder : minOrder // ignore: cast_nullable_to_non_nullable
as double,allowsSample: null == allowsSample ? _self.allowsSample : allowsSample // ignore: cast_nullable_to_non_nullable
as bool,sampleMaxQty: null == sampleMaxQty ? _self.sampleMaxQty : sampleMaxQty // ignore: cast_nullable_to_non_nullable
as double,samplePricePerUnit: freezed == samplePricePerUnit ? _self.samplePricePerUnit : samplePricePerUnit // ignore: cast_nullable_to_non_nullable
as double?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,biomassaType: null == biomassaType ? _self.biomassaType : biomassaType // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String?,province: null == province ? _self.province : province // ignore: cast_nullable_to_non_nullable
as String,regency: freezed == regency ? _self.regency : regency // ignore: cast_nullable_to_non_nullable
as String?,isCertified: null == isCertified ? _self.isCertified : isCertified // ignore: cast_nullable_to_non_nullable
as bool,isIotMonitored: null == isIotMonitored ? _self.isIotMonitored : isIotMonitored // ignore: cast_nullable_to_non_nullable
as bool,isEscrowProtected: null == isEscrowProtected ? _self.isEscrowProtected : isEscrowProtected // ignore: cast_nullable_to_non_nullable
as bool,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,totalReviews: null == totalReviews ? _self.totalReviews : totalReviews // ignore: cast_nullable_to_non_nullable
as int,totalSold: null == totalSold ? _self.totalSold : totalSold // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,seller: null == seller ? _self.seller : seller // ignore: cast_nullable_to_non_nullable
as ProductSellerEntity,technicalSpec: freezed == technicalSpec ? _self.technicalSpec : technicalSpec // ignore: cast_nullable_to_non_nullable
as ProductTechnicalSpecEntity?,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ProductImageEntity>?,productMode: null == productMode ? _self.productMode : productMode // ignore: cast_nullable_to_non_nullable
as String,fertilizerType: freezed == fertilizerType ? _self.fertilizerType : fertilizerType // ignore: cast_nullable_to_non_nullable
as String?,isChemicalFree: null == isChemicalFree ? _self.isChemicalFree : isChemicalFree // ignore: cast_nullable_to_non_nullable
as bool,cropType: freezed == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String?,availabilityType: null == availabilityType ? _self.availabilityType : availabilityType // ignore: cast_nullable_to_non_nullable
as String,nextHarvestDate: freezed == nextHarvestDate ? _self.nextHarvestDate : nextHarvestDate // ignore: cast_nullable_to_non_nullable
as DateTime?,nextHarvestQtyTon: freezed == nextHarvestQtyTon ? _self.nextHarvestQtyTon : nextHarvestQtyTon // ignore: cast_nullable_to_non_nullable
as double?,shelfLifeDays: freezed == shelfLifeDays ? _self.shelfLifeDays : shelfLifeDays // ignore: cast_nullable_to_non_nullable
as int?,landAreaHa: freezed == landAreaHa ? _self.landAreaHa : landAreaHa // ignore: cast_nullable_to_non_nullable
as double?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,specs: null == specs ? _self._specs : specs // ignore: cast_nullable_to_non_nullable
as List<ProductSpecEntity>,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,isPromoted: null == isPromoted ? _self.isPromoted : isPromoted // ignore: cast_nullable_to_non_nullable
as bool,promotedUntil: freezed == promotedUntil ? _self.promotedUntil : promotedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,promoImpressions: null == promoImpressions ? _self.promoImpressions : promoImpressions // ignore: cast_nullable_to_non_nullable
as int,promoClicks: null == promoClicks ? _self.promoClicks : promoClicks // ignore: cast_nullable_to_non_nullable
as int,certificates: null == certificates ? _self._certificates : certificates // ignore: cast_nullable_to_non_nullable
as List<ProductCertificateEntity>,
  ));
}

/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductSellerEntityCopyWith<$Res> get seller {
  
  return $ProductSellerEntityCopyWith<$Res>(_self.seller, (value) {
    return _then(_self.copyWith(seller: value));
  });
}/// Create a copy of ProductEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductTechnicalSpecEntityCopyWith<$Res>? get technicalSpec {
    if (_self.technicalSpec == null) {
    return null;
  }

  return $ProductTechnicalSpecEntityCopyWith<$Res>(_self.technicalSpec!, (value) {
    return _then(_self.copyWith(technicalSpec: value));
  });
}
}

/// @nodoc
mixin _$ProductSpecEntity {

 String get id; String get label; String get value; int get sortOrder;
/// Create a copy of ProductSpecEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSpecEntityCopyWith<ProductSpecEntity> get copyWith => _$ProductSpecEntityCopyWithImpl<ProductSpecEntity>(this as ProductSpecEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSpecEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,value,sortOrder);

@override
String toString() {
  return 'ProductSpecEntity(id: $id, label: $label, value: $value, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ProductSpecEntityCopyWith<$Res>  {
  factory $ProductSpecEntityCopyWith(ProductSpecEntity value, $Res Function(ProductSpecEntity) _then) = _$ProductSpecEntityCopyWithImpl;
@useResult
$Res call({
 String id, String label, String value, int sortOrder
});




}
/// @nodoc
class _$ProductSpecEntityCopyWithImpl<$Res>
    implements $ProductSpecEntityCopyWith<$Res> {
  _$ProductSpecEntityCopyWithImpl(this._self, this._then);

  final ProductSpecEntity _self;
  final $Res Function(ProductSpecEntity) _then;

/// Create a copy of ProductSpecEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? value = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSpecEntity].
extension ProductSpecEntityPatterns on ProductSpecEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSpecEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSpecEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSpecEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductSpecEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSpecEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSpecEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String value,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSpecEntity() when $default != null:
return $default(_that.id,_that.label,_that.value,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String value,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ProductSpecEntity():
return $default(_that.id,_that.label,_that.value,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String value,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ProductSpecEntity() when $default != null:
return $default(_that.id,_that.label,_that.value,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _ProductSpecEntity implements ProductSpecEntity {
  const _ProductSpecEntity({required this.id, required this.label, required this.value, this.sortOrder = 0});
  

@override final  String id;
@override final  String label;
@override final  String value;
@override@JsonKey() final  int sortOrder;

/// Create a copy of ProductSpecEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSpecEntityCopyWith<_ProductSpecEntity> get copyWith => __$ProductSpecEntityCopyWithImpl<_ProductSpecEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSpecEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,value,sortOrder);

@override
String toString() {
  return 'ProductSpecEntity(id: $id, label: $label, value: $value, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ProductSpecEntityCopyWith<$Res> implements $ProductSpecEntityCopyWith<$Res> {
  factory _$ProductSpecEntityCopyWith(_ProductSpecEntity value, $Res Function(_ProductSpecEntity) _then) = __$ProductSpecEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String value, int sortOrder
});




}
/// @nodoc
class __$ProductSpecEntityCopyWithImpl<$Res>
    implements _$ProductSpecEntityCopyWith<$Res> {
  __$ProductSpecEntityCopyWithImpl(this._self, this._then);

  final _ProductSpecEntity _self;
  final $Res Function(_ProductSpecEntity) _then;

/// Create a copy of ProductSpecEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? value = null,Object? sortOrder = null,}) {
  return _then(_ProductSpecEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ProductSellerEntity {

 String get id; String get name; String? get avatarUrl; String? get companyName; int? get rajaongkirOriginId; String? get rajaongkirOriginLabel; bool get isVerified;
/// Create a copy of ProductSellerEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSellerEntityCopyWith<ProductSellerEntity> get copyWith => _$ProductSellerEntityCopyWithImpl<ProductSellerEntity>(this as ProductSellerEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSellerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.rajaongkirOriginId, rajaongkirOriginId) || other.rajaongkirOriginId == rajaongkirOriginId)&&(identical(other.rajaongkirOriginLabel, rajaongkirOriginLabel) || other.rajaongkirOriginLabel == rajaongkirOriginLabel)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,companyName,rajaongkirOriginId,rajaongkirOriginLabel,isVerified);

@override
String toString() {
  return 'ProductSellerEntity(id: $id, name: $name, avatarUrl: $avatarUrl, companyName: $companyName, rajaongkirOriginId: $rajaongkirOriginId, rajaongkirOriginLabel: $rajaongkirOriginLabel, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class $ProductSellerEntityCopyWith<$Res>  {
  factory $ProductSellerEntityCopyWith(ProductSellerEntity value, $Res Function(ProductSellerEntity) _then) = _$ProductSellerEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? avatarUrl, String? companyName, int? rajaongkirOriginId, String? rajaongkirOriginLabel, bool isVerified
});




}
/// @nodoc
class _$ProductSellerEntityCopyWithImpl<$Res>
    implements $ProductSellerEntityCopyWith<$Res> {
  _$ProductSellerEntityCopyWithImpl(this._self, this._then);

  final ProductSellerEntity _self;
  final $Res Function(ProductSellerEntity) _then;

/// Create a copy of ProductSellerEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? companyName = freezed,Object? rajaongkirOriginId = freezed,Object? rajaongkirOriginLabel = freezed,Object? isVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,rajaongkirOriginId: freezed == rajaongkirOriginId ? _self.rajaongkirOriginId : rajaongkirOriginId // ignore: cast_nullable_to_non_nullable
as int?,rajaongkirOriginLabel: freezed == rajaongkirOriginLabel ? _self.rajaongkirOriginLabel : rajaongkirOriginLabel // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSellerEntity].
extension ProductSellerEntityPatterns on ProductSellerEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSellerEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSellerEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSellerEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductSellerEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSellerEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSellerEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  String? companyName,  int? rajaongkirOriginId,  String? rajaongkirOriginLabel,  bool isVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSellerEntity() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.companyName,_that.rajaongkirOriginId,_that.rajaongkirOriginLabel,_that.isVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  String? companyName,  int? rajaongkirOriginId,  String? rajaongkirOriginLabel,  bool isVerified)  $default,) {final _that = this;
switch (_that) {
case _ProductSellerEntity():
return $default(_that.id,_that.name,_that.avatarUrl,_that.companyName,_that.rajaongkirOriginId,_that.rajaongkirOriginLabel,_that.isVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? avatarUrl,  String? companyName,  int? rajaongkirOriginId,  String? rajaongkirOriginLabel,  bool isVerified)?  $default,) {final _that = this;
switch (_that) {
case _ProductSellerEntity() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.companyName,_that.rajaongkirOriginId,_that.rajaongkirOriginLabel,_that.isVerified);case _:
  return null;

}
}

}

/// @nodoc


class _ProductSellerEntity implements ProductSellerEntity {
  const _ProductSellerEntity({required this.id, required this.name, this.avatarUrl, this.companyName, this.rajaongkirOriginId, this.rajaongkirOriginLabel, required this.isVerified});
  

@override final  String id;
@override final  String name;
@override final  String? avatarUrl;
@override final  String? companyName;
@override final  int? rajaongkirOriginId;
@override final  String? rajaongkirOriginLabel;
@override final  bool isVerified;

/// Create a copy of ProductSellerEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSellerEntityCopyWith<_ProductSellerEntity> get copyWith => __$ProductSellerEntityCopyWithImpl<_ProductSellerEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSellerEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.rajaongkirOriginId, rajaongkirOriginId) || other.rajaongkirOriginId == rajaongkirOriginId)&&(identical(other.rajaongkirOriginLabel, rajaongkirOriginLabel) || other.rajaongkirOriginLabel == rajaongkirOriginLabel)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,companyName,rajaongkirOriginId,rajaongkirOriginLabel,isVerified);

@override
String toString() {
  return 'ProductSellerEntity(id: $id, name: $name, avatarUrl: $avatarUrl, companyName: $companyName, rajaongkirOriginId: $rajaongkirOriginId, rajaongkirOriginLabel: $rajaongkirOriginLabel, isVerified: $isVerified)';
}


}

/// @nodoc
abstract mixin class _$ProductSellerEntityCopyWith<$Res> implements $ProductSellerEntityCopyWith<$Res> {
  factory _$ProductSellerEntityCopyWith(_ProductSellerEntity value, $Res Function(_ProductSellerEntity) _then) = __$ProductSellerEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? avatarUrl, String? companyName, int? rajaongkirOriginId, String? rajaongkirOriginLabel, bool isVerified
});




}
/// @nodoc
class __$ProductSellerEntityCopyWithImpl<$Res>
    implements _$ProductSellerEntityCopyWith<$Res> {
  __$ProductSellerEntityCopyWithImpl(this._self, this._then);

  final _ProductSellerEntity _self;
  final $Res Function(_ProductSellerEntity) _then;

/// Create a copy of ProductSellerEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? companyName = freezed,Object? rajaongkirOriginId = freezed,Object? rajaongkirOriginLabel = freezed,Object? isVerified = null,}) {
  return _then(_ProductSellerEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,rajaongkirOriginId: freezed == rajaongkirOriginId ? _self.rajaongkirOriginId : rajaongkirOriginId // ignore: cast_nullable_to_non_nullable
as int?,rajaongkirOriginLabel: freezed == rajaongkirOriginLabel ? _self.rajaongkirOriginLabel : rajaongkirOriginLabel // ignore: cast_nullable_to_non_nullable
as String?,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ProductTechnicalSpecEntity {

 double? get moistureContent; double? get carbonPurity; double? get productionCapacity; double? get surfaceArea; double? get phLevel; String? get density; double? get carbonOffsetPerTon; double? get grossWeightPerSak; double? get netWeightPerSak; String? get bagDimension;
/// Create a copy of ProductTechnicalSpecEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductTechnicalSpecEntityCopyWith<ProductTechnicalSpecEntity> get copyWith => _$ProductTechnicalSpecEntityCopyWithImpl<ProductTechnicalSpecEntity>(this as ProductTechnicalSpecEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductTechnicalSpecEntity&&(identical(other.moistureContent, moistureContent) || other.moistureContent == moistureContent)&&(identical(other.carbonPurity, carbonPurity) || other.carbonPurity == carbonPurity)&&(identical(other.productionCapacity, productionCapacity) || other.productionCapacity == productionCapacity)&&(identical(other.surfaceArea, surfaceArea) || other.surfaceArea == surfaceArea)&&(identical(other.phLevel, phLevel) || other.phLevel == phLevel)&&(identical(other.density, density) || other.density == density)&&(identical(other.carbonOffsetPerTon, carbonOffsetPerTon) || other.carbonOffsetPerTon == carbonOffsetPerTon)&&(identical(other.grossWeightPerSak, grossWeightPerSak) || other.grossWeightPerSak == grossWeightPerSak)&&(identical(other.netWeightPerSak, netWeightPerSak) || other.netWeightPerSak == netWeightPerSak)&&(identical(other.bagDimension, bagDimension) || other.bagDimension == bagDimension));
}


@override
int get hashCode => Object.hash(runtimeType,moistureContent,carbonPurity,productionCapacity,surfaceArea,phLevel,density,carbonOffsetPerTon,grossWeightPerSak,netWeightPerSak,bagDimension);

@override
String toString() {
  return 'ProductTechnicalSpecEntity(moistureContent: $moistureContent, carbonPurity: $carbonPurity, productionCapacity: $productionCapacity, surfaceArea: $surfaceArea, phLevel: $phLevel, density: $density, carbonOffsetPerTon: $carbonOffsetPerTon, grossWeightPerSak: $grossWeightPerSak, netWeightPerSak: $netWeightPerSak, bagDimension: $bagDimension)';
}


}

/// @nodoc
abstract mixin class $ProductTechnicalSpecEntityCopyWith<$Res>  {
  factory $ProductTechnicalSpecEntityCopyWith(ProductTechnicalSpecEntity value, $Res Function(ProductTechnicalSpecEntity) _then) = _$ProductTechnicalSpecEntityCopyWithImpl;
@useResult
$Res call({
 double? moistureContent, double? carbonPurity, double? productionCapacity, double? surfaceArea, double? phLevel, String? density, double? carbonOffsetPerTon, double? grossWeightPerSak, double? netWeightPerSak, String? bagDimension
});




}
/// @nodoc
class _$ProductTechnicalSpecEntityCopyWithImpl<$Res>
    implements $ProductTechnicalSpecEntityCopyWith<$Res> {
  _$ProductTechnicalSpecEntityCopyWithImpl(this._self, this._then);

  final ProductTechnicalSpecEntity _self;
  final $Res Function(ProductTechnicalSpecEntity) _then;

/// Create a copy of ProductTechnicalSpecEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? moistureContent = freezed,Object? carbonPurity = freezed,Object? productionCapacity = freezed,Object? surfaceArea = freezed,Object? phLevel = freezed,Object? density = freezed,Object? carbonOffsetPerTon = freezed,Object? grossWeightPerSak = freezed,Object? netWeightPerSak = freezed,Object? bagDimension = freezed,}) {
  return _then(_self.copyWith(
moistureContent: freezed == moistureContent ? _self.moistureContent : moistureContent // ignore: cast_nullable_to_non_nullable
as double?,carbonPurity: freezed == carbonPurity ? _self.carbonPurity : carbonPurity // ignore: cast_nullable_to_non_nullable
as double?,productionCapacity: freezed == productionCapacity ? _self.productionCapacity : productionCapacity // ignore: cast_nullable_to_non_nullable
as double?,surfaceArea: freezed == surfaceArea ? _self.surfaceArea : surfaceArea // ignore: cast_nullable_to_non_nullable
as double?,phLevel: freezed == phLevel ? _self.phLevel : phLevel // ignore: cast_nullable_to_non_nullable
as double?,density: freezed == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as String?,carbonOffsetPerTon: freezed == carbonOffsetPerTon ? _self.carbonOffsetPerTon : carbonOffsetPerTon // ignore: cast_nullable_to_non_nullable
as double?,grossWeightPerSak: freezed == grossWeightPerSak ? _self.grossWeightPerSak : grossWeightPerSak // ignore: cast_nullable_to_non_nullable
as double?,netWeightPerSak: freezed == netWeightPerSak ? _self.netWeightPerSak : netWeightPerSak // ignore: cast_nullable_to_non_nullable
as double?,bagDimension: freezed == bagDimension ? _self.bagDimension : bagDimension // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductTechnicalSpecEntity].
extension ProductTechnicalSpecEntityPatterns on ProductTechnicalSpecEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductTechnicalSpecEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductTechnicalSpecEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductTechnicalSpecEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductTechnicalSpecEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductTechnicalSpecEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductTechnicalSpecEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? moistureContent,  double? carbonPurity,  double? productionCapacity,  double? surfaceArea,  double? phLevel,  String? density,  double? carbonOffsetPerTon,  double? grossWeightPerSak,  double? netWeightPerSak,  String? bagDimension)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductTechnicalSpecEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? moistureContent,  double? carbonPurity,  double? productionCapacity,  double? surfaceArea,  double? phLevel,  String? density,  double? carbonOffsetPerTon,  double? grossWeightPerSak,  double? netWeightPerSak,  String? bagDimension)  $default,) {final _that = this;
switch (_that) {
case _ProductTechnicalSpecEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? moistureContent,  double? carbonPurity,  double? productionCapacity,  double? surfaceArea,  double? phLevel,  String? density,  double? carbonOffsetPerTon,  double? grossWeightPerSak,  double? netWeightPerSak,  String? bagDimension)?  $default,) {final _that = this;
switch (_that) {
case _ProductTechnicalSpecEntity() when $default != null:
return $default(_that.moistureContent,_that.carbonPurity,_that.productionCapacity,_that.surfaceArea,_that.phLevel,_that.density,_that.carbonOffsetPerTon,_that.grossWeightPerSak,_that.netWeightPerSak,_that.bagDimension);case _:
  return null;

}
}

}

/// @nodoc


class _ProductTechnicalSpecEntity implements ProductTechnicalSpecEntity {
  const _ProductTechnicalSpecEntity({this.moistureContent, this.carbonPurity, this.productionCapacity, this.surfaceArea, this.phLevel, this.density, this.carbonOffsetPerTon, this.grossWeightPerSak, this.netWeightPerSak, this.bagDimension});
  

@override final  double? moistureContent;
@override final  double? carbonPurity;
@override final  double? productionCapacity;
@override final  double? surfaceArea;
@override final  double? phLevel;
@override final  String? density;
@override final  double? carbonOffsetPerTon;
@override final  double? grossWeightPerSak;
@override final  double? netWeightPerSak;
@override final  String? bagDimension;

/// Create a copy of ProductTechnicalSpecEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductTechnicalSpecEntityCopyWith<_ProductTechnicalSpecEntity> get copyWith => __$ProductTechnicalSpecEntityCopyWithImpl<_ProductTechnicalSpecEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductTechnicalSpecEntity&&(identical(other.moistureContent, moistureContent) || other.moistureContent == moistureContent)&&(identical(other.carbonPurity, carbonPurity) || other.carbonPurity == carbonPurity)&&(identical(other.productionCapacity, productionCapacity) || other.productionCapacity == productionCapacity)&&(identical(other.surfaceArea, surfaceArea) || other.surfaceArea == surfaceArea)&&(identical(other.phLevel, phLevel) || other.phLevel == phLevel)&&(identical(other.density, density) || other.density == density)&&(identical(other.carbonOffsetPerTon, carbonOffsetPerTon) || other.carbonOffsetPerTon == carbonOffsetPerTon)&&(identical(other.grossWeightPerSak, grossWeightPerSak) || other.grossWeightPerSak == grossWeightPerSak)&&(identical(other.netWeightPerSak, netWeightPerSak) || other.netWeightPerSak == netWeightPerSak)&&(identical(other.bagDimension, bagDimension) || other.bagDimension == bagDimension));
}


@override
int get hashCode => Object.hash(runtimeType,moistureContent,carbonPurity,productionCapacity,surfaceArea,phLevel,density,carbonOffsetPerTon,grossWeightPerSak,netWeightPerSak,bagDimension);

@override
String toString() {
  return 'ProductTechnicalSpecEntity(moistureContent: $moistureContent, carbonPurity: $carbonPurity, productionCapacity: $productionCapacity, surfaceArea: $surfaceArea, phLevel: $phLevel, density: $density, carbonOffsetPerTon: $carbonOffsetPerTon, grossWeightPerSak: $grossWeightPerSak, netWeightPerSak: $netWeightPerSak, bagDimension: $bagDimension)';
}


}

/// @nodoc
abstract mixin class _$ProductTechnicalSpecEntityCopyWith<$Res> implements $ProductTechnicalSpecEntityCopyWith<$Res> {
  factory _$ProductTechnicalSpecEntityCopyWith(_ProductTechnicalSpecEntity value, $Res Function(_ProductTechnicalSpecEntity) _then) = __$ProductTechnicalSpecEntityCopyWithImpl;
@override @useResult
$Res call({
 double? moistureContent, double? carbonPurity, double? productionCapacity, double? surfaceArea, double? phLevel, String? density, double? carbonOffsetPerTon, double? grossWeightPerSak, double? netWeightPerSak, String? bagDimension
});




}
/// @nodoc
class __$ProductTechnicalSpecEntityCopyWithImpl<$Res>
    implements _$ProductTechnicalSpecEntityCopyWith<$Res> {
  __$ProductTechnicalSpecEntityCopyWithImpl(this._self, this._then);

  final _ProductTechnicalSpecEntity _self;
  final $Res Function(_ProductTechnicalSpecEntity) _then;

/// Create a copy of ProductTechnicalSpecEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? moistureContent = freezed,Object? carbonPurity = freezed,Object? productionCapacity = freezed,Object? surfaceArea = freezed,Object? phLevel = freezed,Object? density = freezed,Object? carbonOffsetPerTon = freezed,Object? grossWeightPerSak = freezed,Object? netWeightPerSak = freezed,Object? bagDimension = freezed,}) {
  return _then(_ProductTechnicalSpecEntity(
moistureContent: freezed == moistureContent ? _self.moistureContent : moistureContent // ignore: cast_nullable_to_non_nullable
as double?,carbonPurity: freezed == carbonPurity ? _self.carbonPurity : carbonPurity // ignore: cast_nullable_to_non_nullable
as double?,productionCapacity: freezed == productionCapacity ? _self.productionCapacity : productionCapacity // ignore: cast_nullable_to_non_nullable
as double?,surfaceArea: freezed == surfaceArea ? _self.surfaceArea : surfaceArea // ignore: cast_nullable_to_non_nullable
as double?,phLevel: freezed == phLevel ? _self.phLevel : phLevel // ignore: cast_nullable_to_non_nullable
as double?,density: freezed == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as String?,carbonOffsetPerTon: freezed == carbonOffsetPerTon ? _self.carbonOffsetPerTon : carbonOffsetPerTon // ignore: cast_nullable_to_non_nullable
as double?,grossWeightPerSak: freezed == grossWeightPerSak ? _self.grossWeightPerSak : grossWeightPerSak // ignore: cast_nullable_to_non_nullable
as double?,netWeightPerSak: freezed == netWeightPerSak ? _self.netWeightPerSak : netWeightPerSak // ignore: cast_nullable_to_non_nullable
as double?,bagDimension: freezed == bagDimension ? _self.bagDimension : bagDimension // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$ProductImageEntity {

 String get id; String get url; bool get isPrimary; int get order;
/// Create a copy of ProductImageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductImageEntityCopyWith<ProductImageEntity> get copyWith => _$ProductImageEntityCopyWithImpl<ProductImageEntity>(this as ProductImageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductImageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,id,url,isPrimary,order);

@override
String toString() {
  return 'ProductImageEntity(id: $id, url: $url, isPrimary: $isPrimary, order: $order)';
}


}

/// @nodoc
abstract mixin class $ProductImageEntityCopyWith<$Res>  {
  factory $ProductImageEntityCopyWith(ProductImageEntity value, $Res Function(ProductImageEntity) _then) = _$ProductImageEntityCopyWithImpl;
@useResult
$Res call({
 String id, String url, bool isPrimary, int order
});




}
/// @nodoc
class _$ProductImageEntityCopyWithImpl<$Res>
    implements $ProductImageEntityCopyWith<$Res> {
  _$ProductImageEntityCopyWithImpl(this._self, this._then);

  final ProductImageEntity _self;
  final $Res Function(ProductImageEntity) _then;

/// Create a copy of ProductImageEntity
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


/// Adds pattern-matching-related methods to [ProductImageEntity].
extension ProductImageEntityPatterns on ProductImageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductImageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductImageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductImageEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProductImageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductImageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProductImageEntity() when $default != null:
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
case _ProductImageEntity() when $default != null:
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
case _ProductImageEntity():
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
case _ProductImageEntity() when $default != null:
return $default(_that.id,_that.url,_that.isPrimary,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _ProductImageEntity implements ProductImageEntity {
  const _ProductImageEntity({required this.id, required this.url, required this.isPrimary, this.order = 0});
  

@override final  String id;
@override final  String url;
@override final  bool isPrimary;
@override@JsonKey() final  int order;

/// Create a copy of ProductImageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductImageEntityCopyWith<_ProductImageEntity> get copyWith => __$ProductImageEntityCopyWithImpl<_ProductImageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductImageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,id,url,isPrimary,order);

@override
String toString() {
  return 'ProductImageEntity(id: $id, url: $url, isPrimary: $isPrimary, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ProductImageEntityCopyWith<$Res> implements $ProductImageEntityCopyWith<$Res> {
  factory _$ProductImageEntityCopyWith(_ProductImageEntity value, $Res Function(_ProductImageEntity) _then) = __$ProductImageEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String url, bool isPrimary, int order
});




}
/// @nodoc
class __$ProductImageEntityCopyWithImpl<$Res>
    implements _$ProductImageEntityCopyWith<$Res> {
  __$ProductImageEntityCopyWithImpl(this._self, this._then);

  final _ProductImageEntity _self;
  final $Res Function(_ProductImageEntity) _then;

/// Create a copy of ProductImageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? isPrimary = null,Object? order = null,}) {
  return _then(_ProductImageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
