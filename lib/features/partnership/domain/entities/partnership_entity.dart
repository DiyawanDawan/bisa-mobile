import 'package:equatable/equatable.dart';

class PartnershipUserEntity extends Equatable {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final String? province;
  final String? regency;
  final bool isVerified;
  final String? companyName;
  final String? businessType;

  const PartnershipUserEntity({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    this.province,
    this.regency,
    this.isVerified = false,
    this.companyName,
    this.businessType,
  });

  @override
  List<Object?> get props => [id, fullName, role];
}

class PartnershipEntity extends Equatable {
  final String id;
  final String contractNumber;
  final String buyerId;
  final String supplierId;
  final String tier;
  final String status;
  final String title;
  final String? description;
  final String? productCategory;
  final double? estimatedMonthlyQty;
  final String? priceAgreement;
  final String? deliveryTerms;
  final String? paymentTerms;
  final String? specialTerms;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? buyerSignedAt;
  final DateTime? sellerSignedAt;
  final bool isFullySigned;
  final String? rejectionReason;
  final DateTime? terminatedAt;
  final int renewalCount;
  final DateTime? renewalProposedEndDate;
  final String? renewalRequestedBy;
  final String? renewalNote;
  final int? daysUntilExpiry;
  final String? contractPhase;
  final bool canRenew;
  final bool isRenewalPending;
  final DateTime createdAt;
  final PartnershipUserEntity buyer;
  final PartnershipUserEntity supplier;

  const PartnershipEntity({
    required this.id,
    required this.contractNumber,
    required this.buyerId,
    required this.supplierId,
    required this.tier,
    required this.status,
    required this.title,
    this.description,
    this.productCategory,
    this.estimatedMonthlyQty,
    this.priceAgreement,
    this.deliveryTerms,
    this.paymentTerms,
    this.specialTerms,
    required this.startDate,
    required this.endDate,
    this.buyerSignedAt,
    this.sellerSignedAt,
    this.isFullySigned = false,
    this.rejectionReason,
    this.terminatedAt,
    this.renewalCount = 0,
    this.renewalProposedEndDate,
    this.renewalRequestedBy,
    this.renewalNote,
    this.daysUntilExpiry,
    this.contractPhase,
    this.canRenew = false,
    this.isRenewalPending = false,
    required this.createdAt,
    required this.buyer,
    required this.supplier,
  });

  bool get isActive => status == 'ACTIVE';
  bool get isExpired => status == 'EXPIRED';
  bool get isPending => status == 'PENDING';
  bool get canSign => status == 'PENDING' || status == 'AWAITING_SIGNATURE';

  @override
  List<Object?> get props => [id, status, contractNumber, endDate];
}
