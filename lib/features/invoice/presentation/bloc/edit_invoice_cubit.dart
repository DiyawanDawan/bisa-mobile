import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../negotiation/domain/repositories/negotiation_repository.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/repositories/order_repository.dart';
import '../../domain/entities/invoice_draft.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../utils/invoice_issue_readiness.dart';

enum EditInvoiceStatus { initial, loading, loaded, submitting, success, error }

class EditInvoiceState {
  final EditInvoiceStatus status;
  final OrderEntity? order;
  final InvoiceDraft? draft;
  final String? errorMessage;

  const EditInvoiceState({
    this.status = EditInvoiceStatus.initial,
    this.order,
    this.draft,
    this.errorMessage,
  });

  EditInvoiceState copyWith({
    EditInvoiceStatus? status,
    OrderEntity? order,
    InvoiceDraft? draft,
    String? errorMessage,
  }) {
    return EditInvoiceState(
      status: status ?? this.status,
      order: order ?? this.order,
      draft: draft ?? this.draft,
      errorMessage: errorMessage,
    );
  }

  bool get canEdit => order?.status == 'PENDING';
}

extension EditInvoiceStateReadiness on EditInvoiceState {
  InvoiceIssueReadiness get saveReadiness =>
      InvoiceIssueReadinessEvaluator.evaluateEditShipping(
        canEdit: canEdit,
        shippingBlockers:
            draft?.shippingFieldBlockers() ?? ['invoice.error_data_not_loaded'],
      );
}

class EditInvoiceCubit extends Cubit<EditInvoiceState> {
  final NegotiationRepository _negotiationRepository;
  final OrderRepository _orderRepository;
  final InvoiceRepository _invoiceRepository;

  EditInvoiceCubit(
    this._negotiationRepository,
    this._orderRepository,
    this._invoiceRepository,
  ) : super(const EditInvoiceState());

  Future<void> load(String negotiationId) async {
    emit(state.copyWith(status: EditInvoiceStatus.loading, errorMessage: null));

    final negotiationResult =
        await _negotiationRepository.getNegotiationDetail(negotiationId);

    await negotiationResult.fold(
      (failure) async {
        emit(state.copyWith(
          status: EditInvoiceStatus.error,
          errorMessage: failure.message,
        ));
      },
      (negotiation) async {
        final orderId = negotiation.orderId;
        if (orderId == null || orderId.isEmpty) {
          emit(state.copyWith(
            status: EditInvoiceStatus.error,
            errorMessage: 'invoice.error_not_issued',
          ));
          return;
        }

        final orderResult = await _orderRepository.getOrderDetail(orderId);
        orderResult.fold(
          (failure) => emit(state.copyWith(
            status: EditInvoiceStatus.error,
            errorMessage: failure.message,
          )),
          (order) => emit(state.copyWith(
            status: EditInvoiceStatus.loaded,
            order: order,
            draft: InvoiceDraft.fromOrder(order),
          )),
        );
      },
    );
  }

  void updateDraft(InvoiceDraft draft) {
    emit(state.copyWith(draft: draft));
  }

  Future<bool> saveChanges() async {
    final order = state.order;
    final draft = state.draft;
    if (order == null || draft == null) return false;

    if (!state.canEdit) {
      emit(state.copyWith(
        status: EditInvoiceStatus.error,
        errorMessage: 'invoice.error_locked_after_payment',
      ));
      return false;
    }

    final readiness = state.saveReadiness;
    if (!readiness.canIssue) {
      emit(state.copyWith(
        status: EditInvoiceStatus.loaded,
        errorMessage: readiness.summaryMessage,
      ));
      return false;
    }

    emit(state.copyWith(status: EditInvoiceStatus.submitting, errorMessage: null));
    final result = await _invoiceRepository.updatePendingInvoice(
      order.id,
      shippingSnapshot: draft.toShippingSnapshot(),
      specifications: draft.specifications.trim().isEmpty
          ? ''
          : draft.specifications.trim(),
    );

    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: EditInvoiceStatus.error,
          errorMessage: failure.message,
        ));
        return false;
      },
      (_) {
        emit(state.copyWith(status: EditInvoiceStatus.success));
        return true;
      },
    );
  }
}
