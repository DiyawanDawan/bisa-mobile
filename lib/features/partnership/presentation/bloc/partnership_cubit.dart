import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/partnership_entity.dart';
import '../../domain/repositories/partnership_repository.dart';

class PartnershipState extends Equatable {
  final List<PartnershipEntity> partnerships;
  final PartnershipEntity? selected;
  final PartnershipEntity? supplierCheck;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const PartnershipState({
    this.partnerships = const [],
    this.selected,
    this.supplierCheck,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  PartnershipState copyWith({
    List<PartnershipEntity>? partnerships,
    PartnershipEntity? selected,
    PartnershipEntity? supplierCheck,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
    bool clearSelected = false,
    bool clearSupplierCheck = false,
  }) {
    return PartnershipState(
      partnerships: partnerships ?? this.partnerships,
      selected: clearSelected ? null : (selected ?? this.selected),
      supplierCheck: clearSupplierCheck ? null : (supplierCheck ?? this.supplierCheck),
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props =>
      [partnerships, selected, supplierCheck, isLoading, isSubmitting, error];
}

class PartnershipCubit extends Cubit<PartnershipState> {
  final PartnershipRepository _repository;

  PartnershipCubit(this._repository) : super(const PartnershipState());

  Future<void> loadPartnerships({String? status}) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.listPartnerships(status: status);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (list) => emit(state.copyWith(isLoading: false, partnerships: list)),
    );
  }

  Future<void> loadDetail(String id) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.getPartnership(id);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (p) => emit(state.copyWith(isLoading: false, selected: p)),
    );
  }

  Future<void> checkSupplier(String supplierId) async {
    final result = await _repository.checkWithSupplier(supplierId);
    result.fold(
      (_) {},
      (p) => emit(state.copyWith(supplierCheck: p)),
    );
  }

  Future<String?> createPartnership(Map<String, dynamic> body) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _repository.createPartnership(body);
    return result.fold(
      (f) {
        emit(state.copyWith(isSubmitting: false, error: f.message));
        return f.message;
      },
      (p) {
        emit(state.copyWith(
          isSubmitting: false,
          selected: p,
          partnerships: [p, ...state.partnerships],
        ));
        return null;
      },
    );
  }

  Future<String?> accept(String id) => _action((_) => _repository.acceptPartnership(id), id);

  Future<String?> reject(String id, String reason) =>
      _action((_) => _repository.rejectPartnership(id, reason), id);

  Future<String?> sign(String id) => _action((_) => _repository.signPartnership(id), id);

  Future<String?> terminate(String id, {String? reason}) =>
      _action((_) => _repository.terminatePartnership(id, reason: reason), id);

  Future<String?> requestRenewal(String id, DateTime newEndDate, {String? note}) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _repository.requestRenewal(id, newEndDate, note: note);
    return result.fold(
      (f) {
        emit(state.copyWith(isSubmitting: false, error: f.message));
        return f.message;
      },
      (PartnershipEntity p) {
        final updated = state.partnerships
            .map((e) => e.id == p.id ? p : e)
            .toList(growable: false);
        emit(state.copyWith(isSubmitting: false, selected: p, partnerships: updated));
        return null;
      },
    );
  }

  Future<String?> acceptRenewal(String id) =>
      _action((_) => _repository.acceptRenewal(id), id);

  Future<String?> rejectRenewal(String id, {String? reason}) =>
      _action((_) => _repository.rejectRenewal(id, reason: reason), id);

  Future<String?> _action(
    Future<dynamic> Function(void _) call,
    String id,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await call(null);
    return result.fold(
      (f) {
        emit(state.copyWith(isSubmitting: false, error: f.message));
        return f.message;
      },
      (PartnershipEntity p) {
        final updated = state.partnerships
            .map((e) => e.id == p.id ? p : e)
            .toList(growable: false);
        emit(state.copyWith(isSubmitting: false, selected: p, partnerships: updated));
        return null;
      },
    );
  }
}
