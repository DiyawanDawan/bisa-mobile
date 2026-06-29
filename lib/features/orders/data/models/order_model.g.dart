// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => _OrderModel(
  id: json['id'] as String,
  orderNumber: json['orderNumber'] as String,
  checkoutBatchId: json['checkoutBatchId'] as String?,
  checkoutBatchNumber: json['checkoutBatchNumber'] as String?,
  status: json['status'] as String,
  orderType: json['orderType'] as String? ?? 'STANDARD',
  totalAmount: json['totalAmount'],
  totalQuantity: json['totalQuantity'],
  subtotal: json['subtotal'],
  platformFee: json['platformFee'],
  logisticsFee: json['logisticsFee'],
  vatAmount: json['vatAmount'],
  specifications: json['specifications'] as String?,
  shippingAddressSnapshot:
      json['shippingAddressSnapshot'] as Map<String, dynamic>?,
  createdAt: json['createdAt'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  buyer: OrderParticipantModel.fromJson(json['buyer'] as Map<String, dynamic>),
  seller: OrderParticipantModel.fromJson(
    json['seller'] as Map<String, dynamic>,
  ),
  transaction: json['transaction'] == null
      ? null
      : OrderTransactionModel.fromJson(
          json['transaction'] as Map<String, dynamic>,
        ),
  shipment: json['shipment'] == null
      ? null
      : OrderShipmentModel.fromJson(json['shipment'] as Map<String, dynamic>),
  orderShipping: json['orderShipping'] == null
      ? null
      : OrderShippingModel.fromJson(
          json['orderShipping'] as Map<String, dynamic>,
        ),
  review: json['review'] == null
      ? null
      : OrderReviewModel.fromJson(json['review'] as Map<String, dynamic>),
  pendingPayment: json['pendingPayment'] as Map<String, dynamic>?,
  dispute: json['dispute'] as Map<String, dynamic>?,
  negotiationId: json['negotiationId'] as String?,
  isDigitalSigned: json['isDigitalSigned'] as bool? ?? false,
  buyerSignedAt: json['buyerSignedAt'] as String?,
  sellerSignedAt: json['sellerSignedAt'] as String?,
);

Map<String, dynamic> _$OrderModelToJson(_OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'checkoutBatchId': instance.checkoutBatchId,
      'checkoutBatchNumber': instance.checkoutBatchNumber,
      'status': instance.status,
      'orderType': instance.orderType,
      'totalAmount': instance.totalAmount,
      'totalQuantity': instance.totalQuantity,
      'subtotal': instance.subtotal,
      'platformFee': instance.platformFee,
      'logisticsFee': instance.logisticsFee,
      'vatAmount': instance.vatAmount,
      'specifications': instance.specifications,
      'shippingAddressSnapshot': instance.shippingAddressSnapshot,
      'createdAt': instance.createdAt,
      'items': instance.items,
      'buyer': instance.buyer,
      'seller': instance.seller,
      'transaction': instance.transaction,
      'shipment': instance.shipment,
      'orderShipping': instance.orderShipping,
      'review': instance.review,
      'pendingPayment': instance.pendingPayment,
      'dispute': instance.dispute,
      'negotiationId': instance.negotiationId,
      'isDigitalSigned': instance.isDigitalSigned,
      'buyerSignedAt': instance.buyerSignedAt,
      'sellerSignedAt': instance.sellerSignedAt,
    };

_OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    _OrderItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      quantity: json['quantity'],
      pricePerUnit: json['pricePerUnit'],
      subtotal: json['subtotal'],
      product: OrderItemProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OrderItemModelToJson(_OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'pricePerUnit': instance.pricePerUnit,
      'subtotal': instance.subtotal,
      'product': instance.product,
    };

_OrderItemProductModel _$OrderItemProductModelFromJson(
  Map<String, dynamic> json,
) => _OrderItemProductModel(
  name: json['name'] as String,
  unit: json['unit'] as String?,
  thumbnailUrl: json['thumbnailUrl'] as String?,
);

Map<String, dynamic> _$OrderItemProductModelToJson(
  _OrderItemProductModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'unit': instance.unit,
  'thumbnailUrl': instance.thumbnailUrl,
};

