import 'package:dio/dio.dart';
import '../models/product_stats_model.dart';
import '../models/product_collection_model.dart';
import '../models/product_model.dart';
import '../models/supplier_model.dart';
import '../models/category_model.dart';

abstract class MarketplaceRemoteDataSource {
  Future<List<ProductModel>> getProducts({
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
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> createProduct(
    Map<String, dynamic> data,
    List<String> imagePaths,
  );
  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> data,
    List<String> imagePaths,
  );
  Future<void> deleteProduct(String id);
  Future<ProductStatsModel> getProductStats(String id);
  Future<ProductModel> duplicateProduct(String id);
  Future<List<SupplierModel>> getSuppliers({
    String? search,
    int page = 1,
    int limit = 20,
  });
  Future<List<ProductModel>> getFeaturedProducts();
  Future<List<ProductCollectionModel>> getCollections();
  Future<List<ProductModel>> getProductsByCollection(
    String slug, {
    int page = 1,
    int limit = 10,
  });
  Future<SupplierModel> getSupplierProfile(String id);
  Future<List<CategoryModel>> getCategories({
    String? productMode,
    String? biomassaType,
    String? search,
  });
  Future<Map<String, dynamic>> getSupplierProductEngagement();
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  final Dio dio;

  MarketplaceRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts({
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
  }) async {
    final String path = productMode == 'ORGANIC_PRODUCE' ?
     '/organic/products' : '/products';
    final response = await dio.get(
      path,
      queryParameters: {
        if (search != null) 'search': search,
        if (biomassaType != null) 'biomassaType': biomassaType,
        if (categoryId != null) 'categoryId': categoryId,
        if (userId != null) 'userId': userId,
        if (minPrice != null) 'minPrice': minPrice,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (minRating != null) 'minRating': minRating,
        if (minCarbonPurity != null) 'minCarbonPurity': minCarbonPurity,
        if (maxMoistureContent != null)
          'maxMoistureContent': maxMoistureContent,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        if (status != null) 'status': status,
        if (productMode != null) 'productMode': productMode,
        if (cropType != null) 'cropType': cropType,
        'page': page,
        'limit': limit,
      },
    );

    final List data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    // Backend tidak punya GET /organic/products/:id — detail produk organic
    // memakai endpoint unified GET /products/:id (ID produk unik lintas mode).
    final response = await dio.get('/products/$id');
    return ProductModel.fromJson(response.data['data']);
  }

  @override
  Future<ProductModel> createProduct(
    Map<String, dynamic> data,
    List<String> imagePaths,
  ) async {
    final formData = FormData.fromMap(data);
    for (var path in imagePaths) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ),
      );
    }

    final response = await dio.post(
      '/products',
      data: formData,
    );
    try {
      return ProductModel.fromJson(response.data['data']);
    } catch (e) {
      final rawData = response.data['data'];
      if (rawData is Map<String, dynamic> && rawData['id'] != null) {
        return getProductById(rawData['id']);
      }
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(
    String id,
    Map<String, dynamic> data,
    List<String> imagePaths,
  ) async {
    final formData = FormData.fromMap(data);
    for (var path in imagePaths) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ),
      );
    }

    final response = await dio.patch(
      '/products/$id',
      data: formData,
    );
    try {
      return ProductModel.fromJson(response.data['data']);
    } catch (e) {
      final rawData = response.data['data'];
      if (rawData is Map<String, dynamic> && rawData['id'] != null) {
        return getProductById(rawData['id']);
      }
      return getProductById(id);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    await dio.delete('/products/$id');
  }

  @override
  Future<ProductStatsModel> getProductStats(String id) async {
    final response = await dio.get('/products/$id/stats');
    return ProductStatsModel.fromJson(response.data['data']);
  }

  @override
  Future<ProductModel> duplicateProduct(String id) async {
    final response = await dio.post('/products/$id/duplicate');
    return ProductModel.fromJson(response.data['data']);
  }

  @override
  Future<List<SupplierModel>> getSuppliers({
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/suppliers',
      queryParameters: {
        if (search != null) 'search': search,
        'page': page,
        'limit': limit,
      },
    );
    final List data = response.data['data'];
    return data.map((e) => SupplierModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await dio.get('/products/featured');
    final List data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductCollectionModel>> getCollections() async {
    final response = await dio.get('/products/collections');
    final List data = response.data['data'];
    return data.map((e) => ProductCollectionModel.fromJson(e)).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCollection(
    String slug, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dio.get(
      '/products/collections/$slug',
      queryParameters: {'page': page, 'limit': limit},
    );
    final List data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<SupplierModel> getSupplierProfile(String id) async {
    final response = await dio.get('/users/$id');
    return SupplierModel.fromJson(response.data['data']);
  }

  @override
  Future<List<CategoryModel>> getCategories({
    String? productMode,
    String? biomassaType,
    String? search,
  }) async {
    // Single categories endpoint — backend filters by productMode / biomassaType.
    final response = await dio.get('/categories', queryParameters: {
      'categoryType': 'PRODUK',
      if (productMode != null) 'productMode': productMode,
      if (biomassaType != null) 'biomassaType': biomassaType,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    });
    final List data = response.data['data'];
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> getSupplierProductEngagement() async {
    final response = await dio.get('/products/engagement');
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }
}
