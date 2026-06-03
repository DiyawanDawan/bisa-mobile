import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/negotiation_entity.dart';
import '../enums/negotiation_chat_purpose.dart';

abstract class NegotiationRepository {
  Future<Either<Failure, List<NegotiationEntity>>> getMyOffers({
    int page = 1,
    int limit = 20,
    NegotiationChatPurpose? roomType,
  });
  Future<Either<Failure, List<NegotiationEntity>>> getIncomingOffers({
    int page = 1,
    int limit = 20,
    NegotiationChatPurpose? roomType,
  });
  Future<Either<Failure, NegotiationEntity>> getNegotiationDetail(String id);
  /// ID ruang chat aktif untuk produk, atau `null` jika belum ada.
  Future<Either<Failure, String?>> findRoomByProductId(
    String productId, {
    NegotiationChatPurpose purpose = NegotiationChatPurpose.negotiation,
  });
  Future<Either<Failure, void>> sendChatMessage(
    String negotiationId,
    String content, {
    String? attachmentUrl,
    String? localFilePath,
  });
  Future<Either<Failure, void>> updateStatus(
    String id,
    String status, {
    double? quantity,
    double? pricePerUnit,
    String? rejectionReason,
  });
  Future<Either<Failure, void>> cancelNegotiation(String id, String cancellationReason);
  Future<Either<Failure, void>> counterOffer(String id, {required double quantity, required double pricePerUnit});
  Future<Either<Failure, void>> createContract(String negotiationId, {String? shippingAddress});
  Future<Either<Failure, NegotiationEntity>> createOffer({
    required String productId,
    required double quantity,
    required double pricePerUnit,
    String? message,
    String? attachmentUrl,
    String? localImagePath,
    NegotiationChatPurpose? purpose,
  });
  Future<Either<Failure, void>> setTypingStatus(String negotiationId, bool isTyping);
  Future<Either<Failure, void>> editChatMessage(
    String negotiationId,
    String messageId,
    String content,
  );
  Future<Either<Failure, void>> deleteChatMessage(
    String negotiationId,
    String messageId,
  );
  Future<Either<Failure, void>> clearChatMessages(String negotiationId);
  Future<void> markMessagesAsRead(String negotiationId);
  Future<Either<Failure, List<NegotiationMessageEntity>>> loadOlderChatMessages(
    String negotiationId, {
    required int skip,
    int limit = 50,
  });
}
