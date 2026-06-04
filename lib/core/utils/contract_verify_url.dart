import '../config/app_config.dart';

/// URL publik verifikasi kontrak (web admin / landing).
abstract class ContractVerifyUrl {
  static String baseUrl() {
    final fromEnv = AppConfig.publicWebUrl.trim();
    if (fromEnv.isNotEmpty) return fromEnv.replaceAll(RegExp(r'/+$'), '');
    return 'http://localhost:3001';
  }

  static String verify(String orderNumber) {
    final encoded = Uri.encodeComponent(orderNumber.trim());
    return '${baseUrl()}/verify/$encoded';
  }

  static String track(String orderNumber) {
    final encoded = Uri.encodeComponent(orderNumber.trim());
    return '${baseUrl()}/track/$encoded';
  }

  /// Mendukung QR lama `nomor:status:ts` dan URL `/verify/...`.
  static String parseOrderNumber(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return trimmed;

    final verifyIdx = trimmed.indexOf('/verify/');
    if (verifyIdx >= 0) {
      final tail = trimmed.substring(verifyIdx + '/verify/'.length);
      return tail.split('/').first.split('?').first.trim();
    }

    final trackIdx = trimmed.indexOf('/track/');
    if (trackIdx >= 0) {
      final tail = trimmed.substring(trackIdx + '/track/'.length);
      return tail.split('/').first.split('?').first.trim();
    }

    if (trimmed.contains(':')) {
      return trimmed.split(':').first.trim();
    }

    return trimmed;
  }
}
