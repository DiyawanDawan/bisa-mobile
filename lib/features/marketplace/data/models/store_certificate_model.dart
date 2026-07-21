import '../../domain/entities/product_certificate_entity.dart';

class StoreCertificateModel {
  const StoreCertificateModel(this.json);

  final Map<String, dynamic> json;

  factory StoreCertificateModel.fromJson(Map<String, dynamic> json) =>
      StoreCertificateModel(json);

  StoreCertificateEntity toEntity() {
    return StoreCertificateEntity(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      certificateType: json['certificateType']?.toString() ?? '',
      issuerName: json['issuerName']?.toString(),
      certificateNumber: json['certificateNumber']?.toString(),
      issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
      expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
      documentUrl: json['documentUrl']?.toString(),
      fileName: json['fileName']?.toString() ?? '',
      mimeType: json['mimeType']?.toString() ?? '',
      status: json['status']?.toString() ?? 'APPROVED',
      rejectionReason: json['rejectionReason']?.toString(),
      reviewedAt: DateTime.tryParse(json['reviewedAt']?.toString() ?? ''),
    );
  }
}
