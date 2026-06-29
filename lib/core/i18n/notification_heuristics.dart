/// Bilingual keyword heuristics for server push title/body (ID + EN).
abstract class NotificationHeuristics {
  static bool isDisputeRelated(String title, String body) {
    final hay = '$title $body'.toLowerCase();
    return hay.contains('sengketa') ||
        hay.contains('dispute') ||
        hay.contains('komplain') ||
        hay.contains('complaint');
  }

  static bool isInvoiceRelated(String type, String title, String body) {
    if (type == 'INVOICE') return true;
    final hay = '$title $body'.toLowerCase();
    return hay.contains('tagihan') ||
        hay.contains('invoice') ||
        hay.contains('bill');
  }

  static bool isKycRelated(String type, String title, String body) {
    if (type == 'KYC' || type == 'VERIFICATION') return true;
    final hay = '$title $body'.toLowerCase();
    return hay.contains('verifikasi') ||
        hay.contains('verification') ||
        hay.contains('kyc') ||
        hay.contains('dokumen akun') ||
        hay.contains('account document');
  }

  static bool needsPaymentAction(String type, String title, String body) {
    if (type == 'PAYMENT_RECEIVED') return false;
    final hay = '$title $body'.toLowerCase();
    return hay.contains('bayar') ||
        hay.contains('pay now') ||
        hay.contains('payment') ||
        hay.contains('pembayaran') ||
        hay.contains('tagihan') ||
        hay.contains('invoice') ||
        hay.contains('bill') ||
        (hay.contains('menunggu') && hay.contains('bayar')) ||
        (hay.contains('awaiting') && hay.contains('pay')) ||
        hay.contains('pending payment') ||
        hay.contains('payment pending');
  }
}
