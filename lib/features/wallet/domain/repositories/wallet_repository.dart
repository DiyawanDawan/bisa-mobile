import 'package:dartz/dartz.dart';
import 'package:mobile_bisa/core/core.dart';
import '../entities/wallet_entity.dart';
import '../entities/wallet_transaction_entity.dart';
import '../entities/payout_account_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getBalance();
  Future<Either<Failure, List<WalletTransactionEntity>>> getTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
  });
  Future<Either<Failure, Unit>> requestWithdrawal({required double amount});
  Future<Either<Failure, List<Map<String, dynamic>>>> getSupportedBanks();
  Future<Either<Failure, List<PayoutAccountEntity>>> getPayoutAccounts();
  Future<Either<Failure, PayoutAccountEntity>> createPayoutAccount(Map<String, dynamic> data);
  Future<Either<Failure, PayoutAccountEntity>> updatePayoutAccount(String id, Map<String, dynamic> data);
  Future<Either<Failure, Unit>> deletePayoutAccount(String id);
  Future<Either<Failure, Unit>> setMainPayoutAccount(String id);
}
