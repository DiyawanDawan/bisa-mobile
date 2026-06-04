// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      companyName: json['companyName'] as String?,
      businessType: json['businessType'] as String?,
      bio: json['bio'] as String?,
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'companyName': instance.companyName,
      'businessType': instance.businessType,
      'bio': instance.bio,
    };

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  name: json['fullName'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  avatar: json['avatarUrl'] as String?,
  profile: json['profile'] == null
      ? null
      : UserProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
  address: json['province'] as String?,
  role: json['role'] as String? ?? 'user',
  isVerified: json['isEmailVerified'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  tier: json['tier'] as String? ?? 'FREE',
  subscriptionExpiresAt: json['subscriptionExpiresAt'] == null
      ? null
      : DateTime.parse(json['subscriptionExpiresAt'] as String),
  enableNotifications: json['enableNotifications'] as bool? ?? true,
);

Map<String, dynamic> _$UserModelToJson(
  _UserModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'avatarUrl': instance.avatar,
  'profile': instance.profile,
  'province': instance.address,
  'role': instance.role,
  'isEmailVerified': instance.isVerified,
  'createdAt': instance.createdAt.toIso8601String(),
  'tier': instance.tier,
  'subscriptionExpiresAt': instance.subscriptionExpiresAt?.toIso8601String(),
  'enableNotifications': instance.enableNotifications,
};
