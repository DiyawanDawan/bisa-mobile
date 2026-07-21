import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';
import '../models/product_stats_model.dart';
import '../models/product_collection_model.dart';
import '../models/product_model.dart';
import '../models/supplier_model.dart';
import '../models/category_model.dart';
import '../models/product_certificate_model.dart';
import '../models/store_certificate_model.dart';

abstract class MarketplaceRemoteDataSource {
  Future<List<ProductModel>> getMyProducts({
    String? search,
    String? status,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 20,
  });
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
    bool? availableNow,
    bool? preHarvestBookable,
    bool? canBook,
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
    bool? verified,
    String? productMode,
    String? biomassaType,
    String? province,
    String? regency,
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
  Future<String> downloadBulkProductTemplate();
  Future<Map<String, dynamic>> uploadBulkProducts(String filePath);
  Future<Map<String, dynamic>> promoteProduct(String productId, {int days = 7});
  Future<void> recordPromoImpression(String productId);
  Future<void> recordPromoClick(String productId);
  Future<ProductModel> uploadProductVideo(String productId, String filePath);
  Future<ProductModel> deleteProductVideo(String productId);
  Future<List<ProductCertificateModel>> getMyProductCertificates(
    String productId,
  );
  Future<ProductCertificateModel> submitProductCertificate({
    required String productId,
    required String localPath,
    required Map<String, dynamic> metadata,
  });
  Future<void> deleteProductCertificate(String productId, String certificateId);
  Future<List<ProductCertificateModel>> getSupplierCertificates(
    String supplierId, {
    int page = 1,
    int limit = 20,
  });
  Future<List<StoreCertificateModel>> getMyStoreCertificates();
  Future<StoreCertificateModel> submitStoreCertificate({
    required String localPath,
    required Map<String, dynamic> metadata,
  });
  Future<void> deleteStoreCertificate(String certificateId);
  Future<List<StoreCertificateModel>> getSupplierStoreCertificates(
    String supplierId,
  );
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  final Dio dio;
  final MediaUploadQueue uploadQueue;

  MarketplaceRemoteDataSourceImpl({
    required this.dio,
    required this.uploadQueue,
  });

