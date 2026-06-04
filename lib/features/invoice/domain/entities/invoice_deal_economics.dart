/// Ringkasan harga, diskon, stok, dan estimasi bersih supplier untuk tagihan negosiasi.
class InvoiceDealEconomics {
  const InvoiceDealEconomics({
    required this.catalogPricePerUnit,
    required this.negotiatedPricePerUnit,
    required this.quantity,
    required this.catalogSubtotal,
    required this.negotiatedSubtotal,
    required this.discountPercentPerUnit,
    required this.discountPercentTotal,
    required this.savingsTotal,
    required this.productStock,
    required this.stockAfterDeal,
    required this.platformFee,
    required this.sellerNetEstimate,
    required this.platformFeePercent,
    required this.unit,
  });

  final double catalogPricePerUnit;
  final double negotiatedPricePerUnit;
  final double quantity;
  final double catalogSubtotal;
  final double negotiatedSubtotal;
  final double discountPercentPerUnit;
  final double discountPercentTotal;
  final double savingsTotal;
  final double productStock;
  final double stockAfterDeal;
  final double platformFee;
  final double sellerNetEstimate;
  final double platformFeePercent;
  final String unit;

  factory InvoiceDealEconomics.fromJson(Map<String, dynamic> json) {
    double n(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;
    return InvoiceDealEconomics(
      catalogPricePerUnit: n(json['catalogPricePerUnit']),
      negotiatedPricePerUnit: n(json['negotiatedPricePerUnit']),
      quantity: n(json['quantity']),
      catalogSubtotal: n(json['catalogSubtotal']),
      negotiatedSubtotal: n(json['negotiatedSubtotal']),
      discountPercentPerUnit: n(json['discountPercentPerUnit']),
      discountPercentTotal: n(json['discountPercentTotal']),
      savingsTotal: n(json['savingsTotal']),
      productStock: n(json['productStock']),
      stockAfterDeal: n(json['stockAfterDeal']),
      platformFee: n(json['platformFee']),
      sellerNetEstimate: n(json['sellerNetEstimate']),
      platformFeePercent: n(json['platformFeePercent']),
      unit: json['unit']?.toString() ?? '',
    );
  }

  bool get hasDiscount => negotiatedPricePerUnit < catalogPricePerUnit;

  bool get isPremiumOverCatalog => negotiatedPricePerUnit > catalogPricePerUnit;

  static InvoiceDealEconomics compute({
    required double catalogPricePerUnit,
    required double negotiatedPricePerUnit,
    required double quantity,
    required double platformFee,
    required double productStock,
    required String unit,
  }) {
    final catalogSubtotal = catalogPricePerUnit * quantity;
    final negotiatedSubtotal = negotiatedPricePerUnit * quantity;
    final savings = catalogSubtotal - negotiatedSubtotal;
    final discountPerUnit = catalogPricePerUnit > 0
        ? ((catalogPricePerUnit - negotiatedPricePerUnit) / catalogPricePerUnit) *
            100
        : 0.0;
    final discountTotal =
        catalogSubtotal > 0 ? (savings / catalogSubtotal) * 100 : 0.0;
    final sellerNet = negotiatedSubtotal - platformFee;
    final feePct =
        negotiatedSubtotal > 0 ? (platformFee / negotiatedSubtotal) * 100 : 0.0;

    return InvoiceDealEconomics(
      catalogPricePerUnit: catalogPricePerUnit,
      negotiatedPricePerUnit: negotiatedPricePerUnit,
      quantity: quantity,
      catalogSubtotal: catalogSubtotal,
      negotiatedSubtotal: negotiatedSubtotal,
      discountPercentPerUnit: discountPerUnit,
      discountPercentTotal: discountTotal,
      savingsTotal: savings,
      productStock: productStock,
      stockAfterDeal: (productStock - quantity).clamp(0, double.infinity),
      platformFee: platformFee,
      sellerNetEstimate: sellerNet,
      platformFeePercent: feePct,
      unit: unit,
    );
  }
}
