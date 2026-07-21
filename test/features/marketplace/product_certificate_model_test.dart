import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/features/marketplace/data/models/product_certificate_model.dart';
import 'package:mobile_bisa/features/marketplace/data/models/product_model.dart';
import 'package:mobile_bisa/features/marketplace/domain/entities/product_certificate_entity.dart';

void main() {
  test('parses an approved public certificate', () {
    final entity = ProductCertificateModel.fromJson({
      'id': 'cert-1',
      'productId': 'product-1',
      'title': 'Sertifikat Organik',
      'certificateType': 'ORGANIC',
      'issuerName': 'Lembaga Organik Indonesia',
      'fileName': 'organik.pdf',
      'mimeType': 'application/pdf',
      'status': 'APPROVED',
      'expiresAt': '2099-01-01T00:00:00.000Z',
      'documentUrl': 'https://api.example.test/document',
    }).toEntity();

    expect(entity.id, 'cert-1');
    expect(entity.isApproved, isTrue);
    expect(entity.documentUrl, isNotNull);
  });

  test('expired approval is not exposed as active approval', () {
    final entity = ProductCertificateModel.fromJson({
      'id': 'cert-2',
      'productId': 'product-1',
      'title': 'Sertifikat Lama',
      'certificateType': 'SNI',
      'fileName': 'sni.pdf',
      'mimeType': 'application/pdf',
      'status': 'APPROVED',
      'expiresAt': '2020-01-01T00:00:00.000Z',
    }).toEntity();

    expect(entity.isApproved, isFalse);
  });

  test('product parsing remains compatible without certificates', () {
    final entity = ProductModel.fromJson({
      'id': 'product-1',
      'name': 'Biochar',
      'pricePerUnit': 1000,
      'unit': 'KG',
      'biomassaType': 'BIOCHAR',
      'province': 'Jawa Timur',
      'user': {'id': 'supplier-1', 'fullName': 'Supplier', 'isVerified': true},
    }).toEntity();

    expect(entity.certificates, isEmpty);
  });

  test(
    'maps pending and rejected status without treating them as approved',
    () {
      for (final status in ['PENDING', 'REJECTED']) {
        final entity = ProductCertificateModel.fromJson({
          'id': 'cert-$status',
          'productId': 'product-1',
          'title': 'Sertifikat',
          'certificateType': 'SNI',
          'fileName': 'sni.pdf',
          'mimeType': 'application/pdf',
          'status': status,
        }).toEntity();
        expect(entity.status, status);
        expect(entity.isApproved, isFalse);
      }
    },
  );

  test('validates supported files and issue-expiry dates', () {
    expect(isSupportedCertificateFileName('certificate.PDF'), isTrue);
    expect(isSupportedCertificateFileName('certificate.webp'), isFalse);
    expect(areCertificateDatesValid(DateTime(2026), DateTime(2027)), isTrue);
    expect(areCertificateDatesValid(DateTime(2027), DateTime(2026)), isFalse);
  });
}
