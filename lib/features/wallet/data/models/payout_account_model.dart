import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_bisa/features/wallet/domain/entities/payout_account_entity.dart';
part 'payout_account_model.freezed.dart';
part 'payout_account_model.g.dart';

@freezed
abstract class PayoutAccountModel with _$PayoutAccountModel {
  const factory PayoutAccountModel({
    required String id,
    required String bankId,
    required String accountNumber,
    required String accountName,
    @Default(false) @JsonKey(name: 'isMain') bool isMain,
    Map<String, dynamic>? bank,
  }) = _PayoutAccountModel;

  factory PayoutAccountModel.fromJson(Map<String, dynamic> json) =>
      _$PayoutAccountModelFromJson(json);

  const PayoutAccountModel._();

  PayoutAccountEntity toEntity() => PayoutAccountEntity(
    id: id,
    bankId: bankId,
    bankName: bank?['name'] ?? 'Unknown Bank',
    bankCode: bank?['code'] ?? '',
    accountNumber: accountNumber,
    accountName: accountName,
    isMain: isMain,
  );
}
