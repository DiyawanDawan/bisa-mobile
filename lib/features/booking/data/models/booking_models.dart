class BookingUserModel {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String? companyName;

  BookingUserModel({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    this.companyName,
  });

  factory BookingUserModel.fromJson(Map<String, dynamic> json) {
    return BookingUserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      companyName: json['companyName'] as String?,
    );
  }
}

class BookingProductModel {
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

  BookingProductModel({
    required this.id,
    required this.name,
    this.thumbnailUrl,
    required this.productMode,
    required this.unit,
    required this.stock,
    required this.reservedStock,
    required this.availableStock,
    required this.pricePerUnit,
    required this.availabilityType,
  });

  factory BookingProductModel.fromJson(Map<String, dynamic> json) {
    return BookingProductModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      productMode: json['productMode'] as String? ?? 'BIOMASS_MATERIAL',
      unit: json['unit'] as String? ?? 'TON',
      stock: (json['stock'] as num?)?.toDouble() ?? 0,
      reservedStock: (json['reservedStock'] as num?)?.toDouble() ?? 0,
      availableStock: (json['availableStock'] as num?)?.toDouble() ??
          (json['stock'] as num?)?.toDouble() ??
          0,
      pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble() ?? 0,
      availabilityType: json['availabilityType'] as String? ?? 'READY',
    );
  }
}

class BookingHarvestLotModel {
  final String id;
  final String? seasonLabel;
  final DateTime expectedHarvestDate;
  final double expectedQuantityTon;
  final double reservedQuantityTon;
  final double availableQuantityTon;
  final String status;

  BookingHarvestLotModel({
    required this.id,
    this.seasonLabel,
    required this.expectedHarvestDate,
    required this.expectedQuantityTon,
    required this.reservedQuantityTon,
    required this.availableQuantityTon,
    required this.status,
  });

  factory BookingHarvestLotModel.fromJson(Map<String, dynamic> json) {
    return BookingHarvestLotModel(
      id: json['id'] as String,
      seasonLabel: json['seasonLabel'] as String?,
      expectedHarvestDate: DateTime.parse(json['expectedHarvestDate'] as String),
      expectedQuantityTon: (json['expectedQuantityTon'] as num?)?.toDouble() ?? 0,
      reservedQuantityTon: (json['reservedQuantityTon'] as num?)?.toDouble() ?? 0,
      availableQuantityTon: (json['availableQuantityTon'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'SCHEDULED',
    );
  }
}

class BookingOrderRefModel {
  final String id;
  final String orderNumber;
  final String status;

  BookingOrderRefModel({
    required this.id,
    required this.orderNumber,
    required this.status,
  });

  factory BookingOrderRefModel.fromJson(Map<String, dynamic> json) {
    return BookingOrderRefModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String? ?? 'PENDING',
    );
  }
}

class BookingModel {
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
  final BookingUserModel buyer;
  final BookingUserModel supplier;
  final BookingProductModel product;
  final BookingHarvestLotModel? harvestLot;
  final BookingOrderRefModel? order;

  BookingModel({
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      bookingNumber: json['bookingNumber'] as String,
      buyerId: json['buyerId'] as String,
      supplierId: json['supplierId'] as String,
      productId: json['productId'] as String,
      harvestLotId: json['harvestLotId'] as String?,
      productMode: json['productMode'] as String? ?? 'BIOMASS_MATERIAL',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? 'TON',
      priceSnapshot: (json['priceSnapshot'] as num?)?.toDouble() ?? 0,
      subtotalSnapshot: (json['subtotalSnapshot'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'PENDING_PAYMENT',
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      expectedDeliveryDate: json['expectedDeliveryDate'] != null
          ? DateTime.tryParse(json['expectedDeliveryDate'] as String)
          : null,
      notes: json['notes'] as String?,
      orderId: json['orderId'] as String?,
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.tryParse(json['confirmedAt'] as String)
          : null,
      isExpired: json['isExpired'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      buyer: BookingUserModel.fromJson(json['buyer'] as Map<String, dynamic>),
      supplier: BookingUserModel.fromJson(json['supplier'] as Map<String, dynamic>),
      product: BookingProductModel.fromJson(json['product'] as Map<String, dynamic>),
      harvestLot: json['harvestLot'] != null
          ? BookingHarvestLotModel.fromJson(json['harvestLot'] as Map<String, dynamic>)
          : null,
      order: json['order'] != null
          ? BookingOrderRefModel.fromJson(json['order'] as Map<String, dynamic>)
          : null,
    );
  }
}

class BookingListModel {
  final List<BookingModel> items;
  final int page;
  final int limit;
  final int total;

  BookingListModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

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

class BookingCheckoutModel {
  final BookingModel booking;
  final Map<String, dynamic> checkout;

  BookingCheckoutModel({required this.booking, required this.checkout});

  factory BookingCheckoutModel.fromJson(Map<String, dynamic> json) {
    return BookingCheckoutModel(
      booking: BookingModel.fromJson(json['booking'] as Map<String, dynamic>),
      checkout: Map<String, dynamic>.from(json['checkout'] as Map),
    );
  }
}
