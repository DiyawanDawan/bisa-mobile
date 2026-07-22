import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../domain/entities/product_entity.dart';
import 'product_certificate_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    String? description,
    required dynamic pricePerUnit,
    dynamic originalPrice,
    @Default(0) dynamic stock,
    @Default(0) dynamic reservedStock,
    @Default(0) dynamic availableStock,
    @Default(true) bool canBook,
    @Default(1) dynamic minOrder,
    @Default(true) bool allowsSample,
    @Default(1) dynamic sampleMaxQty,
    dynamic samplePricePerUnit,
    required String unit,
    String? thumbnailUrl,
    required String biomassaType,
    String? grade,
    required String province,
    String? regency,
    @Default(false) bool isCertified,
    @Default(false) bool isIotMonitored,
    @Default(false) bool isEscrowProtected,
    @Default(0.0) dynamic averageRating,
    @Default(0) dynamic totalReviews,
    @Default(0) dynamic totalSold,
    String? createdAt,
    required ProductSellerModel user,
    @Default('ACTIVE') String status,
    ProductTechnicalSpecModel? technicalSpec,
    List<ProductImageModel>? images,
    @Default('BIOMASS_MATERIAL') String productMode,
    String? fertilizerType,
    @Default(false) bool isChemicalFree,
    String? cropType,
    @Default('READY') String availabilityType,
    String? nextHarvestDate,
    dynamic nextHarvestQtyTon,
    int? shelfLifeDays,
    dynamic landAreaHa,
    String? categoryId,
    @Default([]) List<ProductSpecModel> specs,
    String? videoUrl,
    @Default(false) bool isPromoted,
    String? promotedUntil,
    @Default(0) int promoImpressions,
    @Default(0) int promoClicks,
    @Default([]) List<ProductCertificateModel> certificates,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      pricePerUnit: json['pricePerUnit'],
      originalPrice: json['originalPrice'],
      stock: json['stock'] ?? 0,
      reservedStock: json['reservedStock'] ?? 0,
      availableStock: json['availableStock'] ?? json['stock'] ?? 0,
      canBook: json['canBook'] as bool? ?? true,
      minOrder: json['minOrder'] ?? 1,
      allowsSample: json['allowsSample'] as bool? ?? true,
      sampleMaxQty: json['sampleMaxQty'] ?? 1,
      samplePricePerUnit: json['samplePricePerUnit'],
      unit: json['unit'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      biomassaType: json['biomassaType'] as String,
      grade: json['grade'] as String?,
      province: json['province'] as String? ?? '',
      regency: json['regency'] as String?,
      isCertified: json['isCertified'] as bool? ?? false,
      isIotMonitored: json['isIotMonitored'] as bool? ?? false,
      isEscrowProtected: json['isEscrowProtected'] as bool? ?? false,
      averageRating: json['averageRating'] ?? 0.0,
      totalReviews: json['totalReviews'] ?? 0,
      totalSold: json['totalSold'] ?? 0,
      createdAt: json['createdAt'] as String?,
      user: ProductSellerModel.fromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String? ?? 'ACTIVE',
      technicalSpec: json['technicalSpec'] == null
          ? null
          : ProductTechnicalSpecModel.fromJson(
              json['technicalSpec'] as Map<String, dynamic>,
            ),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      productMode: json['productMode'] as String? ?? 'BIOMASS_MATERIAL',
      fertilizerType: json['fertilizerType'] as String?,
      isChemicalFree: json['isChemicalFree'] as bool? ?? false,
      cropType: json['cropType'] as String?,
      availabilityType: json['availabilityType'] as String? ?? 'READY',
      nextHarvestDate: json['nextHarvestDate'] as String?,
      nextHarvestQtyTon: json['nextHarvestQtyTon'],
      shelfLifeDays: int.tryParse(json['shelfLifeDays']?.toString() ?? ''),
      landAreaHa: json['landAreaHa'],
      categoryId: json['categoryId'] as String?,
      specs: parseSpecs(json['specs']),
      videoUrl: json['videoUrl'] as String?,
      isPromoted: json['isPromoted'] as bool? ?? false,
      promotedUntil: json['promotedUntil'] as String?,
      promoImpressions:
          int.tryParse(json['promoImpressions']?.toString() ?? '') ?? 0,
      promoClicks: int.tryParse(json['promoClicks']?.toString() ?? '') ?? 0,
      certificates:
          (json['certificates'] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (item) => ProductCertificateModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList() ??
          const [],
    );
  }

  const ProductModel._();

  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    description: description,
    pricePerUnit: double.tryParse(pricePerUnit.toString()) ?? 0.0,
    originalPrice: originalPrice != null
        ? double.tryParse(originalPrice.toString())
        : null,
    stock: double.tryParse(stock.toString()) ?? 0.0,
    reservedStock: double.tryParse(reservedStock.toString()) ?? 0.0,
    availableStock:
        double.tryParse(availableStock.toString()) ??
        (double.tryParse(stock.toString()) ?? 0.0),
    canBook: canBook,
    minOrder: double.tryParse(minOrder.toString()) ?? 0.0,
    allowsSample: allowsSample,
    sampleMaxQty: double.tryParse(sampleMaxQty.toString()) ?? 1,
    samplePricePerUnit: samplePricePerUnit != null
        ? double.tryParse(samplePricePerUnit.toString())
        : null,
    unit: unit,
    thumbnailUrl: resolveMediaField(thumbnailUrl),
    biomassaType: biomassaType,
    grade: grade,
    province: province,
    regency: regency,
    isCertified: isCertified,
    isIotMonitored: isIotMonitored,
    isEscrowProtected: isEscrowProtected,
    averageRating: double.tryParse(averageRating.toString()) ?? 0.0,
    totalReviews: int.tryParse(totalReviews.toString()) ?? 0,
    totalSold: int.tryParse(totalSold.toString()) ?? 0,
    status: status,
    createdAt: createdAt != null ? DateTime.parse(createdAt!) : DateTime.now(),
    seller: user.toEntity(),
    technicalSpec: technicalSpec?.toEntity(),
    images: images?.map((e) => e.toEntity()).toList(),
    productMode: productMode,
    fertilizerType: fertilizerType,
    isChemicalFree: isChemicalFree,
    cropType: cropType,
    availabilityType: availabilityType,
    nextHarvestDate: nextHarvestDate != null
        ? DateTime.tryParse(nextHarvestDate!)
        : null,
    nextHarvestQtyTon: nextHarvestQtyTon != null
        ? double.tryParse(nextHarvestQtyTon.toString())
        : null,
    shelfLifeDays: shelfLifeDays,
    landAreaHa: landAreaHa != null
        ? double.tryParse(landAreaHa.toString())
        : null,
    categoryId: categoryId,
    specs: specs
        .map(
          (e) => ProductSpecEntity(
            id: e.id,
            label: e.label,
            value: e.value,
            sortOrder: e.sortOrder,
          ),
        )
        .toList(),
    videoUrl: resolveMediaField(videoUrl),
    isPromoted: isPromoted,
    promotedUntil: promotedUntil != null
        ? DateTime.tryParse(promotedUntil!)
        : null,
    promoImpressions: promoImpressions,
    promoClicks: promoClicks,
    certificates: certificates.map((item) => item.toEntity()).toList(),
  );
}

