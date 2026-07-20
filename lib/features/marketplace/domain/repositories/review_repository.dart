import 'package:dartz/dartz.dart';
import 'package:mobile_bisa/features/marketplace/data/models/review_model.dart';
import '../../../../core/errors/failures.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<ReviewModel>>> getProductReviews(
    String productId, {
    int? rating,
    bool? hasMedia,
  });
  Future<Either<Failure, List<ReviewModel>>> getMyReviews();
  Future<Either<Failure, void>> postReview({
    required String productId,
    required String orderId,
    required double rating,
    required String comment,
  });
  Future<Either<Failure, void>> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  });
  Future<Either<Failure, void>> replyReview({
    required String reviewId,
    required String reply,
  });
}
