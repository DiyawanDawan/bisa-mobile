import 'package:easy_localization/easy_localization.dart';

/// Localized order status labels for badges, filters, and analytics.
String orderStatusLabel(String status) {
  switch (status.toUpperCase()) {
    case 'ALL':
      return 'orders.status.all'.tr();
    case 'PENDING':
      return 'orders.status.pending'.tr();
    case 'CONFIRMED':
      return 'orders.status.confirmed'.tr();
    case 'PAID':
    case 'PROCESSING':
      return 'orders.status.processing'.tr();
    case 'SHIPPED':
      return 'orders.status.shipped'.tr();
    case 'COMPLETED':
      return 'orders.status.completed'.tr();
    case 'CANCELLED':
      return 'orders.status.cancelled'.tr();
    case 'DISPUTED':
      return 'orders.status.disputed'.tr();
    case 'REFUNDED':
      return 'orders.status.refunded'.tr();
    case 'EXPIRED':
      return 'orders.status.expired'.tr();
    default:
      return status;
  }
}

String orderPaymentStatusLabel(String? status) {
  switch (status?.toUpperCase()) {
    case 'SUCCESS':
      return 'orders.payment.paid'.tr();
    case 'PENDING':
      return 'orders.payment.pending'.tr();
    case 'FAILED':
      return 'orders.payment.failed'.tr();
    case 'EXPIRED':
      return 'orders.payment.expired'.tr();
    case 'REFUNDED':
      return 'orders.payment.refunded'.tr();
    default:
      return 'orders.payment.not_initialized'.tr();
  }
}

String orderEscrowStatusLabel(String? status) {
  switch (status?.toUpperCase()) {
    case 'ESCROW_HELD':
      return 'orders.escrow.held'.tr();
    case 'RELEASED':
      return 'orders.escrow.released'.tr();
    case 'PENDING':
      return 'orders.escrow.pending'.tr();
    case 'REFUNDED':
      return 'orders.escrow.refunded'.tr();
    default:
      return status ?? '—';
  }
}

List<Map<String, String>> orderStatusFilters() => [
      {'label': 'orders.status.all'.tr(), 'value': 'ALL'},
      {'label': 'orders.status.pending'.tr(), 'value': 'PENDING'},
      {'label': 'orders.status.processing'.tr(), 'value': 'PROCESSING'},
      {'label': 'orders.status.shipped'.tr(), 'value': 'SHIPPED'},
      {'label': 'orders.status.completed'.tr(), 'value': 'COMPLETED'},
      {'label': 'orders.status.cancelled'.tr(), 'value': 'CANCELLED'},
      {'label': 'orders.status.disputed'.tr(), 'value': 'DISPUTED'},
      {'label': 'orders.status.refunded'.tr(), 'value': 'REFUNDED'},
    ];
