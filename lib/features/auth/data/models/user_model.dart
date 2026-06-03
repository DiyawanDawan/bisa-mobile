import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    String? companyName,
    String? businessType,
    String? bio,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);
}

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @JsonKey(name: 'fullName') required String name,
    required String email,
    String? phone,
    @JsonKey(name: 'avatarUrl') String? avatar,
    UserProfileModel? profile,
    @JsonKey(name: 'province') String? address,
    @Default('user') String role,
    @JsonKey(name: 'isEmailVerified') @Default(false) bool isVerified,
    required DateTime createdAt,
    @Default('FREE') String tier,
    @JsonKey(name: 'subscriptionExpiresAt') DateTime? subscriptionExpiresAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  const UserModel._();

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        phone: phone,
        avatar: resolveMediaField(avatar),
        companyName: profile?.companyName,
        address: address,
        role: role,
        isVerified: isVerified,
        createdAt: createdAt,
        tier: tier,
        subscriptionExpiresAt: subscriptionExpiresAt,
      );
}
