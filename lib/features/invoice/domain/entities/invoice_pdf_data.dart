import '../../../../core/utils/contract_verify_url.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/entities/invoice_draft.dart';
import '../../domain/entities/invoice_preview_entity.dart';

String _verifyQrUrl(String orderNumber) => ContractVerifyUrl.verify(orderNumber);

class InvoicePdfData {
  final String invoiceNumber;
  final String? statusLabel;
  final String supplierName;
  final String? supplierEmail;
  final String buyerName;
  final String? buyerEmail;
  final String? buyerCompany;
  final String productName;
  final String productUnit;
  final double quantity;
  final double pricePerUnit;
  final double subtotal;
  final double platformFee;
  final double logisticsFee;
  final double vatAmount;
  final double totalAmount;
  final String? specifications;
  /// Alamat tujuan pembeli (+ logistics / sellerOrigin jika dari order).
  final Map<String, dynamic>? shippingSnapshot;
  /// Alamat asal toko/supplier (preview atau disalin ke snapshot order).
  final Map<String, dynamic>? sellerShippingSnapshot;
  final String? sellerOriginLabel;
  final OrderShippingEntity? orderShipping;
  final DateTime issuedAt;
  final String? qrData;

  const InvoicePdfData({
    required this.invoiceNumber,
    this.statusLabel,
    required this.supplierName,
    this.supplierEmail,
    required this.buyerName,
    this.buyerEmail,
    this.buyerCompany,
    required this.productName,
    required this.productUnit,
    required this.quantity,
    required this.pricePerUnit,
    required this.subtotal,
    required this.platformFee,
    this.logisticsFee = 0,
    required this.vatAmount,
    required this.totalAmount,
    this.specifications,
    this.shippingSnapshot,
    this.sellerShippingSnapshot,
    this.sellerOriginLabel,
    this.orderShipping,
    required this.issuedAt,
    this.qrData,
  });

  static String displayUnit(String? unit) {
    final trimmed = unit?.trim() ?? '';
    if (trimmed.isEmpty) return 'unit';
    return trimmed.toUpperCase();
  }

  static Map<String, dynamic>? originFromSnapshot(Map<String, dynamic>? snap) {
    if (snap == null) return null;
    final origin = snap['sellerOrigin'];
    if (origin is Map) {
      return Map<String, dynamic>.from(origin);
    }
    return null;
  }

  static String? originLabelFromSnapshot(Map<String, dynamic>? snap) {
    final label = snap?['sellerOriginLabel']?.toString().trim();
    return label != null && label.isNotEmpty ? label : null;
  }

