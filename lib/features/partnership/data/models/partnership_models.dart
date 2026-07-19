import 'package:freezed_annotation/freezed_annotation.dart';

part 'partnership_models.freezed.dart';

DateTime? _dt(dynamic v) {
  if (v == null) return null;
  return DateTime.tryParse(v.toString());
}

@Freezed(fromJson: false, toJson: false)
abstract class PartnershipUserModel with _$PartnershipUserModel {
  const factory PartnershipUserModel({
    required String id,
    required String fullName,
    String? avatarUrl,
    required String role,
    String? province,
    String? regency,
    @Default(false) bool isVerified,
    String? companyName,
    String? businessType,
  }) = _PartnershipUserModel;

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

@Freezed(fromJson: false, toJson: false)
abstract class PartnershipSignatureModel with _$PartnershipSignatureModel {
  const factory PartnershipSignatureModel({
    required String party,
    required String label,
    DateTime? signedAt,
    String? signerName,
    String? signerTitle,
    String? companyName,
  }) = _PartnershipSignatureModel;

  factory PartnershipSignatureModel.fromJson(Map<String, dynamic> json) {
    return PartnershipSignatureModel(
      party: json['party'] as String? ?? '',
      label: json['label'] as String? ?? '',
      signedAt: _dt(json['signedAt']),
      signerName: json['signerName'] as String?,
      signerTitle: json['signerTitle'] as String?,
      companyName: json['companyName'] as String?,
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class PartnershipModel with _$PartnershipModel {
  const factory PartnershipModel({
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
    @Default([]) List<PartnershipSignatureModel> signatures,
    String? rejectionReason,
    DateTime? terminatedAt,
    String? terminatedBy,
    @Default(0) int renewalCount,
    DateTime? renewalProposedEndDate,
    String? renewalRequestedBy,
    DateTime? renewalRequestedAt,
    String? renewalNote,
    int? daysUntilExpiry,
    String? contractPhase,
    @Default(false) bool canRenew,
    @Default(false) bool isRenewalPending,
    required DateTime createdAt,
    required DateTime updatedAt,
    required PartnershipUserModel buyer,
    required PartnershipUserModel supplier,
  }) = _PartnershipModel;

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
      buyerSignedAt: _dt(json['buyerSignedAt']),
      sellerSignedAt: _dt(json['sellerSignedAt']),
      platformSignedAt: _dt(json['platformSignedAt']),
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
          .map(
            (e) => PartnershipSignatureModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      rejectionReason: json['rejectionReason'] as String?,
      terminatedAt: _dt(json['terminatedAt']),
      terminatedBy: json['terminatedBy'] as String?,
      renewalCount: json['renewalCount'] as int? ?? 0,
      renewalProposedEndDate: _dt(json['renewalProposedEndDate']),
      renewalRequestedBy: json['renewalRequestedBy'] as String?,
      renewalRequestedAt: _dt(json['renewalRequestedAt']),
      renewalNote: json['renewalNote'] as String?,
      daysUntilExpiry: json['daysUntilExpiry'] as int?,
      contractPhase: json['contractPhase'] as String?,
      canRenew: json['canRenew'] as bool? ?? false,
      isRenewalPending: json['isRenewalPending'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      buyer:
          PartnershipUserModel.fromJson(json['buyer'] as Map<String, dynamic>),
      supplier: PartnershipUserModel.fromJson(
        json['supplier'] as Map<String, dynamic>,
      ),
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class PartnershipListModel with _$PartnershipListModel {
  const factory PartnershipListModel({
    required List<PartnershipModel> partnerships,
    required int total,
    required int page,
    required int limit,
  }) = _PartnershipListModel;

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

@Freezed(fromJson: false, toJson: false)
abstract class PartnershipCheckModel with _$PartnershipCheckModel {
  const factory PartnershipCheckModel({
    required bool hasPartnership,
    PartnershipModel? partnership,
    @Default(true) bool canCreateNew,
    @Default(false) bool canRenew,
  }) = _PartnershipCheckModel;

  factory PartnershipCheckModel.fromJson(Map<String, dynamic> json) {
    return PartnershipCheckModel(
      hasPartnership: json['hasPartnership'] as bool? ?? false,
      partnership: json['partnership'] != null
          ? PartnershipModel.fromJson(
              json['partnership'] as Map<String, dynamic>,
            )
          : null,
      canCreateNew: json['canCreateNew'] as bool? ?? true,
      canRenew: json['canRenew'] as bool? ?? false,
    );
  }
}
