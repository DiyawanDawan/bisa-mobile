import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/features/gis/domain/entities/waste_point_entity.dart';
import 'package:mobile_bisa/features/gis/presentation/bloc/gis_cubit.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:geolocator/geolocator.dart';

class WasteMappingPage extends StatefulWidget {
  const WasteMappingPage({super.key});

  @override
  State<WasteMappingPage> createState() => _WasteMappingPageState();
}

class _WasteMappingPageState extends State<WasteMappingPage> {
  final MapController _mapController = MapController();

  // State
  String _selectedType = 'Semua';
  bool _isSatellite = true;
  bool _showChoropleth = true;
  bool _showBottomPanel = false;
  WastePointEntity? _selectedPoint;
  String? _selectedProvince;
  final LayerHitNotifier<String> _hitNotifier = ValueNotifier(null);

  // GeoJSON choropleth
  List<Polygon<String>> _choroplethPolygons = [];
  bool _geoJsonLoaded = false;
  bool _geoJsonParsed = false; // Flag to prevent infinite parsing loops
  Map<String, double> _provinceStats = {};

  final List<Map<String, dynamic>> _typeFilters = [
    {
      'key': 'Semua',
      'label': 'Semua',
      'icon': LucideIcons.leaf,
      'color': AppColors.primary,
    },
    {
      'key': 'SEKAM_PADI',
      'label': 'Sekam Padi',
      'icon': LucideIcons.wheat,
      'color': Colors.orange,
    },
    {
      'key': 'TONGKOL_JAGUNG',
      'label': 'Jagung',
      'icon': LucideIcons.sprout,
      'color': Colors.yellow.shade800,
    },
    {
      'key': 'TEMPURUNG_KELAPA',
      'label': 'Kelapa',
      'icon': LucideIcons.nut,
      'color': AppColors.mapLandBrown,
    },
    {
      'key': 'BIOCHAR',
      'label': 'Biochar',
      'icon': LucideIcons.flame,
      'color': Colors.deepOrange,
    },
  ];

