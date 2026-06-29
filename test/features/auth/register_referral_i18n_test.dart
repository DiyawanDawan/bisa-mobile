import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('register referral i18n keys exist in ID and EN', () {
    final id = jsonDecode(
      File('assets/translations/id-ID.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final en = jsonDecode(
      File('assets/translations/en-US.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    for (final key in ['auth.referral_code_label', 'auth.referral_code_hint']) {
      expect(id[key], isNotNull, reason: 'Missing $key in id-ID');
      expect(en[key], isNotNull, reason: 'Missing $key in en-US');
    }
  });
}
