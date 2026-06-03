import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/entities/invoice_draft.dart';
import '../../domain/entities/invoice_preview_entity.dart';

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
  final Map<String, dynamic>? shippingSnapshot;
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
    required this.issuedAt,
    this.qrData,
  });

  factory InvoicePdfData.fromPreview(
    InvoicePreviewEntity preview, {
    required String supplierName,
  }) {
    return InvoicePdfData(
      invoiceNumber: 'DRAFT-${preview.negotiationId.substring(0, 8).toUpperCase()}',
      statusLabel: 'Preview — Belum Diterbitkan',
      supplierName: supplierName,
      buyerName: preview.buyerName,
      buyerCompany: preview.buyerCompanyName,
      productName: preview.productName,
      productUnit: preview.productUnit,
      quantity: preview.quantity,
      pricePerUnit: preview.pricePerUnit,
      subtotal: preview.subtotal,
      platformFee: preview.platformFee,
      logisticsFee: preview.logisticsFee,
      vatAmount: preview.vatAmount,
      totalAmount: preview.totalAmount,
      specifications: preview.specifications,
      shippingSnapshot: preview.shippingSnapshot,
      issuedAt: DateTime.now(),
    );
  }

  factory InvoicePdfData.fromOrder(OrderEntity order) {
    final product = order.items.isNotEmpty ? order.items.first : null;
    return InvoicePdfData(
      invoiceNumber: order.orderNumber,
      statusLabel: _invoiceStatusLabel(order),
      supplierName: order.seller.name,
      supplierEmail: order.seller.email,
      buyerName: order.buyer.name,
      buyerEmail: order.buyer.email,
      productName: product?.productName ?? 'Produk B2B',
      productUnit: 'unit',
      quantity: product?.quantity ?? order.totalQuantity,
      pricePerUnit: product?.pricePerUnit ?? 0,
      subtotal: order.subtotal,
      platformFee: order.platformFee,
      logisticsFee: order.logisticsFee,
      vatAmount: order.vatAmount,
      totalAmount: order.totalAmount,
      specifications: order.specifications,
      shippingSnapshot: order.shippingAddressSnapshot,
      issuedAt: order.createdAt,
      qrData:
          '${order.orderNumber}:${order.status}:${order.createdAt.millisecondsSinceEpoch}',
    );
  }

  factory InvoicePdfData.fromOrderDraft(OrderEntity order, InvoiceDraft draft) {
    final base = InvoicePdfData.fromOrder(order);
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
      shippingSnapshot: draft.toShippingSnapshot(),
      issuedAt: base.issuedAt,
      qrData: base.qrData,
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
