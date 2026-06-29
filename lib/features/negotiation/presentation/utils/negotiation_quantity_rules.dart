import 'package:easy_localization/easy_localization.dart';

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
    if (quantity == null) return 'negotiation.qty_number_invalid'.tr();
    if (isOutOfStock(stock)) {
      return 'negotiation.qty_stock_blocked'.tr();
    }
    if (quantity < minOrder) {
      return 'negotiation.min_order_hint'.tr(namedArgs: {
        'qty': ProductPricingInfo.formatQty(minOrder),
        'unit': unit,
      });
    }
    if (quantity > stock) {
      return 'negotiation.qty_max_available'.tr(namedArgs: {
        'stock': formatStock(stock, unit),
      });
    }
    return null;
  }
}
