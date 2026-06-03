import 'package:equatable/equatable.dart';

enum WalletTransactionType { sales, payout, subscription, unknown }

enum WalletTransactionStatus {
  pending,
  escrowHeld,
  released,
  failed,
  refunded,
  unknown,
}

class WalletTransactionEntity extends Equatable {
  final String id;
  final double amount;
  final double sellerAmount;
  final double platformFee;
  final WalletTransactionStatus status;
  final WalletTransactionType type;
  final String? externalId;
  final DateTime? paidAt;
  final DateTime? escrowReleasedAt;
  final DateTime createdAt;
  final String? orderNumber;
  final String? paymentMethod;

  const WalletTransactionEntity({
    required this.id,
    required this.amount,
    required this.sellerAmount,
    required this.platformFee,
    required this.status,
    required this.type,
    this.externalId,
    this.paidAt,
    this.escrowReleasedAt,
    required this.createdAt,
    this.orderNumber,
    this.paymentMethod,
  });

  @override
  List<Object?> get props => [
    id,
    amount,
    sellerAmount,
    platformFee,
    status,
    type,
    externalId,
    paidAt,
    escrowReleasedAt,
    createdAt,
    orderNumber,
    paymentMethod,
  ];
}
