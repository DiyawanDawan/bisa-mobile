import 'package:mobile_bisa/core/config/app_config.dart';

/// Konfigurasi host publik untuk URL media (gambar R2 via proxy API).
abstract class MediaConfig {
  /// Origin tanpa `/api/v1`, mis. `https://cdn.bisaagri.com` atau API host
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
    return raw.replaceAll(RegExp(r'/+$'), '').replaceAll(RegExp(r'/api/v1$', caseSensitive: false), '');
  }

  static const storageAssetsPrefix = '/api/v1/storage/assets/';

  /// R2 custom domain (cdn.*) — path langsung ke CDN tanpa proxy API.
  static bool get useDirectCdn {
    final base = mediaBaseUrl.toLowerCase();
    if (base.isEmpty) return false;
    return base.contains('cdn.') ||
        const bool.fromEnvironment('MEDIA_CDN_DIRECT', defaultValue: false);
  }
}
