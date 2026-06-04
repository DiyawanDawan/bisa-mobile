import '../utils/router.dart';
import '../../features/notifications/presentation/utils/notification_ui_utils.dart';

/// Deep link dari push / tap notifikasi lokal (§29).
abstract class NotificationNavigation {
  static void handle(Map<String, dynamic> data) {
    final type = data['type']?.toString().toUpperCase() ?? '';
    final refId = data['refId']?.toString() ?? data['id']?.toString();
    final title = data['title']?.toString() ?? '';
    final body = data['body']?.toString() ?? '';
    final negotiationId = data['negotiationId']?.toString();

    final isDispute = type == 'DISPUTE' ||
        type == 'ORDER_DISPUTE' ||
        ((type == 'ORDER' || type == 'ORDER_STATUS') &&
            notificationIsDisputeRelatedFromText(title, body));

    if (isDispute && refId != null && refId.isNotEmpty) {
      goRouter.push('/order/$refId');
      return;
    }

    if (_isInvoiceNotification(type, title, body) &&
        negotiationId != null &&
        negotiationId.isNotEmpty) {
      goRouter.push('/negotiation/$negotiationId/review-invoice');
      return;
    }

    if ((type == 'ORDER' ||
            type == 'ORDER_STATUS' ||
            type == 'PAYMENT' ||
            type == 'PAYMENT_RECEIVED') &&
        refId != null &&
        refId.isNotEmpty) {
      final autoPay = _shouldOpenPaymentFlow(type, title, body);
      if (autoPay) {
        goRouter.push('/order/$refId', extra: {'autoPay': true});
      } else {
        goRouter.push('/order/$refId');
      }
      return;
    }

    if (type == 'NEGOTIATION' && refId != null && refId.isNotEmpty) {
      goRouter.push('/negotiation/$refId');
      return;
    }

    if (_isKycNotification(type, title, body)) {
      goRouter.push('/verification');
      return;
    }

    final notificationId = data['notificationId']?.toString();
    if (notificationId != null && notificationId.isNotEmpty) {
      goRouter.push('/notifications/$notificationId');
      return;
    }

    if (type == 'IOT_ALERT') {
      goRouter.push('/iot-dashboard');
      return;
    }
    if (type == 'WALLET' || type == 'PAYMENT') {
      goRouter.push('/wallet');
      return;
    }
    if (type == 'MARKET' || type == 'MARKET_INSIGHT') {
      goRouter.push('/market-insight');
      return;
    }
    if (type == 'FORUM' && refId != null && refId.isNotEmpty) {
      goRouter.push('/forum-detail/$refId');
      return;
    }

    goRouter.push('/notifications');
  }

  static bool _isInvoiceNotification(String type, String title, String body) {
    final hay = '$title $body'.toLowerCase();
    return hay.contains('tagihan') ||
        hay.contains('invoice') ||
        type == 'INVOICE';
  }

  static bool _isKycNotification(String type, String title, String body) {
    if (type == 'KYC' || type == 'VERIFICATION') return true;
    final hay = '$title $body'.toLowerCase();
    return hay.contains('verifikasi') ||
        hay.contains('kyc') ||
        hay.contains('dokumen akun');
  }

  static bool _shouldOpenPaymentFlow(String type, String title, String body) {
    if (type == 'PAYMENT_RECEIVED') return false;
    final hay = '$title $body'.toLowerCase();
    return hay.contains('bayar') ||
        hay.contains('tagihan') ||
        hay.contains('pembayaran') ||
        hay.contains('menunggu') && hay.contains('bayar') ||
        hay.contains('pending');
  }
}
