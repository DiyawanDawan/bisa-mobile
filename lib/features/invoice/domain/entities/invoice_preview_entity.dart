import 'package:freezed_annotation/freezed_annotation.dart';
import 'invoice_deal_economics.dart';

part 'invoice_preview_entity.freezed.dart';

@freezed
abstract class InvoicePreviewEntity with _$InvoicePreviewEntity {
  const factory InvoicePreviewEntity({
    required String negotiationId,
    required String productId,
    required String productName,
    required String productUnit,
    String? productThumbnailUrl,
    required String buyerId,
    required String buyerName,
    String? buyerCompanyName,
    required double quantity,
    required double pricePerUnit,
    required double subtotal,
    required double platformFee,
    @Default(0) double logisticsFee,
    required double vatAmount,
    required double totalAmount,
    String? specifications,
    Map<String, dynamic>? shippingSnapshot,
    Map<String, dynamic>? sellerShippingSnapshot,
    int? sellerOriginId,
    String? sellerOriginLabel,
    String? sellerOriginResolvedFrom,
    InvoiceDealEconomics? economics,
  }) = _InvoicePreviewEntity;
}
