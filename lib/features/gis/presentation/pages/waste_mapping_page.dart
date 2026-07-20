import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/i18n/failure_messages.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import 'package:mobile_bisa/core/utils/safe_area_utils.dart';
import 'package:mobile_bisa/features/gis/domain/entities/waste_point_entity.dart';
import 'package:mobile_bisa/features/gis/data/province_centroids.dart';
import 'package:mobile_bisa/features/gis/presentation/bloc/gis_cubit.dart';
import 'package:mobile_bisa/shared/widgets/bisa_app_bar.dart';
import 'package:mobile_bisa/core/network/api_client.dart';
import 'package:mobile_bisa/injection_container.dart';
import 'package:mobile_bisa/shared/widgets/shimmer_loading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class WasteMappingPage extends StatefulWidget {
  const WasteMappingPage({super.key});

  @override
  State<WasteMappingPage> createState() => _WasteMappingPageState();
}

class _WasteMappingPageState extends State<WasteMappingPage> {
  final MapController _mapController = MapController();

  // State
  String _selectedType = 'Semua';
  bool _showMapBackground = false;
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
  List<WastePointEntity> _cachedWastePoints = [];

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
      'color': AppColors.mapFilterRiceHusk,
    },
    {
      'key': 'TONGKOL_JAGUNG',
      'label': 'Jagung',
      'icon': LucideIcons.sprout,
      'color': AppColors.mapFilterCorn,
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
      'color': AppColors.mapFilterBiochar,
    },
  ];

  String _typeFilterLabel(String key) {
    switch (key) {
      case 'SEKAM_PADI':
        return 'gis.filter_rice_husk'.tr();
      case 'TONGKOL_JAGUNG':
        return 'gis.filter_corn'.tr();
      case 'TEMPURUNG_KELAPA':
        return 'gis.filter_coconut'.tr();
      case 'BIOCHAR':
        return 'gis.filter_biochar'.tr();
      default:
        return 'gis.filter_all'.tr();
    }
  }

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
          final borderColor = _provinceBorderColor(propName, volume.toDouble());

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
                  color: AppColors.transparent,
                  borderColor: borderColor,
                  borderStrokeWidth: _selectedProvince == propName ? 2.5 : 1.8,
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
                    color: AppColors.transparent,
                    borderColor: borderColor,
                    borderStrokeWidth: _selectedProvince == propName ? 2.5 : 1.8,
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

  Color _provinceBorderColor(String provinceName, double volume) {
    if (_selectedProvince == provinceName) return AppColors.primary;
    return _getChoroplethColor(volume);
  }

  void _zoomToPoint(WastePointEntity point) {
    _mapController.move(LatLng(point.lat, point.lng), 10.5);
  }

  void _zoomToProvince(String province) {
    final bounds = _boundsForProvince(province);
    if (bounds != null) {
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: EdgeInsets.all(56.w),
        ),
      );
      return;
    }

    final centroid = resolveProvinceCentroid(province);
    _mapController.move(LatLng(centroid.lat, centroid.lng), 7.5);
  }

  LatLngBounds? _boundsForProvince(String province) {
    final matching = _choroplethPolygons
        .where((polygon) => polygon.hitValue == province)
        .toList();
    if (matching.isEmpty) return null;

    var minLat = 90.0;
    var maxLat = -90.0;
    var minLng = 180.0;
    var maxLng = -180.0;

    for (final polygon in matching) {
      for (final point in polygon.points) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLng) minLng = point.longitude;
        if (point.longitude > maxLng) maxLng = point.longitude;
      }
    }

    if (minLat >= maxLat || minLng >= maxLng) return null;
    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  Future<void> _refreshChoroplethBorders() async {
    if (!_geoJsonLoaded) return;
    try {
      final geoJsonString = await rootBundle.loadString(
        'assets/indonesia_provinces.json',
      );
      if (!mounted) return;
      setState(() => _rebuildChoropleth(geoJsonString));
    } catch (_) {}
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
        backgroundColor: AppColors.black,
        appBar: BisaAppBar(
          title: 'gis.page_title'.tr(),
          backgroundColor: AppColors.surface,
          actions: [
            IconButton(
              onPressed: () =>
                  setState(() => _showChoropleth = !_showChoropleth),
              icon: Icon(
                LucideIcons.layers,
                color: _showChoropleth ? AppColors.primary : AppColors.grey400,
                size: 20.sp,
              ),
              tooltip: 'gis.toggle_region_tooltip'.tr(),
            ),
            IconButton(
              onPressed: () =>
                  setState(() => _showMapBackground = !_showMapBackground),
              icon: Icon(
                LucideIcons.map,
                color: _showMapBackground ? AppColors.primary : AppColors.grey400,
                size: 20.sp,
              ),
              tooltip: _showMapBackground
                  ? 'gis.map_satellite_tooltip'.tr()
                  : 'gis.map_standard_tooltip'.tr(),
            ),
            if (_showMapBackground)
              IconButton(
                onPressed: () => setState(() => _isSatellite = !_isSatellite),
                icon: Icon(
                  _isSatellite ? LucideIcons.globe : LucideIcons.map,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                tooltip: _isSatellite
                    ? 'gis.map_standard_tooltip'.tr()
                    : 'gis.map_satellite_tooltip'.tr(),
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
                    padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xl, AppSpacing.md, 0),
                  ),
                ],
              ),
              error: (msg) => Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.mapPinOff,
                        size: 40.sp,
                        color: AppColors.grey400,
                      ),
                      SizedBox(height: AppSpacing.md12),
                      Text(
                        msg.localizedFailure,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.grey400,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextButton.icon(
                        onPressed: () =>
                            context.read<GisCubit>().getWastePoints(),
                        icon: Icon(LucideIcons.refreshCw, size: 16.sp),
                        label: Text('marketplace.retry'.tr()),
                      ),
                    ],
                  ),
                ),
              ),
              wasteMapLoaded: (points) {
                _cachedWastePoints = points;
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _showMatchResultsSheet(context, data);
                });
                if (_cachedWastePoints.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final filtered = _applyFilter(_cachedWastePoints);
                final topStats = _calcTopStats(_cachedWastePoints);
                return _buildMap(context, filtered, topStats);
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
        ColoredBox(
          color: AppColors.grey900,
          child: FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: LatLng(-2.5, 118.0),
            initialZoom: 5.0,
          ),
          children: [
            if (_showMapBackground)
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
                    final province = hit.hitValues.first;
                    setState(() {
                      _selectedProvince = province;
                      _selectedPoint = null;
                      _showBottomPanel = true;
                    });
                    _zoomToProvince(province);
                    _refreshChoroplethBorders();
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
                    onTap: () {
                      setState(() {
                        _selectedPoint = point;
                        _selectedProvince = null;
                        _showBottomPanel = true;
                      });
                      _zoomToPoint(point);
                      _refreshChoroplethBorders();
                    },
                    child: _buildMarker(point.biomassaType, isSelected),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        ),

        // ── TYPE FILTER CHIPS ──
        Positioned(
          top: AppSpacing.md12,
          left: AppSpacing.md12,
          right: AppSpacing.md12,
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
                    margin: EdgeInsets.only(right: AppSpacing.sm),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.section,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.15),
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
                          color: isSelected ? AppColors.textOnPrimary : color,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          _typeFilterLabel(filter['key'] as String),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
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
          right: AppSpacing.md12,
          child: GestureDetector(
            onTap: () => _showStatsSheet(context, topStats, filtered.length),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md12, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.15),
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
            left: AppSpacing.md12,
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
          right: AppSpacing.md12,
          child: FloatingActionButton.extended(
            heroTag: 'supply_match',
            backgroundColor: AppColors.primary,
            onPressed: () => _triggerSupplyMatching(context),
            icon: Icon(
              LucideIcons.radar,
              color: AppColors.surface,
              size: 18.sp,
            ),
            label: Text(
              'gis.find_nearest_supply'.tr(),
              style: TextStyle(
                color: AppColors.surface,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // ── FAB Recenter ──
        Positioned(
          bottom: _showBottomPanel ? 220.h : 20.h,
          right: AppSpacing.md12,
          child: FloatingActionButton.small(
            heroTag: 'recenter',
            backgroundColor: AppColors.surface,
            onPressed: () {
              _mapController.move(const LatLng(-2.5, 118.0), 5.0);
              setState(() {
                _showBottomPanel = false;
                _selectedPoint = null;
                _selectedProvince = null;
              });
              _refreshChoroplethBorders();
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
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm10, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
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
            'gis.volume_biomass_title'.tr(),
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.grey700,
            ),
          ),
          SizedBox(height: 5.h),
          ...[
            {'color': AppColors.mapVolumeHighest, 'label': 'gis.volume_legend_highest'.tr()},
            {'color': AppColors.secondary, 'label': 'gis.volume_legend_high'.tr()},
            {'color': AppColors.mapVolumeMid, 'label': 'gis.volume_legend_mid'.tr()},
            {'color': AppColors.mapVolumeLow, 'label': 'gis.volume_legend_low'.tr()},
            {'color': AppColors.grey300, 'label': 'gis.no_data_label'.tr()},
          ].map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 3.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppSpacing.sm10,
                    height: AppSpacing.sm10,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    item['label'] as String,
                    style: TextStyle(fontSize: 9.sp, color: AppColors.textPrimary),
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
      color = AppColors.mapFilterRiceHusk;
      icon = LucideIcons.wheat;
    } else if (type.contains('TONGKOL_JAGUNG')) {
      color = AppColors.mapFilterCorn;
      icon = LucideIcons.sprout;
    } else if (type.contains('TEMPURUNG_KELAPA')) {
      color = AppColors.mapLandBrown;
      icon = LucideIcons.nut;
    } else if (type.contains('BIOCHAR')) {
      color = AppColors.mapFilterBiochar;
      icon = LucideIcons.flame;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: isSelected ? 3 : 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isSelected ? 0.6 : 0.35),
            blurRadius: isSelected ? 14 : 6,
            spreadRadius: isSelected ? 3 : 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.textOnPrimary, size: isSelected ? 22.sp : 17.sp),
    );
  }

  Widget _buildDetailPanel(BuildContext context) {
    final point = _selectedPoint!;
    final Color typeColor = _getTypeColor(point.biomassaType);

    return Container(
      margin: EdgeInsets.all(AppSpacing.md12),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.xlPx.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
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
              margin: EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.grey300,
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
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                ),
                child: Icon(
                  _getTypeIcon(point.biomassaType),
                  color: typeColor,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md12),
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
                        horizontal: AppSpacing.sm,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
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
                  _selectedProvince = null;
                }),
                child: Icon(LucideIcons.x, size: 20.sp, color: AppColors.grey400),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _statBox(
                LucideIcons.package,
                'gis.detail_volume'.tr(),
                '${(point.volumeTon / 1000).toStringAsFixed(1)}K Ton',
                AppColors.primary,
              ),
              SizedBox(width: AppSpacing.md12),
              _statBox(
                LucideIcons.calendarDays,
                'Tahun',
                point.year.toString(),
                AppColors.info,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: () => _openNearbyProducts(context, point),
              icon: Icon(
                LucideIcons.shoppingBag,
                color: AppColors.surface,
                size: 16.sp,
              ),
              label: Text(
                'gis.view_marketplace_products'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.tile),
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
      margin: EdgeInsets.all(AppSpacing.md12),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.xlPx.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
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
              margin: EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.grey300,
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
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.tile),
                ),
                child: Icon(
                  LucideIcons.map,
                  color: AppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md12),
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
                        horizontal: AppSpacing.sm,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'gis.region_selected_title'.tr(),
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
                onTap: () {
                  setState(() {
                    _showBottomPanel = false;
                    _selectedProvince = null;
                  });
                  _refreshChoroplethBorders();
                },
                child: Icon(LucideIcons.x, size: 20.sp, color: AppColors.grey400),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _statBox(
                  LucideIcons.package,
                  'gis.total_volume_title'.tr(),
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
        padding: EdgeInsets.all(AppSpacing.md12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withValues(alpha: 0.15)),
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
      backgroundColor: AppColors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                margin: EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
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
                SizedBox(width: AppSpacing.sm),
                Text(
                  'gis.stats_distribution_title'.tr(),
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
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
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
            SizedBox(height: AppSpacing.lg),
            if (topStats.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
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
                    padding: EdgeInsets.only(bottom: AppSpacing.md12),
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
            SizedBox(height: AppSpacing.md),
            // Choropleth Color Scale
            Container(
              padding: EdgeInsets.all(AppSpacing.md12),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'gis.scale_color_title'.tr(),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
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
                                child: Container(height: AppSpacing.md12, color: c),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'gis.scale_low'.tr(),
                        style: TextStyle(fontSize: 9.sp, color: AppColors.grey400),
                      ),
                      Text(
                        'gis.scale_high'.tr(),
                        style: TextStyle(fontSize: 9.sp, color: AppColors.grey400),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    if (type.contains('SEKAM_PADI')) return AppColors.mapFilterRiceHusk;
    if (type.contains('TONGKOL_JAGUNG')) return AppColors.mapFilterCorn;
    if (type.contains('TEMPURUNG_KELAPA')) return AppColors.mapLandBrown;
    if (type.contains('BIOCHAR')) return AppColors.mapFilterBiochar;
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
          showErrorSnackBar(context, 'gis.location_denied_permanent'.tr());
        }
        return;
      }

      if (permission == LocationPermission.denied) {
        if (mounted) {
          showCustomSnackBar(
            context,
            content: Text('gis.location_denied'.tr()),
            backgroundColor: AppColors.mapFilterRiceHusk,
          );
        }
        return;
      }

      // Get current position
      if (mounted) {
        showCustomSnackBar(
          context,
          content: Row(
            children: [
              SizedBox(
                width: AppSpacing.md,
                height: AppSpacing.md,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.surface,
                ),
              ),
              SizedBox(width: AppSpacing.md12),
              Text('gis.location_fetching'.tr()),
            ],
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 3),
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
        showErrorSnackBar(
          context,
          'gis.location_error'.tr(namedArgs: {'error': '$e'}),
        );
      }
    }
  }

  Future<void> _openNearbyProducts(BuildContext context, WastePointEntity point) async {
    try {
      final res = await sl<ApiClient>().dio.post('/gis/match', data: {
        'lat': point.lat,
        'lng': point.lng,
        'radius': 100,
        'biomassaType': point.biomassaType,
        'regency': point.regency,
        'province': point.province,
      });
      if (!mounted) return;
      final data = Map<String, dynamic>.from(res.data['data'] as Map);
      _showMatchResultsSheet(context, data);
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(context, 'gis.match_load_failed'.tr());
    }
  }

  void _showMatchResultsSheet(BuildContext context, Map<String, dynamic> data) {
    final matches = data['matches'] as List? ?? [];
    final radius = data['radius'] ?? 100;

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
        padding: EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
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
                margin: EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Row(
              children: [
                Icon(LucideIcons.radar, color: AppColors.primary, size: 22.sp),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'gis.match_nearest_title'.tr(
                      namedArgs: {'radius': '$radius'},
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm10, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
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
            SizedBox(height: AppSpacing.md),
            if (matches.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    children: [
                      Icon(LucideIcons.searchX, size: 48.sp, color: AppColors.grey300),
                      SizedBox(height: AppSpacing.md12),
                      Text(
                        'gis.match_empty'.tr(),
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

                    final productId = match['productId']?.toString();
                    final supplierId = match['supplierId']?.toString();
                    final productName =
                        match['productName']?.toString() ?? name.toString();

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                      onTap: () {
                        Navigator.pop(context);
                        if (productId != null && productId.isNotEmpty) {
                          context.push('/product/$productId');
                        } else if (supplierId != null && supplierId.isNotEmpty) {
                          context.push(
                            '/supplier/$supplierId',
                            extra: {'name': name.toString()},
                          );
                        }
                      },
                      leading: Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Icon(
                          LucideIcons.package,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),
                      title: Text(
                        productName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      subtitle: Text(
                        '$name • $biomassType • ${volume}T',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.button),
                        ),
                        child: Text(
                          '${distance is num ? distance.toStringAsFixed(1) : distance} km',
                          style: TextStyle(
                            color: AppColors.info,
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
