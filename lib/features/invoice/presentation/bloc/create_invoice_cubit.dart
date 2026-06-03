import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/invoice_draft.dart';
import '../../domain/entities/invoice_preview_entity.dart';
import '../../domain/repositories/invoice_repository.dart';

enum CreateInvoiceStatus { initial, loading, loaded, submitting, success, error }

class CreateInvoiceState {
  final CreateInvoiceStatus status;
  final InvoicePreviewEntity? preview;
  final InvoiceDraft? draft;
  final Map<String, dynamic>? shippingSelection;
  final String? errorMessage;

  const CreateInvoiceState({
    this.status = CreateInvoiceStatus.initial,
    this.preview,
    this.draft,
    this.shippingSelection,
    this.errorMessage,
  });

  CreateInvoiceState copyWith({
    CreateInvoiceStatus? status,
    InvoicePreviewEntity? preview,
    InvoiceDraft? draft,
    Map<String, dynamic>? shippingSelection,
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
      )),
    );
  }

  Future<void> refreshPreview(String negotiationId) async {
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
      (preview) => emit(state.copyWith(
        status: CreateInvoiceStatus.loaded,
        preview: preview,
        errorMessage: null,
      )),
    );
  }

  void updateDraft(InvoiceDraft draft) {
    emit(state.copyWith(draft: draft));
  }

  void setShippingSelection(Map<String, dynamic>? selection) {
    emit(state.copyWith(
      shippingSelection: selection,
      clearShippingSelection: selection == null,
    ));
  }

  Future<bool> issueInvoice(String negotiationId) async {
    final draft = state.draft;
    if (draft == null) return false;

    final validationError = draft.validate();
    if (validationError != null) {
      emit(state.copyWith(
        status: CreateInvoiceStatus.error,
        errorMessage: validationError,
      ));
      return false;
    }

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
