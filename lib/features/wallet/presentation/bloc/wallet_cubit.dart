import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile_bisa/features/wallet/domain/entities/payout_account_entity.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

part 'wallet_state.dart';
part 'wallet_cubit.freezed.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _repository;
  bool _withdrawSnackPending = false;
  String? _withdrawErrorPending;

  WalletCubit(this._repository) : super(const WalletState.initial());

  bool consumeWithdrawSnackPending() {
    if (!_withdrawSnackPending) return false;
    _withdrawSnackPending = false;
    return true;
  }

  String? consumeWithdrawErrorPending() {
    final message = _withdrawErrorPending;
    _withdrawErrorPending = null;
    return message;
  }

  Future<void> getWalletData({bool showLoading = true}) async {
    if (showLoading) {
      emit(const WalletState.loading());
    }
    
    final balanceResult = await _repository.getBalance();
    final transactionsResult = await _repository.getTransactions();
    final banksResult = await _repository.getSupportedBanks();
    final payoutAccountsResult = await _repository.getPayoutAccounts();

    balanceResult.fold(
      (failure) => emit(WalletState.error(failure.message)),
      (wallet) {
        transactionsResult.fold(
          (failure) => emit(WalletState.error(failure.message)),
          (transactions) {
            banksResult.fold(
              (failure) => emit(WalletState.loaded(
                wallet: wallet,
                transactions: transactions,
                supportedBanks: [],
                payoutAccounts: [],
              )),
              (banks) {
                payoutAccountsResult.fold(
                  (failure) => emit(WalletState.loaded(
                    wallet: wallet,
                    transactions: transactions,
                    supportedBanks: banks,
                    payoutAccounts: [],
                  )),
                  (payoutAccounts) => emit(WalletState.loaded(
                    wallet: wallet,
                    transactions: transactions,
                    supportedBanks: banks,
                    payoutAccounts: payoutAccounts,
                  )),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> createPayoutAccount({
    required String bankId,
    required String accountNumber,
    required String accountName,
    bool isMain = false,
  }) async {
    emit(const WalletState.loading());
    final result = await _repository.createPayoutAccount({
      'bankId': bankId,
      'accountNumber': accountNumber,
      'accountName': accountName,
      'isMain': isMain,
    });

    result.fold(
      (failure) => emit(WalletState.error(failure.message)),
      (_) {
        emit(const WalletState.payoutAccountSuccess());
        getWalletData(showLoading: false);
      },
    );
  }

  Future<void> updatePayoutAccount({
    required String id,
    String? bankId,
    String? accountNumber,
    String? accountName,
    bool? isMain,
  }) async {
    emit(const WalletState.loading());
    final result = await _repository.updatePayoutAccount(id, {
      if (bankId != null) 'bankId': bankId,
      if (accountNumber != null) 'accountNumber': accountNumber,
      if (accountName != null) 'accountName': accountName,
      if (isMain != null) 'isMain': isMain,
    });

    result.fold(
      (failure) => emit(WalletState.error(failure.message)),
      (_) {
        emit(const WalletState.payoutAccountSuccess());
        getWalletData(showLoading: false);
      },
    );
  }

  Future<void> deletePayoutAccount(String id) async {
    emit(const WalletState.loading());
    final result = await _repository.deletePayoutAccount(id);

    result.fold(
      (failure) => emit(WalletState.error(failure.message)),
      (_) => getWalletData(showLoading: false),
    );
  }

  Future<void> requestWithdrawal({required double amount}) async {
    final currentState = state;
    if (currentState is! _Loaded) return;

    final previous = currentState;

    emit(
      WalletState.loaded(
        wallet: previous.wallet.copyWith(
          balance: previous.wallet.balance - amount,
          totalWithdrawn: previous.wallet.totalWithdrawn + amount,
        ),
        transactions: previous.transactions,
        supportedBanks: previous.supportedBanks,
        payoutAccounts: previous.payoutAccounts,
      ),
    );

    final result = await _repository.requestWithdrawal(amount: amount);

    await result.fold(
      (failure) async {
        _withdrawErrorPending = failure.message;
        emit(
          WalletState.loaded(
            wallet: previous.wallet,
            transactions: previous.transactions,
            supportedBanks: previous.supportedBanks,
            payoutAccounts: previous.payoutAccounts,
          ),
        );
      },
      (_) async {
        _withdrawSnackPending = true;
        await getWalletData(showLoading: false);
      },
    );
  }

  Future<void> setMainPayoutAccount(String id) async {
    emit(const WalletState.loading());
    final result = await _repository.setMainPayoutAccount(id);

    result.fold(
      (failure) => emit(WalletState.error(failure.message)),
      (_) => getWalletData(showLoading: false),
    );
  }
}
