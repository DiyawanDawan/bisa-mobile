import 'package:equatable/equatable.dart';

import '../i18n/failure_messages.dart';

/// Base class for all domain-level failures
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  /// User-facing message in the active locale.
  String get localizedMessage => localizeFailureMessage(message);

  @override
  List<Object> get props => [message];
}

/// Network / koneksi internet bermasalah
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'errors.network']);
}

/// Server mengembalikan error (5xx)
class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure({String message = 'errors.server', this.statusCode})
      : super(message);

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Request timeout
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'errors.timeout']);
}

/// Tidak ditemukan (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'errors.not_found']);
}

/// Tidak diizinkan / sesi berakhir (401)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'errors.unauthorized']);
}

/// Akses terlarang (403)
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'errors.forbidden']);
}

/// Validasi data gagal (422)
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;
  const ValidationFailure({
    String message = 'errors.validation',
    this.errors,
  }) : super(message);

  @override
  List<Object> get props => [message, errors ?? {}];
}

/// Cache lokal bermasalah
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'errors.cache']);
}

/// Error tak terduga
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'errors.unexpected']);
}

/// Profil toko / pembeli belum lengkap (422 + code readiness)
class ReadinessFailure extends Failure {
  final String code;
  final List<String> missing;

  const ReadinessFailure({
    required this.code,
    required String message,
    this.missing = const [],
  }) : super(message);

  @override
  List<Object> get props => [message, code, missing];
}
