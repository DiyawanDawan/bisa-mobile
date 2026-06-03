import 'order_entity.dart';

/// Detail checkout multi-supplier dari API GET /orders/:id/batch.
class CheckoutBatchDetailEntity {
  const CheckoutBatchDetailEntity({
    required this.checkoutBatchId,
    this.checkoutBatchNumber,
    required this.batchTotalAmount,
    this.shippingAddressSnapshot,
    required this.createdAt,
    required this.supplierCount,
    required this.orders,
  });

  final String checkoutBatchId;
  final String? checkoutBatchNumber;
  final double batchTotalAmount;
  final Map<String, dynamic>? shippingAddressSnapshot;
  final DateTime createdAt;
  final int supplierCount;
  final List<OrderEntity> orders;

  String get displayOrderNumber {
    final batch = checkoutBatchNumber?.trim();
    if (batch != null && batch.isNotEmpty) return batch;
    if (orders.length == 1) return orders.first.orderNumber;
    return checkoutBatchId;
  }
}