List<ProductSpecModel> parseSpecs(dynamic raw) {
  if (raw is! List) return const [];
  final list = raw
      .whereType<Map>()
      .map(
        (e) => ProductSpecModel(
          id: e['id']?.toString() ?? '',
          label: e['label']?.toString() ?? '',
          value: e['value']?.toString() ?? '',
          sortOrder: int.tryParse(e['sortOrder']?.toString() ?? '') ?? 0,
        ),
      )
      .where((e) => e.label.isNotEmpty && e.value.isNotEmpty)
      .toList();
  list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return list;
}

class ProductSpecModel {
  const ProductSpecModel({
    required this.id,
    required this.label,
    required this.value,
    this.sortOrder = 0,
  });

  final String id;
  final String label;
  final String value;
  final int sortOrder;
}

@freezed
abstract class ProductSellerModel with _$ProductSellerModel {
  const factory ProductSellerModel({
    required String id,
    @JsonKey(name: 'fullName') required String name,
    String? avatarUrl,
    @JsonKey(name: 'profile') ProductSellerProfileModel? profile,
    @JsonKey(name: 'isVerified', defaultValue: false)
    @Default(false)
    bool isVerified,
  }) = _ProductSellerModel;

  factory ProductSellerModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSellerModelFromJson(json);

