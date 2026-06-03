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
