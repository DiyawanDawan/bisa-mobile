import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Telemetry ringan untuk request kritikal tanpa dependency analytics tambahan.
///
/// Fokus endpoint:
/// - checkout order direct
/// - inisialisasi pembayaran
/// - shipping (origin/destination/cost/tracking)
class RequestTelemetry {
  static final Map<String, int> _successCount = {};
  static final Map<String, int> _errorCount = {};

  static String? _criticalKey(RequestOptions options) {
    final method = options.method.toUpperCase();
    final path = options.path;

    if (method == 'POST' && path == '/orders/direct') return 'orders.direct.create';
    if (method == 'POST' && RegExp(r'^/orders/[^/]+/pay$').hasMatch(path)) {
      return 'orders.payment.initialize';
    }
    if (method == 'GET' && path == '/shipping/origin') return 'shipping.origin.get';
    if (method == 'GET' && path == '/shipping/destinations') return 'shipping.destination.search';
    if (method == 'POST' && path == '/shipping/calculate-domestic') {
      return 'shipping.cost.calculate';
    }
    if (method == 'POST' && path == '/shipping/track') return 'shipping.track.sync';

    return null;
  }

  static void onSuccess(Response<dynamic> response) {
    final key = _criticalKey(response.requestOptions);
    if (key == null) return;
    _successCount[key] = (_successCount[key] ?? 0) + 1;
    _log('ok', key, response.statusCode);
  }

  static void onError(DioException error) {
    final key = _criticalKey(error.requestOptions);
    if (key == null) return;
    _errorCount[key] = (_errorCount[key] ?? 0) + 1;
    _log('err', key, error.response?.statusCode);
  }

  static void _log(String tag, String key, int? statusCode) {
    if (!kDebugMode) return;
    final ok = _successCount[key] ?? 0;
    final err = _errorCount[key] ?? 0;
    debugPrint('[Telemetry][$tag] $key status=${statusCode ?? '-'} ok=$ok err=$err');
  }
}
