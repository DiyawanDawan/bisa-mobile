/// Cache hasil pencarian destinasi RajaOngkir (in-memory, per sesi app).
class ShippingDestinationCache {
  ShippingDestinationCache._();
  static final ShippingDestinationCache instance = ShippingDestinationCache._();

  final Map<String, List<Map<String, dynamic>>> _hits = {};
  final Map<String, List<Map<String, dynamic>>> _misses = {};

  List<Map<String, dynamic>>? get(String searchKey) {
    final key = searchKey.trim().toLowerCase();
    if (_hits.containsKey(key)) return _hits[key];
    if (_misses.containsKey(key)) return _misses[key];
    return null;
  }

  void put(String searchKey, List<Map<String, dynamic>> results) {
    final key = searchKey.trim().toLowerCase();
    final store = results.isEmpty ? _misses : _hits;
    store[key] = List<Map<String, dynamic>>.unmodifiable(results);
  }

  void clear() {
    _hits.clear();
    _misses.clear();
  }
}
