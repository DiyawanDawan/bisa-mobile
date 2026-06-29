import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_bisa/core/i18n/bootstrap_localization.dart';

/// Wraps widget tests that call `.tr()`.
Future<void> pumpLocalizedWidget(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('id', 'ID'),
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await bootstrapLocalization(locale);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        locale: locale,
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
