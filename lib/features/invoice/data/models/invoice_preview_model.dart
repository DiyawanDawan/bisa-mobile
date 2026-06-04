import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/invoice_deal_economics.dart';
import '../../domain/entities/invoice_preview_entity.dart';

part 'invoice_preview_model.freezed.dart';
part 'invoice_preview_model.g.dart';

double _parseNum(dynamic value) =>
    double.tryParse(value?.toString() ?? '') ?? 0;

@freezed
abstract class InvoicePreviewModel with _$InvoicePreviewModel {
  const factory InvoicePreviewModel({
    required String negotiationId,
    required InvoicePreviewProductModel product,
    required InvoicePreviewBuyerModel buyer,
    required dynamic quantity,
    required dynamic pricePerUnit,
    required dynamic subtotal,
    required dynamic platformFee,
    @JsonKey(name: 'logisticsFee') dynamic logisticsFee,
    required dynamic vatAmount,
    required dynamic totalAmount,
    String? specifications,
    @JsonKey(name: 'buyerShippingSnapshot')
    Map<String, dynamic>? shippingSnapshot,
  }) = _InvoicePreviewModel;

  factory InvoicePreviewModel.fromJson(Map<String, dynamic> json) =>
      _$InvoicePreviewModelFromJson(json);

  const InvoicePreviewModel._();

  InvoicePreviewEntity toEntity({Map<String, dynamic>? raw}) {
    final qty = _parseNum(quantity);
    final negoUnit = _parseNum(pricePerUnit);
    final fee = _parseNum(platformFee);
    InvoiceDealEconomics? economics;
    final economicsJson = raw?['economics'];
    if (economicsJson is Map<String, dynamic>) {
      economics = InvoiceDealEconomics.fromJson(economicsJson);
    } else {
      economics = InvoiceDealEconomics.compute(
        catalogPricePerUnit: _parseNum(product.pricePerUnit),
        negotiatedPricePerUnit: negoUnit,
        quantity: qty,
        platformFee: fee,
        productStock: _parseNum(product.stock),
        unit: product.unit,
      );
    }

    return InvoicePreviewEntity(
      negotiationId: negotiationId,
      productId: product.id,
      productName: product.name,
      productUnit: product.unit,
      productThumbnailUrl: product.thumbnailUrl,
      buyerId: buyer.id,
      buyerName: buyer.name,
      buyerCompanyName: buyer.profile?.companyName,
      quantity: qty,
      pricePerUnit: negoUnit,
      subtotal: _parseNum(subtotal),
      platformFee: fee,
      logisticsFee: _parseNum(logisticsFee),
      vatAmount: _parseNum(vatAmount),
      totalAmount: _parseNum(totalAmount),
      specifications: specifications,
      shippingSnapshot: shippingSnapshot,
      sellerShippingSnapshot: _parseSellerShipping(raw),
      sellerOriginId: _parseSellerOriginId(raw),
      sellerOriginLabel: _parseSellerOriginLabel(raw),
      sellerOriginResolvedFrom: _parseSellerOriginResolvedFrom(raw),
      economics: economics,
    );
  }

  static Map<String, dynamic>? _parseSellerShipping(Map<String, dynamic>? raw) {
    final ship = raw?['sellerShipping'];
    if (ship is! Map) return null;
    final snap = ship['snapshot'];
    if (snap is Map<String, dynamic>) return snap;
    if (snap is Map) return Map<String, dynamic>.from(snap);
    return null;
  }

  static int? _parseSellerOriginId(Map<String, dynamic>? raw) {
    final ship = raw?['sellerShipping'];
    if (ship is! Map) return null;
    return int.tryParse(ship['originId']?.toString() ?? '');
  }

  static String? _parseSellerOriginLabel(Map<String, dynamic>? raw) {
    final ship = raw?['sellerShipping'];
    if (ship is! Map) return null;
    return ship['originLabel']?.toString();
  }

  static String? _parseSellerOriginResolvedFrom(Map<String, dynamic>? raw) {
    final ship = raw?['sellerShipping'];
    if (ship is! Map) return null;
    return ship['resolvedFrom']?.toString();
  }
}

@freezed
abstract class InvoicePreviewProductModel with _$InvoicePreviewProductModel {
  const factory InvoicePreviewProductModel({
    required String id,
    required String name,
    required String unit,
    String? thumbnailUrl,
    @Default(0) dynamic pricePerUnit,
    @Default(0) dynamic stock,
    @Default(1) dynamic minOrder,
  }) = _InvoicePreviewProductModel;

  factory InvoicePreviewProductModel.fromJson(Map<String, dynamic> json) =>
      _$InvoicePreviewProductModelFromJson(json);
}

@freezed
abstract class InvoicePreviewBuyerModel with _$InvoicePreviewBuyerModel {
  const factory InvoicePreviewBuyerModel({
    required String id,
    @JsonKey(name: 'fullName') required String name,
    InvoicePreviewBuyerProfileModel? profile,
  }) = _InvoicePreviewBuyerModel;

  factory InvoicePreviewBuyerModel.fromJson(Map<String, dynamic> json) =>
      _$InvoicePreviewBuyerModelFromJson(json);
}

@freezed
abstract class InvoicePreviewBuyerProfileModel
    with _$InvoicePreviewBuyerProfileModel {
  const factory InvoicePreviewBuyerProfileModel({
    String? companyName,
  }) = _InvoicePreviewBuyerProfileModel;

  factory InvoicePreviewBuyerProfileModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$InvoicePreviewBuyerProfileModelFromJson(json);
}
