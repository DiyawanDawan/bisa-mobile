import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/domain/repositories/order_repository.dart';

/// Hasil keluar WebView — callback URL terdeteksi, bukan konfirmasi server.
enum PaymentWebViewExit {
  /// Redirect sukses/gagal terdeteksi; wajib poll API sebelum UI sukses.
  callbackDetected,
  failed,
  dismissed,
}

/// Parse nilai pop dari route `/payment-webview`.
PaymentWebViewExit parsePaymentWebViewExit(Object? value) {
  if (value == false || value == PaymentWebViewExit.failed) {
    return PaymentWebViewExit.failed;
  }
  if (value == true ||
      value == PaymentWebViewExit.callbackDetected ||
      value == 'callback_detected') {
    return PaymentWebViewExit.callbackDetected;
  }
  return PaymentWebViewExit.dismissed;
}

bool isOrderPaid(OrderEntity order) {
  final status = order.status.toUpperCase();
  if (status == 'PAID' ||
      status == 'PROCESSING' ||
      status == 'CONFIRMED' ||
      status == 'COMPLETED') {
    return true;
  }
  final payStatus = order.transaction?.paymentStatus?.toUpperCase() ?? '';
  return payStatus == 'SUCCESS' || payStatus == 'PAID';
}

/// Poll order detail sampai status pembayaran terkonfirmasi server-side.
Future<bool> pollOrderPaymentStatus(
  OrderRepository repository,
  String orderId, {
  int maxAttempts = 10,
  Duration interval = const Duration(seconds: 3),
}) async {
  for (var i = 0; i < maxAttempts; i++) {
    final result = await repository.getOrderDetail(orderId);
    final paid = result.fold((_) => false, isOrderPaid);
    if (paid) return true;
    if (i < maxAttempts - 1) {
      await Future.delayed(interval);
    }
  }
  return false;
}
