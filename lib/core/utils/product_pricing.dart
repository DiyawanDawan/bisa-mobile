import 'money_format.dart';

/// Aturan harga produk BISA (MVP):
///
/// - [pricePerUnit] = harga jual **per 1 unit** (KG/TON) — dipakai di checkout.
/// - [originalPrice] = harga coret **per 1 unit** (hanya tampilan promo).
/// - [minOrder] = minimal qty pembelian — **bukan** trigger diskon bertingkat.
///
/// Total order = qty × pricePerUnit (tarif sama untuk semua qty).
/// Diskon % = (originalPrice - pricePerUnit) / originalPrice — per unit, tidak stack.
class ProductPricingInfo {
  final double pricePerUnit;
  final double? originalPrice;
  final double minOrder;
  final String unit;

  const ProductPricingInfo({
    required this.pricePerUnit,
    this.originalPrice,
    required this.minOrder,
    required this.unit,
  });

  factory ProductPricingInfo.fromProduct({
    required double pricePerUnit,
    double? originalPrice,
    required double minOrder,
    required String unit,
  }) {
    return ProductPricingInfo(
      pricePerUnit: pricePerUnit,
      originalPrice: originalPrice,
      minOrder: minOrder,
      unit: unit,
    );
  }

  /// Promo aktif jika harga coret > harga jual (keduanya per unit).
  bool get hasPromo =>
      originalPrice != null && originalPrice! > pricePerUnit;

  int? get discountPercent {
    if (!hasPromo) return null;
    return (((originalPrice! - pricePerUnit) / originalPrice!) * 100).round();
  }

  double get savingsPerUnit =>
      hasPromo ? originalPrice! - pricePerUnit : 0;

  /// Total bayar = qty × harga jual per unit (tarif flat, tidak diskon bertingkat).
  double totalForQuantity(double quantity) => quantity * pricePerUnit;

  double totalSavingsForQuantity(double quantity) => savingsPerUnit * quantity;

  String get priceLabel => '${formatMoneyDisplay(pricePerUnit)} / $unit';

  String get promoRuleSummary =>
      'Diskon promo berlaku per $unit. Total = jumlah × harga jual. '
      'Min. order ${formatQty(minOrder)} $unit (bukan syarat diskon tambahan).';

  String exampleForQuantity(double quantity) {
    final q = formatQty(quantity);
    final total = totalForQuantity(quantity);
    if (!hasPromo) {
      return 'Contoh: $q $unit × ${formatMoneyDisplay(pricePerUnit)} = ${formatMoneyDisplay(total)}';
    }
    final pct = discountPercent;
    return 'Contoh: $q $unit × ${formatMoneyDisplay(pricePerUnit)} = ${formatMoneyDisplay(total)}'
        '${pct != null ? ' (hemat ~${pct}% per $unit, bukan diskon ganda)' : ''}';
  }

  static String formatQty(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}
