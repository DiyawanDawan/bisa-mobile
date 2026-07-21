import '../../domain/entities/product_certificate_entity.dart';

class ProductCertificateModel {
  const ProductCertificateModel(this.json);

  final Map<String, dynamic> json;

  factory ProductCertificateModel.fromJson(Map<String, dynamic> json) =>
      ProductCertificateModel(json);

  Map<String, dynamic> toJson() => json;

  ProductCertificateEntity toEntity() {
    final product = json['product'] as Map<String, dynamic>?;
    return ProductCertificateEntity(
      id: json['id']?.toString() ?? '',
      productId:
          json['productId']?.toString() ?? product?['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      certificateType: json['certificateType']?.toString() ?? '',
      issuerName: json['issuerName']?.toString(),
      certificateNumber: json['certificateNumber']?.toString(),
      issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
      expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
      documentUrl: json['documentUrl']?.toString(),
      fileName: json['fileName']?.toString() ?? '',
      mimeType: json['mimeType']?.toString() ?? '',
      status: json['status']?.toString() ?? 'PENDING',
      rejectionReason: json['rejectionReason']?.toString(),
      reviewedAt: DateTime.tryParse(json['reviewedAt']?.toString() ?? ''),
      productName: product?['name']?.toString(),
      productThumbnailUrl: product?['thumbnailUrl']?.toString(),
    );
  }
}
