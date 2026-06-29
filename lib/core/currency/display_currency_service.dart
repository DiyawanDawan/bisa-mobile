import 'package:shared_preferences/shared_preferences.dart';
import '../../injection_container.dart';
import 'package:dio/dio.dart';

/// FB-19 — Kurs tampilan (checkout tetap IDR).
class DisplayCurrencyService {
  DisplayCurrencyService._();
  static final DisplayCurrencyService instance = DisplayCurrencyService._();

  static const _prefKey = 'display_currency_code';

  String _currency = 'IDR';
  Map<String, double> _quotes = const {'IDR': 1, 'USD': 15800, 'SGD': 11700, 'EUR': 17200};
  bool _loaded = false;

  String get currency => _currency;
  Map<String, double> get quotes => _quotes;
  List<String> get supported => _quotes.keys.toList();

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString(_prefKey) ?? 'IDR';
    try {
      final dio = sl<Dio>();
      final res = await dio.get('/commerce/exchange-rates');
      final data = res.data['data'] as Map<String, dynamic>;
      final raw = data['quotes'] as Map<String, dynamic>? ?? {};
      _quotes = raw.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } catch (_) {}
    _loaded = true;
  }

  Future<void> setCurrency(String code) async {
    final upper = code.toUpperCase();
    if (!_quotes.containsKey(upper)) return;
    _currency = upper;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, upper);
    try {
      await sl<Dio>().patch('/commerce/display-currency', data: {'currency': upper});
    } catch (_) {}
  }

  String formatIdr(num amountIdr, {bool showIdrHint = true}) {
    if (_currency == 'IDR') {
      return _formatIdr(amountIdr);
    }
    final rate = _quotes[_currency] ?? 1;
    final converted = amountIdr / rate;
    final symbol = _symbol(_currency);
    final formatted = converted >= 100
        ? converted.toStringAsFixed(0)
        : converted.toStringAsFixed(2);
    if (!showIdrHint) return '$symbol$formatted';
    return '$symbol$formatted · ${_formatIdr(amountIdr)}';
  }

  String _symbol(String code) {
    switch (code) {
      case 'USD':
        return '\$';
      case 'SGD':
        return 'S\$';
      case 'EUR':
        return '€';
      default:
        return 'Rp ';
    }
  }

  String _formatIdr(num n) {
    final v = n.round();
    final s = v.toString();
    final buf = StringBuffer('Rp ');
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
