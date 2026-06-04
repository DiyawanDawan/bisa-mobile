import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_bisa/features/invoice/domain/entities/invoice_deal_economics.dart';

part 'negotiation_entity.freezed.dart';

class NegotiationOrderSummaryEntity {
  const NegotiationOrderSummaryEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
    this.totalAmount,
  });

  final String id;
  final String orderNumber;
  final String status;
  final double? totalAmount;
}

@freezed
abstract class NegotiationEntity with _$NegotiationEntity {
  const factory NegotiationEntity({
    required String id,
    String? orderId,
    NegotiationOrderSummaryEntity? order,
    required String productId,
    required String buyerId,
    required String sellerId,
    required double quantity,
    required double pricePerUnit,
    required double totalEstimate,
    String? specifications,
    @Default('NEGOTIATION') String roomType,
    required String status,
    required bool isLocked,
    String? rejectionReason,
    String? closedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required NegotiationProductEntity product,
    required NegotiationParticipantEntity buyer,
    required NegotiationParticipantEntity seller,
    List<NegotiationMessageEntity>? messages,
    int? messagesTotal,
    InvoiceDealEconomics? economics,
  }) = _NegotiationEntity;
}

@freezed
abstract class NegotiationProductEntity with _$NegotiationProductEntity {
  const factory NegotiationProductEntity({
    required String id,
    required String name,
    String? thumbnailUrl,
    required double pricePerUnit,
    required String unit,
    @Default(1) double minOrder,
    @Default(0) double stock,
    String? description,
    String? biomassaType,
    String? regency,
    String? province,
    String? status,
  }) = _NegotiationProductEntity;
}

@freezed
abstract class NegotiationParticipantEntity with _$NegotiationParticipantEntity {
  const factory NegotiationParticipantEntity({
    required String id,
    required String name,
    String? avatarUrl,
    String? companyName,
  }) = _NegotiationParticipantEntity;
}

@freezed
abstract class NegotiationMessageEntity with _$NegotiationMessageEntity {
  const factory NegotiationMessageEntity({
    required String id,
    required String senderId,
    required String content,
    String? attachmentUrl,
    required bool isSystemMessage,
    required bool isRead,
    @Default(false) bool isDeleted,
    DateTime? editedAt,
    required DateTime createdAt,
  }) = _NegotiationMessageEntity;
}
