import 'package:equatable/equatable.dart';

class PayoutAccountEntity extends Equatable {
  final String id;
  final String bankId;
  final String bankName;
  final String bankCode;
  final String accountNumber;
  final String accountName;
  final bool isMain;

  const PayoutAccountEntity({
    required this.id,
    required this.bankId,
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
    this.isMain = false,
  });

  @override
  List<Object?> get props => [
    id,
    bankId,
    bankName,
    bankCode,
    accountNumber,
    accountName,
    isMain,
  ];
}
