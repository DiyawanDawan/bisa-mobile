import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_model.freezed.dart';
part 'supplier_model.g.dart';

@freezed
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

  factory SupplierModel.fromJson(Map<String, dynamic> json) => _$SupplierModelFromJson(json);
}