  const ProductSellerModel._();

  ProductSellerEntity toEntity() => ProductSellerEntity(
    id: id,
    name: name,
    avatarUrl: resolveMediaField(avatarUrl),
    companyName: profile?.companyName,
    rajaongkirOriginId: profile?.rajaongkirOriginId,
    rajaongkirOriginLabel: profile?.rajaongkirOriginLabel,
    isVerified: isVerified,
  );
}

@freezed
abstract class ProductSellerProfileModel with _$ProductSellerProfileModel {
  const factory ProductSellerProfileModel({
    String? companyName,
    int? rajaongkirOriginId,
    String? rajaongkirOriginLabel,
  }) = _ProductSellerProfileModel;

  factory ProductSellerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSellerProfileModelFromJson(json);
}

@freezed
abstract class ProductTechnicalSpecModel with _$ProductTechnicalSpecModel {
  const factory ProductTechnicalSpecModel({
    dynamic moistureContent,
    dynamic carbonPurity,
    dynamic productionCapacity,
    dynamic surfaceArea,
    dynamic phLevel,
    String? density,
    dynamic carbonOffsetPerTon,
    dynamic grossWeightPerSak,
    dynamic netWeightPerSak,
    String? bagDimension,
  }) = _ProductTechnicalSpecModel;

  factory ProductTechnicalSpecModel.fromJson(Map<String, dynamic> json) =>
      _$ProductTechnicalSpecModelFromJson(json);

  const ProductTechnicalSpecModel._();

  ProductTechnicalSpecEntity toEntity() => ProductTechnicalSpecEntity(
    moistureContent: moistureContent != null
        ? double.tryParse(moistureContent.toString())
        : null,
    carbonPurity: carbonPurity != null
        ? double.tryParse(carbonPurity.toString())
        : null,
    productionCapacity: productionCapacity != null
        ? double.tryParse(productionCapacity.toString())
        : null,
    surfaceArea: surfaceArea != null
        ? double.tryParse(surfaceArea.toString())
        : null,
    phLevel: phLevel != null ? double.tryParse(phLevel.toString()) : null,
    density: density,
    carbonOffsetPerTon: carbonOffsetPerTon != null
        ? double.tryParse(carbonOffsetPerTon.toString())
        : null,
    grossWeightPerSak: grossWeightPerSak != null
        ? double.tryParse(grossWeightPerSak.toString())
        : null,
    netWeightPerSak: netWeightPerSak != null
        ? double.tryParse(netWeightPerSak.toString())
        : null,
    bagDimension: bagDimension,
  );
}

@freezed
abstract class ProductImageModel with _$ProductImageModel {
  const factory ProductImageModel({
    required String id,
    required String url,
    @Default(false) bool isPrimary,
    @Default(0) int order,
  }) = _ProductImageModel;

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);

  const ProductImageModel._();

  ProductImageEntity toEntity() {
    return ProductImageEntity(
      id: id,
      url: resolveMediaField(url) ?? url,
      isPrimary: isPrimary,
      order: order,
    );
  }
}
