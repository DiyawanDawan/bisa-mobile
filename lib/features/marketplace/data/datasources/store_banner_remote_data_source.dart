import 'package:dio/dio.dart';
import '../models/store_banner_model.dart';

abstract class StoreBannerRemoteDataSource {
  Future<List<StoreBannerModel>> getMyBanners();
  Future<List<StoreBannerModel>> getUserBanners(String userId);
  Future<StoreBannerModel> uploadBanner(String imagePath, {String? title});
  Future<void> deleteBanner(String bannerId);
  Future<StoreBannerModel> toggleBannerActive(String bannerId, bool isActive);
}

List<StoreBannerModel> parseStoreBannerList(dynamic responseData) {
  if (responseData is! Map) return const [];
  final raw = responseData['data'];
  if (raw == null) return const [];
  if (raw is! List) return const [];

  return raw
      .whereType<Map>()
      .map((e) => StoreBannerModel.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

class StoreBannerRemoteDataSourceImpl implements StoreBannerRemoteDataSource {
  final Dio dio;

  StoreBannerRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<StoreBannerModel>> getMyBanners() async {
    final response = await dio.get('/users/me/store-banners');
    return parseStoreBannerList(response.data);
  }

  @override
  Future<List<StoreBannerModel>> getUserBanners(String userId) async {
    final response = await dio.get('/users/$userId/store-banners');
    return parseStoreBannerList(response.data);
  }

  @override
  Future<StoreBannerModel> uploadBanner(String imagePath, {String? title}) async {
    final formData = FormData.fromMap({
      if (title != null && title.isNotEmpty) 'title': title,
      'image': await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      ),
    });
    final response = await dio.post('/users/me/store-banners', data: formData);
    return StoreBannerModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteBanner(String bannerId) async {
    await dio.delete('/users/me/store-banners/$bannerId');
  }

  @override
  Future<StoreBannerModel> toggleBannerActive(String bannerId, bool isActive) async {
    final response = await dio.patch(
      '/users/me/store-banners/$bannerId',
      data: {'isActive': isActive},
    );
    return StoreBannerModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
