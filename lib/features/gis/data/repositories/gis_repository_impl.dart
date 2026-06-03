import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/entities/waste_point_entity.dart';
import '../../domain/repositories/gis_repository.dart';
import '../datasources/gis_remote_data_source.dart';
import '../gis_region_cache.dart';

class GisRepositoryImpl implements GisRepository {
  final GisRemoteDataSource remoteDataSource;

  GisRepositoryImpl({required this.remoteDataSource});

  @override
  List<RegionEntity>? peekRegions({
    required String level,
    String? parentId,
    String? search,
  }) {
    return GisRegionCache.instance.get(
      level: level,
      parentId: parentId,
      search: search,
    );
  }

  @override
  Future<Either<Failure, List<RegionEntity>>> getRegions({
    required String level,
    String? parentId,
    String? search,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = peekRegions(
        level: level,
        parentId: parentId,
        search: search,
      );
      if (cached != null) {
        return Right(cached);
      }
    }

    try {
      final models = await remoteDataSource.getRegions(
        level: level,
        parentId: parentId,
        search: search,
      );
      final entities = models.map((e) => e.toEntity()).toList();
      GisRegionCache.instance.put(
        level: level,
        parentId: parentId,
        search: search,
        regions: entities,
      );
      return Right(entities);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Gagal memuat data wilayah'),
      );
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<WastePointEntity>>> getWastePoints() async {
    try {
      final models = await remoteDataSource.getWastePoints();
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Gagal memuat peta limbah'),
      );
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> matchSupplyDemand(
    double lat,
    double lng,
    double radius,
  ) async {
    try {
      final result = await remoteDataSource.matchSupplyDemand(lat, lng, radius);
      return Right(result);
    } on DioException catch (e) {
      return Left(
        ServerFailure(message: e.message ?? 'Gagal melakukan pemetaan'),
      );
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }
}
