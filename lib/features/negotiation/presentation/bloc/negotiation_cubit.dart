import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/pusher_service.dart';
import '../../domain/entities/negotiation_entity.dart';
import '../../domain/enums/negotiation_chat_purpose.dart';
import '../../domain/repositories/negotiation_repository.dart';

part 'negotiation_state.dart';
part 'negotiation_cubit.freezed.dart';

class NegotiationCubit extends Cubit<NegotiationState> {
  final NegotiationRepository _repository;

  NegotiationCubit(this._repository) : super(const NegotiationState.initial());

  bool _pusherSubscribed = false;

  Future<void> createOffer({
    required String productId,
    required double quantity,
    required double pricePerUnit,
    String? message,
    String? attachmentUrl,
    String? localImagePath,
  }) async {
    emit(const NegotiationState.loading());
    final result = await _repository.createOffer(
      productId: productId,
      quantity: quantity,
      pricePerUnit: pricePerUnit,
      message: message,
      attachmentUrl: attachmentUrl,
      localImagePath: localImagePath,
    );
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (negotiation) => emit(NegotiationState.detailLoaded(negotiation)),
    );
  }

  Future<void> getMyOffers({NegotiationChatPurpose? roomType}) async {
    emit(const NegotiationState.loading());
    final result = await _repository.getMyOffers(roomType: roomType);
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (negotiations) => emit(NegotiationState.loaded(negotiations)),
    );
  }

  Future<void> getIncomingOffers({NegotiationChatPurpose? roomType}) async {
    emit(const NegotiationState.loading());
    final result = await _repository.getIncomingOffers(roomType: roomType);
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (negotiations) => emit(NegotiationState.loaded(negotiations)),
    );
  }

  Future<void> getDetail(String id, {bool showLoading = true}) async {
    if (showLoading) emit(const NegotiationState.loading());
    final result = await _repository.getNegotiationDetail(id);
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (negotiation) => emit(NegotiationState.detailLoaded(negotiation)),
    );
  }

  Future<void> sendChat(
    String negotiationId,
    String content,
    String senderId, {
    String? attachmentUrl,
    String? localFilePath,
  }) async {
    final currentState = state;
    if (currentState is _DetailLoaded) {
      final negotiation = currentState.negotiation;
      final tempMessage = NegotiationMessageEntity(
        id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
        senderId: senderId,
        content: content,
        attachmentUrl: attachmentUrl,
        isSystemMessage: false,
        isRead: false,
        isDeleted: false,
        createdAt: DateTime.now(),
      );

      final updatedMessages = List<NegotiationMessageEntity>.from(
        negotiation.messages ?? [],
      )..add(tempMessage);

      emit(
        NegotiationState.detailLoaded(
          negotiation.copyWith(messages: updatedMessages),
        ),
      );
    }

    final result = await _repository.sendChatMessage(
      negotiationId,
      content,
      attachmentUrl: attachmentUrl,
      localFilePath: localFilePath,
    );
    result.fold((failure) {
      emit(NegotiationState.error(failure.message));
      getDetail(negotiationId, showLoading: false);
    }, (_) => getDetail(negotiationId, showLoading: false));
  }

  Future<void> editChatMessage(
    String negotiationId,
    String messageId,
    String content,
  ) async {
    final result = await _repository.editChatMessage(
      negotiationId,
      messageId,
      content,
    );
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (_) => getDetail(negotiationId, showLoading: false),
    );
  }

  Future<void> deleteChatMessage(
    String negotiationId,
    String messageId,
  ) async {
    final result = await _repository.deleteChatMessage(
      negotiationId,
      messageId,
    );
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (_) => getDetail(negotiationId, showLoading: false),
    );
  }

  Future<void> clearChatMessages(String negotiationId) async {
    final result = await _repository.clearChatMessages(negotiationId);
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (_) => getDetail(negotiationId, showLoading: false),
    );
  }

  Future<void> markMessagesAsRead(String negotiationId) async {
    await _repository.markMessagesAsRead(negotiationId);
  }

  static const int _chatPageSize = 50;

  bool _hasOlderMessages(NegotiationEntity negotiation) {
    final total = negotiation.messagesTotal;
    final loaded = negotiation.messages?.length ?? 0;
    if (total != null) return loaded < total;
    return loaded >= _chatPageSize;
  }

  bool hasOlderMessages(NegotiationEntity negotiation) => _hasOlderMessages(negotiation);

  Future<void> loadOlderChatMessages(String negotiationId) async {
    final currentState = state;
    if (currentState is! _DetailLoaded || currentState.isLoadingOlderMessages) {
      return;
    }

    final negotiation = currentState.negotiation;
    if (!_hasOlderMessages(negotiation)) return;

    final loaded = negotiation.messages?.length ?? 0;
    final total = negotiation.messagesTotal ?? loaded;
    final batchSize = _chatPageSize;
    final skip = (total - loaded - batchSize).clamp(0, total);

    emit(
      NegotiationState.detailLoaded(
        negotiation,
        isTyping: currentState.isTyping,
        isLoadingOlderMessages: true,
      ),
    );

    final result = await _repository.loadOlderChatMessages(
      negotiationId,
      skip: skip,
      limit: batchSize,
    );

    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (olderMessages) {
        final existing = negotiation.messages ?? [];
        final existingIds = existing.map((m) => m.id).toSet();
        final merged = [
          ...olderMessages.where((m) => !existingIds.contains(m.id)),
          ...existing,
        ];
        emit(
          NegotiationState.detailLoaded(
            negotiation.copyWith(messages: merged),
            isTyping: currentState.isTyping,
          ),
        );
      },
    );
  }

  Future<void> acceptOffer(
    String id, {
    double? quantity,
    double? pricePerUnit,
  }) async {
    final result = await _repository.updateStatus(
      id,
      'OFFER_ACCEPTED',
      quantity: quantity,
      pricePerUnit: pricePerUnit,
    );
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (_) => getDetail(id, showLoading: false),
    );
  }

  Future<void> counterOffer(
    String id, {
    required double quantity,
    required double pricePerUnit,
  }) async {
    final result = await _repository.counterOffer(
      id,
      quantity: quantity,
      pricePerUnit: pricePerUnit,
    );
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (_) => getDetail(id, showLoading: false),
    );
  }

  Future<void> rejectOffer(String id, {required String rejectionReason}) async {
    final result = await _repository.updateStatus(
      id,
      'OFFER_REJECTED',
      rejectionReason: rejectionReason,
    );
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (_) => getDetail(id, showLoading: false),
    );
  }

  Future<void> cancelNegotiation(String id, {required String cancellationReason}) async {
    final result = await _repository.cancelNegotiation(id, cancellationReason);
    result.fold(
      (failure) => emit(NegotiationState.error(failure.message)),
      (_) => getDetail(id, showLoading: false),
    );
  }

  Future<void> createContract(String negotiationId, {String? shippingAddress}) async {
    final result = await _repository.createContract(
      negotiationId,
      shippingAddress: shippingAddress,
    );
    result.fold((failure) => emit(NegotiationState.error(failure.message)), (
      _,
    ) {
      emit(const NegotiationState.success('Tagihan berhasil diterbitkan'));
      getDetail(negotiationId, showLoading: false);
    });
  }

  void subscribeToNegotiation(String negotiationId) {
    _pusherSubscribed = true;
    // SEC-MOB-004: pakai private channel agar hanya participant yang lulus auth
    // backend yang bisa subscribe & terima event chat.
    PusherService().init(
      channelName: 'private-negotiation-$negotiationId',
      onEvent: (event) {
        if (event.eventName == 'new-message' ||
            event.eventName == 'status-updated' ||
            event.eventName == 'message-updated' ||
            event.eventName == 'message-deleted' ||
            event.eventName == 'chat-cleared') {
          getDetail(negotiationId, showLoading: false);
        } else if (event.eventName == 'typing-status') {
          final data = event.data;
          if (data != null) {
            final currentState = state;
            if (currentState is _DetailLoaded) {
              emit(NegotiationState.detailLoaded(
                currentState.negotiation,
                isTyping: data['isTyping'] ?? false,
              ));
            }
          }
        }
      },
    );
  }

  Future<void> updateTypingStatus(String negotiationId, bool isTyping) async {
    await _repository.setTypingStatus(negotiationId, isTyping);
  }

  @override
  Future<void> close() async {
    if (_pusherSubscribed) {
      await PusherService().disconnect();
    }
    return super.close();
  }
}
