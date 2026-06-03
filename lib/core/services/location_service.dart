import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Service terpusat untuk akses lokasi user (GPS) dan reverse-geocoding.
///
/// Fitur-fitur yang butuh izin lokasi (Cart, Checkout, GIS, Update Tracking)
/// memanggil service ini supaya:
/// - Logika permission konsisten (di-handle satu tempat)
/// - Tidak crash kalau permission ditolak / location service mati
/// - Hasil di-cache singkat (`_lastFix`) supaya UI tidak request berkali-kali
///   dalam satu sesi
///
/// Reverse-geocoding pakai **OpenStreetMap Nominatim** (gratis, tanpa API key),
/// jadi cukup ramah untuk hackathon. Production sebaiknya pakai Mapbox /
/// Google Maps Geocoding untuk SLA.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  static const _nominatimUrl = 'https://nominatim.openstreetmap.org/reverse';
  static const _userAgent = 'BISA-Mobile/1.0 (contact: dev@bisa.app)';

  LocationFix? _lastFix;
  DateTime? _lastFixAt;
  static const _cacheTtl = Duration(minutes: 5);

  /// Hasil terakhir yang sudah di-resolve (cache singkat).
  LocationFix? get cachedFix {
    if (_lastFix == null || _lastFixAt == null) return null;
    if (DateTime.now().difference(_lastFixAt!) > _cacheTtl) return null;
    return _lastFix;
  }

  /// Cek + minta izin lokasi.
  ///
  /// Return [LocationPermissionResult] yang membedakan kondisi:
  /// - `granted` → siap getPosition
  /// - `denied` → user tolak sekali, masih bisa minta lagi
  /// - `deniedForever` → user blokir permanen, arahkan ke Settings
  /// - `serviceDisabled` → GPS device dimatikan
  Future<LocationPermissionResult> ensurePermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return LocationPermissionResult.serviceDisabled;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      switch (permission) {
        case LocationPermission.always:
        case LocationPermission.whileInUse:
          return LocationPermissionResult.granted;
        case LocationPermission.denied:
          return LocationPermissionResult.denied;
        case LocationPermission.deniedForever:
          return LocationPermissionResult.deniedForever;
        case LocationPermission.unableToDetermine:
          return LocationPermissionResult.denied;
      }
    } catch (e) {
      debugPrint('[LocationService] ensurePermission error: $e');
      return LocationPermissionResult.denied;
    }
  }

  /// Ambil posisi terkini + reverse-geocode jadi alamat.
  /// Return `null` kalau gagal di tahap manapun.
  Future<LocationFix?> getCurrentFix({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final perm = await ensurePermission();
    if (perm != LocationPermissionResult.granted) {
      debugPrint('[LocationService] permission denied: $perm');
      return null;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: timeout,
        ),
      );
      final address = await _reverseGeocode(pos.latitude, pos.longitude);
      final fix = LocationFix(
        latitude: pos.latitude,
        longitude: pos.longitude,
        address: address?.fullAddress,
        city: address?.city,
        province: address?.province,
        country: address?.country,
      );
      _lastFix = fix;
      _lastFixAt = DateTime.now();
      return fix;
    } catch (e) {
      debugPrint('[LocationService] getCurrentFix error: $e');
      return null;
    }
  }

  Future<_GeocodeResult?> _reverseGeocode(double lat, double lng) async {
    try {
      final dio = Dio(
        BaseOptions(
          headers: {'User-Agent': _userAgent},
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );
      final resp = await dio.get(
        _nominatimUrl,
        queryParameters: {
          'lat': lat,
          'lon': lng,
          'format': 'jsonv2',
          'accept-language': 'id',
          'zoom': 14,
        },
      );
      final data = resp.data as Map<String, dynamic>;
      final addr = (data['address'] as Map<String, dynamic>?) ?? const {};

      final city = (addr['city'] ??
              addr['town'] ??
              addr['village'] ??
              addr['municipality'] ??
              addr['county'])
          ?.toString();
      final province = (addr['state'] ?? addr['region'])?.toString();
      final country = addr['country']?.toString();
      final full = data['display_name']?.toString();

      return _GeocodeResult(
        fullAddress: full,
        city: city,
        province: province,
        country: country,
      );
    } catch (e) {
      debugPrint('[LocationService] reverseGeocode failed: $e');
      return null;
    }
  }

  /// Untuk testing/dev: reset cache.
  void clearCache() {
    _lastFix = null;
    _lastFixAt = null;
  }
}

class LocationFix {
  final double latitude;
  final double longitude;
  final String? address;
  final String? city;
  final String? province;
  final String? country;

  const LocationFix({
    required this.latitude,
    required this.longitude,
    this.address,
    this.city,
    this.province,
    this.country,
  });

  /// Label ringkas untuk ditampilkan di UI (misal: "Bandung, Jawa Barat").
  String get shortLabel {
    if (city != null && province != null) return '$city, $province';
    if (city != null) return city!;
    if (province != null) return province!;
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }
}

enum LocationPermissionResult {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

class _GeocodeResult {
  final String? fullAddress;
  final String? city;
  final String? province;
  final String? country;

  _GeocodeResult({
    this.fullAddress,
    this.city,
    this.province,
    this.country,
  });
}
