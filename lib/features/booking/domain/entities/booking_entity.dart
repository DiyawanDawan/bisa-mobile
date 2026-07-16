import 'package:equatable/equatable.dart';

class BookingUserEntity extends Equatable {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String? companyName;

  const BookingUserEntity({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.companyName,
  });

  @override
  List<Object?> get props => [id, fullName];
}

class BookingProductEntity extends Equatable {
  final String id;
  final String name;
  final String? thumbnailUrl;
  final String productMode;
  final String unit;
  final double stock;
  final double reservedStock;
  final double availableStock;
  final double pricePerUnit;
  final String availabilityType;

  const BookingProductEntity({
    required this.id,
    required this.name,
    this.thumbnailUrl,
    required this.productMode,
    required this.unit,
    required this.stock,
    this.reservedStock = 0,
    required this.availableStock,
    required this.pricePerUnit,
    required this.availabilityType,
  });

  @override
  List<Object?> get props => [id, name];
}

class BookingHarvestLotEntity extends Equatable {
  final String id;
  final String? seasonLabel;
  final DateTime expectedHarvestDate;
  final double expectedQuantityTon;
  final double reservedQuantityTon;
  final double availableQuantityTon;
  final String status;

  const BookingHarvestLotEntity({
    required this.id,
    this.seasonLabel,
    required this.expectedHarvestDate,
    required this.expectedQuantityTon,
    this.reservedQuantityTon = 0,
    required this.availableQuantityTon,
    required this.status,
  });

  @override
  List<Object?> get props => [id];
}

class BookingOrderRefEntity extends Equatable {
  final String id;
  final String orderNumber;
  final String status;

  const BookingOrderRefEntity({
    required this.id,
    required this.orderNumber,
    required this.status,
  });

  @override
  List<Object?> get props => [id];
}

class BookingEntity extends Equatable {
  final String id;
  final String bookingNumber;
  final String buyerId;
  final String supplierId;
  final String productId;
  final String? harvestLotId;
  final String productMode;
  final double quantity;
  final String unit;
  final double priceSnapshot;
  final double subtotalSnapshot;
  final String status;
  final DateTime expiresAt;
  final DateTime? expectedDeliveryDate;
  final String? notes;
  final String? orderId;
  final DateTime? confirmedAt;
  final bool isExpired;
  final DateTime createdAt;
  final BookingUserEntity buyer;
  final BookingUserEntity supplier;
  final BookingProductEntity product;
  final BookingHarvestLotEntity? harvestLot;
  final BookingOrderRefEntity? order;

  const BookingEntity({
    required this.id,
    required this.bookingNumber,
    required this.buyerId,
    required this.supplierId,
    required this.productId,
    this.harvestLotId,
    required this.productMode,
    required this.quantity,
    required this.unit,
    required this.priceSnapshot,
    required this.subtotalSnapshot,
    required this.status,
    required this.expiresAt,
    this.expectedDeliveryDate,
    this.notes,
    this.orderId,
    this.confirmedAt,
    this.isExpired = false,
    required this.createdAt,
    required this.buyer,
    required this.supplier,
    required this.product,
    this.harvestLot,
    this.order,
  });

  bool get canCheckout =>
      (status == 'PENDING_PAYMENT' || status == 'CONFIRMED') && !isExpired;

  bool get canCancel =>
      (status == 'PENDING_PAYMENT' || status == 'CONFIRMED') && !isExpired;

  bool get canConfirm => status == 'PENDING_PAYMENT' && !isExpired;

  Duration get timeLeft => expiresAt.difference(DateTime.now());

  @override
  List<Object?> get props => [id, status, bookingNumber];
}
