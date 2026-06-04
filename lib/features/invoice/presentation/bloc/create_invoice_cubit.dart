import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/invoice_draft.dart';
import '../../domain/entities/invoice_preview_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../utils/invoice_issue_readiness.dart';

enum CreateInvoiceStatus { initial, loading, loaded, submitting, success, error }

class CreateInvoiceState {
  final CreateInvoiceStatus status;
  final InvoicePreviewEntity? preview;
  final InvoiceDraft? draft;
  final Map<String, dynamic>? shippingSelection;
  final Map<String, dynamic>? sellerShippingSnapshot;
  final int? sellerOriginId;
  final String? sellerOriginLabel;
  final String? errorMessage;

  const CreateInvoiceState({
    this.status = CreateInvoiceStatus.initial,
    this.preview,
    this.draft,
    this.shippingSelection,
    this.sellerShippingSnapshot,
    this.sellerOriginId,
    this.sellerOriginLabel,
    this.errorMessage,
  });

  CreateInvoiceState copyWith({
    CreateInvoiceStatus? status,
    InvoicePreviewEntity? preview,
    InvoiceDraft? draft,
    Map<String, dynamic>? shippingSelection,
    Map<String, dynamic>? sellerShippingSnapshot,
    int? sellerOriginId,
    String? sellerOriginLabel,
    String? errorMessage,
    bool clearShippingSelection = false,
  }) {
    return CreateInvoiceState(
      status: status ?? this.status,
      preview: preview ?? this.preview,
      draft: draft ?? this.draft,
      shippingSelection: clearShippingSelection
          ? null
          : (shippingSelection ?? this.shippingSelection),
      sellerShippingSnapshot:
          sellerShippingSnapshot ?? this.sellerShippingSnapshot,
      sellerOriginId: sellerOriginId ?? this.sellerOriginId,
      sellerOriginLabel: sellerOriginLabel ?? this.sellerOriginLabel,
      errorMessage: errorMessage,
    );
  }

  InvoicePreviewEntity? get previewWithDraft {
    if (preview == null || draft == null) return preview;
    return draft!.applyToPreview(preview!);
  }
}

class CreateInvoiceCubit extends Cubit<CreateInvoiceState> {
  final InvoiceRepository _repository;

  CreateInvoiceCubit(this._repository) : super(const CreateInvoiceState());

