import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Konfigurasi runtime: `--dart-define` (prioritas) atau `assets/config/api_dev.json` (debug).
abstract class AppConfig {
  static const String apiUrl = String.fromEnvironment('API_URL', defaultValue: '');
  static const String mediaBaseUrl = String.fromEnvironment('MEDIA_BASE_URL', defaultValue: '');
  static const String pusherKey = String.fromEnvironment('PUSHER_KEY', defaultValue: '');
  static const String pusherCluster = String.fromEnvironment(
    'PUSHER_CLUSTER',
    defaultValue: '',
  );

  /// `development` (pre-live / QA) atau `production` (go-live).
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => appEnv.toLowerCase() != 'production';
  static bool get isProduction => appEnv.toLowerCase() == 'production';

  /// IP komputer dev untuk HP fisik (satu WiFi). Update jika IP berubah.
  static const String devLanHost = String.fromEnvironment(
    'DEV_LAN_HOST',
    defaultValue: '192.168.38.239',
  );

  static const String publicWebUrl = String.fromEnvironment(
    'PUBLIC_WEB_URL',
    defaultValue: 'https://www.bisaagri.com',
  );

  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '94564351976-o1k5d6sd9pna74e7angarlr8qrvln2pv.apps.googleusercontent.com',
  );

  /// Meta App ID (opsional). Isi lewat `--dart-define=FACEBOOK_APP_ID=...`
  /// dan mirror ke `android/local.properties` (`facebook.app.id`).
  static const String facebookAppId = String.fromEnvironment(
    'FACEBOOK_APP_ID',
    defaultValue: '',
  );

  static const String facebookClientToken = String.fromEnvironment(
    'FACEBOOK_CLIENT_TOKEN',
    defaultValue: '',
  );

  static bool get hasFacebookNativeConfig =>
      facebookAppId.isNotEmpty &&
      facebookAppId != 'FACEBOOK_APP_ID' &&
      facebookClientToken.isNotEmpty &&
      facebookClientToken != 'FACEBOOK_CLIENT_TOKEN';

  static String? _runtimeApiUrl;
  static String? _runtimeMediaBaseUrl;

  static bool _isLocalDevHost(String url) {
    final u = url.trim();
    if (u.isEmpty) return true;
    return u.contains('10.0.2.2') ||
        u.contains('localhost') ||
        u.contains('127.0.0.1') ||
        u.contains(devLanHost);
  }

  static Future<({String api, String media})?> _loadDevApiFromAsset() async {
    try {
      final raw = await rootBundle.loadString('assets/config/api_dev.json');
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final api = (map['API_URL'] as String?)?.trim() ?? '';
      if (api.isEmpty) return null;
      final media = (map['MEDIA_BASE_URL'] as String?)?.trim() ?? '';
      return (api: api, media: media);
    } catch (e) {
      debugPrint('[BISA] api_dev.json tidak terbaca: $e');
      return null;
    }
  }

  static void _applyResolvedApi(String configuredApi, String configuredMedia, String source) {
    _runtimeApiUrl = configuredApi;
    _runtimeMediaBaseUrl = configuredMedia.isNotEmpty
        ? configuredMedia
        : configuredApi.replaceAll(RegExp(r'/api/v1$'), '');
    debugPrint('[BISA] API ($source): $_runtimeApiUrl');
  }

  /// Panggil di `main()` sebelum `di.init()`.
  static Future<void> bootstrap() async {
    debugPrint('[BISA] APP_ENV=$appEnv');
    if (!kDebugMode) return;

    final fromDartDefine = apiUrl.trim();
    var configuredMedia = mediaBaseUrl.trim();
    var configuredApi = fromDartDefine;
    String source = '--dart-define';

    final fromAsset = await _loadDevApiFromAsset();
    if (fromDartDefine.isNotEmpty && !_isLocalDevHost(fromDartDefine)) {
      // Remote eksplisit dari dart-define (ngrok / staging)
      configuredApi = fromDartDefine;
      source = '--dart-define';
    } else if (fromAsset != null) {
      configuredApi = fromAsset.api;
      configuredMedia = fromAsset.media;
      source = 'api_dev.json';
    } else if (fromDartDefine.isNotEmpty) {
      configuredApi = fromDartDefine;
      source = '--dart-define';
    }

    // Flutter web: pakai localhost, jangan panggil device_info_plus (Android API di browser crash).
    if (kIsWeb) {
      if (configuredApi.isEmpty || !_isLocalDevHost(configuredApi)) {
        configuredApi = _staticDebugApiUrl;
        configuredMedia = _staticDebugMediaBaseUrl;
        source = configuredApi.contains('localhost')
            ? 'web-localhost (hindari CORS ngrok)'
            : 'web-default';
      }
      _applyResolvedApi(configuredApi, configuredMedia, source);
      return;
    }

    // ngrok / staging / remote — jangan timpa dengan localhost di HP fisik
    if (configuredApi.isNotEmpty && !_isLocalDevHost(configuredApi)) {
      _applyResolvedApi(configuredApi, configuredMedia, source);
      return;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final android = await DeviceInfoPlugin().androidInfo;
      final isPhysical = android.isPhysicalDevice;

      if (isPhysical) {
        final useLan = const bool.fromEnvironment('USE_LAN_HOST', defaultValue: false);
        final host = useLan ? devLanHost.trim() : '127.0.0.1';
        final needsReplace = _isLocalDevHost(configuredApi);

        if (needsReplace) {
          _runtimeApiUrl = 'http://$host:3000/api/v1';
          _runtimeMediaBaseUrl = 'http://$host:3000';
          debugPrint(
            '[BISA] HP fisik — API: $_runtimeApiUrl'
            '${useLan ? ' (WiFi/LAN)' : ' (USB adb reverse — jalankan setup-phone-dev.ps1)'}',
          );
          return;
        }
      } else if (configuredApi.isEmpty) {
        _runtimeApiUrl = 'http://10.0.2.2:3000/api/v1';
        _runtimeMediaBaseUrl = 'http://10.0.2.2:3000';
        debugPrint('[BISA] Emulator terdeteksi — API: $_runtimeApiUrl');
        return;
      }
    }

    if (configuredApi.isEmpty) {
      _runtimeApiUrl = _staticDebugApiUrl;
      _runtimeMediaBaseUrl = _staticDebugMediaBaseUrl;
      debugPrint('[BISA] Fallback dev — API: $_runtimeApiUrl');
      return;
    }

    _applyResolvedApi(configuredApi, configuredMedia, '--dart-define');
  }

  static String get effectiveApiUrl {
    if (_runtimeApiUrl != null) return _runtimeApiUrl!;
    final configured = apiUrl.trim();
    if (configured.isNotEmpty) return configured;
    if (kDebugMode) return _staticDebugApiUrl;
    return '';
  }

  static String get effectiveMediaBaseUrl {
    if (_runtimeMediaBaseUrl != null) return _runtimeMediaBaseUrl!;
    final configured = mediaBaseUrl.trim();
    if (configured.isNotEmpty) return configured;
    if (kDebugMode) return _staticDebugMediaBaseUrl;
    return '';
  }

  static bool get isApiConfigured => effectiveApiUrl.isNotEmpty;

  static String get _staticDebugApiUrl {
    if (kIsWeb) return 'http://localhost:3000/api/v1';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000/api/v1';
      default:
        return 'http://localhost:3000/api/v1';
    }
  }

  static String get _staticDebugMediaBaseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      default:
        return 'http://localhost:3000';
    }
  }
}
