import 'package:dio/dio.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getProductReviews(
    String productId, {
    int? rating,
    bool? hasMedia,
  });
  Future<List<ReviewModel>> getMyReviews();
  Future<void> postReview({
    required String productId,
    required String orderId,
    required double rating,
    required String comment,
  });
  Future<void> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  });
  Future<void> replyReview({required String reviewId, required String reply});
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final Dio dio;

  ReviewRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ReviewModel>> getProductReviews(
    String productId, {
    int? rating,
    bool? hasMedia,
  }) async {
    final response = await dio.get(
      '/reviews/products/$productId',
      queryParameters: {
        if (rating != null) 'rating': rating,
        if (hasMedia == true) 'hasMedia': true,
        'limit': 50,
      },
    );
    final List data = response.data['data'];
    return data.map((e) => ReviewModel.fromJson(e)).toList();
  }

  @override
  Future<List<ReviewModel>> getMyReviews() async {
    final response = await dio.get('/reviews/my-reviews');
    final List data = response.data['data'];
    return data.map((e) => ReviewModel.fromJson(e)).toList();
  }

  @override
  Future<void> postReview({
    required String productId,
    required String orderId,
    required double rating,
    required String comment,
  }) async {
    await dio.post(
      '/reviews',
      data: {'orderId': orderId, 'rating': rating.toInt(), 'comment': comment},
    );
  }

  @override
  Future<void> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    await dio.patch(
      '/reviews/$reviewId',
      data: {'rating': rating.toInt(), 'comment': comment},
    );
  }

  @override
  Future<void> replyReview({
    required String reviewId,
    required String reply,
  }) async {
    await dio.patch('/reviews/$reviewId/reply', data: {'reply': reply});
  }
}
