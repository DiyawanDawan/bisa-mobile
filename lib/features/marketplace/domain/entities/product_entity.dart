import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required String id,
    required String name,
    required String? description,
    required double pricePerUnit,
    double? originalPrice,
    required double stock,
    required double minOrder,
    required String unit,
    String? thumbnailUrl,
    required String biomassaType,
    String? grade,
    required String province,
    String? regency,
    required bool isCertified,
    required bool isIotMonitored,
    required bool isEscrowProtected,
    required double averageRating,
    required int totalReviews,
    @Default(0) int totalSold,
    required String status,
    required DateTime createdAt,
    required ProductSellerEntity seller,
    ProductTechnicalSpecEntity? technicalSpec,
    List<ProductImageEntity>? images,
    @Default('BIOMASS_MATERIAL') String productMode,
    String? fertilizerType,
    @Default(false) bool isChemicalFree,
    String? cropType,
    String? categoryId,
    @Default([]) List<ProductSpecEntity> specs,
  }) = _ProductEntity;
}

@freezed
abstract class ProductSpecEntity with _$ProductSpecEntity {
  const factory ProductSpecEntity({
    required String id,
    required String label,
    required String value,
    @Default(0) int sortOrder,
  }) = _ProductSpecEntity;
}

@freezed
abstract class ProductSellerEntity with _$ProductSellerEntity {
  const factory ProductSellerEntity({
    required String id,
    required String name,
    String? avatarUrl,
    String? companyName,
    int? rajaongkirOriginId,
    String? rajaongkirOriginLabel,
    required bool isVerified,
  }) = _ProductSellerEntity;
}

@freezed
abstract class ProductTechnicalSpecEntity with _$ProductTechnicalSpecEntity {
  const factory ProductTechnicalSpecEntity({
    double? moistureContent,
    double? carbonPurity,
    double? productionCapacity,
    double? surfaceArea,
    double? phLevel,
    String? density,
    double? carbonOffsetPerTon,
    double? grossWeightPerSak,
    double? netWeightPerSak,
    String? bagDimension,
  }) = _ProductTechnicalSpecEntity;
}

@freezed
abstract class ProductImageEntity with _$ProductImageEntity {
  const factory ProductImageEntity({
    required String id,
    required String url,
    required bool isPrimary,
    @Default(0) int order,
  }) = _ProductImageEntity;
}
