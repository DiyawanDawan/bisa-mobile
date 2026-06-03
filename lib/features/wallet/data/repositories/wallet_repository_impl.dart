import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mobile_bisa/core/core.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';
import '../../domain/entities/payout_account_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../models/payout_account_model.dart';
import '../datasources/wallet_remote_data_source.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WalletEntity>> getBalance() async {
    try {
      final model = await remoteDataSource.getBalance();
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Gagal mengambil saldo'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>> getTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
  }) async {
    try {
      final models = await remoteDataSource.getTransactions(
        page: page,
        limit: limit,
        type: type,
        status: status,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Gagal mengambil transaksi'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> requestWithdrawal({required double amount}) async {
    try {
      await remoteDataSource.requestWithdrawal(amount: amount);
      return const Right(unit);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? (data['meta']?['message'] ?? data['message'] ?? 'Gagal memproses penarikan')
          : 'Gagal memproses penarikan';
      return Left(ServerFailure(message: message.toString()));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getSupportedBanks() async {
    try {
      final banks = await remoteDataSource.getSupportedBanks();
      return Right(banks);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Gagal mengambil daftar bank'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PayoutAccountEntity>>> getPayoutAccounts() async {
    try {
      final models = await remoteDataSource.getPayoutAccounts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Gagal mengambil daftar rekening'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PayoutAccountEntity>> createPayoutAccount(Map<String, dynamic> data) async {
    try {
      final PayoutAccountModel model = await remoteDataSource.createPayoutAccount(data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Gagal menyimpan rekening'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PayoutAccountEntity>> updatePayoutAccount(String id, Map<String, dynamic> data) async {
    try {
      final PayoutAccountModel model = await remoteDataSource.updatePayoutAccount(id, data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Gagal memperbarui rekening'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePayoutAccount(String id) async {
    try {
      await remoteDataSource.deletePayoutAccount(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Gagal menghapus rekening'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setMainPayoutAccount(String id) async {
    try {
      await remoteDataSource.setMainPayoutAccount(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.response?.data['message'] ?? 'Gagal memperbarui rekening utama'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
