import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/currency/display_currency_service.dart';

void main() {
  group('DisplayCurrencyService (FB-19)', () {
    test('formatIdr in IDR mode uses Rp prefix and thousand separators', () {
      final formatted = DisplayCurrencyService.instance.formatIdr(2_500_000);
      expect(formatted, 'Rp 2.500.000');
    });

    test('formatIdr without hint when showIdrHint is false', () {
      final formatted = DisplayCurrencyService.instance.formatIdr(
        100_000,
        showIdrHint: false,
      );
      expect(formatted, 'Rp 100.000');
    });
  });
}
