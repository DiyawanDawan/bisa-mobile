import 'package:freezed_annotation/freezed_annotation.dart';

part 'payout_account_entity.freezed.dart';

@freezed
abstract class PayoutAccountEntity with _$PayoutAccountEntity {
  const factory PayoutAccountEntity({
    required String id,
    required String bankId,
    required String bankName,
    required String bankCode,
    required String accountNumber,
    required String accountName,
    @Default(false) bool isMain,
  }) = _PayoutAccountEntity;
}
