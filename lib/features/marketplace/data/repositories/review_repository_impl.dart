import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/review_remote_data_source.dart';
import '../models/review_model.dart';
import '../../domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ReviewModel>>> getProductReviews(
    String productId, {
    int? rating,
    bool? hasMedia,
  }) async {
    try {
      final reviews = await remoteDataSource.getProductReviews(
        productId,
        rating: rating,
        hasMedia: hasMedia,
      );
      return Right(reviews.map((r) => r.withResolvedMedia()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReviewModel>>> getMyReviews() async {
    try {
      final reviews = await remoteDataSource.getMyReviews();
      return Right(reviews.map((r) => r.withResolvedMedia()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> postReview({
    required String productId,
    required String orderId,
    required double rating,
    required String comment,
  }) async {
    try {
      await remoteDataSource.postReview(
        productId: productId,
        orderId: orderId,
        rating: rating,
        comment: comment,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    try {
      await remoteDataSource.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> replyReview({
    required String reviewId,
    required String reply,
  }) async {
    try {
      await remoteDataSource.replyReview(
        reviewId: reviewId,
        reply: reply,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _mapDioExceptionToFailure(DioException e) {
    // Simple mapping logic based on standard app pattern
    return ServerFailure(message: e.message ?? 'Server Error');
  }
}
