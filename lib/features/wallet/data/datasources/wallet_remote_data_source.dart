import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_bisa/features/wallet/data/models/payout_account_model.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getBalance();
  Future<List<WalletTransactionModel>> getTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
  });
  Future<void> requestWithdrawal({required double amount});
  Future<List<Map<String, dynamic>>> getSupportedBanks();
  Future<List<PayoutAccountModel>> getPayoutAccounts();
  Future<PayoutAccountModel> createPayoutAccount(Map<String, dynamic> data);
  Future<PayoutAccountModel> updatePayoutAccount(String id, Map<String, dynamic> data);
  Future<void> deletePayoutAccount(String id);
  Future<void> setMainPayoutAccount(String id);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final Dio dio;

  WalletRemoteDataSourceImpl({required this.dio});

  @override
  Future<WalletModel> getBalance() async {
    final response = await dio.get('/wallets/me');
    // SEC-MOB-006: jangan log response wallet (berisi balance). Hanya status di debug.
    if (kDebugMode) debugPrint('WALLET BALANCE status=${response.statusCode}');
    try {
      final json = response.data['data'] as Map<String, dynamic>;
      final fixedJson = Map<String, dynamic>.from(json);
      fixedJson['id'] = fixedJson['id'] ?? '';
      fixedJson['userId'] = fixedJson['userId'] ?? '';

      // Inject createdAt because the backend Wallet table doesn't have it!
      fixedJson['createdAt'] =
          fixedJson['createdAt'] ??
          fixedJson['updatedAt'] ??
          DateTime.now().toIso8601String();
      fixedJson['updatedAt'] =
          fixedJson['updatedAt'] ?? DateTime.now().toIso8601String();

      // Fix numbers that might be parsed as int or String instead of double
      if (fixedJson['balance'] is int)
        fixedJson['balance'] = (fixedJson['balance'] as int).toDouble();
      else if (fixedJson['balance'] is String)
        fixedJson['balance'] = double.tryParse(fixedJson['balance']) ?? 0.0;

      if (fixedJson['totalEarned'] is int)
        fixedJson['totalEarned'] = (fixedJson['totalEarned'] as int).toDouble();
      else if (fixedJson['totalEarned'] is String)
        fixedJson['totalEarned'] = double.tryParse(fixedJson['totalEarned']) ?? 0.0;

      if (fixedJson['totalWithdrawn'] is int)
        fixedJson['totalWithdrawn'] = (fixedJson['totalWithdrawn'] as int).toDouble();
      else if (fixedJson['totalWithdrawn'] is String)
        fixedJson['totalWithdrawn'] = double.tryParse(fixedJson['totalWithdrawn']) ?? 0.0;

      return WalletModel.fromJson(fixedJson);
    } catch (e) {
      // SEC-MOB-006: log error type saja, tanpa response data (PII).
      if (kDebugMode) debugPrint('ERROR PARSING WALLET: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<List<WalletTransactionModel>> getTransactions({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
  }) async {
    final response = await dio.get(
      '/wallets/transactions',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (type != null) 'type': type,
        if (status != null) 'status': status,
      },
    );
    // SEC-MOB-006: jangan log response transaksi (berisi PII finansial).
    if (kDebugMode) {
      debugPrint('WALLET TRANSACTIONS status=${response.statusCode} count=${(response.data['data'] as List?)?.length ?? 0}');
    }
    final List data = response.data['data'] ?? [];
    try {
      return data.map((item) {
        final json = item as Map<String, dynamic>;
        final fixedJson = Map<String, dynamic>.from(json);
        fixedJson['externalId'] = fixedJson['externalId'] ?? '';
        fixedJson['status'] = fixedJson['status'] ?? 'UNKNOWN';
        fixedJson['type'] = fixedJson['type'] ?? 'UNKNOWN';
        fixedJson['id'] = fixedJson['id'] ?? '';

        // Fix numbers that might be parsed as int or String instead of double
        if (fixedJson['amount'] is int)
          fixedJson['amount'] = (fixedJson['amount'] as int).toDouble();
        else if (fixedJson['amount'] is String)
          fixedJson['amount'] = double.tryParse(fixedJson['amount']) ?? 0.0;

        if (fixedJson['sellerAmount'] is int)
          fixedJson['sellerAmount'] = (fixedJson['sellerAmount'] as int)
              .toDouble();
        else if (fixedJson['sellerAmount'] is String)
          fixedJson['sellerAmount'] =
              double.tryParse(fixedJson['sellerAmount']) ?? 0.0;

        if (fixedJson['platformFee'] is int)
          fixedJson['platformFee'] = (fixedJson['platformFee'] as int)
              .toDouble();
        else if (fixedJson['platformFee'] is String)
          fixedJson['platformFee'] =
              double.tryParse(fixedJson['platformFee']) ?? 0.0;

        String? paymentMethod;
        if (fixedJson['paymentChannel'] != null) {
          paymentMethod = fixedJson['paymentChannel']['name'];
        } else if (fixedJson['payoutAccount'] != null) {
          final accName = fixedJson['payoutAccount']['accountName'] ?? '';
          final bankName = fixedJson['payoutAccount']['bank']?['name'] ?? '';
          paymentMethod = '$bankName - $accName'.trim();
          if (paymentMethod == '-') paymentMethod = null;
        }
        fixedJson['paymentMethod'] = paymentMethod;

        return WalletTransactionModel.fromJson(fixedJson);
      }).toList();
    } catch (e) {
      // SEC-MOB-006: log error type saja, tanpa first item (PII).
      if (kDebugMode) debugPrint('ERROR PARSING TRANSACTIONS: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<void> requestWithdrawal({required double amount}) async {
    await dio.post(
      '/wallets/withdraw',
      data: {'amount': amount},
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getSupportedBanks() async {
    final response = await dio.get('/wallets/banks');
    // SEC-MOB-006: jangan log full response (dapat berisi metadata bank sensitif).
    if (kDebugMode) debugPrint('SUPPORTED BANKS status=${response.statusCode}');
    final List data = response.data['data'];
    return data.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<PayoutAccountModel>> getPayoutAccounts() async {
    final response = await dio.get('/wallets/payout-accounts');
    final List data = response.data['data'] ?? [];
    return data.map((item) => PayoutAccountModel.fromJson(item)).toList();
  }

  @override
  Future<PayoutAccountModel> createPayoutAccount(Map<String, dynamic> data) async {
    final response = await dio.post('/wallets/payout-accounts', data: data);
    return PayoutAccountModel.fromJson(response.data['data']);
  }

  @override
  Future<PayoutAccountModel> updatePayoutAccount(String id, Map<String, dynamic> data) async {
    final response = await dio.patch('/wallets/payout-accounts/$id', data: data);
    return PayoutAccountModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deletePayoutAccount(String id) async {
    await dio.delete('/wallets/payout-accounts/$id');
  }

  @override
  Future<void> setMainPayoutAccount(String id) async {
    await dio.patch('/wallets/payout-accounts/$id/main');
  }
}
