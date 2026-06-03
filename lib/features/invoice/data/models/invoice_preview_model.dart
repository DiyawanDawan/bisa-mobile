import 'package:freezed_annotation/freezed_annotation.dart';
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

  InvoicePreviewEntity toEntity() => InvoicePreviewEntity(
        negotiationId: negotiationId,
        productId: product.id,
        productName: product.name,
        productUnit: product.unit,
        productThumbnailUrl: product.thumbnailUrl,
        buyerId: buyer.id,
        buyerName: buyer.name,
        buyerCompanyName: buyer.profile?.companyName,
        quantity: _parseNum(quantity),
        pricePerUnit: _parseNum(pricePerUnit),
        subtotal: _parseNum(subtotal),
        platformFee: _parseNum(platformFee),
        logisticsFee: _parseNum(logisticsFee),
        vatAmount: _parseNum(vatAmount),
        totalAmount: _parseNum(totalAmount),
        specifications: specifications,
        shippingSnapshot: shippingSnapshot,
      );
}

@freezed
abstract class InvoicePreviewProductModel with _$InvoicePreviewProductModel {
  const factory InvoicePreviewProductModel({
    required String id,
    required String name,
    required String unit,
    String? thumbnailUrl,
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
