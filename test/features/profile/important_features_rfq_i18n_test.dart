import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RFQ menu i18n keys for important features page', () {
    final id = jsonDecode(
      File('assets/translations/id-ID.json').readAsStringSync(),
    ) as Map<String, dynamic>;

    for (final key in [
      'rfq.menu_title',
      'rfq.menu_subtitle',
      'rfq.menu_inbox_subtitle',
      'rfq.inbox_title',
    ]) {
      expect(id[key], isNotNull, reason: 'Missing $key');
    }
  });
}
