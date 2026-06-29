import 'package:easy_localization/easy_localization.dart';

/// Display helper for cubit/API error strings (keys or legacy ID text).
extension LocalizedFailureMessage on String {
  String get localizedFailure => localizeFailureMessage(this);
}

/// True if [value] looks like an easy_localization key (e.g. `errors.network`).
bool isI18nKey(String value) {
  final t = value.trim();
  if (!t.contains('.')) return false;
  return RegExp(r'^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$').hasMatch(t);
}

/// Legacy Indonesian defaults → i18n keys (API / server text passes through).
const _legacyMessageKeys = <String, String>{
  'Periksa koneksi internet Anda': 'errors.network',
  'Tidak ada koneksi internet': 'errors.network_offline',
  'Kesalahan server': 'errors.server',
  'Permintaan habis waktu': 'errors.timeout',
  'Data tidak ditemukan': 'errors.not_found',
  'Sesi Anda telah berakhir. Silakan masuk kembali.': 'errors.unauthorized',
  'Anda tidak memiliki akses': 'errors.forbidden',
  'Data tidak valid': 'errors.validation',
  'Gagal membaca data lokal': 'errors.cache',
  'Gagal memproses data dari server': 'errors.parse',
  'Terjadi kesalahan tak terduga': 'errors.unexpected',
  'errors.generic': 'errors.generic',
  'Gagal mengunggah dokumen verifikasi': 'errors.verification_upload',
  'Respons server alamat kosong': 'errors.address_empty_response',
  'Gagal mengambil saldo': 'errors.wallet_balance',
  'Gagal mengambil transaksi': 'errors.wallet_transactions',
  'Gagal memproses penarikan': 'errors.wallet_withdraw',
  'Gagal mengambil daftar bank': 'errors.wallet_banks',
  'Gagal mengambil daftar rekening': 'errors.wallet_accounts_list',
  'Gagal mengambil detail rekening': 'errors.wallet_account_detail',
  'Gagal menyimpan rekening': 'errors.wallet_account_save',
  'Gagal memperbarui rekening': 'errors.wallet_account_update',
  'Gagal menghapus rekening': 'errors.wallet_account_delete',
  'Gagal memperbarui rekening utama': 'errors.wallet_account_main',
};

/// Localize a failure or snackbar message for display.
String localizeFailureMessage(String message) {
  final trimmed = message.trim();
  if (trimmed.isEmpty) return trimmed;
  if (isI18nKey(trimmed)) return trimmed.tr();
  final key = _legacyMessageKeys[trimmed];
  if (key != null) return key.tr();
  if (trimmed.startsWith('Gagal memproses data alamat:')) {
    return 'errors.address_process'.tr();
  }
  return message;
}

/// Checkout / cart: buyer profile or shipping incomplete (ID or EN server text).
bool isBuyerReadinessMessage(String message) {
  final trimmed = message.trim();
  if (trimmed == 'BUYER_NOT_READY') return true;
  if (isI18nKey(trimmed)) {
    return trimmed.startsWith('readiness.') ||
        trimmed.contains('buyer') ||
        trimmed.contains('shipping') ||
        trimmed.contains('address') ||
        trimmed.contains('recipient');
  }
  final lower = trimmed.toLowerCase();
  return lower.contains('alamat') ||
      lower.contains('address') ||
      lower.contains('pengiriman') ||
      lower.contains('shipping') ||
      lower.contains('telepon') ||
      lower.contains('phone') ||
      lower.contains('recipient') ||
      lower.contains('penerima');
}
