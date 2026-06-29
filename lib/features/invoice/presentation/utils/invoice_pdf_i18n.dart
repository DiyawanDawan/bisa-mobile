import 'package:easy_localization/easy_localization.dart';

import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/utils/order_status_i18n.dart';
import '../../domain/entities/invoice_pdf_data.dart';

const _legacyPreviewStatus = 'Preview — Belum Diterbitkan';
const _legacyProductDefault = 'Produk B2B';

InvoicePdfData localizeInvoicePdfData(
  InvoicePdfData data, {
  bool isPreview = false,
  OrderEntity? order,
}) {
  final statusLabel = isPreview
      ? 'invoice.pdf_status_preview'.tr()
      : (order != null
          ? _orderPdfStatusLabel(order)
          : _localizeLegacyStatus(data.statusLabel));

  final productName = data.productName == _legacyProductDefault
      ? 'invoice.pdf_product_default'.tr()
      : data.productName;

  return InvoicePdfData(
    invoiceNumber: data.invoiceNumber,
    statusLabel: statusLabel,
    supplierName: data.supplierName,
    supplierEmail: data.supplierEmail,
    buyerName: data.buyerName,
    buyerEmail: data.buyerEmail,
    buyerCompany: data.buyerCompany,
    productName: productName,
    productUnit: data.productUnit,
    quantity: data.quantity,
    pricePerUnit: data.pricePerUnit,
    subtotal: data.subtotal,
    platformFee: data.platformFee,
    logisticsFee: data.logisticsFee,
    vatAmount: data.vatAmount,
    totalAmount: data.totalAmount,
    specifications: data.specifications,
    shippingSnapshot: data.shippingSnapshot,
    sellerShippingSnapshot: data.sellerShippingSnapshot,
    sellerOriginLabel: data.sellerOriginLabel,
    orderShipping: data.orderShipping,
    issuedAt: data.issuedAt,
    qrData: data.qrData,
  );
}

String _orderPdfStatusLabel(OrderEntity order) {
  final pay = order.transaction?.paymentStatus;
  if (pay != null && pay.trim().isNotEmpty) {
    return orderPaymentStatusLabel(pay);
  }
  return orderStatusLabel(order.status);
}

String? _localizeLegacyStatus(String? statusLabel) {
  if (statusLabel == null || statusLabel.isEmpty) return statusLabel;
  if (statusLabel == _legacyPreviewStatus) {
    return 'invoice.pdf_status_preview'.tr();
  }
  const legacyPayment = {
    'Pembayaran Lunas': 'orders.payment.paid',
    'Menunggu Pembayaran': 'orders.payment.pending',
    'Pembayaran Gagal': 'orders.payment.failed',
    'Pembayaran Kedaluwarsa': 'orders.payment.expired',
    'Dana Dikembalikan': 'orders.payment.refunded',
  };
  final paymentKey = legacyPayment[statusLabel];
  if (paymentKey != null) return paymentKey.tr();

  const legacyOrder = {
    'Diproses': 'orders.status.processing',
    'Dikirim': 'orders.status.shipped',
    'Selesai': 'orders.status.completed',
    'Dibatalkan': 'orders.status.cancelled',
  };
  final orderKey = legacyOrder[statusLabel];
  if (orderKey != null) return orderKey.tr();

  return statusLabel;
}
