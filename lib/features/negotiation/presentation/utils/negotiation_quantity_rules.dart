import '../../../../core/utils/product_pricing.dart';

/// Validasi jumlah penawaran negosiasi terhadap min order & stok.
class NegotiationQuantityRules {
  NegotiationQuantityRules._();

  static bool isOutOfStock(double stock) => stock <= 0;

  static String formatStock(double stock, String unit) {
    return '${ProductPricingInfo.formatQty(stock)} $unit';
  }

  static String? validate({
    required double? quantity,
    required double minOrder,
    required double stock,
    required String unit,
  }) {
    if (quantity == null) return 'Angka tidak valid';
    if (isOutOfStock(stock)) {
      return 'Stok habis. Penawaran jumlah tidak dapat diproses.';
    }
    if (quantity < minOrder) {
      return 'Min. order ${ProductPricingInfo.formatQty(minOrder)} $unit';
    }
    if (quantity > stock) {
      return 'Maks. ${formatStock(stock, unit)} (stok tersedia)';
    }
    return null;
  }
}
