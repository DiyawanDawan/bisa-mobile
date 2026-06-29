import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/currency/display_currency_service.dart';

/// Smoke unit test — pengganti template counter default.
void main() {
  test('DisplayCurrencyService smoke', () {
    expect(
      DisplayCurrencyService.instance.formatIdr(1000),
      'Rp 1.000',
    );
  });
}
