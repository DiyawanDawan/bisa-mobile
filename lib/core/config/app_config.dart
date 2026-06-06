/// Konfigurasi runtime berbasis `--dart-define`.
///
/// Contoh:
/// flutter run --dart-define=API_URL=https://api.example.com/api/v1
/// flutter run --dart-define=PUSHER_KEY=xxx --dart-define=PUSHER_CLUSTER=ap1
abstract class AppConfig {
  static const String apiUrl = String.fromEnvironment('API_URL', defaultValue: '');
  static const String mediaBaseUrl = String.fromEnvironment('MEDIA_BASE_URL', defaultValue: '');
  static const String pusherKey = String.fromEnvironment('PUSHER_KEY', defaultValue: '');
  static const String pusherCluster = String.fromEnvironment(
    'PUSHER_CLUSTER',
    defaultValue: '',
  );

  /// Base URL halaman publik verifikasi/lacak (admin web). Contoh: http://localhost:3001
  static const String publicWebUrl = String.fromEnvironment(
    'PUBLIC_WEB_URL',
    defaultValue: 'http://localhost:3001',
  );

  /// Google OAuth server client ID (--dart-define=GOOGLE_SERVER_CLIENT_ID=...)
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue:
        '94564351976-o1k5d6sd9pna74e7angarlr8qrvln2pv.apps.googleusercontent.com',
  );

  static bool get isApiConfigured => apiUrl.trim().isNotEmpty;
}
