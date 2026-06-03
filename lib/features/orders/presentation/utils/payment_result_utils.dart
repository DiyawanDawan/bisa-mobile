/// Cek apakah response `/pay` sudah punya VA/QR/link yang bisa ditampilkan.
bool paymentInstructionsReady(Map<String, dynamic> data) {
  final mode = (data['mode'] as String?)?.toUpperCase() ?? '';
  if (mode == 'WEB') {
    final url = data['invoiceUrl']?.toString();
    return url != null && url.isNotEmpty;
  }

  if (mode != 'DIRECT') return false;

  final raw = data['paymentData'];
  if (raw is! Map) return false;
  final pd = Map<String, dynamic>.from(raw);

  String? pick(List<String> keys) {
    for (final k in keys) {
      final v = pd[k];
      if (v != null && v.toString().trim().isNotEmpty) return v.toString();
    }
    return null;
  }

  final va = pick([
    'virtual_account_number',
    'virtualAccountNumber',
    'account_number',
    'accountNumber',
    'payment_code',
    'paymentCode',
  ]);
  if (va != null) return true;

  final qr = pick(['qr_string', 'qrString', 'qr_code', 'qrCode']);
  if (qr != null) return true;

  final redirect = pick(['redirectUrl', 'redirect_url']);
  return redirect != null;
}
