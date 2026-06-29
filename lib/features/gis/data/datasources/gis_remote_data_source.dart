import 'package:dio/dio.dart';
import '../models/region_model.dart';
import '../models/waste_point_model.dart';

abstract class GisRemoteDataSource {
  Future<List<RegionModel>> getRegions({
    required String level,
    String? parentId,
    String? search,
  });
  Future<List<WastePointModel>> getWastePoints();
  Future<Map<String, dynamic>> matchSupplyDemand(
    double lat,
    double lng,
    double radius, {
    String? biomassaType,
    String? regency,
    String? province,
  });
}

class GisRemoteDataSourceImpl implements GisRemoteDataSource {
  final Dio dio;

  GisRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RegionModel>> getRegions({
    required String level,
    String? parentId,
    String? search,
  }) async {
    final response = await dio.get(
      '/gis',
      queryParameters: {
        'level': level,
        if (parentId != null) 'parentId': parentId,
        if (search != null) 'search': search,
      },
    );

    final List data = response.data['data'];
    return data.map((e) => RegionModel.fromJson(e)).toList();
  }

  @override
  Future<List<WastePointModel>> getWastePoints() async {
    final response = await dio.get('/gis/waste');
    final List data = response.data['data'];
    return data.map((e) => WastePointModel.fromJson(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> matchSupplyDemand(
    double lat,
    double lng,
    double radius, {
    String? biomassaType,
    String? regency,
    String? province,
  }) async {
    final response = await dio.post('/gis/match', data: {
      'lat': lat,
      'lng': lng,
      'radius': radius,
      if (biomassaType != null && biomassaType.isNotEmpty)
        'biomassaType': biomassaType,
      if (regency != null && regency.isNotEmpty) 'regency': regency,
      if (province != null && province.isNotEmpty) 'province': province,
    });
    return response.data['data'];
  }
}
