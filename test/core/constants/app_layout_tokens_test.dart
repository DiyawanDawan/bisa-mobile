import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/constants/app_radius.dart';
import 'package:mobile_bisa/core/constants/app_spacing.dart';

void main() {
  group('AppLayout tokens', () {
    test('AppRadius px constants for ThemeData', () {
      expect(AppRadius.smPx, 6);
      expect(AppRadius.mdPx, 10);
      expect(AppRadius.tilePx, 14);
      expect(AppRadius.xlPx, 16);
      expect(AppRadius.pillPx, 20);
      expect(AppRadius.buttonPx, 8);
    });

    test('AppSpacing px constants for ThemeData', () {
      expect(AppSpacing.xsPx, 4);
      expect(AppSpacing.xs6Px, 6);
      expect(AppSpacing.smPx, 8);
      expect(AppSpacing.sm10Px, 10);
      expect(AppSpacing.md12Px, 12);
      expect(AppSpacing.sectionPx, 14);
      expect(AppSpacing.mdPx, 16);
      expect(AppSpacing.lgPx, 20);
      expect(AppSpacing.xlPx, 24);
      expect(AppSpacing.xl28Px, 28);
      expect(AppSpacing.xxlPx, 32);
      expect(AppSpacing.xxxlPx, 40);
      expect(AppSpacing.buttonHeightSmPx, 40);
      expect(AppSpacing.buttonHeightPx, 48);
      expect(AppSpacing.buttonHeightLgPx, 56);
    });

    test('AppRadius lg constant', () {
      expect(AppRadius.lgPx, 12);
    });
  });
}
