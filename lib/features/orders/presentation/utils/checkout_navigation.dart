import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/safe_navigator.dart';

/// Setelah checkout / pembayaran — arahkan ke tab Pesanan (index 3).
void navigateToOrdersTab(BuildContext context) {
  if (!context.mounted) return;
  context.go('/?tab=3');
}

/// Keluar dari instruksi pembayaran dengan hasil yang konsisten.
void leavePaymentInstruction(
  BuildContext context, {
  required bool paymentConfirmed,
  required List<String> batchOrderIds,
}) {
  if (!context.mounted) return;
  if (paymentConfirmed) {
    navigateToOrdersTab(context);
    return;
  }
  safeRouterPop(context, false);
}

/// Rute setelah order dibuat tetapi inisialisasi pembayaran gagal.
/// Tidak boleh ke `/checkout-result` (itu untuk alur sukses).
String? paymentInitFailureRoute(String? leadOrderId, {bool autoPay = true}) {
  if (leadOrderId == null || leadOrderId.isEmpty) return null;
  final suffix = autoPay ? '?autoPay=1' : '';
  return '/order/$leadOrderId$suffix';
}

/// Buka detail checkout multi-supplier jika memungkinkan.
void openOrderDetailOrBatch(
  BuildContext context, {
  required String orderId,
  String? checkoutBatchId,
}) {
  final batchId = checkoutBatchId?.trim();
  if (batchId != null && batchId.isNotEmpty) {
    context.push('/order-batch/$orderId');
    return;
  }
  context.push('/order/$orderId');
}
