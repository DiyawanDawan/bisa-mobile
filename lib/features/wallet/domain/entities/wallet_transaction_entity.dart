import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_transaction_entity.freezed.dart';

enum WalletTransactionType { sales, payout, subscription, unknown }

enum WalletTransactionStatus {
  pending,
  escrowHeld,
  released,
  failed,
  refunded,
  unknown,
}

@freezed
abstract class WalletTransactionEntity with _$WalletTransactionEntity {
  const factory WalletTransactionEntity({
    required String id,
    required double amount,
    required double sellerAmount,
    required double platformFee,
    required WalletTransactionStatus status,
    required WalletTransactionType type,
    String? externalId,
    DateTime? paidAt,
    DateTime? escrowReleasedAt,
    required DateTime createdAt,
    String? orderNumber,
    String? paymentMethod,
  }) = _WalletTransactionEntity;
}
