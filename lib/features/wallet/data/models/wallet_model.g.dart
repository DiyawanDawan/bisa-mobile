// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletModel _$WalletModelFromJson(Map<String, dynamic> json) => _WalletModel(
  id: json['id'] as String? ?? '',
  userId: json['userId'] as String? ?? '',
  balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
  totalEarned: (json['totalEarned'] as num?)?.toDouble() ?? 0.0,
  totalWithdrawn: (json['totalWithdrawn'] as num?)?.toDouble() ?? 0.0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$WalletModelToJson(_WalletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'balance': instance.balance,
      'totalEarned': instance.totalEarned,
      'totalWithdrawn': instance.totalWithdrawn,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
