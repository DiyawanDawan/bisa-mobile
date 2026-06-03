import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../marketplace/domain/entities/product_entity.dart';

part 'negotiation_offer_draft.freezed.dart';

/// Data penawaran sebelum dikirim ke backend (preview & edit ulang).
@freezed
abstract class NegotiationOfferDraft with _$NegotiationOfferDraft {
  const NegotiationOfferDraft._();

  const factory NegotiationOfferDraft({
    required String productId,
    required String productName,
    String? productThumbnailUrl,
    required String sellerId,
    required String sellerName,
    String? sellerCompanyName,
    String? sellerAvatarUrl,
    @Default(false) bool sellerIsVerified,
    required String unit,
    required double minOrder,
    required double stock,
    required double catalogPricePerUnit,
    required double quantity,
    required double offerPricePerUnit,
    String? message,
    String? localImagePath,
  }) = _NegotiationOfferDraft;

  factory NegotiationOfferDraft.fromProduct(
    ProductEntity product, {
    required double quantity,
    required double offerPricePerUnit,
    String? message,
    String? localImagePath,
  }) {
    return NegotiationOfferDraft(
      productId: product.id,
      productName: product.name,
      productThumbnailUrl: product.thumbnailUrl,
      sellerId: product.seller.id,
      sellerName: product.seller.name,
      sellerCompanyName: product.seller.companyName,
      sellerAvatarUrl: product.seller.avatarUrl,
      sellerIsVerified: product.seller.isVerified,
      unit: product.unit,
      minOrder: product.minOrder,
      stock: product.stock,
      catalogPricePerUnit: product.pricePerUnit,
      quantity: quantity,
      offerPricePerUnit: offerPricePerUnit,
      message: message,
      localImagePath: localImagePath,
    );
  }

  /// Nama toko yang ditampilkan ke buyer (prioritas nama perusahaan).
  String get sellerDisplayName {
    final company = sellerCompanyName?.trim();
    if (company != null && company.isNotEmpty) return company;
    final name = sellerName.trim();
    return name.isNotEmpty ? name : 'Toko';
  }

  double get catalogSubtotal => quantity * catalogPricePerUnit;

  double get offerSubtotal => quantity * offerPricePerUnit;

  double get totalSavings => catalogSubtotal - offerSubtotal;

  double get discountPerUnitPercent {
    if (catalogPricePerUnit <= 0) return 0;
    return ((catalogPricePerUnit - offerPricePerUnit) / catalogPricePerUnit) *
        100;
  }

  double get discountTotalPercent {
    if (catalogSubtotal <= 0) return 0;
    return (totalSavings / catalogSubtotal) * 100;
  }

  bool get hasDiscount => offerPricePerUnit < catalogPricePerUnit;

  bool get isHigherThanCatalog => offerPricePerUnit > catalogPricePerUnit;

  bool get isSameAsCatalog =>
      (offerPricePerUnit - catalogPricePerUnit).abs() < 0.01;

  bool get isQuantityValid =>
      quantity >= minOrder && quantity <= stock && stock > 0;
}
