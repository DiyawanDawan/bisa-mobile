import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';

// ── UseCase base class ────────────────────────────────────────────────────────

/// Base class untuk semua UseCase dengan parameter
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Base class untuk UseCase tanpa parameter
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

// ── NoParams ──────────────────────────────────────────────────────────────────

class NoParams {}

// ── DioException → Failure converter ─────────────────────────────────────────

/// Konversi [DioException] ke [Failure] untuk digunakan di repository
Failure dioExceptionToFailure(DioException e) {
  final error = e.error;

  if (error is UnauthorizedException) return UnauthorizedFailure(error.message);
  if (error is ForbiddenException) return ForbiddenFailure(error.message);
  if (error is NotFoundException) return NotFoundFailure(error.message);
  if (error is NetworkException) return NetworkFailure(error.message);
  if (error is TimeoutException) return TimeoutFailure(error.message);
  if (error is ValidationException) {
    return ValidationFailure(message: error.message, errors: error.errors);
  }
  if (error is ServerException) {
    return ServerFailure(
        message: error.message, statusCode: error.statusCode);
  }

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    default:
      return const UnexpectedFailure();
  }
}

// ── General helpers ───────────────────────────────────────────────────────────

/// Format angka ribuan dengan titik: 1500000 → "1.500.000"
String formatNumber(num value) {
  return value.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

/// Cek apakah string adalah URL valid
bool isValidUrl(String url) {
  return Uri.tryParse(url)?.hasAbsolutePath ?? false;
}

/// Safe parse int, return [defaultValue] jika gagal
int safeParseInt(dynamic value, {int defaultValue = 0}) {
  if (value == null) return defaultValue;
  return int.tryParse(value.toString()) ?? defaultValue;
}

/// Safe parse double, return [defaultValue] jika gagal
double safeParseDouble(dynamic value, {double defaultValue = 0.0}) {
  if (value == null) return defaultValue;
  return double.tryParse(value.toString()) ?? defaultValue;
}

/// Masking email: "user@example.com" → "us***@example.com"
String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;
  final name = parts[0];
  final domain = parts[1];
  final visible = name.length > 2 ? name.substring(0, 2) : name[0];
  return '$visible***@$domain';
}

/// Masking nomor telepon: "081234567890" → "0812****7890"
String maskPhone(String phone) {
  if (phone.length < 8) return phone;
  final start = phone.substring(0, 4);
  final end = phone.substring(phone.length - 4);
  final masked = '*' * (phone.length - 8);
  return '$start$masked$end';
}
