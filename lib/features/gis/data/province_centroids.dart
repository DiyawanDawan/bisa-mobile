/// Fallback marker position when waste row has no lat/lng.
const Map<String, ({double lat, double lng})> kProvinceCentroids = {
  'Jawa Barat': (lat: -6.9, lng: 107.6),
  'Jawa Tengah': (lat: -7.15, lng: 110.0),
  'Jawa Timur': (lat: -7.25, lng: 112.75),
  'DI Yogyakarta': (lat: -7.8, lng: 110.37),
  'Daerah Istimewa Yogyakarta': (lat: -7.8, lng: 110.37),
  'Banten': (lat: -6.4, lng: 106.1),
  'DKI Jakarta': (lat: -6.2, lng: 106.8),
  'Lampung': (lat: -4.9, lng: 105.3),
  'Sumatera Selatan': (lat: -3.3, lng: 104.0),
  'Sumatera Utara': (lat: 2.1, lng: 99.1),
  'Sumatera Barat': (lat: -0.9, lng: 100.4),
  'Riau': (lat: 0.5, lng: 101.5),
  'Jambi': (lat: -1.6, lng: 103.6),
  'Bengkulu': (lat: -3.8, lng: 102.3),
  'Aceh': (lat: 4.7, lng: 96.7),
  'Sulawesi Selatan': (lat: -4.4, lng: 119.9),
  'Sulawesi Utara': (lat: 1.5, lng: 124.8),
  'Sulawesi Tengah': (lat: -1.4, lng: 121.4),
  'Kalimantan Selatan': (lat: -3.3, lng: 114.6),
  'Kalimantan Barat': (lat: -0.3, lng: 111.5),
  'Kalimantan Timur': (lat: 0.5, lng: 116.2),
  'Kalimantan Tengah': (lat: -1.7, lng: 113.4),
  'Bali': (lat: -8.4, lng: 115.2),
  'Nusa Tenggara Barat': (lat: -8.58, lng: 117.5),
  'Nusa Tenggara Timur': (lat: -9.7, lng: 121.0),
  'Papua': (lat: -4.3, lng: 138.0),
  'Maluku': (lat: -3.2, lng: 129.0),
};

/// Indonesia geographic center as last-resort fallback.
const ({double lat, double lng}) kIndonesiaCentroid = (lat: -2.5, lng: 118.0);

({double lat, double lng}) resolveProvinceCentroid(String? province) {
  if (province == null || province.trim().isEmpty) return kIndonesiaCentroid;
  final key = province.trim();
  final direct = kProvinceCentroids[key];
  if (direct != null) return direct;
  final lower = key.toLowerCase();
  for (final entry in kProvinceCentroids.entries) {
    if (entry.key.toLowerCase() == lower) return entry.value;
  }
  return kIndonesiaCentroid;
}
