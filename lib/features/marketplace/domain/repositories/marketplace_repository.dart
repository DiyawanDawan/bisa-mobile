import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product_collection_entity.dart';
import '../entities/product_engagement_entity.dart';
import '../entities/product_entity.dart';
import '../entities/product_stats_entity.dart';
import '../../data/models/supplier_model.dart';
import '../../data/models/category_model.dart';
import '../entities/product_certificate_entity.dart';

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
    bool? availableNow,
    bool? preHarvestBookable,
    bool? canBook,
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, ProductEntity>> createProduct(
    Map<String, dynamic> data,
    List<String> imagePaths,
  );
  Future<Either<Failure, ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> data,
    List<String> imagePaths,
  );
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, ProductStatsEntity>> getProductStats(String id);
  Future<Either<Failure, ProductEntity>> duplicateProduct(String id);
  Future<Either<Failure, List<SupplierModel>>> getSuppliers({
    String? search,
    bool? verified,
    String? productMode,
    String? biomassaType,
    String? province,
    String? regency,
    int page = 1,
    int limit = 20,
  });
  Future<Either<Failure, SupplierModel>> getSupplierProfile(String id);
  Future<Either<Failure, List<ProductEntity>>> getFeaturedProducts();
  Future<Either<Failure, List<ProductCollectionEntity>>> getCollections();
  Future<Either<Failure, List<ProductEntity>>> getProductsByCollection(
    String slug, {
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, ProductEngagementData>> getSupplierProductEngagement();
  Future<Either<Failure, Map<String, dynamic>>> promoteProduct(
    String productId, {
    int days = 7,
  });
  Future<void> recordPromoImpression(String productId);
  Future<void> recordPromoClick(String productId);
  Future<Either<Failure, ProductEntity>> uploadProductVideo(
    String productId,
    String filePath,
  );
  Future<Either<Failure, ProductEntity>> deleteProductVideo(String productId);
  Future<Either<Failure, List<ProductCertificateEntity>>>
  getMyProductCertificates(String productId);
  Future<Either<Failure, ProductCertificateEntity>> submitProductCertificate({
    required String productId,
    required String localPath,
    required Map<String, dynamic> metadata,
  });
  Future<Either<Failure, void>> deleteProductCertificate(
    String productId,
    String certificateId,
  );
  Future<Either<Failure, List<ProductCertificateEntity>>>
  getSupplierCertificates(String supplierId, {int page = 1, int limit = 20});
}