  factory InvoicePdfData.fromPreview(
    InvoicePreviewEntity preview, {
    required String supplierName,
    Map<String, dynamic>? sellerShippingSnapshot,
    String? sellerOriginLabel,
    Map<String, dynamic>? shippingSelection,
  }) {
    return InvoicePdfData(
      invoiceNumber: 'DRAFT-${preview.negotiationId.substring(0, 8).toUpperCase()}',
      statusLabel: 'Preview — Belum Diterbitkan',
      supplierName: supplierName,
      buyerName: preview.buyerName,
      buyerCompany: preview.buyerCompanyName,
      productName: preview.productName,
      productUnit: displayUnit(preview.productUnit),
      quantity: preview.quantity,
      pricePerUnit: preview.pricePerUnit,
      subtotal: preview.subtotal,
      platformFee: preview.platformFee,
      logisticsFee: preview.logisticsFee,
      vatAmount: preview.vatAmount,
      totalAmount: preview.totalAmount,
      specifications: preview.specifications,
      shippingSnapshot: preview.shippingSnapshot,
      sellerShippingSnapshot:
          sellerShippingSnapshot ?? preview.sellerShippingSnapshot,
      sellerOriginLabel: sellerOriginLabel ?? preview.sellerOriginLabel,
      orderShipping: shippingSelection != null
          ? _orderShippingFromSelection(shippingSelection)
          : null,
      issuedAt: DateTime.now(),
      qrData:
          'DRAFT-${preview.negotiationId}:PREVIEW:${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  factory InvoicePdfData.fromOrder(OrderEntity order) {
    final product = order.items.isNotEmpty ? order.items.first : null;
    final snap = order.shippingAddressSnapshot;
    return InvoicePdfData(
      invoiceNumber: order.orderNumber,
      statusLabel: _invoiceStatusLabel(order),
      supplierName: order.seller.name,
      supplierEmail: order.seller.email,
      buyerName: order.buyer.name,
      buyerEmail: order.buyer.email,
      productName: product?.productName ?? 'Produk B2B',
      productUnit: displayUnit(product?.productUnit),
      quantity: product?.quantity ?? order.totalQuantity,
      pricePerUnit: product?.pricePerUnit ?? 0,
      subtotal: order.subtotal,
      platformFee: order.platformFee,
      logisticsFee: order.logisticsFee,
      vatAmount: order.vatAmount,
      totalAmount: order.totalAmount,
      specifications: order.specifications,
      shippingSnapshot: snap,
      sellerShippingSnapshot: originFromSnapshot(snap),
      sellerOriginLabel:
          originLabelFromSnapshot(snap) ?? order.orderShipping?.originLabel,
      orderShipping: order.orderShipping,
      issuedAt: order.createdAt,
      qrData: _verifyQrUrl(order.orderNumber),
    );
  }

  factory InvoicePdfData.fromOrderDraft(OrderEntity order, InvoiceDraft draft) {
    final base = InvoicePdfData.fromOrder(order);
    final orderSnap = order.shippingAddressSnapshot ?? {};
    final draftSnap = draft.toShippingSnapshot();
    return InvoicePdfData(
      invoiceNumber: base.invoiceNumber,
      statusLabel: base.statusLabel,
      supplierName: base.supplierName,
      supplierEmail: base.supplierEmail,
      buyerName: base.buyerName,
      buyerEmail: base.buyerEmail,
      productName: base.productName,
      productUnit: base.productUnit,
      quantity: base.quantity,
      pricePerUnit: base.pricePerUnit,
      subtotal: base.subtotal,
      platformFee: base.platformFee,
      logisticsFee: base.logisticsFee,
      vatAmount: base.vatAmount,
      totalAmount: base.totalAmount,
      specifications: draft.specifications.trim().isEmpty
          ? null
          : draft.specifications.trim(),
      shippingSnapshot: {
        ...draftSnap,
        if (orderSnap['logistics'] != null) 'logistics': orderSnap['logistics'],
        if (orderSnap['sellerOrigin'] != null)
          'sellerOrigin': orderSnap['sellerOrigin'],
        if (orderSnap['sellerOriginLabel'] != null)
          'sellerOriginLabel': orderSnap['sellerOriginLabel'],
      },
      sellerShippingSnapshot: base.sellerShippingSnapshot,
      sellerOriginLabel: base.sellerOriginLabel,
      orderShipping: base.orderShipping,
      issuedAt: base.issuedAt,
      qrData: base.qrData,
    );
  }

  static OrderShippingEntity? _orderShippingFromSelection(
    Map<String, dynamic> selection,
  ) {
    final courier = selection['courierCode']?.toString();
    if (courier == null || courier.isEmpty) return null;
    return OrderShippingEntity(
      originLabel: selection['originLabel']?.toString(),
      destinationLabel: selection['destinationLabel']?.toString(),
      courierCode: courier,
      courierName: selection['courierName']?.toString(),
      serviceCode: selection['serviceCode']?.toString(),
      serviceName: selection['serviceName']?.toString(),
      serviceDescription: selection['verifiedDescription']?.toString(),
      shippingCost: double.tryParse(selection['cost']?.toString() ?? ''),
      etd: selection['etd']?.toString(),
    );
  }

  static String _invoiceStatusLabel(OrderEntity order) {
    final pay = order.transaction?.paymentStatus?.toUpperCase();
    if (pay == 'SUCCESS') return 'Pembayaran Lunas';
    if (pay == 'PENDING') return 'Menunggu Pembayaran';
    if (pay == 'FAILED') return 'Pembayaran Gagal';
    if (pay == 'EXPIRED') return 'Pembayaran Kedaluwarsa';
    if (pay == 'REFUNDED') return 'Dana Dikembalikan';
    return _orderStatusLabel(order.status);
  }

  static String _orderStatusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Menunggu Pembayaran';
      case 'CONFIRMED':
      case 'PROCESSING':
        return 'Diproses';
      case 'SHIPPED':
        return 'Dikirim';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}
