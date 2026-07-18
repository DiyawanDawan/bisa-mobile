class PartnershipUserModel {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final String? province;
  final String? regency;
  final bool isVerified;
  final String? companyName;
  final String? businessType;

  PartnershipUserModel({
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

  factory PartnershipUserModel.fromJson(Map<String, dynamic> json) {
    return PartnershipUserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String? ?? '',
      province: json['province'] as String?,
      regency: json['regency'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      companyName: json['companyName'] as String?,
      businessType: json['businessType'] as String?,
    );
  }
}

class PartnershipSignatureModel {
  final String party;
  final String label;
  final DateTime? signedAt;
  final String? signerName;
  final String? signerTitle;
  final String? companyName;

  PartnershipSignatureModel({
    required this.party,
    required this.label,
    this.signedAt,
    this.signerName,
    this.signerTitle,
    this.companyName,
  });

  factory PartnershipSignatureModel.fromJson(Map<String, dynamic> json) {
    return PartnershipSignatureModel(
      party: json['party'] as String? ?? '',
      label: json['label'] as String? ?? '',
      signedAt: json['signedAt'] != null
          ? DateTime.parse(json['signedAt'] as String)
          : null,
      signerName: json['signerName'] as String?,
      signerTitle: json['signerTitle'] as String?,
      companyName: json['companyName'] as String?,
    );
  }
}

class PartnershipModel {
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
  final DateTime? platformSignedAt;
  final String? buyerSignerName;
  final String? buyerSignerTitle;
  final String? buyerCompanyName;
  final String? sellerSignerName;
  final String? sellerSignerTitle;
  final String? sellerCompanyName;
  final String? platformSignerName;
  final String? platformSignerTitle;
  final bool isFullySigned;
  final int requiredSigners;
  final int signedCount;
  final List<PartnershipSignatureModel> signatures;
  final String? rejectionReason;
  final DateTime? terminatedAt;
  final String? terminatedBy;
  final int renewalCount;
  final DateTime? renewalProposedEndDate;
  final String? renewalRequestedBy;
  final DateTime? renewalRequestedAt;
  final String? renewalNote;
  final int? daysUntilExpiry;
  final String? contractPhase;
  final bool canRenew;
  final bool isRenewalPending;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PartnershipUserModel buyer;
  final PartnershipUserModel supplier;

  PartnershipModel({
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
    this.platformSignedAt,
    this.buyerSignerName,
    this.buyerSignerTitle,
    this.buyerCompanyName,
    this.sellerSignerName,
    this.sellerSignerTitle,
    this.sellerCompanyName,
    this.platformSignerName,
    this.platformSignerTitle,
    this.isFullySigned = false,
    this.requiredSigners = 3,
    this.signedCount = 0,
    this.signatures = const [],
    this.rejectionReason,
    this.terminatedAt,
    this.terminatedBy,
    this.renewalCount = 0,
    this.renewalProposedEndDate,
    this.renewalRequestedBy,
    this.renewalRequestedAt,
    this.renewalNote,
    this.daysUntilExpiry,
    this.contractPhase,
    this.canRenew = false,
    this.isRenewalPending = false,
    required this.createdAt,
    required this.updatedAt,
    required this.buyer,
    required this.supplier,
  });

  factory PartnershipModel.fromJson(Map<String, dynamic> json) {
    final sigList = json['signatures'] as List? ?? [];
    return PartnershipModel(
      id: json['id'] as String,
      contractNumber: json['contractNumber'] as String,
      buyerId: json['buyerId'] as String,
      supplierId: json['supplierId'] as String,
      tier: json['tier'] as String? ?? 'MAIN_PARTNER',
      status: json['status'] as String? ?? 'PENDING',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      productCategory: json['productCategory'] as String?,
      estimatedMonthlyQty: (json['estimatedMonthlyQty'] as num?)?.toDouble(),
      priceAgreement: json['priceAgreement'] as String?,
      deliveryTerms: json['deliveryTerms'] as String?,
      paymentTerms: json['paymentTerms'] as String?,
      specialTerms: json['specialTerms'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      buyerSignedAt: json['buyerSignedAt'] != null
          ? DateTime.parse(json['buyerSignedAt'] as String)
          : null,
      sellerSignedAt: json['sellerSignedAt'] != null
          ? DateTime.parse(json['sellerSignedAt'] as String)
          : null,
      platformSignedAt: json['platformSignedAt'] != null
          ? DateTime.parse(json['platformSignedAt'] as String)
          : null,
      buyerSignerName: json['buyerSignerName'] as String?,
      buyerSignerTitle: json['buyerSignerTitle'] as String?,
      buyerCompanyName: json['buyerCompanyName'] as String?,
      sellerSignerName: json['sellerSignerName'] as String?,
      sellerSignerTitle: json['sellerSignerTitle'] as String?,
      sellerCompanyName: json['sellerCompanyName'] as String?,
      platformSignerName: json['platformSignerName'] as String?,
      platformSignerTitle: json['platformSignerTitle'] as String?,
      isFullySigned: json['isFullySigned'] as bool? ?? false,
      requiredSigners: json['requiredSigners'] as int? ?? 3,
      signedCount: json['signedCount'] as int? ?? 0,
      signatures: sigList
          .map((e) => PartnershipSignatureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rejectionReason: json['rejectionReason'] as String?,
      terminatedAt: json['terminatedAt'] != null
          ? DateTime.parse(json['terminatedAt'] as String)
          : null,
      terminatedBy: json['terminatedBy'] as String?,
      renewalCount: json['renewalCount'] as int? ?? 0,
      renewalProposedEndDate: json['renewalProposedEndDate'] != null
          ? DateTime.parse(json['renewalProposedEndDate'] as String)
          : null,
      renewalRequestedBy: json['renewalRequestedBy'] as String?,
      renewalRequestedAt: json['renewalRequestedAt'] != null
          ? DateTime.parse(json['renewalRequestedAt'] as String)
          : null,
      renewalNote: json['renewalNote'] as String?,
      daysUntilExpiry: json['daysUntilExpiry'] as int?,
      contractPhase: json['contractPhase'] as String?,
      canRenew: json['canRenew'] as bool? ?? false,
      isRenewalPending: json['isRenewalPending'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      buyer: PartnershipUserModel.fromJson(json['buyer'] as Map<String, dynamic>),
      supplier: PartnershipUserModel.fromJson(json['supplier'] as Map<String, dynamic>),
    );
  }
}

class PartnershipListModel {
  final List<PartnershipModel> partnerships;
  final int total;
  final int page;
  final int limit;

  PartnershipListModel({
    required this.partnerships,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PartnershipListModel.fromJson(Map<String, dynamic> json) {
    final list = json['partnerships'] as List? ?? [];
    return PartnershipListModel(
      partnerships: list
          .map((e) => PartnershipModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? list.length,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
    );
  }
}

class PartnershipCheckModel {
  final bool hasPartnership;
  final PartnershipModel? partnership;
  final bool canCreateNew;
  final bool canRenew;

  PartnershipCheckModel({
    required this.hasPartnership,
    this.partnership,
    this.canCreateNew = true,
    this.canRenew = false,
  });

  factory PartnershipCheckModel.fromJson(Map<String, dynamic> json) {
    return PartnershipCheckModel(
      hasPartnership: json['hasPartnership'] as bool? ?? false,
      partnership: json['partnership'] != null
          ? PartnershipModel.fromJson(json['partnership'] as Map<String, dynamic>)
          : null,
      canCreateNew: json['canCreateNew'] as bool? ?? true,
      canRenew: json['canRenew'] as bool? ?? false,
    );
  }
}
