import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_models.freezed.dart';

double _d(dynamic v, [double fallback = 0]) =>
    (v as num?)?.toDouble() ?? fallback;

DateTime? _dt(dynamic v) {
  if (v == null) return null;
  return DateTime.tryParse(v.toString());
}

@Freezed(fromJson: false, toJson: false)
abstract class BookingUserModel with _$BookingUserModel {
  const factory BookingUserModel({
    required String id,
    required String fullName,
    String? avatarUrl,
    String? companyName,
    @Default(false) bool isVerified,
  }) = _BookingUserModel;

  factory BookingUserModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] is Map
        ? Map<String, dynamic>.from(json['profile'] as Map)
        : null;
    final verification = json['verification'] is Map
        ? Map<String, dynamic>.from(json['verification'] as Map)
        : null;
    return BookingUserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      companyName: json['companyName'] as String? ??
          profile?['companyName'] as String?,
      isVerified: json['isVerified'] == true ||
          verification?['isVerified'] == true,
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class BookingProductModel with _$BookingProductModel {
  const factory BookingProductModel({
    required String id,
    required String name,
    String? thumbnailUrl,
    required String productMode,
    required String unit,
    required double stock,
    required double reservedStock,
    required double availableStock,
    required double pricePerUnit,
    required String availabilityType,
  }) = _BookingProductModel;

  factory BookingProductModel.fromJson(Map<String, dynamic> json) {
    final stock = _d(json['stock']);
    return BookingProductModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      productMode: json['productMode'] as String? ?? 'BIOMASS_MATERIAL',
      unit: json['unit'] as String? ?? 'TON',
      stock: stock,
      reservedStock: _d(json['reservedStock']),
      availableStock: _d(json['availableStock'], stock),
      pricePerUnit: _d(json['pricePerUnit']),
      availabilityType: json['availabilityType'] as String? ?? 'READY',
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class BookingHarvestLotModel with _$BookingHarvestLotModel {
  const factory BookingHarvestLotModel({
    required String id,
    String? seasonLabel,
    required DateTime expectedHarvestDate,
    required double expectedQuantityTon,
    required double reservedQuantityTon,
    required double availableQuantityTon,
    required String status,
  }) = _BookingHarvestLotModel;

  factory BookingHarvestLotModel.fromJson(Map<String, dynamic> json) {
    return BookingHarvestLotModel(
      id: json['id'] as String,
      seasonLabel: json['seasonLabel'] as String?,
      expectedHarvestDate: DateTime.parse(json['expectedHarvestDate'] as String),
      expectedQuantityTon: _d(json['expectedQuantityTon']),
      reservedQuantityTon: _d(json['reservedQuantityTon']),
      availableQuantityTon: _d(json['availableQuantityTon']),
      status: json['status'] as String? ?? 'SCHEDULED',
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class BookingOrderRefModel with _$BookingOrderRefModel {
  const factory BookingOrderRefModel({
    required String id,
    required String orderNumber,
    required String status,
  }) = _BookingOrderRefModel;

  factory BookingOrderRefModel.fromJson(Map<String, dynamic> json) {
    return BookingOrderRefModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String? ?? 'PENDING',
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class BookingModel with _$BookingModel {
  const factory BookingModel({
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
    required BookingUserModel buyer,
    required BookingUserModel supplier,
    required BookingProductModel product,
    BookingHarvestLotModel? harvestLot,
    BookingOrderRefModel? order,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      bookingNumber: json['bookingNumber'] as String,
      buyerId: json['buyerId'] as String,
      supplierId: json['supplierId'] as String,
      productId: json['productId'] as String,
      harvestLotId: json['harvestLotId'] as String?,
      productMode: json['productMode'] as String? ?? 'BIOMASS_MATERIAL',
      quantity: _d(json['quantity']),
      unit: json['unit'] as String? ?? 'TON',
      priceSnapshot: _d(json['priceSnapshot']),
      subtotalSnapshot: _d(json['subtotalSnapshot']),
      status: json['status'] as String? ?? 'PENDING_PAYMENT',
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      expectedDeliveryDate: _dt(json['expectedDeliveryDate']),
      notes: json['notes'] as String?,
      orderId: json['orderId'] as String?,
      confirmedAt: _dt(json['confirmedAt']),
      isExpired: json['isExpired'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      buyer: BookingUserModel.fromJson(json['buyer'] as Map<String, dynamic>),
      supplier:
          BookingUserModel.fromJson(json['supplier'] as Map<String, dynamic>),
      product:
          BookingProductModel.fromJson(json['product'] as Map<String, dynamic>),
      harvestLot: json['harvestLot'] != null
          ? BookingHarvestLotModel.fromJson(
              json['harvestLot'] as Map<String, dynamic>,
            )
          : null,
      order: json['order'] != null
          ? BookingOrderRefModel.fromJson(json['order'] as Map<String, dynamic>)
          : null,
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class BookingListModel with _$BookingListModel {
  const factory BookingListModel({
    required List<BookingModel> items,
    required int page,
    required int limit,
    required int total,
  }) = _BookingListModel;

  factory BookingListModel.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List? ?? [];
    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};
    return BookingListModel(
      items: list
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: pagination['page'] as int? ?? 1,
      limit: pagination['limit'] as int? ?? 20,
      total: pagination['total'] as int? ?? list.length,
    );
  }
}

@Freezed(fromJson: false, toJson: false)
abstract class BookingCheckoutModel with _$BookingCheckoutModel {
  const factory BookingCheckoutModel({
    required BookingModel booking,
    required Map<String, dynamic> checkout,
  }) = _BookingCheckoutModel;

  factory BookingCheckoutModel.fromJson(Map<String, dynamic> json) {
    return BookingCheckoutModel(
      booking: BookingModel.fromJson(json['booking'] as Map<String, dynamic>),
      checkout: Map<String, dynamic>.from(json['checkout'] as Map),
    );
  }
}
