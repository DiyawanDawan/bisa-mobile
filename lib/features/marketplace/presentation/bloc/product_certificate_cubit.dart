import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_certificate_entity.dart';
import '../../domain/repositories/marketplace_repository.dart';

class ProductCertificateState {
  const ProductCertificateState({
    this.items = const [],
    this.loading = false,
    this.submitting = false,
    this.error,
  });

  final List<ProductCertificateEntity> items;
  final bool loading;
  final bool submitting;
  final String? error;

  ProductCertificateState copyWith({
    List<ProductCertificateEntity>? items,
    bool? loading,
    bool? submitting,
    String? error,
    bool clearError = false,
  }) {
    return ProductCertificateState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class ProductCertificateCubit extends Cubit<ProductCertificateState> {
  ProductCertificateCubit(this._repository)
    : super(const ProductCertificateState());

  final MarketplaceRepository _repository;

  Future<void> loadOwner(String productId) async {
    emit(state.copyWith(loading: true, clearError: true));
    final result = await _repository.getMyProductCertificates(productId);
    result.fold(
      (failure) =>
          emit(state.copyWith(loading: false, error: failure.localizedMessage)),
      (items) =>
          emit(state.copyWith(items: items, loading: false, clearError: true)),
    );
  }

  Future<bool> submit({
    required String productId,
    required String localPath,
    required Map<String, dynamic> metadata,
  }) async {
    emit(state.copyWith(submitting: true, clearError: true));
    final result = await _repository.submitProductCertificate(
      productId: productId,
      localPath: localPath,
      metadata: metadata,
    );
    return result.fold<Future<bool>>(
      (failure) async {
        emit(
          state.copyWith(submitting: false, error: failure.localizedMessage),
        );
        return false;
      },
      (_) async {
        await loadOwner(productId);
        emit(state.copyWith(submitting: false));
        return true;
      },
    );
  }

  Future<bool> remove(String productId, String certificateId) async {
    emit(state.copyWith(submitting: true, clearError: true));
    final result = await _repository.deleteProductCertificate(
      productId,
      certificateId,
    );
    return result.fold(
      (failure) async {
        emit(
          state.copyWith(submitting: false, error: failure.localizedMessage),
        );
        return false;
      },
      (_) async {
        await loadOwner(productId);
        emit(state.copyWith(submitting: false));
        return true;
      },
    );
  }
}
