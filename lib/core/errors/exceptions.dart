/// Exception classes thrown from the data layer.
/// These are caught by repository implementations and converted to [Failure].

/// Server mengembalikan error HTTP
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'errors.server',
    this.statusCode,
  });

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

/// Tidak ada koneksi internet
class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'errors.network_offline']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Request timeout
class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'errors.timeout']);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Token tidak valid / sesi berakhir (401)
class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'errors.unauthorized']);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Akses terlarang (403)
class ForbiddenException implements Exception {
  final String message;
  const ForbiddenException([this.message = 'errors.forbidden']);

  @override
  String toString() => 'ForbiddenException: $message';
}

/// Data tidak ditemukan (404)
class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'errors.not_found']);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Validasi gagal (422)
class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  const ValidationException({
    this.message = 'errors.validation',
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message, errors: $errors';
}

/// Gagal parsing / decode data
class ParseException implements Exception {
  final String message;
  const ParseException([this.message = 'errors.parse']);

  @override
  String toString() => 'ParseException: $message';
}

/// Cache (SharedPreferences / Hive) error
class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'errors.cache']);

  @override
  String toString() => 'CacheException: $message';
}
