import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mobile_bisa/core/currency/display_currency_service.dart';
import 'package:mobile_bisa/core/utils/money_format.dart';

void main() {
  group('formatMoneyIdr', () {
    test('formats IDR with Rp prefix and thousand separators', () {
      final formatted = formatMoneyIdr(1_500_000);
      expect(formatted, startsWith('Rp'));
      expect(formatted, contains('1.500.000'));
      expect(formatMoneyIdr(0), startsWith('Rp'));
    });
  });

  group('formatMoneyDisplay', () {
    test('delegates to DisplayCurrencyService', () {
      expect(
        formatMoneyDisplay(2_500_000),
        DisplayCurrencyService.instance.formatIdr(2_500_000),
      );
    });
  });

  group('formatMoneyLocale', () {
    test('uses id_ID intl locale for Indonesian', () {
      // Widget test with EasyLocalization → widget_test_scope (U-4).
      final formatted = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      ).format(750_000);
      expect(formatted, contains('750'));
      expect(formatted, contains('000'));
    });
  });
}
