import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/order_entity.dart';
import '../entities/checkout_batch_detail_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getMyPurchases({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? orderType,
  });
  Future<Either<Failure, List<OrderEntity>>> getMySales({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? orderType,
  });
  Future<Either<Failure, Map<String, int>>> getMyPurchasesStatusCounts({
    String? search,
    String? orderType,
  });
  Future<Either<Failure, Map<String, int>>> getMySalesStatusCounts({
    String? search,
    String? orderType,
  });
  Future<Either<Failure, OrderEntity>> getOrderDetail(String id);
  Future<Either<Failure, CheckoutBatchDetailEntity>> getCheckoutBatchDetail(String anchorOrderId);
  Future<Either<Failure, Map<String, dynamic>>> initializePayment(
    String orderId,
    String channelCode, {
    bool forceNew = false,
  });
  Future<Either<Failure, Map<String, dynamic>>> initializeBatchPayment(
    List<String> orderIds,
    String channelCode, {
    bool forceNew = false,
  });
  Future<Either<Failure, void>> mockConfirmPayment(String orderId);
  Future<Either<Failure, void>> simulatePayment(String orderId);
  Future<Either<Failure, void>> simulateBatchPayment(List<String> orderIds);
  Future<Either<Failure, void>> cancelPayment(String orderId);
  Future<Either<Failure, Map<String, dynamic>>> getSalesStats();
  Future<Either<Failure, void>> releaseEscrow(String id);
  Future<Either<Failure, void>> raiseDispute(
    String id,
    String reason,
    String description,
    List<String> evidenceImagePaths,
  );
  Future<Either<Failure, void>> respondToDispute(
    String id,
    String response,
    List<String> evidenceImagePaths,
  );
  Future<Either<Failure, void>> updateTracking(String id, Map<String, dynamic> data);
  Future<Either<Failure, Map<String, dynamic>>> createDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? orderType,
    String? voucherCode,
  });
  Future<Either<Failure, Map<String, dynamic>>> previewDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? voucherCode,
  });
  Future<Either<Failure, Map<String, dynamic>>> validateVoucher({
    required String code,
    required double subtotal,
    List<String>? sellerIds,
  });
  Future<Either<Failure, Map<String, dynamic>?>> getShippingOrigin();
  Future<Either<Failure, void>> setShippingOrigin({
    required int originId,
    String? originLabel,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> searchShippingDestinations({
    required String search,
    int limit,
    int offset,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> calculateDomesticShipping({
    required int originId,
    required int destinationId,
    required int weightGrams,
    String? courier,
  });
  Future<Either<Failure, Map<String, dynamic>>> trackShipment({
    required String awb,
    required String courier,
    String? lastPhoneNumber,
    String? orderId,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getPickupVehicles();
  Future<Either<Failure, List<String>>> getActiveCouriers();
  Future<Either<Failure, List<Map<String, dynamic>>>> requestPickup({
    required String pickupDate,
    required String pickupTime,
    required String pickupVehicle,
    required List<String> orderNumbers,
  });
  Future<Either<Failure, void>> uploadPaymentProof(String orderId, String paymentProofUrl);
}
