/// Batas waktu default jika Xendit tidak mengirim `expiryDate` (invoice VA umumnya 24 jam).
const Duration paymentExpiryFallbackDuration = Duration(hours: 24);

/// Parse tanggal kedaluwarsa dari string ISO / timestamp.
DateTime? parsePaymentExpiryDate(dynamic raw) {
  if (raw == null) return null;
  if (raw is DateTime) return raw.toLocal();
  final text = raw.toString().trim();
  if (text.isEmpty) return null;
  final parsed = DateTime.tryParse(text);
  return parsed?.toLocal();
}

/// Ambil `expiryDate` dari payload pembayaran (init / pendingPayment).
DateTime? expiryFromPaymentPayload(Map<String, dynamic>? payload) {
  if (payload == null || payload.isEmpty) return null;
  final direct = parsePaymentExpiryDate(payload['expiryDate']);
  if (direct != null) return direct;

  final paymentData = payload['paymentData'];
  if (paymentData is Map) {
    final nested = parsePaymentExpiryDate(
      paymentData['expires_at'] ??
          paymentData['expiresAt'] ??
          paymentData['expiry_date'] ??
          paymentData['expiryDate'],
    );
    if (nested != null) return nested;
  }

  return null;
}

/// Tentukan waktu kedaluwarsa: dari API, atau fallback dari waktu pesanan dibuat.
DateTime? resolvePaymentExpiresAt({
  Map<String, dynamic>? pendingPayment,
  DateTime? orderCreatedAt,
}) {
  final fromPayload = expiryFromPaymentPayload(pendingPayment);
  if (fromPayload != null) return fromPayload;
  if (orderCreatedAt != null) {
    return orderCreatedAt.add(paymentExpiryFallbackDuration);
  }
  return null;
}

bool isPaymentExpired({
  DateTime? expiresAt,
  String? paymentStatus,
}) {
  final status = paymentStatus?.toUpperCase() ?? '';
  if (status == 'EXPIRED') return true;
  if (expiresAt == null) return false;
  return DateTime.now().isAfter(expiresAt);
}

Duration? remainingUntilPaymentExpiry(DateTime? expiresAt) {
  if (expiresAt == null) return null;
  final diff = expiresAt.difference(DateTime.now());
  if (diff.isNegative) return Duration.zero;
  return diff;
}

/// Format hitung mundur `HH:MM:SS` atau `MM:SS` jika kurang dari 1 jam.
String formatPaymentCountdown(Duration remaining) {
  final totalSeconds = remaining.inSeconds;
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;
  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}

String formatPaymentExpiryDateTime(DateTime expiresAt) {
  final local = expiresAt.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = _monthShort(local.month);
  final year = local.year;
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day $month $year, $hour:$minute';
}

String _monthShort(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  if (month < 1 || month > 12) return '';
  return months[month - 1];
}
