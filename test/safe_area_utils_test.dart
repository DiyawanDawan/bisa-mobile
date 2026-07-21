import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';

Widget _wrap(Widget child, {double bottomPadding = 0}) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    builder: (_, __) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(padding: EdgeInsets.only(bottom: bottomPadding)),
        child: Builder(builder: (context) => child),
      ),
    ),
  );
}

void main() {
  group('safe_area_utils', () {
    testWidgets('systemBottomInset reads MediaQuery padding', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              expect(systemBottomInset(context), 34);
              return const SizedBox();
            },
          ),
          bottomPadding: 34,
        ),
      );
    });

    testWidgets('mainShellBottomPadding does not double system inset', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              final pad = mainShellBottomPadding(
                context,
                kind: MainShellScrollKind.orders,
              );
              expect(pad, closeTo(72, 1));
              return const SizedBox();
            },
          ),
          bottomPadding: 20,
        ),
      );
    });

    testWidgets('sheetBottomPadding uses the larger keyboard/system inset', (
      tester,
    ) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (_, __) => MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                padding: EdgeInsets.only(bottom: 24),
                viewInsets: EdgeInsets.only(bottom: 300),
              ),
              child: Builder(
                builder: (context) {
                  final pad = sheetBottomPadding(context);
                  expect(pad.bottom, 300);
                  final canonical = bisaSheetPadding(context);
                  expect(canonical.left, closeTo(16.w, 0.5));
                  expect(canonical.bottom, closeTo(300 + 8.w, 0.5));
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
    });

    testWidgets('gisMapFloatingBottomOffset increases when panel open', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              final closed = gisMapFloatingBottomOffset(
                context,
                panelOpen: false,
              );
              final open = gisMapFloatingBottomOffset(context, panelOpen: true);
              expect(open, greaterThan(closed));
              return const SizedBox();
            },
          ),
          bottomPadding: 16,
        ),
      );
    });

    testWidgets('bisaSnackBarMargin adds extraBottom', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              final margin = bisaSnackBarMargin(context, extraBottom: 40);
              expect(margin.bottom, greaterThan(40.h));
              return const SizedBox();
            },
          ),
          bottomPadding: 12,
        ),
      );
    });
  });
}
