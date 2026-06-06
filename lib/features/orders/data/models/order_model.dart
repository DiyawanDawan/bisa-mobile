import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/media_url_utils.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_dispute_entity.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

String _orderParticipantNameFromJson(dynamic value) {
  if (value == null) return 'Pengguna';
  final name = value.toString().trim();
  return name.isEmpty ? 'Pengguna' : name;
}

@freezed
abstract class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String orderNumber,
    String? checkoutBatchId,
    @JsonKey(name: 'checkoutBatchNumber') String? checkoutBatchNumber,
    required String status,
    required dynamic totalAmount,
    required dynamic totalQuantity,
    required dynamic subtotal,
    required dynamic platformFee,
    @JsonKey(name: 'logisticsFee') dynamic logisticsFee,
    required dynamic vatAmount,
    String? specifications,
    Map<String, dynamic>? shippingAddressSnapshot,
    required String createdAt,
    required List<OrderItemModel> items,
    required OrderParticipantModel buyer,
    required OrderParticipantModel seller,
    OrderTransactionModel? transaction,
    OrderShipmentModel? shipment,
    OrderShippingModel? orderShipping,
    OrderReviewModel? review,
    Map<String, dynamic>? pendingPayment,
    Map<String, dynamic>? dispute,
    String? negotiationId,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  const OrderModel._();

  /// Nomor pesanan yang ditampilkan ke buyer (satu per checkout).
  String get displayOrderNumber =>
      (checkoutBatchNumber?.trim().isNotEmpty ?? false)
          ? checkoutBatchNumber!.trim()
          : orderNumber;

  OrderEntity toEntity() => OrderEntity(
        id: id,
        orderNumber: orderNumber,
        checkoutBatchId: checkoutBatchId,
        checkoutBatchNumber: checkoutBatchNumber,
        status: status,
        totalAmount: double.tryParse(totalAmount.toString()) ?? 0.0,
        totalQuantity: double.tryParse(totalQuantity.toString()) ?? 0.0,
        subtotal: double.tryParse(subtotal.toString()) ?? 0.0,
        platformFee: double.tryParse(platformFee.toString()) ?? 0.0,
        logisticsFee: double.tryParse(logisticsFee?.toString() ?? '0') ?? 0.0,
        vatAmount: double.tryParse(vatAmount.toString()) ?? 0.0,
        specifications: specifications,
        shippingAddressSnapshot: shippingAddressSnapshot,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
        items: items.map((e) => e.toEntity()).toList(),
        buyer: buyer.toEntity(),
        seller: seller.toEntity(),
        transaction: transaction?.toEntity(),
        shipment: shipment?.toEntity(),
        orderShipping: orderShipping?.toEntity(),
        review: review?.toEntity(),
        pendingPayment: pendingPayment,
        dispute: dispute != null
            ? OrderDisputeEntity.fromJson(dispute!)
            : null,
        negotiationId: negotiationId,
      );
}

@freezed
abstract class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String id,
    required String productId,
    required dynamic quantity,
    required dynamic pricePerUnit,
    required dynamic subtotal,
    required OrderItemProductModel product,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);

  const OrderItemModel._();

  OrderItemEntity toEntity() => OrderItemEntity(
        id: id,
        productId: productId,
        productName: product.name,
        quantity: double.tryParse(quantity.toString()) ?? 0.0,
        pricePerUnit: double.tryParse(pricePerUnit.toString()) ?? 0.0,
        subtotal: double.tryParse(subtotal.toString()) ?? 0.0,
        productUnit: product.unit,
        thumbnailUrl: resolveMediaField(product.thumbnailUrl),
      );
}

@freezed
abstract class OrderItemProductModel with _$OrderItemProductModel {
  const factory OrderItemProductModel({
    required String name,
    String? unit,
    String? thumbnailUrl,
  }) = _OrderItemProductModel;

  factory OrderItemProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemProductModelFromJson(json);
}

@freezed
abstract class OrderParticipantModel with _$OrderParticipantModel {
  const factory OrderParticipantModel({
    String? id,
    @JsonKey(name: 'fullName', fromJson: _orderParticipantNameFromJson)
    required String name,
    String? email,
    String? avatarUrl,
    String? regency,
    Map<String, dynamic>? verification,
  }) = _OrderParticipantModel;

  factory OrderParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$OrderParticipantModelFromJson(json);

