/// Exception classes thrown from the data layer.
/// These are caught by repository implementations and converted to [Failure].

/// Server mengembalikan error HTTP
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Kesalahan server',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

/// Tidak ada koneksi internet
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Tidak ada koneksi internet']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Request timeout
class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Permintaan habis waktu']);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Token tidak valid / sesi berakhir (401)
class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException(
      [this.message = 'Sesi Anda telah berakhir. Silakan masuk kembali.']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Akses terlarang (403)
class ForbiddenException implements Exception {
  final String message;
  const ForbiddenException([this.message = 'Anda tidak memiliki akses']);

  @override
  String toString() => 'ForbiddenException: $message';
}

/// Data tidak ditemukan (404)
class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Data tidak ditemukan']);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Validasi gagal (422)
class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  const ValidationException({
    this.message = 'Data tidak valid',
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message, errors: $errors';
}

/// Gagal parsing / decode data
class ParseException implements Exception {
  final String message;
  const ParseException([this.message = 'Gagal memproses data dari server']);

  @override
  String toString() => 'ParseException: $message';
}

/// Cache (SharedPreferences / Hive) error
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Gagal membaca data lokal']);

  @override
  String toString() => 'CacheException: $message';
}
