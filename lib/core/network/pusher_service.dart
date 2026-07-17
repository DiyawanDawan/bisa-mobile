import 'package:dio/dio.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:developer';
import 'package:mobile_bisa/core/config/app_config.dart';

/// SEC-MOB-004: PusherService dengan dukungan **private channel**.
///
/// Kontrak baru:
/// - Channel name harus diawali `private-` untuk private channels.
/// - `onAuthorizer` memanggil endpoint backend `/pusher/auth` (memerlukan JWT)
///   yang memvalidasi user adalah participant negotiation/forum sebelum sign.
///
/// Backend wajib menyediakan `POST /api/v1/pusher/auth` yang:
///   1. Cek JWT (requireAuth).
///   2. Parse `channel_name` dari form body.
///   3. Untuk `private-negotiation-{id}` → verifikasi user.id == buyerId || sellerId.
///   4. Untuk `private-support-{id}` → verifikasi user.id == ticket.userId || ADMIN.
///   5. Return `pusher.authorizeChannel(socketId, channel)` response.
///
/// Catatan: `ApiClient` Dio singleton di-pass via `setAuthDio` agar interceptor
/// JWT terbawa.
class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  bool _initialized = false;
  bool _connected = false;
  String? _activeChannel;
  Dio? _authDio;

  bool get isConnected => _connected;

  /// Inject Dio yang sudah punya interceptor JWT (untuk private channel auth).
  /// Panggil sekali saat app start (di `injection_container.dart`).
  void setAuthDio(Dio dio) {
    _authDio = dio;
  }

  Future<void> init({
    required String channelName,
    required Function(PusherEvent event) onEvent,
  }) async {
    try {
      if (!_initialized) {
        const apiKey = AppConfig.pusherKey;
        const cluster = AppConfig.pusherCluster;
        if (apiKey.isEmpty || cluster.isEmpty) {
          log(
            'Pusher: PUSHER_KEY/PUSHER_CLUSTER kosong. Set via --dart-define saat run/build.',
          );
          return;
        }

        await pusher.init(
          apiKey: apiKey,
          cluster: cluster,
          onEvent: (PusherEvent event) {
            log('Pusher Event: ${event.eventName} on ${event.channelName}');
            onEvent(event);
          },
          onAuthorizer: _authorizePrivateChannel,
        );
        _initialized = true;
      }

      if (_activeChannel != null && _activeChannel != channelName) {
        try {
          await pusher.unsubscribe(channelName: _activeChannel!);
        } catch (e) {
          log('Pusher unsubscribe warning: $e');
        }
      }

      await pusher.subscribe(channelName: channelName);
      _activeChannel = channelName;

      if (!_connected) {
        await pusher.connect();
        _connected = true;
      }
    } catch (e) {
      log('Pusher Error: $e');
    }
  }

  /// SEC-MOB-004: handler untuk private channel auth.
  /// Dipanggil oleh pusher SDK saat subscribe ke channel `private-*`.
  Future<dynamic> _authorizePrivateChannel(
    String channelName,
    String socketId,
    dynamic options,
  ) async {
    final dio = _authDio;
    if (dio == null) {
      log('Pusher auth: Dio belum di-inject (setAuthDio). Private channel akan gagal.');
      return null;
    }
    try {
      final response = await dio.post(
        '/pusher/auth',
        data: FormData.fromMap({
          'socket_id': socketId,
          'channel_name': channelName,
        }),
      );
      // Pusher expects: { auth: "key:hmac", channel_data?: "..." }
      return response.data;
    } catch (e) {
      log('Pusher auth FAILED for $channelName: $e');
      return null;
    }
  }

  Future<void> subscribe(String channelName) async {
    if (!_initialized) return;
    await pusher.subscribe(channelName: channelName);
    _activeChannel = channelName;
  }

  Future<void> unsubscribe(String channelName) async {
    if (!_initialized) return;
    try {
      await pusher.unsubscribe(channelName: channelName);
      if (_activeChannel == channelName) _activeChannel = null;
    } catch (e) {
      log('Pusher unsubscribe error: $e');
    }
  }

  Future<void> disconnect() async {
    if (!_initialized && !_connected) return;

    try {
      await pusher.disconnect();
    } catch (e) {
      // Plugin Android melempar NPE jika disconnect dipanggil tanpa init/connect.
      log('Pusher disconnect error (ignored): $e');
    } finally {
      _initialized = false;
      _connected = false;
      _activeChannel = null;
    }
  }
}
