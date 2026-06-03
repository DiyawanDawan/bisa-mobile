import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_entity.freezed.dart';

@freezed
abstract class WalletEntity with _$WalletEntity {
  const factory WalletEntity({
    required String id,
    required String userId,
    required double balance,
    required double totalEarned,
    required double totalWithdrawn,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WalletEntity;
}
