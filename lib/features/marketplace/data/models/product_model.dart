import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../domain/entities/product_entity.dart';

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
    @Default(1) dynamic minOrder,
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
    String? categoryId,
    @Default([]) List<ProductSpecModel> specs,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      pricePerUnit: json['pricePerUnit'],
      originalPrice: json['originalPrice'],
      stock: json['stock'] ?? 0,
      minOrder: json['minOrder'] ?? 1,
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
      categoryId: json['categoryId'] as String?,
      specs: parseSpecs(json['specs']),
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
    minOrder: double.tryParse(minOrder.toString()) ?? 0.0,
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
  }) =
      _ProductSellerProfileModel;

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
