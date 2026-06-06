import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_collection_entity.dart';
import '../entities/product_engagement_entity.dart';
import '../entities/product_entity.dart';
import '../entities/product_stats_entity.dart';
import '../../data/models/supplier_model.dart';
import '../../data/models/category_model.dart';

abstract class MarketplaceRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories({
    String? productMode,
    String? biomassaType,
    String? search,
  });
  Future<Either<Failure, List<ProductEntity>>> getMyProducts({
    String? search,
    String? status,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 20,
  });
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
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, ProductEntity>> createProduct(
      Map<String, dynamic> data, List<String> imagePaths);
  Future<Either<Failure, ProductEntity>> updateProduct(
      String id, Map<String, dynamic> data, List<String> imagePaths);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, ProductStatsEntity>> getProductStats(String id);
  Future<Either<Failure, ProductEntity>> duplicateProduct(String id);
  Future<Either<Failure, List<SupplierModel>>> getSuppliers(
      {String? search, int page = 1, int limit = 20});
  Future<Either<Failure, SupplierModel>> getSupplierProfile(String id);
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts();
  Future<Either<Failure, List<ProductCollectionEntity>>> getCollections();
  Future<Either<Failure, List<ProductEntity>>> getProductsByCollection(
      String slug, {int page = 1, int limit = 10});
  Future<Either<Failure, ProductEngagementData>> getSupplierProductEngagement();
}
