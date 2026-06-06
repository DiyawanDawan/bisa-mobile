import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/readiness/readiness_models.dart';

void main() {
  test('RoleReadiness parses missing keys and messages', () {
    final readiness = RoleReadiness.fromJson({
      'ready': false,
      'missing': ['companyName', 'rajaongkirOriginId'],
      'messages': ['Nama toko belum diisi'],
    });

    expect(readiness.ready, isFalse);
    expect(readiness.missing, ['companyName', 'rajaongkirOriginId']);
    expect(readiness.messages.first, contains('Nama toko'));
  });

  test('readinessLabelForKey maps buyer keys', () {
    expect(readinessLabelForKey('shippingAddress'), contains('Alamat'));
    expect(readinessRouteForBuyerKey('recipientPhone'), '/edit-profile');
    expect(readinessRouteForStoreKey('rajaongkirOriginId'), '/supplier-shipping-origin');
    expect(readinessLabelForKey('kycVerified'), contains('KYC'));
    expect(readinessRouteForStoreKey('kycVerified'), '/verification');
  });
}