_OrderParticipantModel _$OrderParticipantModelFromJson(
  Map<String, dynamic> json,
) => _OrderParticipantModel(
  id: json['id'] as String?,
  name: _orderParticipantNameFromJson(json['fullName']),
  email: json['email'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  regency: json['regency'] as String?,
  verification: json['verification'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$OrderParticipantModelToJson(
  _OrderParticipantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.name,
  'email': instance.email,
  'avatarUrl': instance.avatarUrl,
  'regency': instance.regency,
  'verification': instance.verification,
};

_OrderTransactionModel _$OrderTransactionModelFromJson(
  Map<String, dynamic> json,
) => _OrderTransactionModel(
  status: json['status'] as String,
  paymentStatus: json['paymentStatus'] as String?,
  paymentUrl: json['paymentUrl'] as String?,
  paidAt: json['paidAt'] as String?,
  paymentChannel: json['paymentChannel'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$OrderTransactionModelToJson(
  _OrderTransactionModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'paymentStatus': instance.paymentStatus,
  'paymentUrl': instance.paymentUrl,
  'paidAt': instance.paidAt,
  'paymentChannel': instance.paymentChannel,
};

_OrderShipmentModel _$OrderShipmentModelFromJson(Map<String, dynamic> json) =>
    _OrderShipmentModel(
      trackingNumber: json['trackingNumber'] as String?,
      vesselName: json['vesselName'] as String?,
      originHub: json['originHub'] as String?,
      destinationHub: json['destinationHub'] as String?,
      awbNumber: json['awbNumber'] as String?,
      courierCode: json['courierCode'] as String?,
      deliveryStatus: json['deliveryStatus'] as String?,
      lastTrackedAt: json['lastTrackedAt'] as String?,
      currentLat: json['currentLat'],
      currentLng: json['currentLng'],
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$OrderShipmentModelToJson(_OrderShipmentModel instance) =>
    <String, dynamic>{
      'trackingNumber': instance.trackingNumber,
      'vesselName': instance.vesselName,
      'originHub': instance.originHub,
      'destinationHub': instance.destinationHub,
      'awbNumber': instance.awbNumber,
      'courierCode': instance.courierCode,
      'deliveryStatus': instance.deliveryStatus,
      'lastTrackedAt': instance.lastTrackedAt,
      'currentLat': instance.currentLat,
      'currentLng': instance.currentLng,
      'updatedAt': instance.updatedAt,
    };

_OrderShippingModel _$OrderShippingModelFromJson(Map<String, dynamic> json) =>
    _OrderShippingModel(
      originDestinationId: json['originDestinationId'],
      destinationDestinationId: json['destinationDestinationId'],
      originLabel: json['originLabel'] as String?,
      destinationLabel: json['destinationLabel'] as String?,
      weightGrams: json['weightGrams'],
      courierCode: json['courierCode'] as String?,
      courierName: json['courierName'] as String?,
      serviceCode: json['serviceCode'] as String?,
      serviceName: json['serviceName'] as String?,
      serviceDescription: json['serviceDescription'] as String?,
      shippingCost: json['shippingCost'],
      etd: json['etd'] as String?,
      verifiedAt: json['verifiedAt'] as String?,
    );

Map<String, dynamic> _$OrderShippingModelToJson(_OrderShippingModel instance) =>
    <String, dynamic>{
      'originDestinationId': instance.originDestinationId,
      'destinationDestinationId': instance.destinationDestinationId,
      'originLabel': instance.originLabel,
      'destinationLabel': instance.destinationLabel,
      'weightGrams': instance.weightGrams,
      'courierCode': instance.courierCode,
      'courierName': instance.courierName,
      'serviceCode': instance.serviceCode,
      'serviceName': instance.serviceName,
      'serviceDescription': instance.serviceDescription,
      'shippingCost': instance.shippingCost,
      'etd': instance.etd,
      'verifiedAt': instance.verifiedAt,
    };

_OrderReviewModel _$OrderReviewModelFromJson(Map<String, dynamic> json) =>
    _OrderReviewModel(
      id: json['id'] as String,
      rating: json['rating'],
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$OrderReviewModelToJson(_OrderReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'comment': instance.comment,
    };
