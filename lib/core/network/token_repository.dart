import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRepository {
  final FlutterSecureStorage _storage;
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  TokenRepository(this._storage);

  /// Dipanggil sekali saat startup bila token lama tidak bisa didekripsi (algorithm change).
  Future<void> repairStorageIfCorrupted() async {
    for (final key in [_accessTokenKey, _refreshTokenKey]) {
      try {
        await _storage.read(key: key);
      } catch (e, st) {
        debugPrint('[BISA] Secure storage rusak ($key), reset: $e\n$st');
        await _purgeAll();
        return;
      }
    }
  }

  Future<void> _purgeAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('[BISA] Gagal deleteAll secure storage: $e');
      await clearTokens();
    }
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() => _safeRead(_accessTokenKey);

  Future<String?> getRefreshToken() => _safeRead(_refreshTokenKey);

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint('[BISA] read $key gagal, bersihkan token: $e');
      await _purgeAll();
      return null;
    }
  }

  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
    } catch (e) {
      debugPrint('[BISA] clearTokens gagal, coba deleteAll: $e');
      await _purgeAll();
    }
  }

  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