  @override
  Future<List<ProductModel>> getMyProducts({
    String? search,
    String? status,
    String? categoryId,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/products/me',
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
        if (categoryId != null && categoryId.isNotEmpty)
          'categoryId': categoryId,
        if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sortOrder': sortOrder,
        'page': page,
        'limit': limit,
      },
    );
    final List data = response.data['data'];
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

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
    bool? availableNow,
    bool? preHarvestBookable,
    bool? canBook,
    int page = 1,
    int limit = 10,
  }) async {
    final String path = productMode == 'ORGANIC_PRODUCE'
        ? '/organic/products'
        : '/products';
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
        if (availableNow != null) 'availableNow': availableNow,
        if (preHarvestBookable != null)
          'preHarvestBookable': preHarvestBookable,
        if (canBook != null) 'canBook': canBook,
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

  Future<List<String>> _uploadProductImages(List<String> imagePaths) async {
    final uploaded = await uploadQueue.uploadFiles(
      localPaths: imagePaths,
      folder: 'products',
    );
    return uploaded.map((item) => item.path).toList();
  }

  @override
  Future<ProductModel> createProduct(
    Map<String, dynamic> data,
    List<String> imagePaths,
  ) async {
    final uploadedPaths = imagePaths.isNotEmpty
        ? await _uploadProductImages(imagePaths)
        : <String>[];

    final formData = FormData.fromMap({
      ...data,
      if (uploadedPaths.isNotEmpty) 'imageUrls': jsonEncode(uploadedPaths),
    });

    final response = await dio.post('/products', data: formData);
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
    final uploadedPaths = imagePaths.isNotEmpty
        ? await _uploadProductImages(imagePaths)
        : <String>[];

    final formData = FormData.fromMap({
      ...data,
      if (uploadedPaths.isNotEmpty) 'imageUrls': jsonEncode(uploadedPaths),
    });

    final response = await dio.patch('/products/$id', data: formData);
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
    bool? verified,
    String? productMode,
    String? biomassaType,
    String? province,
    String? regency,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/suppliers',
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (verified == true) 'verified': 'true',
        if (productMode != null && productMode.isNotEmpty)
          'productMode': productMode,
        if (biomassaType != null && biomassaType.isNotEmpty)
          'biomassaType': biomassaType,
        if (province != null && province.trim().isNotEmpty)
          'province': province.trim(),
        if (regency != null && regency.trim().isNotEmpty)
          'regency': regency.trim(),
        'page': page,
        'limit': limit,
      },
    );
    final raw = response.data['data'];
    final List data = raw is List
        ? raw
        : (raw is Map && raw['suppliers'] is List)
        ? raw['suppliers'] as List
        : const [];
    return data
        .whereType<Map>()
        .map((e) => SupplierModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
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
    final response = await dio.get(
      '/categories',
      queryParameters: {
        'categoryType': 'PRODUK',
        if (productMode != null) 'productMode': productMode,
        if (biomassaType != null) 'biomassaType': biomassaType,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final List data = response.data['data'];
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> getSupplierProductEngagement() async {
    final response = await dio.get('/products/engagement');
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  @override
  Future<String> downloadBulkProductTemplate() async {
    final response = await dio.get(
      '/products/bulk/template',
      options: Options(responseType: ResponseType.plain),
    );
    return response.data?.toString() ?? '';
  }

  @override
  Future<Map<String, dynamic>> uploadBulkProducts(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split(RegExp(r'[/\\]')).last,
      ),
    });
    final response = await dio.post('/products/bulk', data: formData);
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  @override
  Future<Map<String, dynamic>> promoteProduct(
    String productId, {
    int days = 7,
  }) async {
    final response = await dio.post(
      '/products/$productId/promote',
      data: {'days': days},
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  @override
  Future<void> recordPromoImpression(String productId) async {
    try {
      await dio.post('/products/$productId/promo-impression');
    } catch (_) {}
  }

  @override
  Future<void> recordPromoClick(String productId) async {
    try {
      await dio.post('/products/$productId/promo-click');
    } catch (_) {}
  }

  @override
  Future<ProductModel> uploadProductVideo(
    String productId,
    String filePath,
  ) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split(RegExp(r'[/\\]')).last,
      ),
    });
    final response = await dio.post(
      '/products/$productId/video',
      data: formData,
    );
    return ProductModel.fromJson(response.data['data']);
  }

  @override
  Future<ProductModel> deleteProductVideo(String productId) async {
    final response = await dio.delete('/products/$productId/video');
    return ProductModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ProductCertificateModel>> getMyProductCertificates(
    String productId,
  ) async {
    final response = await dio.get('/products/$productId/certificates/me');
    final data = response.data['data'] as List<dynamic>? ?? const [];
    return data
        .whereType<Map>()
        .map(
          (item) =>
              ProductCertificateModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  @override
  Future<ProductCertificateModel> submitProductCertificate({
    required String productId,
    required String localPath,
    required Map<String, dynamic> metadata,
  }) async {
    final uploaded = await uploadQueue.uploadFile(
      localPath: localPath,
      folder: 'product-certificates',
    );
    final response = await dio.post(
      '/products/$productId/certificates',
      data: {...metadata, 'storageKey': uploaded.path},
    );
    return ProductCertificateModel.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  @override
  Future<void> deleteProductCertificate(
    String productId,
    String certificateId,
  ) async {
    await dio.delete('/products/$productId/certificates/$certificateId');
  }

  @override
  Future<List<ProductCertificateModel>> getSupplierCertificates(
    String supplierId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/suppliers/$supplierId/certificates',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data['data'] as List<dynamic>? ?? const [];
    return data
        .whereType<Map>()
        .map(
          (item) =>
              ProductCertificateModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  @override
  Future<List<StoreCertificateModel>> getMyStoreCertificates() async {
    final response = await dio.get('/users/me/store-certificates');
    final data = response.data['data'] as List<dynamic>? ?? const [];
    return data
        .whereType<Map>()
        .map(
          (item) =>
              StoreCertificateModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  @override
  Future<StoreCertificateModel> submitStoreCertificate({
    required String localPath,
    required Map<String, dynamic> metadata,
  }) async {
    final uploaded = await uploadQueue.uploadFile(
      localPath: localPath,
      folder: 'store-certificates',
    );
    final response = await dio.post(
      '/users/me/store-certificates',
      data: {...metadata, 'storageKey': uploaded.path},
    );
    return StoreCertificateModel.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  @override
  Future<void> deleteStoreCertificate(String certificateId) async {
    await dio.delete('/users/me/store-certificates/$certificateId');
  }

  @override
  Future<List<StoreCertificateModel>> getSupplierStoreCertificates(
    String supplierId,
  ) async {
    final response = await dio.get('/suppliers/$supplierId/store-certificates');
    final data = response.data['data'] as List<dynamic>? ?? const [];
    return data
        .whereType<Map>()
        .map(
          (item) =>
              StoreCertificateModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}
