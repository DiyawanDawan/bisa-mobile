import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/utils/payment_expiry_utils.dart';

void main() {
  group('payment_expiry_utils', () {
    test('parsePaymentExpiryDate parses ISO string', () {
      final dt = parsePaymentExpiryDate('2026-06-06T12:00:00.000Z');
      expect(dt, isNotNull);
    });

    test('expiryFromPaymentPayload reads expiryDate', () {
      final dt = expiryFromPaymentPayload({
        'expiryDate': '2026-06-06T15:30:00.000Z',
      });
      expect(dt, isNotNull);
    });

    test('resolvePaymentExpiresAt falls back to orderCreatedAt + 24h', () {
      final created = DateTime(2026, 6, 5, 10, 0);
      final expires = resolvePaymentExpiresAt(orderCreatedAt: created);
      expect(expires, created.add(paymentExpiryFallbackDuration));
    });

    test('isPaymentExpired true when status EXPIRED', () {
      expect(
        isPaymentExpired(paymentStatus: 'EXPIRED'),
        isTrue,
      );
    });

    test('formatPaymentCountdown shows HH:MM:SS', () {
      expect(
        formatPaymentCountdown(const Duration(hours: 1, minutes: 5, seconds: 9)),
        '01:05:09',
      );
    });

    test('formatPaymentCountdown shows MM:SS under one hour', () {
      expect(
        formatPaymentCountdown(const Duration(minutes: 4, seconds: 7)),
        '04:07',
      );
    });
  });
}