  String get _tileUrl => _isSatellite
      ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
      : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    try {
      final String geoJsonString = await rootBundle.loadString(
        'assets/indonesia_provinces.json',
      );
      setState(() {
        _geoJsonLoaded = true;
        _rebuildChoropleth(geoJsonString);
      });
    } catch (e) {
      debugPrint('GeoJSON load failed: $e');
    }
  }

  void _rebuildChoropleth(String geoJsonString) {
    try {
      final data = jsonDecode(geoJsonString);
      final features = data['features'] as List;
      final List<Polygon<String>> newPolygons = [];

      for (final feature in features) {
        try {
          final properties = feature['properties'] ?? {};
          final propName = (properties['Propinsi'] as String? ?? '')
              .toUpperCase();
          final volume = _provinceStats[propName] ?? 0.0;
          final color = _getChoroplethColor(
            volume.toDouble(),
          ).withOpacity(0.65);

          final geometry = feature['geometry'];
          if (geometry == null) continue;

          final type = (geometry['type'] as String).toLowerCase();
          final coordinates = geometry['coordinates'] as List;

          if (type == 'polygon') {
            final points = _parsePolygon(coordinates);
            if (points.isNotEmpty) {
              newPolygons.add(
                Polygon<String>(
                  points: points,
                  color: color,
                  borderColor: Colors.white,
                  borderStrokeWidth: 1.5,
                  hitValue: propName,
                ),
              );
            }
          } else if (type == 'multipolygon') {
            for (final polyCoords in coordinates) {
              final points = _parsePolygon(polyCoords);
              if (points.isNotEmpty) {
                newPolygons.add(
                  Polygon<String>(
                    points: points,
                    color: color,
                    borderColor: Colors.white,
                    borderStrokeWidth: 1.5,
                    hitValue: propName,
                  ),
                );
              }
            }
          }
        } catch (e) {
          debugPrint('Error parsing single feature: $e');
        }
      }

      _choroplethPolygons = newPolygons;
      _geoJsonParsed = true;
      debugPrint('Successfully parsed ${_choroplethPolygons.length} polygons');
    } catch (e) {
      _geoJsonParsed =
          true; // Set to true even on failure to avoid infinite loops
      debugPrint('Error parsing GeoJSON data: $e');
    }
  }

  List<LatLng> _parsePolygon(List coordinates) {
    if (coordinates.isEmpty) return [];
    final ring = coordinates[0] as List;
    return ring.map((point) {
      final lon = (point[0] as num).toDouble();
      final lat = (point[1] as num).toDouble();
      return LatLng(lat, lon);
    }).toList();
  }

  Color _getChoroplethColor(double volume) {
    if (volume >= 400000) return AppColors.mapVolumeHighest; // dark green
    if (volume >= 200000) return AppColors.secondary; // medium green
    if (volume >= 100000) return AppColors.mapVolumeMid; // light green
    if (volume > 0) return AppColors.mapVolumeLow; // very light
    return AppColors.grey300; // grey (no data)
  }

  List<WastePointEntity> _applyFilter(List<WastePointEntity> points) {
    var filtered = points;
    if (_selectedType != 'Semua') {
      filtered = filtered
          .where((p) => p.biomassaType.contains(_selectedType))
          .toList();
    }
    if (_selectedProvince != null) {
      filtered = filtered
          .where((p) => p.province.toUpperCase() == _selectedProvince)
          .toList();
    }
    return filtered;
  }

  void _recalcStats(List<WastePointEntity> points) {
    final Map<String, double> stats = {};
    for (final p in points) {
      final key = p.province.toUpperCase();
      stats[key] = (stats[key] ?? 0) + p.volumeTon;
    }
    _provinceStats = stats;
  }

  Map<String, double> _calcTopStats(List<WastePointEntity> points) {
    final Map<String, double> stats = {};
    for (final p in points) {
      final key = p.biomassaType.replaceAll('_', ' ');
      stats[key] = (stats[key] ?? 0) + p.volumeTon;
    }
    final sorted = stats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sorted.take(5));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GisCubit>()..getWastePoints(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: BisaAppBar(
          title: 'Peta Sebaran Limbah',
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () =>
                  setState(() => _showChoropleth = !_showChoropleth),
              icon: Icon(
                LucideIcons.layers,
                color: _showChoropleth ? AppColors.primary : Colors.grey,
                size: 20.sp,
              ),
              tooltip: 'Toggle Wilayah',
            ),
            IconButton(
              onPressed: () => setState(() => _isSatellite = !_isSatellite),
              icon: Icon(
                _isSatellite ? LucideIcons.map : LucideIcons.globe,
                color: AppColors.primary,
                size: 20.sp,
              ),
              tooltip: _isSatellite ? 'Peta Standar' : 'Peta Satelit',
            ),
          ],
        ),
        body: BlocBuilder<GisCubit, GisState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => Stack(
                children: [
                  Container(color: AppColors.grey100),
                  ShimmerListPlaceholder(
                    itemCount: 4,
                    itemHeight: 72.h,
                    scrollable: true,
                    padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
                  ),
                ],
              ),
              error: (msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.mapPinOff,
                      size: 40.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      msg,
                      style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
              wasteMapLoaded: (points) {
                final filtered = _applyFilter(points);
                _recalcStats(points); // always use all points for choropleth

                // Rebuild choropleth when stats change
                if (_geoJsonLoaded && !_geoJsonParsed) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    try {
                      final String geoJsonString = await rootBundle.loadString(
                        'assets/indonesia_provinces.json',
                      );
                      if (mounted)
                        setState(() => _rebuildChoropleth(geoJsonString));
                    } catch (_) {}
                  });
                }

                final topStats = _calcTopStats(points);
                return _buildMap(context, filtered, topStats);
              },
              matchLoaded: (data) {
                // Show match results in a bottom sheet
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _showMatchResultsSheet(context, data);
                });
                return const Center(
                  child: Text('Hasil pencocokan suplai berhasil dimuat.'),
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMap(
    BuildContext context,
    List<WastePointEntity> filtered,
    Map<String, double> topStats,
  ) {
    return Stack(
      children: [
        // ── MAP ──
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: LatLng(-2.5, 118.0),
            initialZoom: 5.0,
          ),
          children: [
            TileLayer(
              urlTemplate: _tileUrl,
              userAgentPackageName: 'com.bisa.app',
              subdomains: const ['a', 'b', 'c'],
            ),

            // ── CHOROPLETH (Province boundaries) ──
            if (_showChoropleth && _choroplethPolygons.isNotEmpty)
              GestureDetector(
                onTap: () {
                  final hit = _hitNotifier.value;
                  if (hit != null && hit.hitValues.isNotEmpty) {
                    setState(() {
                      _selectedProvince = hit.hitValues.first;
                      _selectedPoint = null;
                      _showBottomPanel = true;
                    });
                  }
                },
                child: PolygonLayer(
                  hitNotifier: _hitNotifier,
                  polygons: _choroplethPolygons,
                ),
              ),

            // ── WASTE POINT MARKERS ──
            MarkerLayer(
              markers: filtered.map((point) {
                final isSelected = point == _selectedPoint;
                return Marker(
                  point: LatLng(point.lat, point.lng),
                  width: isSelected ? 48.w : 38.w,
                  height: isSelected ? 48.w : 38.w,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedPoint = point;
                      _showBottomPanel = true;
                    }),
                    child: _buildMarker(point.biomassaType, isSelected),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // ── TYPE FILTER CHIPS ──
        Positioned(
          top: 12.h,
          left: 12.w,
          right: 12.w,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _typeFilters.map((filter) {
                final isSelected = _selectedType == filter['key'];
                final color = filter['color'] as Color;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedType = filter['key'] as String;
                    _showBottomPanel = false;
                    _selectedPoint = null;
                    _selectedProvince = null;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          filter['icon'] as IconData,
                          size: 14.sp,
                          color: isSelected ? Colors.white : color,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          filter['label'] as String,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // ── STATS BADGE ──
        Positioned(
          top: 62.h,
          right: 12.w,
          child: GestureDetector(
            onTap: () => _showStatsSheet(context, topStats, filtered.length),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.chartBar,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${filtered.length} Titik (${_choroplethPolygons.length} Poly)',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── CHOROPLETH LEGEND (bottom-left corner) ──
        if (_showChoropleth)
          Positioned(
            bottom: gisMapFloatingBottomOffset(
              context,
              panelOpen: _showBottomPanel,
            ),
            left: 12.w,
            child: _buildLegend(),
          ),

        // ── BOTTOM DETAIL PANEL ──
        if (_showBottomPanel && _selectedPoint != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: _buildDetailPanel(context),
            ),
          )
        else if (_showBottomPanel && _selectedProvince != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: _buildProvincePanel(context),
            ),
          ),

        // ── FAB Supply Matching (GPS) ──
        Positioned(
          bottom: gisMapFloatingBottomOffset(
            context,
            panelOpen: _showBottomPanel,
          ),
          right: 12.w,
          child: FloatingActionButton.extended(
            heroTag: 'supply_match',
            backgroundColor: AppColors.primary,
            onPressed: () => _triggerSupplyMatching(context),
            icon: Icon(
              LucideIcons.radar,
              color: Colors.white,
              size: 18.sp,
            ),
            label: Text(
              'Cari Suplai Terdekat',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // ── FAB Recenter ──
        Positioned(
          bottom: _showBottomPanel ? 220.h : 20.h,
          right: 12.w,
          child: FloatingActionButton.small(
            heroTag: 'recenter',
            backgroundColor: Colors.white,
            onPressed: () {
              _mapController.move(const LatLng(-2.5, 118.0), 5.0);
              setState(() {
                _showBottomPanel = false;
                _selectedPoint = null;
                _selectedProvince = null;
              });
            },
            child: Icon(
              LucideIcons.locateFixed,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Volume Biomassa',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 5.h),
          ...[
            {'color': AppColors.mapVolumeHighest, 'label': '≥400K ton'},
            {'color': AppColors.secondary, 'label': '200K–400K'},
            {'color': AppColors.mapVolumeMid, 'label': '100K–200K'},
            {'color': AppColors.mapVolumeLow, 'label': '<100K'},
            {'color': AppColors.grey300, 'label': 'Tidak ada'},
          ].map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 3.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    item['label'] as String,
                    style: TextStyle(fontSize: 9.sp, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker(String type, bool isSelected) {
    Color color = AppColors.primary;
    IconData icon = LucideIcons.leaf;

    if (type.contains('SEKAM_PADI')) {
      color = Colors.orange;
      icon = LucideIcons.wheat;
    } else if (type.contains('TONGKOL_JAGUNG')) {
      color = Colors.yellow.shade800;
      icon = LucideIcons.sprout;
    } else if (type.contains('TEMPURUNG_KELAPA')) {
      color = AppColors.mapLandBrown;
      icon = LucideIcons.nut;
    } else if (type.contains('BIOCHAR')) {
      color = Colors.deepOrange;
      icon = LucideIcons.flame;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: isSelected ? 3 : 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isSelected ? 0.6 : 0.35),
            blurRadius: isSelected ? 14 : 6,
            spreadRadius: isSelected ? 3 : 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: isSelected ? 22.sp : 17.sp),
    );
  }

  Widget _buildDetailPanel(BuildContext context) {
    final point = _selectedPoint!;
    final Color typeColor = _getTypeColor(point.biomassaType);

    return Container(
      margin: EdgeInsets.all(12.r),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  _getTypeIcon(point.biomassaType),
                  color: typeColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${point.regency}, ${point.province}',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        point.biomassaType.replaceAll('_', ' '),
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _showBottomPanel = false;
                  _selectedPoint = null;
                }),
                child: Icon(LucideIcons.x, size: 20.sp, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _statBox(
                LucideIcons.package,
                'Volume',
                '${(point.volumeTon / 1000).toStringAsFixed(1)}K Ton',
                AppColors.primary,
              ),
              SizedBox(width: 12.w),
              _statBox(
                LucideIcons.calendarDays,
                'Tahun',
                point.year.toString(),
                Colors.blue,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                LucideIcons.phoneCall,
                color: Colors.white,
                size: 16.sp,
              ),
              label: Text(
                'hubungi_supplier'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProvincePanel(BuildContext context) {
    final province = _selectedProvince!;
    final volume = _provinceStats[province] ?? 0;

    return Container(
      margin: EdgeInsets.all(12.r),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  LucideIcons.map,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      province,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Wilayah Terpilih',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  _showBottomPanel = false;
                  _selectedProvince = null;
                }),
                child: Icon(LucideIcons.x, size: 20.sp, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _statBox(
                  LucideIcons.package,
                  'Total Volume',
                  '${(volume / 1000).toStringAsFixed(1)}K Ton',
                  AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12.sp, color: color),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showStatsSheet(
    BuildContext context,
    Map<String, double> topStats,
    int total,
  ) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  LucideIcons.chartBar,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Statistik Sebaran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '$total titik',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            if (topStats.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Text(
                    'tidak_ada_data'.tr(),
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ...(() {
                final maxVal = topStats.values.first;
                return topStats.entries.map((entry) {
                  final pct = maxVal > 0 ? entry.value / maxVal : 0.0;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(entry.value / 1000).toStringAsFixed(1)}K ton',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.r),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 6.h,
                            backgroundColor: AppColors.grey100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList();
              })(),
            SizedBox(height: 16.h),
            // Choropleth Color Scale
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Skala Warna Wilayah',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children:
                        [
                              AppColors.grey300,
                              AppColors.mapVolumeLow,
                              AppColors.mapVolumeMid,
                              AppColors.secondary,
                              AppColors.mapVolumeHighest,
                            ]
                            .map(
                              (c) => Expanded(
                                child: Container(height: 12.h, color: c),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rendah',
                        style: TextStyle(fontSize: 9.sp, color: Colors.grey),
                      ),
                      Text(
                        'Tinggi',
                        style: TextStyle(fontSize: 9.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    if (type.contains('SEKAM_PADI')) return Colors.orange;
    if (type.contains('TONGKOL_JAGUNG')) return Colors.yellow.shade800;
    if (type.contains('TEMPURUNG_KELAPA')) return AppColors.mapLandBrown;
    if (type.contains('BIOCHAR')) return Colors.deepOrange;
    return AppColors.primary;
  }

  IconData _getTypeIcon(String type) {
    if (type.contains('SEKAM_PADI')) return LucideIcons.wheat;
    if (type.contains('TONGKOL_JAGUNG')) return LucideIcons.sprout;
    if (type.contains('TEMPURUNG_KELAPA')) return LucideIcons.nut;
    if (type.contains('BIOCHAR')) return LucideIcons.flame;
    return LucideIcons.leaf;
  }

  Future<void> _triggerSupplyMatching(BuildContext context) async {
    try {
      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin lokasi ditolak secara permanen. Aktifkan di pengaturan perangkat.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Izin lokasi diperlukan untuk fitur ini.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Get current position
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                const Text('Mendapatkan lokasi GPS Anda...'),
              ],
            ),
            backgroundColor: AppColors.primary,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Move map to user location
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        8.0,
      );

      // Trigger matching with 100km radius
      if (mounted) {
        context.read<GisCubit>().matchSupplyDemand(
              position.latitude,
              position.longitude,
              100.0,
            );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan lokasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showMatchResultsSheet(BuildContext context, Map<String, dynamic> data) {
    final matches = data['matches'] as List? ?? [];
    final radius = data['radius'] ?? 100;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Row(
              children: [
                Icon(LucideIcons.radar, color: AppColors.primary, size: 22.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Suplai Terdekat (radius ${radius}km)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${matches.length} hasil',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (matches.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32.r),
                  child: Column(
                    children: [
                      Icon(LucideIcons.searchX, size: 48.sp, color: Colors.grey[300]),
                      SizedBox(height: 12.h),
                      Text(
                        'Tidak ditemukan suplai dalam radius ini.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.grey100),
                  itemBuilder: (context, index) {
                    final match = matches[index] as Map<String, dynamic>;
                    final name = match['supplierName'] ?? match['name'] ?? 'Supplier';
                    final distance = match['distance'] ?? 0;
                    final biomassType = (match['biomassType'] ?? match['type'] ?? '').toString().replaceAll('_', ' ');
                    final volume = match['volume'] ?? match['volumeTon'] ?? 0;

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                      leading: Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          LucideIcons.warehouse,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        name.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      subtitle: Text(
                        '$biomassType • ${volume}T',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '${distance is num ? distance.toStringAsFixed(1) : distance} km',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
