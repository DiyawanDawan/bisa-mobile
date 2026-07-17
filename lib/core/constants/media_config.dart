import 'package:mobile_bisa/core/config/app_config.dart';

/// Konfigurasi host publik untuk URL media R2 (CDN custom domain).
abstract class MediaConfig {
  /// Origin CDN tanpa `/api/v1`, mis. `https://cdn.bisaagri.com`
  static String get mediaBaseUrl {
    final explicit = AppConfig.effectiveMediaBaseUrl.trim();
    if (explicit.isNotEmpty) {
      return _stripApiSuffix(explicit);
    }

    final apiUrl = AppConfig.effectiveApiUrl.trim();
    if (apiUrl.isNotEmpty) {
      return _stripApiSuffix(apiUrl);
    }

    return '';
  }

  static String _stripApiSuffix(String raw) {
    return raw
        .replaceAll(RegExp(r'/+$'), '')
        .replaceAll(RegExp(r'/api/v1$', caseSensitive: false), '');
  }
}
