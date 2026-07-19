import 'package:freezed_annotation/freezed_annotation.dart';

part 'partnership_entity.freezed.dart';

@freezed
abstract class PartnershipUserEntity with _$PartnershipUserEntity {
  const factory PartnershipUserEntity({
    required String id,
    required String fullName,
    String? avatarUrl,
    required String role,
    String? province,
    String? regency,
    @Default(false) bool isVerified,
    String? companyName,
    String? businessType,
  }) = _PartnershipUserEntity;
}

@freezed
abstract class PartnershipSignatureEntity with _$PartnershipSignatureEntity {
  const factory PartnershipSignatureEntity({
    required String party,
    required String label,
    DateTime? signedAt,
    String? signerName,
    String? signerTitle,
    String? companyName,
  }) = _PartnershipSignatureEntity;
}

@freezed
abstract class PartnershipEntity with _$PartnershipEntity {
  const PartnershipEntity._();

  const factory PartnershipEntity({
    required String id,
    required String contractNumber,
    required String buyerId,
    required String supplierId,
    required String tier,
    required String status,
    required String title,
    String? description,
    String? productCategory,
    double? estimatedMonthlyQty,
    String? priceAgreement,
    String? deliveryTerms,
    String? paymentTerms,
    String? specialTerms,
    required DateTime startDate,
    required DateTime endDate,
    DateTime? buyerSignedAt,
    DateTime? sellerSignedAt,
    DateTime? platformSignedAt,
    String? buyerSignerName,
    String? buyerSignerTitle,
    String? buyerCompanyName,
    String? sellerSignerName,
    String? sellerSignerTitle,
    String? sellerCompanyName,
    String? platformSignerName,
    String? platformSignerTitle,
    @Default(false) bool isFullySigned,
    @Default(3) int requiredSigners,
    @Default(0) int signedCount,
    @Default([]) List<PartnershipSignatureEntity> signatures,
    String? rejectionReason,
    DateTime? terminatedAt,
    @Default(0) int renewalCount,
    DateTime? renewalProposedEndDate,
    String? renewalRequestedBy,
    String? renewalNote,
    int? daysUntilExpiry,
    String? contractPhase,
    @Default(false) bool canRenew,
    @Default(false) bool isRenewalPending,
    required DateTime createdAt,
    required PartnershipUserEntity buyer,
    required PartnershipUserEntity supplier,
  }) = _PartnershipEntity;

  bool get isActive => status == 'ACTIVE';
  bool get isExpired => status == 'EXPIRED';
  bool get isPending => status == 'PENDING';
  bool get canSign => status == 'PENDING' || status == 'AWAITING_SIGNATURE';

  PartnershipSignatureEntity? signatureFor(String party) {
    for (final s in signatures) {
      if (s.party == party) return s;
    }
    return null;
  }
}
