class ProductCertificateEntity {
  const ProductCertificateEntity({
    required this.id,
    required this.productId,
    required this.title,
    required this.certificateType,
    required this.fileName,
    required this.mimeType,
    required this.status,
    this.issuerName,
    this.certificateNumber,
    this.issuedAt,
    this.expiresAt,
    this.documentUrl,
    this.rejectionReason,
    this.reviewedAt,
    this.productName,
    this.productThumbnailUrl,
  });

  final String id;
  final String productId;
  final String title;
  final String certificateType;
  final String fileName;
  final String mimeType;
  final String status;
  final String? issuerName;
  final String? certificateNumber;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final String? documentUrl;
  final String? rejectionReason;
  final DateTime? reviewedAt;
  final String? productName;
  final String? productThumbnailUrl;

  bool get isApproved =>
      status == 'APPROVED' &&
      (expiresAt == null || expiresAt!.isAfter(DateTime.now()));
}

class ProductCertificateDraft {
  const ProductCertificateDraft({
    required this.localPath,
    required this.fileName,
    required this.metadata,
  });

  final String localPath;
  final String fileName;
  final Map<String, dynamic> metadata;
}

bool isSupportedCertificateFileName(String fileName) {
  final extension = fileName.split('.').last.toLowerCase();
  return const {'pdf', 'jpg', 'jpeg', 'png'}.contains(extension);
}

bool areCertificateDatesValid(DateTime? issuedAt, DateTime? expiresAt) {
  return issuedAt == null || expiresAt == null || expiresAt.isAfter(issuedAt);
}
