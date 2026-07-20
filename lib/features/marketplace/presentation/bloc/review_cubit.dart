import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/review_repository.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _repository;

  ReviewCubit(this._repository) : super(const ReviewState.initial());

  Future<void> getProductReviews(
    String productId, {
    int? rating,
    bool? hasMedia,
  }) async {
    emit(const ReviewState.loading());
    final result = await _repository.getProductReviews(
      productId,
      rating: rating,
      hasMedia: hasMedia,
    );
    result.fold(
      (failure) => emit(ReviewState.error(failure.message)),
      (reviews) => emit(ReviewState.loaded(reviews)),
    );
  }

  Future<void> postReview({
    required String productId,
    required String orderId,
    required double rating,
    required String comment,
  }) async {
    emit(const ReviewState.loading());
    final result = await _repository.postReview(
      productId: productId,
      orderId: orderId,
      rating: rating,
      comment: comment,
    );
    result.fold(
      (failure) => emit(ReviewState.error(failure.message)),
      (_) => emit(const ReviewState.success()),
    );
  }

  Future<void> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    emit(const ReviewState.loading());
    final result = await _repository.updateReview(
      reviewId: reviewId,
      rating: rating,
      comment: comment,
    );
    result.fold(
      (failure) => emit(ReviewState.error(failure.message)),
      (_) => emit(const ReviewState.success()),
    );
  }

  Future<void> replyReview({
    required String reviewId,
    required String productId,
    required String reply,
  }) async {
    emit(const ReviewState.loading());
    final result = await _repository.replyReview(
      reviewId: reviewId,
      reply: reply,
    );
    result.fold(
      (failure) => emit(ReviewState.error(failure.message)),
      (_) {
        emit(const ReviewState.success());
        getProductReviews(productId);
      },
    );
  }
}
