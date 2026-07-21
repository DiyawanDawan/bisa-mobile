import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_certificate_entity.dart';
import '../../domain/repositories/marketplace_repository.dart';

class StoreCertificateState {
  const StoreCertificateState({
    this.items = const [],
    this.loading = false,
    this.submitting = false,
    this.error,
  });

  final List<StoreCertificateEntity> items;
  final bool loading;
  final bool submitting;
  final String? error;

  StoreCertificateState copyWith({
    List<StoreCertificateEntity>? items,
    bool? loading,
    bool? submitting,
    String? error,
    bool clearError = false,
  }) {
    return StoreCertificateState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class StoreCertificateCubit extends Cubit<StoreCertificateState> {
  StoreCertificateCubit(this._repository) : super(const StoreCertificateState());

  final MarketplaceRepository _repository;

  Future<void> loadMine() async {
    emit(state.copyWith(loading: true, clearError: true));
    final result = await _repository.getMyStoreCertificates();
    result.fold(
      (failure) =>
          emit(state.copyWith(loading: false, error: failure.localizedMessage)),
      (items) =>
          emit(state.copyWith(items: items, loading: false, clearError: true)),
    );
  }

  Future<bool> submit({
    required String localPath,
    required Map<String, dynamic> metadata,
  }) async {
    emit(state.copyWith(submitting: true, clearError: true));
    final result = await _repository.submitStoreCertificate(
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
        await loadMine();
        emit(state.copyWith(submitting: false));
        return true;
      },
    );
  }

  Future<bool> remove(String certificateId) async {
    emit(state.copyWith(submitting: true, clearError: true));
    final result = await _repository.deleteStoreCertificate(certificateId);
    return result.fold(
      (failure) async {
        emit(
          state.copyWith(submitting: false, error: failure.localizedMessage),
        );
        return false;
      },
      (_) async {
        await loadMine();
        emit(state.copyWith(submitting: false));
        return true;
      },
    );
  }
}