  Future<void> loadPreview(String negotiationId) async {
    emit(state.copyWith(status: CreateInvoiceStatus.loading, errorMessage: null));
    final draft = state.draft;
    final result = await _repository.getInvoicePreview(
      negotiationId,
      shippingSelection: state.shippingSelection,
      shippingSnapshot: draft?.toShippingSnapshot(),
      quantity: draft?.quantity,
      pricePerUnit: draft?.pricePerUnit,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: CreateInvoiceStatus.error,
        errorMessage: failure.message,
      )),
      (preview) => emit(state.copyWith(
        status: CreateInvoiceStatus.loaded,
        preview: preview,
        draft: state.draft ?? InvoiceDraft.fromPreview(preview),
        sellerShippingSnapshot: preview.sellerShippingSnapshot,
        sellerOriginId: preview.sellerOriginId,
        sellerOriginLabel: preview.sellerOriginLabel,
      )),
    );
  }

  Future<void> refreshPreview(String negotiationId) async {
    final draft = state.draft;
    if (draft == null) return;

    final result = await _repository.getInvoicePreview(
      negotiationId,
      shippingSelection: state.shippingSelection,
      shippingSnapshot: draft.toShippingSnapshot(),
      quantity: draft.quantity,
      pricePerUnit: draft.pricePerUnit,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (preview) => emit(state.copyWith(
        status: CreateInvoiceStatus.loaded,
        preview: preview,
        sellerShippingSnapshot: preview.sellerShippingSnapshot,
        sellerOriginId: preview.sellerOriginId,
        sellerOriginLabel: preview.sellerOriginLabel,
        errorMessage: null,
      )),
    );
  }

  bool _destinationFieldsChanged(InvoiceDraft prev, InvoiceDraft next) {
    return prev.address.trim() != next.address.trim() ||
        prev.regency.trim() != next.regency.trim() ||
        prev.province.trim() != next.province.trim() ||
        (prev.zipCode ?? '') != (next.zipCode ?? '') ||
        prev.latitude != next.latitude ||
        prev.longitude != next.longitude;
  }

  /// Returns true when preview should be refreshed (alamat berubah / ongkir di-reset).
  bool updateDraft(InvoiceDraft draft) {
    final prev = state.draft;
    final destinationChanged =
        prev != null && _destinationFieldsChanged(prev, draft);
    emit(state.copyWith(
      draft: draft,
      clearShippingSelection: destinationChanged,
    ));
    return destinationChanged;
  }

  static bool isDestinationReady(InvoiceDraft? draft) {
    if (draft == null) return false;
    if (draft.address.trim().length < 10) return false;
    final hasRegion = draft.regency.trim().isNotEmpty ||
        draft.province.trim().isNotEmpty;
    return hasRegion;
  }

  void setShippingSelection(Map<String, dynamic>? selection) {
    emit(state.copyWith(
      shippingSelection: selection,
      clearShippingSelection: selection == null,
    ));
  }

  /// Isi ulang alamat dari profil/alamat utama pembeli (backend).
  Future<void> resetShippingFromBuyerProfile(String negotiationId) async {
    final draft = state.draft;
    if (draft == null) return;

    final result = await _repository.getInvoicePreview(
      negotiationId,
      shippingSelection: state.shippingSelection,
      quantity: draft.quantity,
      pricePerUnit: draft.pricePerUnit,
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (preview) {
        final shippingDraft = InvoiceDraft.fromShippingSnapshot(
          preview.shippingSnapshot ?? {},
          specifications: draft.specifications,
          quantity: draft.quantity,
          pricePerUnit: draft.pricePerUnit,
          fallbackRecipient: preview.buyerName,
        );
        emit(state.copyWith(
          preview: preview,
          draft: shippingDraft,
          sellerShippingSnapshot: preview.sellerShippingSnapshot,
          sellerOriginId: preview.sellerOriginId,
          sellerOriginLabel: preview.sellerOriginLabel,
          errorMessage: null,
          clearShippingSelection: true,
        ));
      },
    );
  }

  void applyShippingSnapshot(Map<String, dynamic> snapshot) {
    final draft = state.draft;
    final preview = state.preview;
    if (draft == null || preview == null) return;

    final next = InvoiceDraft.fromShippingSnapshot(
      snapshot,
      specifications: draft.specifications,
      quantity: draft.quantity,
      pricePerUnit: draft.pricePerUnit,
      fallbackRecipient: preview.buyerName,
    );
    emit(state.copyWith(draft: next, clearShippingSelection: true));
  }

  Future<Map<String, dynamic>?> fetchBuyerShippingAddresses(
    String negotiationId,
  ) async {
    final result = await _repository.getBuyerShippingAddresses(negotiationId);
    return result.fold((failure) {
      emit(state.copyWith(errorMessage: failure.message));
      return null;
    }, (data) => data);
  }

  InvoiceIssueReadiness get issueReadiness =>
      InvoiceIssueReadinessEvaluator.evaluate(state);

  Future<bool> issueInvoice(String negotiationId) async {
    final readiness = issueReadiness;
    if (!readiness.canIssue) {
      emit(state.copyWith(
        status: CreateInvoiceStatus.loaded,
        errorMessage: readiness.summaryMessage,
      ));
      return false;
    }

    final draft = state.draft!;

    emit(state.copyWith(status: CreateInvoiceStatus.submitting, errorMessage: null));
    final result = await _repository.issueInvoice(
      negotiationId,
      shippingSnapshot: draft.toShippingSnapshot(),
      shippingSelection: state.shippingSelection,
      specifications: draft.specifications.trim().isEmpty
          ? null
          : draft.specifications.trim(),
      quantity: draft.quantity,
      pricePerUnit: draft.pricePerUnit,
    );
    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: CreateInvoiceStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(status: CreateInvoiceStatus.success));
        return true;
      },
    );
  }
}
