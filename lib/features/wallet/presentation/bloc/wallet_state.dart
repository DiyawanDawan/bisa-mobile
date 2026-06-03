part of 'wallet_cubit.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState.initial() = _Initial;
  const factory WalletState.loading() = _Loading;
  const factory WalletState.loaded({
    required WalletEntity wallet,
    required List<WalletTransactionEntity> transactions,
    @Default([]) List<Map<String, dynamic>> supportedBanks,
    @Default([]) List<PayoutAccountEntity> payoutAccounts,
  }) = _Loaded;
  const factory WalletState.error(String message) = _Error;
  const factory WalletState.withdrawalSuccess() = _WithdrawalSuccess;
  const factory WalletState.payoutAccountSuccess() = _PayoutAccountSuccess;
}
