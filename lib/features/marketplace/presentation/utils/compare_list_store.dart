import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/product_entity.dart';
import 'compare_product_codec.dart';

class CompareSavedList {
  final String id;
  final String name;
  final List<ProductEntity> products;

  const CompareSavedList({
    required this.id,
    required this.name,
    required this.products,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'products': products.map(CompareProductCodec.toJson).toList(),
      };

  factory CompareSavedList.fromJson(Map<String, dynamic> j) {
    final productsRaw = j['products'] as List? ?? [];
    return CompareSavedList(
      id: j['id'] as String,
      name: j['name'] as String,
      products: productsRaw
          .map(
            (e) => CompareProductCodec.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );
  }
}

class CompareListStore {
  static const _key = 'compare_saved_lists_v1';
  static const maxLists = 8;

  final SharedPreferences _prefs;

  CompareListStore(this._prefs);

  List<CompareSavedList> load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .map(
            (e) => CompareSavedList.fromJson(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<CompareSavedList> lists) async {
    final encoded = jsonEncode(lists.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
