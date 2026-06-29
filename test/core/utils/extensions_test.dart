import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/utils/extensions.dart';

void main() {
  group('StringExt', () {
    test('isValidEmail accepts common formats', () {
      expect('buyer@bisa.id'.isValidEmail, isTrue);
      expect('not-an-email'.isValidEmail, isFalse);
    });

    test('isValidPhone accepts Indonesian numbers', () {
      expect('081234567890'.isValidPhone, isTrue);
      expect('+6281234567890'.isValidPhone, isTrue);
      expect('123'.isValidPhone, isFalse);
    });
  });

  group('NumExt', () {
    test('toRupiah formats IDR', () {
      expect(1500000.toRupiah, contains('Rp'));
      expect(1500000.toRupiah, contains('1'));
    });
  });
}
