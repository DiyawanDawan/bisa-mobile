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
/// Tidak boleh ke `/checkout-result` (itu untuk ringkasan order sukses).
/// Prefers `/checkout` untuk alur checkout keranjang.
/// [paymentCode]/[paymentName] diteruskan agar tidak minta pilih metode lagi.
String? paymentInitFailureRoute(
  String? leadOrderId, {
  bool autoPay = true,
  String? paymentCode,
  String? paymentName,
}) {
  if (leadOrderId == null || leadOrderId.isEmpty) return null;
  final params = <String, String>{};
  if (autoPay) params['autoPay'] = '1';
  final code = paymentCode?.trim();
  if (code != null && code.isNotEmpty) {
    params['paymentCode'] = code;
  }
  final name = paymentName?.trim();
  if (name != null && name.isNotEmpty) {
    params['paymentName'] = name;
  }
  final query = params.isEmpty ? '' : '?${Uri(queryParameters: params).query}';
  return '/order/$leadOrderId$query';
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
