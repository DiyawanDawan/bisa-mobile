class PurchasedProductItem {
  final String productId;
  final String productName;
  final String? thumbnailUrl;
  final double totalQuantity;
  final DateTime lastOrderDate;
  final String lastOrderId;

  const PurchasedProductItem({
    required this.productId,
    required this.productName,
    this.thumbnailUrl,
    required this.totalQuantity,
    required this.lastOrderDate,
    required this.lastOrderId,
  });
}
