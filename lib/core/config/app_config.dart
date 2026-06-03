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
}
