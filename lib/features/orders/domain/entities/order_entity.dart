import 'package:freezed_annotation/freezed_annotation.dart';
import 'order_dispute_entity.dart';

part 'order_entity.freezed.dart';

@freezed
abstract class OrderEntity with _$OrderEntity {
  const factory OrderEntity({
    required String id,
    required String orderNumber,
    String? checkoutBatchId,
    String? checkoutBatchNumber,
    required String status,
    @Default('STANDARD') String orderType,
    required double totalAmount,
    required double totalQuantity,
    required double subtotal,
    required double platformFee,
    @Default(0) double logisticsFee,
    required double vatAmount,
    String? specifications,
    Map<String, dynamic>? shippingAddressSnapshot,
    required DateTime createdAt,
    required List<OrderItemEntity> items,
    required OrderParticipantEntity buyer,
    required OrderParticipantEntity seller,
    OrderTransactionEntity? transaction,
    OrderShipmentEntity? shipment,
    OrderShippingEntity? orderShipping,
    OrderReviewEntity? review,
    /// Data VA/QR/invoice dari backend jika pembayaran sudah diinisialisasi.
    Map<String, dynamic>? pendingPayment,
    OrderDisputeEntity? dispute,
    String? negotiationId,
    @Default(false) bool isDigitalSigned,
    DateTime? buyerSignedAt,
    DateTime? sellerSignedAt,
  }) = _OrderEntity;

  const OrderEntity._();

  bool get needsMySignature =>
      !isDigitalSigned && (buyerSignedAt == null || sellerSignedAt == null);
}

@freezed
abstract class OrderTransactionEntity with _$OrderTransactionEntity {
  const factory OrderTransactionEntity({
    required String status,
    String? paymentStatus,
    String? paymentUrl,
    DateTime? paidAt,
    String? paymentChannelCode,
    String? paymentChannelName,
  }) = _OrderTransactionEntity;
}

@freezed
abstract class OrderReviewEntity with _$OrderReviewEntity {
  const factory OrderReviewEntity({
    required String id,
    required double rating,
    required String comment,
  }) = _OrderReviewEntity;
}

@freezed
abstract class OrderItemEntity with _$OrderItemEntity {
  const factory OrderItemEntity({
    required String id,
    required String productId,
    required String productName,
    required double quantity,
    required double pricePerUnit,
    required double subtotal,
    String? productUnit,
    String? thumbnailUrl,
  }) = _OrderItemEntity;
}

@freezed
abstract class OrderParticipantEntity with _$OrderParticipantEntity {
  const factory OrderParticipantEntity({
    required String id,
    required String name,
    String? email,
    String? avatarUrl,
    String? regency,
    @Default(false) bool isVerified,
  }) = _OrderParticipantEntity;
}

@freezed
abstract class OrderShipmentEntity with _$OrderShipmentEntity {
  const factory OrderShipmentEntity({
    /// Nomor tracking BISA (TRK-{orderNumber}), dari backend.
    String? trackingNumber,
    String? vesselName,
    String? originHub,
    String? destinationHub,
    String? awbNumber,
    String? courierCode,
    String? deliveryStatus,
    DateTime? lastTrackedAt,
    double? currentLat,
    double? currentLng,
    DateTime? updatedAt,
  }) = _OrderShipmentEntity;
}

@freezed
abstract class OrderShippingEntity with _$OrderShippingEntity {
  const factory OrderShippingEntity({
    int? originDestinationId,
    int? destinationDestinationId,
    String? originLabel,
    String? destinationLabel,
    double? weightGrams,
    String? courierCode,
    String? courierName,
    String? serviceCode,
    String? serviceName,
    String? serviceDescription,
    double? shippingCost,
    String? etd,
    DateTime? verifiedAt,
  }) = _OrderShippingEntity;
}

extension OrderEntityDisplay on OrderEntity {
  /// Satu nomor pesanan untuk seluruh checkout (multi-supplier).
  String get displayOrderNumber {
    final batch = checkoutBatchNumber?.trim();
    if (batch != null && batch.isNotEmpty) return batch;
    return orderNumber;
  }
}
