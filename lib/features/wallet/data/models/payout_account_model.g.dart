// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayoutAccountModel _$PayoutAccountModelFromJson(Map<String, dynamic> json) =>
    _PayoutAccountModel(
      id: json['id'] as String,
      bankId: json['bankId'] as String,
      accountNumber: json['accountNumber'] as String,
      accountName: json['accountName'] as String,
      isMain: json['isMain'] as bool? ?? false,
      bank: json['bank'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PayoutAccountModelToJson(_PayoutAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bankId': instance.bankId,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
      'isMain': instance.isMain,
      'bank': instance.bank,
    };
