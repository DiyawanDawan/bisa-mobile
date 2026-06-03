import 'negotiation_entity.dart';

/// Legacy: sebelum kolom `room_type` ada di DB.
const negotiationPurposeInquiryTag = 'PURPOSE:INQUIRY';

extension NegotiationEntityChatPurpose on NegotiationEntity {
  bool get isInquiryChat =>
      roomType.toUpperCase() == 'INQUIRY' ||
      (specifications?.startsWith(negotiationPurposeInquiryTag) ?? false);

  bool get isNegotiationChat => !isInquiryChat;
}
