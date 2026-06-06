import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart'
    hide LocationService;
import '../../core/constants/app_colors.dart';
import '../../core/utils/safe_area_utils.dart';
import '../../core/services/location_service.dart';
import '../../core/utils/safe_navigator.dart';
import 'bisa_app_bar.dart';

/// Halaman pemilih lokasi interaktif berbasis OpenStreetMap + Nominatim.
class OsmLocationPickerPage extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const OsmLocationPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  static Future<PickedData?> open(
    BuildContext context, {
    double? initialLatitude,
    double? initialLongitude,
  }) {
    return Navigator.of(context).push<PickedData>(
      MaterialPageRoute(
        builder: (_) => OsmLocationPickerPage(
          initialLatitude: initialLatitude,
          initialLongitude: initialLongitude,
        ),
      ),
    );
  }

  @override
  State<OsmLocationPickerPage> createState() => _OsmLocationPickerPageState();
}

class _OsmLocationPickerPageState extends State<OsmLocationPickerPage> {
  static const _fallback = LatLong(-6.2088, 106.8456);

  late LatLong _mapPosition;
  bool _centeringOnGps = false;
  bool _gpsPending = false;

  @override
  void initState() {
    super.initState();
    if (_hasInitialCoords) {
      _mapPosition = LatLong(widget.initialLatitude!, widget.initialLongitude!);
    } else {
      _mapPosition = _fallback;
      _gpsPending = true;
      _loadGpsInBackground();
    }
  }

  bool get _hasInitialCoords {
    final lat = widget.initialLatitude;
    final lng = widget.initialLongitude;
    return lat != null && lng != null && lat != 0 && lng != 0;
  }

  Future<void> _loadGpsInBackground() async {
    final fix = await LocationService.instance.getCurrentFix();
    if (!mounted || fix == null) {
      if (mounted) setState(() => _gpsPending = false);
      return;
    }
    setState(() {
      _mapPosition = LatLong(fix.latitude, fix.longitude);
      _gpsPending = false;
    });
  }

  Future<void> _centerOnCurrentGps() async {
    if (_centeringOnGps) return;
    setState(() => _centeringOnGps = true);
    try {
      final fix = await LocationService.instance.getCurrentFix();
      if (!mounted) return;
      if (fix == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tidak dapat mengambil lokasi GPS. Periksa izin lokasi.',
            ),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }
      setState(() {
        _mapPosition = LatLong(fix.latitude, fix.longitude);
      });
    } finally {
      if (mounted) setState(() => _centeringOnGps = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const BisaAppBar(
        title: 'Cari Alamat di Peta',
        backgroundColor: Colors.white,
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: systemBottomInset(context)),
        child: FloatingActionButton.small(
          heroTag: 'osm_gps_center',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          onPressed: _centeringOnGps ? null : _centerOnCurrentGps,
          child: _centeringOnGps
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.my_location_rounded),
        ),
      ),
      body: Stack(
        children: [
          FlutterLocationPicker.withConfiguration(
            key: ValueKey(
              '${_mapPosition.latitude},${_mapPosition.longitude}',
            ),
            userAgent: 'BISA-Mobile/1.0 (contact: dev@bisa.app)',
            trackMyPosition: false,
            showCurrentLocationPointer: true,
            initPosition: _mapPosition,
            onPicked: (picked) => safeNavigatorPop(context, picked),
            onError: (e) {
              if (!mounted) return;
              showBisaSnackBarMessage(
                context,
                'Gagal memuat peta: $e',
                isError: true,
              );
            },
            mapConfiguration: const MapConfiguration(
              mapLanguage: 'id',
              initZoom: 16,
            ),
            searchConfiguration: const SearchConfiguration(
              searchBarHintText: 'Cari jalan, desa, atau landmark...',
              maxSearchResults: 8,
            ),
            selectButtonConfiguration: SelectButtonConfiguration(
              selectLocationButtonText: 'Gunakan Lokasi Ini',
              selectedLocationButtonTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              selectLocationButtonStyle: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          if (_gpsPending)
            Positioned(
              top: 8,
              left: 16,
              right: 16,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Memusatkan ke lokasi Anda...',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
