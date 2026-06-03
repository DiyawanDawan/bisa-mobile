import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/region_entity.dart';
import '../entities/waste_point_entity.dart';

abstract class GisRepository {
  List<RegionEntity>? peekRegions({
    required String level,
    String? parentId,
    String? search,
  });

  Future<Either<Failure, List<RegionEntity>>> getRegions({
    required String level,
    String? parentId,
    String? search,
    bool forceRefresh = false,
  });
  Future<Either<Failure, List<WastePointEntity>>> getWastePoints();
  Future<Either<Failure, Map<String, dynamic>>> matchSupplyDemand(double lat, double lng, double radius);
}
