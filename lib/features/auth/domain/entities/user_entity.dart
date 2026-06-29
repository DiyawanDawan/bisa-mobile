import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatar,
    String? companyName,
    String? address,
    @Default('user') String role,
    @Default(false) bool isVerified,
    String? kycStatus,
    @Default(false) bool isKycVerified,
    String? kycRejectionReason,
    required DateTime createdAt,
    @Default('FREE') String tier,
    DateTime? subscriptionExpiresAt,
    @Default(true) bool enableNotifications,
  }) = _UserEntity;

  const UserEntity._();

  bool get isKycPending => kycStatus == 'PENDING';

  bool get isKycRejected => kycStatus == 'REJECTED';

  bool get isKycApproved => kycStatus == 'VERIFIED' || isKycVerified;

  bool get canSubmitKycDocuments =>
      kycStatus == null || kycStatus == 'REJECTED';
}
