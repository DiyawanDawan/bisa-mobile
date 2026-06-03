import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/wallet_entity.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
abstract class WalletModel with _$WalletModel {
  const factory WalletModel({
    @Default('') String id,
    @Default('') String userId,
    @Default(0.0) double balance,
    @Default(0.0) double totalEarned,
    @Default(0.0) double totalWithdrawn,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);

  const WalletModel._();

  WalletEntity toEntity() => WalletEntity(
    id: id,
    userId: userId,
    balance: balance,
    totalEarned: totalEarned,
    totalWithdrawn: totalWithdrawn,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
