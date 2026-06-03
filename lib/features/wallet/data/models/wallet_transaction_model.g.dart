// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletTransactionModel _$WalletTransactionModelFromJson(
  Map<String, dynamic> json,
) => _WalletTransactionModel(
  id: json['id'] as String? ?? '',
  amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
  sellerAmount: (json['sellerAmount'] as num?)?.toDouble() ?? 0.0,
  platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
  status: json['status'] as String? ?? 'PENDING',
  type: json['type'] as String? ?? 'UNKNOWN',
  externalId: json['externalId'] as String?,
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
  escrowReleasedAt: json['escrowReleasedAt'] == null
      ? null
      : DateTime.parse(json['escrowReleasedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  order: json['order'] as Map<String, dynamic>?,
  paymentMethod: json['paymentMethod'] as String?,
);

Map<String, dynamic> _$WalletTransactionModelToJson(
  _WalletTransactionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'sellerAmount': instance.sellerAmount,
  'platformFee': instance.platformFee,
  'status': instance.status,
  'type': instance.type,
  'externalId': instance.externalId,
  'paidAt': instance.paidAt?.toIso8601String(),
  'escrowReleasedAt': instance.escrowReleasedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'order': instance.order,
  'paymentMethod': instance.paymentMethod,
};
