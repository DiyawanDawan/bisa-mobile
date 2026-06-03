import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'request_telemetry.dart';
import 'token_repository.dart';

/// Base URL constants
abstract class ApiConstants {
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}

/// Singleton Dio client with interceptors for Auth and Refresh Token.
///
/// SEC-MOB-009: refresh token guarded by `_refreshCompleter` agar concurrent
/// 401 hanya memicu satu refresh request. Sebelumnya N request paralel bisa
/// memicu N refresh, dan karena token rotation, salah satu refresh akan invalidate
/// yang lain → user di-logout walaupun sesi sebenarnya valid.
///
/// SEC-MOB-011: Authorization header di-redact saat dilewatkan ke Talker logger
/// (printRequestHeaders=false). Dipertahankan eksplisit di sini agar tidak
/// regress di refactor mendatang.
class ApiClient {
  final TokenRepository _tokenRepository;
  final String _baseUrl;
  late final Dio _dio;

  Completer<String?>? _refreshCompleter;

  ApiClient(this._tokenRepository, this._baseUrl) {
    _init();
  }

  Dio get dio => _dio;

  void _init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          // SEC-MOB-011: hindari log header (Authorization) & body (password/token).
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseMessage: true,
          printRequestData: false,
          printResponseData: false,
        ),
      ));
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenRepository.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          RequestTelemetry.onSuccess(response);
          return handler.next(response);
        },
        onError: (DioException err, handler) async {
          RequestTelemetry.onError(err);
          if (err.response?.statusCode == 401 &&
              !err.requestOptions.path.contains('/auth/login') &&
              !err.requestOptions.path.contains('/auth/refresh-token')) {

            final newAccessToken = await _refreshTokenOnce();

            if (newAccessToken != null) {
              // FormData tidak bisa di-replay setelah dibaca — minta user simpan ulang.
              if (err.requestOptions.data is FormData) {
                return handler.reject(
                  DioException(
                    requestOptions: err.requestOptions,
                    response: Response(
                      requestOptions: err.requestOptions,
                      statusCode: 401,
                      data: {
                        'meta': {
                          'message':
                              'Sesi diperbarui. Silakan tekan Simpan lagi.',
                        },
                      },
                    ),
                    type: DioExceptionType.badResponse,
                  ),
                );
              }

              final options = err.requestOptions;
              options.headers['Authorization'] = 'Bearer $newAccessToken';

              try {
                final retryResponse = await _dio.fetch(options);
                return handler.resolve(retryResponse);
              } catch (retryErr) {
                if (retryErr is DioException) return handler.next(retryErr);
                rethrow;
              }
            }
          }
          return handler.next(err);
        },
      ),
    );
  }

  /// SEC-MOB-009: pastikan hanya satu refresh inflight pada satu waktu.
  /// Caller yang menemukan refresh sedang berjalan akan menunggu hasilnya
  /// daripada memicu refresh paralel.
  Future<String?> _refreshTokenOnce() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }
    final completer = Completer<String?>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await _tokenRepository.getRefreshToken();
      if (refreshToken == null) {
        completer.complete(null);
        return null;
      }

      final refreshDio = Dio(BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ));

      final response = await refreshDio.post(
        '/auth/refresh-token',
        data: {'token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final newAccessToken = data['accessToken'] as String?;
        final newRefreshToken = data['refreshToken'] as String?;
        if (newAccessToken != null && newRefreshToken != null) {
          await _tokenRepository.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );
          completer.complete(newAccessToken);
          return newAccessToken;
        }
      }
      completer.complete(null);
      return null;
    } catch (e) {
      await _tokenRepository.clearTokens();
      completer.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }
}
