import 'negotiation_entity.dart';

/// Legacy: sebelum kolom `room_type` ada di DB.
const negotiationPurposeInquiryTag = 'PURPOSE:INQUIRY';

extension NegotiationEntityChatPurpose on NegotiationEntity {
  bool get isInquiryChat =>
      roomType.toUpperCase() == 'INQUIRY' ||
      (specifications?.startsWith(negotiationPurposeInquiryTag) ?? false);

  bool get isNegotiationChat => !isInquiryChat;

  bool isParticipant(String userId) =>
      buyerId == userId || sellerId == userId;

  /// Penjual di ruang ini (bukan role global akun).
  bool isSellerParticipant(String userId) => sellerId == userId;
}
