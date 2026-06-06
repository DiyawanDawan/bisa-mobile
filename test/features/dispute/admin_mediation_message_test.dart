import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_bisa/features/negotiation/presentation/utils/admin_mediation_message.dart';

void main() {
  test('detects admin mediation prefix', () {
    expect(
      isAdminMediationMessageContent('[Admin BISA] Mohon kirim bukti resi.'),
      isTrue,
    );
    expect(isAdminMediationMessageContent('SENGKETA DIAJUKAN: rusak'), isFalse);
  });

  test('strips admin mediation prefix', () {
    expect(
      stripAdminMediationPrefix('[Admin BISA] Mohon kirim bukti resi.'),
      'Mohon kirim bukti resi.',
    );
  });
}
