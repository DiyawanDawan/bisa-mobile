import '../../injection_container.dart';
import '../../features/marketplace/domain/repositories/marketplace_repository.dart';

/// Dedupes sponsored listing impression/click per app session.
class PromoAnalyticsTracker {
  PromoAnalyticsTracker._();

  static final _impressions = <String>{};
  static final _clicks = <String>{};

  static Future<void> recordImpression(String productId) async {
    if (!_impressions.add(productId)) return;
    await sl<MarketplaceRepository>().recordPromoImpression(productId);
  }

  static Future<void> recordClick(String productId) async {
    if (!_clicks.add(productId)) return;
    await sl<MarketplaceRepository>().recordPromoClick(productId);
  }
}
