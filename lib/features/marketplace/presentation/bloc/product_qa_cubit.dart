import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_question_entity.dart';
import '../../domain/repositories/product_question_repository.dart';

class ProductQaState extends Equatable {
  final List<ProductQuestionEntity> questions;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const ProductQaState({
    this.questions = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  ProductQaState copyWith({
    List<ProductQuestionEntity>? questions,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
  }) {
    return ProductQaState(
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [questions, isLoading, isSubmitting, error];
}

class ProductQaCubit extends Cubit<ProductQaState> {
  final ProductQuestionRepository _repository;

  ProductQaCubit(this._repository) : super(const ProductQaState());

  Future<void> load(String productId) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.getProductQuestions(productId);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(state.copyWith(
        isLoading: false,
        questions: list,
        clearError: true,
      )),
    );
  }

  Future<bool> ask({
    required String productId,
    required String question,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _repository.askQuestion(
      productId: productId,
      question: question,
    );
    return await result.fold<Future<bool>>(
      (f) async {
        emit(state.copyWith(isSubmitting: false, error: f.message));
        return false;
      },
      (_) async {
        emit(state.copyWith(isSubmitting: false, clearError: true));
        await load(productId);
        return true;
      },
    );
  }

  Future<bool> answer({
    required String questionId,
    required String productId,
    required String answer,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _repository.answerQuestion(
      questionId: questionId,
      answer: answer,
    );
    return await result.fold<Future<bool>>(
      (f) async {
        emit(state.copyWith(isSubmitting: false, error: f.message));
        return false;
      },
      (_) async {
        emit(state.copyWith(isSubmitting: false, clearError: true));
        await load(productId);
        return true;
      },
    );
  }
}
