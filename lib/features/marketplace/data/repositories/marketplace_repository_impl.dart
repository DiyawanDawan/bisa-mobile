import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/readiness/readiness_service.dart';
import '../../domain/entities/product_collection_entity.dart';
import '../../domain/entities/product_engagement_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_stats_entity.dart';
import '../../domain/repositories/marketplace_repository.dart';
import '../datasources/marketplace_remote_data_source.dart';

import '../models/supplier_model.dart';
import '../models/category_model.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final MarketplaceRemoteDataSource remoteDataSource;

  MarketplaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getMyProducts({
    String? search,
    String? status,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.getMyProducts(
        search: search,
        status: status,
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
        page: page,
        limit: limit,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? search,
    String? biomassaType,
    String? categoryId,
    String? userId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    double? minCarbonPurity,
    double? maxMoistureContent,
    String? sortBy,
    String? sortOrder,
    String? status,
    String? productMode,
    String? cropType,
    bool? availableNow,
    bool? preHarvestBookable,
    bool? canBook,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final models = await remoteDataSource.getProducts(
        search: search,
        biomassaType: biomassaType,
        categoryId: categoryId,
        userId: userId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        minCarbonPurity: minCarbonPurity,
        maxMoistureContent: maxMoistureContent,
        sortBy: sortBy,
        sortOrder: sortOrder,
        status: status,
        productMode: productMode,
        cropType: cropType,
        availableNow: availableNow,
        preHarvestBookable: preHarvestBookable,
        canBook: canBook,
        page: page,
        limit: limit,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct(
    Map<String, dynamic> data,
    List<String> imagePaths,
  ) async {
    try {
      final model = await remoteDataSource.createProduct(data, imagePaths);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> data,
    List<String> imagePaths,
  ) async {
    try {
      final model = await remoteDataSource.updateProduct(id, data, imagePaths);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ProductStatsEntity>> getProductStats(String id) async {
    try {
      final model = await remoteDataSource.getProductStats(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> duplicateProduct(String id) async {
    try {
      final model = await remoteDataSource.duplicateProduct(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<SupplierModel>>> getSuppliers({
    String? search,
    bool? verified,
    String? productMode,
    String? biomassaType,
    String? province,
    String? regency,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await remoteDataSource.getSuppliers(
        search: search,
        verified: verified,
        productMode: productMode,
        biomassaType: biomassaType,
        province: province,
        regency: regency,
        page: page,
        limit: limit,
      );
      return Right(models);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, SupplierModel>> getSupplierProfile(String id) async {
    try {
      final model = await remoteDataSource.getSupplierProfile(id);
      return Right(model);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts() async {
    try {
      final models = await remoteDataSource.getFeaturedProducts();
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductCollectionEntity>>>
  getCollections() async {
    try {
      final models = await remoteDataSource.getCollections();
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCollection(
    String slug, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final models = await remoteDataSource.getProductsByCollection(
        slug,
        page: page,
        limit: limit,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories({
    String? productMode,
    String? biomassaType,
    String? search,
  }) async {
    try {
      final models = await remoteDataSource.getCategories(
        productMode: productMode,
        biomassaType: biomassaType,
        search: search,
      );
      return Right(models);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEngagementData>> getSupplierProductEngagement() async {
    try {
      final raw = await remoteDataSource.getSupplierProductEngagement();
      return Right(ProductEngagementData.fromJson(raw));
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> promoteProduct(
    String productId, {
    int days = 7,
  }) async {
    try {
      final data = await remoteDataSource.promoteProduct(productId, days: days);
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<void> recordPromoImpression(String productId) =>
      remoteDataSource.recordPromoImpression(productId);

  @override
  Future<void> recordPromoClick(String productId) =>
      remoteDataSource.recordPromoClick(productId);

  @override
  Future<Either<Failure, ProductEntity>> uploadProductVideo(
    String productId,
    String filePath,
  ) async {
    try {
      final model = await remoteDataSource.uploadProductVideo(productId, filePath);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> deleteProductVideo(String productId) async {
    try {
      final model = await remoteDataSource.deleteProductVideo(productId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _mapDioExceptionToFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const TimeoutFailure();
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final rawData = e.response?.data;
      final data = rawData is Map<String, dynamic> ? rawData : null;
      final message = _resolveApiMessage(data);

      switch (statusCode) {
        case 401:
          return UnauthorizedFailure(message);
        case 403:
          return ForbiddenFailure(message);
        case 404:
          return const NotFoundFailure();
        case 400:
        case 422:
          {
            final readiness = ReadinessService.failureFromResponseData(data, message);
            if (readiness != null) return readiness;
            return ValidationFailure(
              message: message,
              errors: _extractFieldErrors(data),
            );
          }
        default:
          return ServerFailure(message: message, statusCode: statusCode);
      }
    } else if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return const UnexpectedFailure();
  }

  String _resolveApiMessage(Map<String, dynamic>? data) {
    if (data == null) return 'errors.generic';
    final base = data['meta']?['message'] ?? data['message'] ?? 'errors.generic';
    final details = data['data'];
    if (details is List && details.isNotEmpty) {
      final first = details.first;
      if (first is Map && first['message'] != null) {
        return '$base: ${first['message']}';
      }
    }
    return base.toString();
  }

  Map<String, List<String>>? _extractFieldErrors(Map<String, dynamic>? data) {
    final details = data?['data'];
    if (details is! List) return null;
    final out = <String, List<String>>{};
    for (final item in details) {
      if (item is Map && item['field'] != null && item['message'] != null) {
        out[item['field'].toString()] = [item['message'].toString()];
      }
    }
    return out.isEmpty ? null : out;
  }
}
