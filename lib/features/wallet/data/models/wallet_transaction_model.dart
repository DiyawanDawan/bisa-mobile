import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/wallet_transaction_entity.dart';

part 'wallet_transaction_model.freezed.dart';
part 'wallet_transaction_model.g.dart';

@freezed
abstract class WalletTransactionModel with _$WalletTransactionModel {
  const factory WalletTransactionModel({
    @Default('') String id,
    @Default(0.0) double amount,
    @Default(0.0) double sellerAmount,
    @Default(0.0) double platformFee,
    @Default('PENDING') String status,
    @Default('UNKNOWN') String type,
    String? externalId,
    DateTime? paidAt,
    DateTime? escrowReleasedAt,
    required DateTime createdAt,
    Map<String, dynamic>? order,
    String? paymentMethod,
  }) = _WalletTransactionModel;

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionModelFromJson(json);

  const WalletTransactionModel._();

  WalletTransactionEntity toEntity() => WalletTransactionEntity(
    id: id,
    amount: amount,
    sellerAmount: sellerAmount,
    platformFee: platformFee,
    status: _mapStatus(status),
    type: _mapType(type),
    externalId: externalId,
    paidAt: paidAt,
    escrowReleasedAt: escrowReleasedAt,
    createdAt: createdAt,
    orderNumber: order?['orderNumber'],
    paymentMethod: paymentMethod,
  );

  WalletTransactionStatus _mapStatus(String status) {
    switch (status) {
      case 'PENDING':
        return WalletTransactionStatus.pending;
      case 'ESCROW_HELD':
        return WalletTransactionStatus.escrowHeld;
      case 'RELEASED':
        return WalletTransactionStatus.released;
      case 'FAILED':
        return WalletTransactionStatus.failed;
      case 'REFUNDED':
        return WalletTransactionStatus.refunded;
      default:
        return WalletTransactionStatus.unknown;
    }
  }

  WalletTransactionType _mapType(String type) {
    switch (type) {
      case 'SALES':
        return WalletTransactionType.sales;
      case 'PAYOUT':
        return WalletTransactionType.payout;
      case 'SUBSCRIPTION':
        return WalletTransactionType.subscription;
      default:
        return WalletTransactionType.unknown;
    }
  }
}
