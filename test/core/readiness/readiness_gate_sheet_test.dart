import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/core/readiness/readiness_gate_sheet.dart';
import 'package:mobile_bisa/core/readiness/readiness_models.dart';

void main() {
  testWidgets('ReadinessGateSheet shows blockers and CTA', (tester) async {
    const readiness = RoleReadiness(
      ready: false,
      missing: ['rajaongkirOriginId'],
      messages: ['Lokasi asal pengiriman RajaOngkir belum diatur'],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: ReadinessGateSheet(
              title: 'Lengkapi data toko',
              subtitle: 'Subtitle test',
              readiness: readiness,
              routeForKey: readinessRouteForStoreKey,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Lengkapi data toko'), findsOneWidget);
    expect(find.textContaining('RajaOngkir'), findsOneWidget);
    expect(find.text('Lengkapi sekarang'), findsOneWidget);
    expect(find.text('Tutup'), findsOneWidget);
  });
}
