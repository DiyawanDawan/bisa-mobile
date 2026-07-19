import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_model.freezed.dart';
part 'supplier_model.g.dart';

@Freezed(fromJson: false, toJson: true)
abstract class SupplierModel with _$SupplierModel {
  const factory SupplierModel({
    required String id,
    required String name,
    String? avatar,
    String? phone,
    String? address,
    String? province,
    String? regency,
    @Default(false) bool isVerified,
    @Default(0.0) double rating,
    @Default(0) int totalProducts,
  }) = _SupplierModel;

  /// Maps both flat mobile fields and nested backend user payloads.
  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'] as Map)
        : null;
    final verification = json['verification'] is Map
        ? Map<String, dynamic>.from(json['verification'] as Map)
        : null;
    final count = json['_count'] is Map
        ? Map<String, dynamic>.from(json['_count'] as Map)
        : null;

    final companyName = profile?['companyName']?.toString().trim();
    final fullName =
        json['fullName']?.toString().trim() ?? json['name']?.toString().trim();
    final displayName = (companyName != null && companyName.isNotEmpty)
        ? companyName
        : (fullName ?? '');

    final id = json['id']?.toString();
    if (id == null || id.isEmpty) {
      throw FormatException('Supplier JSON missing id');
    }

    return SupplierModel(
      id: id,
      name: displayName.isNotEmpty ? displayName : 'Supplier',
      avatar: json['avatar']?.toString() ?? json['avatarUrl']?.toString(),
      phone: json['phone']?.toString(),
      address: json['address']?.toString() ??
          verification?['businessAddress']?.toString(),
      province: json['province']?.toString(),
      regency: json['regency']?.toString(),
      isVerified: verification?['isVerified'] == true ||
          json['isVerified'] == true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalProducts: (json['totalProducts'] as num?)?.toInt() ??
          (count?['products'] as num?)?.toInt() ??
          0,
    );
  }
}

extension SupplierModelX on SupplierModel {
  String get locationLabel {
    final parts = <String>[
      if (regency != null && regency!.trim().isNotEmpty) regency!.trim(),
      if (province != null && province!.trim().isNotEmpty) province!.trim(),
    ];
    return parts.isEmpty ? '—' : parts.join(', ');
  }
}
