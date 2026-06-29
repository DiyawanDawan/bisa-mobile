import '../../domain/entities/product_entity.dart';

/// Snapshot ringkas produk untuk daftar banding tersimpan (SharedPreferences).
abstract class CompareProductCodec {
  static Map<String, dynamic> toJson(ProductEntity p) => {
        'id': p.id,
        'name': p.name,
        'description': p.description,
        'pricePerUnit': p.pricePerUnit,
        'samplePricePerUnit': p.samplePricePerUnit,
        'stock': p.stock,
        'minOrder': p.minOrder,
        'unit': p.unit,
        'thumbnailUrl': p.thumbnailUrl,
        'averageRating': p.averageRating,
        'totalReviews': p.totalReviews,
        'productMode': p.productMode,
        'status': p.status,
        'createdAt': p.createdAt.toIso8601String(),
        'biomassaType': p.biomassaType,
        'province': p.province,
        'isCertified': p.isCertified,
        'isIotMonitored': p.isIotMonitored,
        'isEscrowProtected': p.isEscrowProtected,
        'seller': {
          'id': p.seller.id,
          'name': p.seller.name,
          'companyName': p.seller.companyName,
          'isVerified': p.seller.isVerified,
        },
        'specs': p.specs
            .map(
              (s) => {
                'id': s.id,
                'label': s.label,
                'value': s.value,
                'sortOrder': s.sortOrder,
              },
            )
            .toList(),
      };

  static ProductEntity fromJson(Map<String, dynamic> j) {
    final seller = j['seller'] as Map<String, dynamic>? ?? {};
    final specsRaw = j['specs'] as List? ?? [];
    return ProductEntity(
      id: j['id'] as String,
      name: j['name'] as String,
      description: j['description'] as String?,
      pricePerUnit: (j['pricePerUnit'] as num).toDouble(),
      samplePricePerUnit: (j['samplePricePerUnit'] as num?)?.toDouble(),
      stock: (j['stock'] as num).toDouble(),
      minOrder: (j['minOrder'] as num).toDouble(),
      unit: j['unit'] as String,
      thumbnailUrl: j['thumbnailUrl'] as String?,
      averageRating: (j['averageRating'] as num).toDouble(),
      totalReviews: j['totalReviews'] as int,
      productMode: j['productMode'] as String? ?? 'BIOMASS_MATERIAL',
      status: j['status'] as String? ?? 'ACTIVE',
      createdAt: DateTime.parse(j['createdAt'] as String),
      biomassaType: j['biomassaType'] as String? ?? '',
      province: j['province'] as String? ?? '',
      isCertified: j['isCertified'] as bool? ?? false,
      isIotMonitored: j['isIotMonitored'] as bool? ?? false,
      isEscrowProtected: j['isEscrowProtected'] as bool? ?? false,
      seller: ProductSellerEntity(
        id: seller['id'] as String? ?? '',
        name: seller['name'] as String? ?? '',
        companyName: seller['companyName'] as String?,
        isVerified: seller['isVerified'] as bool? ?? false,
      ),
      specs: specsRaw
          .map(
            (e) => ProductSpecEntity(
              id: (e as Map)['id'] as String? ?? '',
              label: e['label'] as String? ?? '',
              value: e['value'] as String? ?? '',
              sortOrder: e['sortOrder'] as int? ?? 0,
            ),
          )
          .toList(),
    );
  }
}
