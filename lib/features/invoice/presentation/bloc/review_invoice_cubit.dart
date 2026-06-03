import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../negotiation/domain/entities/negotiation_entity.dart';
import '../../../negotiation/domain/repositories/negotiation_repository.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/repositories/order_repository.dart';

enum ReviewInvoiceStatus { initial, loading, loaded, error }

class ReviewInvoiceState {
  final ReviewInvoiceStatus status;
  final NegotiationEntity? negotiation;
  final OrderEntity? order;
  final String? errorMessage;

  const ReviewInvoiceState({
    this.status = ReviewInvoiceStatus.initial,
    this.negotiation,
    this.order,
    this.errorMessage,
  });

  ReviewInvoiceState copyWith({
    ReviewInvoiceStatus? status,
    NegotiationEntity? negotiation,
    OrderEntity? order,
    String? errorMessage,
  }) {
    return ReviewInvoiceState(
      status: status ?? this.status,
      negotiation: negotiation ?? this.negotiation,
      order: order ?? this.order,
      errorMessage: errorMessage,
    );
  }
}

class ReviewInvoiceCubit extends Cubit<ReviewInvoiceState> {
  final NegotiationRepository _negotiationRepository;
  final OrderRepository _orderRepository;

  ReviewInvoiceCubit(this._negotiationRepository, this._orderRepository)
      : super(const ReviewInvoiceState());

  Future<void> load(String negotiationId) async {
    emit(state.copyWith(status: ReviewInvoiceStatus.loading, errorMessage: null));

    final negotiationResult =
        await _negotiationRepository.getNegotiationDetail(negotiationId);

    await negotiationResult.fold(
      (failure) async {
        emit(state.copyWith(
          status: ReviewInvoiceStatus.error,
          errorMessage: failure.message,
        ));
      },
      (negotiation) async {
        final orderId = negotiation.orderId;
        if (orderId == null || orderId.isEmpty) {
          emit(state.copyWith(
            status: ReviewInvoiceStatus.error,
            errorMessage: 'Tagihan belum diterbitkan untuk negosiasi ini.',
          ));
          return;
        }

        final orderResult = await _orderRepository.getOrderDetail(orderId);
        orderResult.fold(
          (failure) => emit(state.copyWith(
            status: ReviewInvoiceStatus.error,
            errorMessage: failure.message,
          )),
          (order) => emit(state.copyWith(
            status: ReviewInvoiceStatus.loaded,
            negotiation: negotiation,
            order: order,
          )),
        );
      },
    );
  }
}
