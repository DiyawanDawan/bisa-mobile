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
    required DateTime createdAt,
    @Default('FREE') String tier,
    DateTime? subscriptionExpiresAt,
  }) = _UserEntity;

  const UserEntity._();
}
