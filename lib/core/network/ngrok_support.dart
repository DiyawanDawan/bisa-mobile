/// Helpers untuk ngrok free tier (interstitial HTML + upstream offline).
abstract final class NgrokSupport {
  static bool isNgrokHost(String url) =>
      url.contains('ngrok-free.app') ||
      url.contains('ngrok-free.dev') ||
      url.contains('.ngrok.io') ||
      url.contains('.ngrok.app');

  static Map<String, String> requestHeaders(String baseUrl) {
    if (!isNgrokHost(baseUrl)) return const {};
    return const {'ngrok-skip-browser-warning': 'true'};
  }

  /// Ngrok mengembalikan HTML/teks (sering HTTP 400) saat upstream mati.
  static bool isNgrokErrorBody(Object? data) {
    if (data is! String) return false;
    final body = data.toLowerCase();
    return body.contains('err_ngrok') ||
        body.contains('ngrok.com/docs/errors') ||
        (body.contains('ngrok') && body.contains('upstream'));
  }

  static String errorMessageKey(Object? data) {
    if (data is String && data.contains('ERR_NGROK_8012')) {
      return 'errors.ngrok_backend_down';
    }
    if (data is String && data.contains('browser-warning')) {
      return 'errors.ngrok_browser_warning';
    }
    return 'errors.ngrok_unreachable';
  }
}
