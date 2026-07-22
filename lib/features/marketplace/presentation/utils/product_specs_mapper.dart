import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/product_entity.dart';

class ProductSpecEntry {
  const ProductSpecEntry({required this.label, required this.value});

  final String label;
  final String value;

  bool get isValid => label.trim().isNotEmpty && value.trim().isNotEmpty;

  Map<String, String> toJson() => {'label': label.trim(), 'value': value.trim()};

  factory ProductSpecEntry.fromEntity(ProductSpecEntity entity) {
    return ProductSpecEntry(label: entity.label, value: entity.value);
  }

  factory ProductSpecEntry.fromJson(Map<String, dynamic> json) {
    return ProductSpecEntry(
      label: json['label']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}

/// Maps between API `product_specs` table ↔ unified key-value rows.
class ProductSpecsMapper {
  /// Canonical Indonesian labels stored in API / DB — do not change.
  static const _labelI18nKeys = <String, String>{
    'Jenis Hasil Tani': 'marketplace.spec_label_crop_type',
    'Pupuk / Nutrisi': 'marketplace.spec_label_fertilizer',
    'Bebas Bahan Kimia': 'marketplace.spec_label_chemical_free',
    'Ketahanan (hari)': 'marketplace.spec_label_shelf_life',
    'Luas Lahan (ha)': 'marketplace.spec_label_land_area',
    'Metode Irigasi': 'marketplace.spec_label_irrigation',
    'Musim Tanam': 'marketplace.spec_label_planting_season',
    'Sertifikasi': 'marketplace.spec_label_certification',
    'Kadar Air': 'marketplace.spec_label_moisture',
    'Kemurnian Karbon': 'marketplace.spec_label_carbon_purity',
    'Tingkat pH': 'marketplace.spec_label_ph',
    'Densitas': 'marketplace.spec_label_density',
    'Kapasitas Produksi': 'marketplace.spec_label_production_capacity',
    'Luas Permukaan': 'marketplace.spec_label_surface_area',
    'Offset Karbon per Ton': 'marketplace.spec_label_carbon_offset',
    'Berat Kotor per Sak': 'marketplace.spec_label_gross_weight',
    'Berat Bersih per Sak': 'marketplace.spec_label_net_weight',
    'Dimensi Karung': 'marketplace.spec_label_bag_dimension',
  };

  static const _valueI18nKeys = <String, String>{
    'Ya (100% Organik)': 'marketplace.spec_value_chemical_free_yes',
    'Tidak': 'marketplace.spec_value_no',
  };

  /// Localized label for UI; falls back to [canonicalLabel] for custom rows.
  static String displayLabel(String canonicalLabel) {
    final key = _labelI18nKeys[canonicalLabel.trim()];
    return key != null ? key.tr() : canonicalLabel;
  }

  /// Localized value for known preset values; falls back to raw [value].
  static String displayValue(String value) {
    final key = _valueI18nKeys[value.trim()];
    return key != null ? key.tr() : value;
  }

  static List<String> presetLabels(String productMode) {
    if (productMode == 'ORGANIC_PRODUCE') {
      return [
        'Jenis Hasil Tani',
        'Pupuk / Nutrisi',
        'Bebas Bahan Kimia',
        'Ketahanan (hari)',
        'Luas Lahan (ha)',
        'Metode Irigasi',
        'Musim Tanam',
        'Sertifikasi',
      ];
    }
    return [
      'Kadar Air',
      'Kemurnian Karbon',
      'Tingkat pH',
      'Densitas',
      'Kapasitas Produksi',
      'Luas Permukaan',
      'Berat Bersih per Sak',
      'Dimensi Karung',
    ];
  }

  static List<ProductSpecEntry> fromProduct(ProductEntity product) {
    if (product.specs.isNotEmpty) {
      return product.specs
          .map(ProductSpecEntry.fromEntity)
          .where((e) => e.isValid)
          .toList();
    }
    return _legacyFromStructuredFields(product);
  }

  static List<ProductSpecEntry> _legacyFromStructuredFields(ProductEntity product) {
    final rows = <ProductSpecEntry>[];
    final isOrganic = product.productMode == 'ORGANIC_PRODUCE';

    if (isOrganic) {
      if (product.cropType != null && product.cropType!.isNotEmpty) {
        rows.add(ProductSpecEntry(label: 'Jenis Hasil Tani', value: product.cropType!));
      }
      if (product.fertilizerType != null && product.fertilizerType!.isNotEmpty) {
        rows.add(ProductSpecEntry(label: 'Pupuk / Nutrisi', value: product.fertilizerType!));
      }
      rows.add(ProductSpecEntry(
        label: 'Bebas Bahan Kimia',
        value: product.isChemicalFree ? 'Ya (100% Organik)' : 'Tidak',
      ));
      if (product.shelfLifeDays != null && product.shelfLifeDays! > 0) {
        rows.add(ProductSpecEntry(
          label: 'Ketahanan (hari)',
          value: '${product.shelfLifeDays}',
        ));
      }
      if (product.landAreaHa != null && product.landAreaHa! > 0) {
        rows.add(ProductSpecEntry(
          label: 'Luas Lahan (ha)',
          value: '${product.landAreaHa}',
        ));
      }
    } else {
      final spec = product.technicalSpec;
      if (spec != null) {
        void addNum(String label, num? v, {String suffix = ''}) {
          if (v == null) return;
          rows.add(ProductSpecEntry(label: label, value: '$v$suffix'));
        }

        addNum('Kadar Air', spec.moistureContent, suffix: '%');
        addNum('Kemurnian Karbon', spec.carbonPurity, suffix: '%');
        addNum('Tingkat pH', spec.phLevel);
        if (spec.density != null && spec.density!.isNotEmpty) {
          rows.add(ProductSpecEntry(label: 'Densitas', value: spec.density!));
        }
        addNum('Kapasitas Produksi', spec.productionCapacity, suffix: ' /bln');
        addNum('Luas Permukaan', spec.surfaceArea, suffix: ' m²/g');
        addNum('Offset Karbon per Ton', spec.carbonOffsetPerTon, suffix: ' tCO₂e');
        addNum('Berat Kotor per Sak', spec.grossWeightPerSak, suffix: ' kg');
        addNum('Berat Bersih per Sak', spec.netWeightPerSak, suffix: ' kg');
        if (spec.bagDimension != null && spec.bagDimension!.isNotEmpty) {
          rows.add(ProductSpecEntry(label: 'Dimensi Karung', value: spec.bagDimension!));
        }
      }
    }

    return rows;
  }

  static List<MapEntry<String, String>> toDisplayEntries(
    List<ProductSpecEntry> entries,
  ) {
    return entries
        .where((e) => e.isValid)
        .map((e) => MapEntry(e.label.trim(), e.value.trim()))
        .toList();
  }

  static Map<String, dynamic> toApiPayload(
    String productMode,
    List<ProductSpecEntry> entries,
  ) {
    final api = <String, dynamic>{};
    final specs = entries.where((e) => e.isValid).map((e) => e.toJson()).toList();
    final isOrganic = productMode == 'ORGANIC_PRODUCE';

    for (final entry in entries.where((e) => e.isValid)) {
      final label = entry.label.trim();
      final value = entry.value.trim();

      if (isOrganic) {
        switch (label) {
          case 'Jenis Hasil Tani':
            api['cropType'] = value;
            break;
          case 'Pupuk / Nutrisi':
            api['fertilizerType'] = value;
            break;
          case 'Bebas Bahan Kimia':
            api['isChemicalFree'] =
                value.toLowerCase().contains('ya') || value.contains('100%');
            break;
          case 'Ketahanan (hari)':
          case 'Ketahanan':
            final n = _parseNum(value);
            if (n != null) api['shelfLifeDays'] = n.round();
            break;
          case 'Luas Lahan (ha)':
          case 'Luas Lahan':
            final n = _parseNum(value);
            if (n != null) api['landAreaHa'] = n;
            break;
        }
      } else {
        switch (label) {
          case 'Kadar Air':
            final n = _parseNum(value);
            if (n != null) api['moistureContent'] = n;
            break;
          case 'Kemurnian Karbon':
            final n = _parseNum(value);
            if (n != null) api['carbonPurity'] = n;
            break;
          case 'Tingkat pH':
            final n = _parseNum(value);
            if (n != null) api['phLevel'] = n;
            break;
          case 'Densitas':
            api['density'] = value;
            break;
          case 'Kapasitas Produksi':
            final n = _parseNum(value);
            if (n != null) api['productionCapacity'] = n;
            break;
          case 'Luas Permukaan':
            final n = _parseNum(value);
            if (n != null) api['surfaceArea'] = n;
            break;
          case 'Offset Karbon per Ton':
            final n = _parseNum(value);
            if (n != null) api['carbonOffsetPerTon'] = n;
            break;
          case 'Berat Kotor per Sak':
            final n = _parseNum(value);
            if (n != null) api['grossWeightPerSak'] = n;
            break;
          case 'Berat Bersih per Sak':
            final n = _parseNum(value);
            if (n != null) api['netWeightPerSak'] = n;
            break;
          case 'Dimensi Karung':
            api['bagDimension'] = value;
            break;
        }
      }
    }

    api['specs'] = specs;
    return api;
  }

  static double? _parseNum(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.,-]'), '').replaceAll(',', '.');
    return double.tryParse(cleaned);
  }
}
