import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_entity.freezed.dart';

@freezed
abstract class BookingUserEntity with _$BookingUserEntity {
  const factory BookingUserEntity({
    required String id,
    required String fullName,
    String? avatarUrl,
    String? companyName,
  }) = _BookingUserEntity;
}

@freezed
abstract class BookingProductEntity with _$BookingProductEntity {
  const factory BookingProductEntity({
    required String id,
    required String name,
    String? thumbnailUrl,
    required String productMode,
    required String unit,
    required double stock,
    @Default(0) double reservedStock,
    required double availableStock,
    required double pricePerUnit,
    required String availabilityType,
  }) = _BookingProductEntity;
}

@freezed
abstract class BookingHarvestLotEntity with _$BookingHarvestLotEntity {
  const factory BookingHarvestLotEntity({
    required String id,
    String? seasonLabel,
    required DateTime expectedHarvestDate,
    required double expectedQuantityTon,
    @Default(0) double reservedQuantityTon,
    required double availableQuantityTon,
    required String status,
  }) = _BookingHarvestLotEntity;
}

@freezed
abstract class BookingOrderRefEntity with _$BookingOrderRefEntity {
  const factory BookingOrderRefEntity({
    required String id,
    required String orderNumber,
    required String status,
  }) = _BookingOrderRefEntity;
}

@freezed
abstract class BookingEntity with _$BookingEntity {
  const BookingEntity._();

  const factory BookingEntity({
    required String id,
    required String bookingNumber,
    required String buyerId,
    required String supplierId,
    required String productId,
    String? harvestLotId,
    required String productMode,
    required double quantity,
    required String unit,
    required double priceSnapshot,
    required double subtotalSnapshot,
    required String status,
    required DateTime expiresAt,
    DateTime? expectedDeliveryDate,
    String? notes,
    String? orderId,
    DateTime? confirmedAt,
    @Default(false) bool isExpired,
    required DateTime createdAt,
    required BookingUserEntity buyer,
    required BookingUserEntity supplier,
    required BookingProductEntity product,
    BookingHarvestLotEntity? harvestLot,
    BookingOrderRefEntity? order,
  }) = _BookingEntity;

  bool get canCheckout =>
      (status == 'PENDING_PAYMENT' || status == 'CONFIRMED') && !isExpired;

  bool get canCancel =>
      (status == 'PENDING_PAYMENT' || status == 'CONFIRMED') && !isExpired;

  bool get canConfirm => status == 'PENDING_PAYMENT' && !isExpired;

  Duration get timeLeft => expiresAt.difference(DateTime.now());
}