  const OrderParticipantModel._();

  OrderParticipantEntity toEntity() => OrderParticipantEntity(
        id: id ?? '',
        name: name,
        email: email,
        avatarUrl: resolveMediaField(avatarUrl),
        regency: regency,
        isVerified: verification != null && verification!['isVerified'] == true,
      );
}

@freezed
abstract class OrderTransactionModel with _$OrderTransactionModel {
  const factory OrderTransactionModel({
    required String status,
    String? paymentStatus,
    String? paymentUrl,
    String? paidAt,
    Map<String, dynamic>? paymentChannel,
  }) = _OrderTransactionModel;

  factory OrderTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTransactionModelFromJson(json);

  const OrderTransactionModel._();

  OrderTransactionEntity toEntity() => OrderTransactionEntity(
        status: status,
        paymentStatus: paymentStatus,
        paymentUrl: paymentUrl,
        paidAt: paidAt != null ? DateTime.tryParse(paidAt!) : null,
        paymentChannelCode: paymentChannel?['code']?.toString(),
        paymentChannelName: paymentChannel?['name']?.toString(),
      );
}

@freezed
abstract class OrderShipmentModel with _$OrderShipmentModel {
  const factory OrderShipmentModel({
    String? trackingNumber,
    String? vesselName,
    String? originHub,
    String? destinationHub,
    String? awbNumber,
    String? courierCode,
    String? deliveryStatus,
    String? lastTrackedAt,
    dynamic currentLat,
    dynamic currentLng,
    String? updatedAt,
  }) = _OrderShipmentModel;

  factory OrderShipmentModel.fromJson(Map<String, dynamic> json) =>
      _$OrderShipmentModelFromJson(json);

  const OrderShipmentModel._();

  OrderShipmentEntity toEntity() => OrderShipmentEntity(
        trackingNumber: trackingNumber,
        vesselName: vesselName,
        originHub: originHub,
        destinationHub: destinationHub,
        awbNumber: awbNumber,
        courierCode: courierCode,
        deliveryStatus: deliveryStatus,
        lastTrackedAt: lastTrackedAt != null ? DateTime.tryParse(lastTrackedAt!) : null,
        currentLat: currentLat != null ? double.tryParse(currentLat.toString()) : null,
        currentLng: currentLng != null ? double.tryParse(currentLng.toString()) : null,
        updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      );
}

@freezed
abstract class OrderShippingModel with _$OrderShippingModel {
  const factory OrderShippingModel({
    dynamic originDestinationId,
    dynamic destinationDestinationId,
    String? originLabel,
    String? destinationLabel,
    dynamic weightGrams,
    String? courierCode,
    String? courierName,
    String? serviceCode,
    String? serviceName,
    String? serviceDescription,
    dynamic shippingCost,
    String? etd,
    String? verifiedAt,
  }) = _OrderShippingModel;

  factory OrderShippingModel.fromJson(Map<String, dynamic> json) =>
      _$OrderShippingModelFromJson(json);

  const OrderShippingModel._();

  OrderShippingEntity toEntity() => OrderShippingEntity(
        originDestinationId: int.tryParse(originDestinationId?.toString() ?? ''),
        destinationDestinationId:
            int.tryParse(destinationDestinationId?.toString() ?? ''),
        originLabel: originLabel,
        destinationLabel: destinationLabel,
        weightGrams: double.tryParse(weightGrams?.toString() ?? ''),
        courierCode: courierCode,
        courierName: courierName,
        serviceCode: serviceCode,
        serviceName: serviceName,
        serviceDescription: serviceDescription,
        shippingCost: double.tryParse(shippingCost?.toString() ?? ''),
        etd: etd,
        verifiedAt: verifiedAt != null ? DateTime.tryParse(verifiedAt!) : null,
      );
}

@freezed
abstract class OrderReviewModel with _$OrderReviewModel {
  const factory OrderReviewModel({
    required String id,
    required dynamic rating,
    required String comment,
  }) = _OrderReviewModel;

  factory OrderReviewModel.fromJson(Map<String, dynamic> json) =>
      _$OrderReviewModelFromJson(json);

  const OrderReviewModel._();

  OrderReviewEntity toEntity() => OrderReviewEntity(
        id: id,
        rating: double.tryParse(rating.toString()) ?? 0.0,
        comment: comment,
      );
}
