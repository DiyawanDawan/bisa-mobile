import 'package:mobile_bisa/core/config/app_config.dart';

/// Konfigurasi host publik untuk URL media (gambar R2 via proxy API).
abstract class MediaConfig {
  /// Origin tanpa `/api/v1`, mis. `https://xxx.ngrok-free.dev`
  static String get mediaBaseUrl {
    final explicit = AppConfig.mediaBaseUrl.trim();
    if (explicit.isNotEmpty) {
      return _stripApiSuffix(explicit);
    }

    final apiUrl = AppConfig.apiUrl.trim();
    if (apiUrl.isNotEmpty) {
      return _stripApiSuffix(apiUrl);
    }

    return '';
  }

  static String _stripApiSuffix(String raw) {
    return raw.replaceAll(RegExp(r'/+$'), '').replaceAll(RegExp(r'/api/v1$', caseSensitive: false), '');
  }

  static const storageAssetsPrefix = '/api/v1/storage/assets/';
}
