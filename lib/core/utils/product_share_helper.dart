import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/marketplace/domain/entities/product_entity.dart';
import 'contract_verify_url.dart';
import 'money_format.dart';

/// Bagikan produk/toko lewat sheet native (WhatsApp, Telegram, dll).
abstract class ProductShareHelper {
  static String productUrl(String productId) {
    final encoded = Uri.encodeComponent(productId.trim());
    return '${ContractVerifyUrl.baseUrl()}/product/$encoded';
  }

  static String supplierUrl(String supplierId) {
    final encoded = Uri.encodeComponent(supplierId.trim());
    return '${ContractVerifyUrl.baseUrl()}/supplier/$encoded';
  }

  static String buildProductShareText(ProductEntity product) {
    final seller =
        (product.seller.companyName?.trim().isNotEmpty == true)
            ? product.seller.companyName!
            : product.seller.name;

    return 'marketplace.share_product'.tr(namedArgs: {
      'name': product.name,
      'price': formatMoneyDisplay(product.pricePerUnit),
      'unit': product.unit,
      'seller': seller,
      'url': productUrl(product.id),
    });
  }

  static Future<void> shareProduct(ProductEntity product) async {
    await Share.share(
      buildProductShareText(product),
      subject: product.name,
    );
  }

  static Future<void> shareSupplier({
    required String supplierId,
    required String supplierName,
    String? companyName,
  }) async {
    final displayName =
        (companyName?.trim().isNotEmpty == true) ? companyName! : supplierName;

    await Share.share(
      'marketplace.share_supplier'.tr(namedArgs: {
        'name': displayName,
        'url': supplierUrl(supplierId),
      }),
      subject: displayName,
    );
  }
}
