import '../domain/entities/region_entity.dart';

/// Cache in-memory daftar wilayah (negara → desa) agar tidak memanggil API berulang.
class GisRegionCache {
  GisRegionCache._();
  static final GisRegionCache instance = GisRegionCache._();

  final Map<String, List<RegionEntity>> _store = {};

  static String key({
    required String level,
    String? parentId,
    String? search,
  }) {
    final q = (search ?? '').trim().toLowerCase();
    return '${level.toLowerCase()}:${parentId ?? ''}:$q';
  }

  List<RegionEntity>? get({
    required String level,
    String? parentId,
    String? search,
  }) {
    return _store[key(level: level, parentId: parentId, search: search)];
  }

  void put({
    required String level,
    String? parentId,
    String? search,
    required List<RegionEntity> regions,
  }) {
    _store[key(level: level, parentId: parentId, search: search)] =
        List<RegionEntity>.unmodifiable(regions);
  }

  void clear() => _store.clear();
}
