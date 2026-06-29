import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// LT-4 gate: high-traffic & shared widgets must not use inline `16.w` / `20.r`.
void main() {
  final root = Directory.current.path.endsWith('mobile_bisa')
      ? Directory.current
      : Directory('Mobile Apps/mobile_bisa');

  String read(String relativePath) {
    return File('${root.path}/$relativePath').readAsStringSync();
  }

  bool hasInlineMagic(String content, {List<String> allowSubstrings = const []}) {
    final patterns = [RegExp(r'\b16\.w\b'), RegExp(r'\b20\.r\b')];
    for (final pattern in patterns) {
      for (final match in pattern.allMatches(content)) {
        final lineStart = content.lastIndexOf('\n', match.start) + 1;
        final lineEnd = content.indexOf('\n', match.start);
        final line = content.substring(
          lineStart,
          lineEnd == -1 ? content.length : lineEnd,
        );
        if (allowSubstrings.any(line.contains)) continue;
        return true;
      }
    }
    return false;
  }

  group('LT-4 layout token gate', () {
    const lt2Pages = [
      'lib/features/marketplace/presentation/pages/marketplace_page.dart',
      'lib/features/marketplace/presentation/pages/product_detail_page.dart',
      'lib/features/commerce/presentation/pages/cart_page.dart',
      'lib/features/auth/presentation/pages/register_page.dart',
      'lib/features/auth/presentation/pages/login_page.dart',
      'lib/features/orders/presentation/pages/order_detail_page.dart',
      'lib/features/orders/presentation/pages/orders_page.dart',
      'lib/features/profile/presentation/pages/profile_page.dart',
      'lib/features/negotiation/presentation/pages/negotiation_room_page.dart',
      'lib/features/invoice/presentation/pages/review_invoice_page.dart',
      'lib/features/public_orders/presentation/pages/public_verify_page.dart',
      'lib/features/public_orders/presentation/pages/public_track_page.dart',
    ];

    const smokeWidgets = [
      'lib/features/marketplace/presentation/widgets/product_card.dart',
      'lib/features/auth/presentation/pages/register_page.dart',
      'lib/features/commerce/presentation/pages/cart_page.dart',
    ];

    const lt1Shared = [
      'lib/shared/widgets/custom_button.dart',
      'lib/shared/widgets/custom_text_field.dart',
      'lib/shared/widgets/bisa_app_bar.dart',
      'lib/shared/widgets/bisa_dialog.dart',
      'lib/shared/widgets/bisa_filter_chip.dart',
      'lib/shared/widgets/floating_bottom_nav.dart',
      'lib/shared/widgets/auth_sheet.dart',
      'lib/shared/widgets/bisa_search_field.dart',
      'lib/shared/widgets/currency_selector_sheet.dart',
      'lib/shared/widgets/language_picker_sheet.dart',
      'lib/shared/widgets/pro_tier_matrix.dart',
    ];

    test('LT-2 high-traffic pages: no 16.w / 20.r', () {
      for (final path in lt2Pages) {
        final content = read(path);
        final allow = path.contains('cart_page.dart') ? ['Bone('] : <String>[];
        expect(
          hasInlineMagic(content, allowSubstrings: allow),
          isFalse,
          reason: path,
        );
      }
    });

    test('smoke targets (product_card, register, cart): no 16.w / 20.r', () {
      for (final path in smokeWidgets) {
        final content = read(path);
        final allow = path.contains('cart_page.dart') ? ['Bone('] : <String>[];
        expect(
          hasInlineMagic(content, allowSubstrings: allow),
          isFalse,
          reason: path,
        );
      }
    });

    test('LT-1 shared widgets: no 16.w / 20.r', () {
      for (final path in lt1Shared) {
        expect(
          hasInlineMagic(read(path)),
          isFalse,
          reason: path,
        );
      }
    });
  });
}
