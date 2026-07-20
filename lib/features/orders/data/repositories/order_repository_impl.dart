import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/readiness/readiness_service.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/checkout_batch_detail_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyPurchases({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? orderType,
  }) async {
    try {
      final models = await remoteDataSource.getMyPurchases(
        page: page,
        limit: limit,
        search: search,
        status: status,
        orderType: orderType,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getMySales({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? orderType,
  }) async {
    try {
      final models = await remoteDataSource.getMySales(
        page: page,
        limit: limit,
        search: search,
        status: status,
        orderType: orderType,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getMyPurchasesStatusCounts({
    String? search,
    String? orderType,
  }) async {
    try {
      final counts = await remoteDataSource.getMyPurchasesStatusCounts(
        search: search,
        orderType: orderType,
      );
      return Right(counts);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getMySalesStatusCounts({
    String? search,
    String? orderType,
  }) async {
    try {
      final counts = await remoteDataSource.getMySalesStatusCounts(
        search: search,
        orderType: orderType,
      );
      return Right(counts);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetail(String id) async {
    try {
      final model = await remoteDataSource.getOrderDetail(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, CheckoutBatchDetailEntity>> getCheckoutBatchDetail(
    String anchorOrderId,
  ) async {
    try {
      final data = await remoteDataSource.getCheckoutBatchDetail(anchorOrderId);
      final ordersRaw = data['orders'];
      final orders = ordersRaw is List
          ? ordersRaw
              .whereType<Map>()
              .map((row) => OrderModel.fromJson(Map<String, dynamic>.from(row)).toEntity())
              .toList()
          : <OrderEntity>[];

      final totalRaw = data['batchTotalAmount'];
      final total = totalRaw is num
          ? totalRaw.toDouble()
          : double.tryParse(totalRaw?.toString() ?? '') ??
              orders.fold<double>(0, (s, o) => s + o.totalAmount);

      final createdRaw = data['createdAt']?.toString();
      final createdAt = createdRaw != null
          ? DateTime.tryParse(createdRaw) ?? DateTime.now()
          : (orders.isNotEmpty ? orders.first.createdAt : DateTime.now());

      return Right(
        CheckoutBatchDetailEntity(
          checkoutBatchId: data['checkoutBatchId']?.toString() ?? '',
          checkoutBatchNumber: data['checkoutBatchNumber']?.toString(),
          batchTotalAmount: total,
          shippingAddressSnapshot: data['shippingAddressSnapshot'] is Map
              ? Map<String, dynamic>.from(data['shippingAddressSnapshot'] as Map)
              : null,
          createdAt: createdAt,
          supplierCount: data['supplierCount'] is num
              ? (data['supplierCount'] as num).toInt()
              : orders.length,
          orders: orders,
        ),
      );
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> initializePayment(
    String orderId,
    String channelCode, {
    bool forceNew = false,
  }) async {
    try {
      final data = await remoteDataSource.initializePayment(
        orderId,
        channelCode,
        forceNew: forceNew,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> initializeBatchPayment(
    List<String> orderIds,
    String channelCode, {
    bool forceNew = false,
  }) async {
    try {
      final data = await remoteDataSource.initializeBatchPayment(
        orderIds,
        channelCode,
        forceNew: forceNew,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> mockConfirmPayment(String orderId) async {
    try {
      await remoteDataSource.mockConfirmPayment(orderId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> simulatePayment(String orderId) async {
    try {
      await remoteDataSource.simulatePayment(orderId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> simulateBatchPayment(List<String> orderIds) async {
    try {
      await remoteDataSource.simulateBatchPayment(orderIds);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelPayment(String orderId) async {
    try {
      await remoteDataSource.cancelPayment(orderId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSalesStats() async {
    try {
      final data = await remoteDataSource.getSalesStats();
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> releaseEscrow(String id) async {
    try {
      await remoteDataSource.releaseEscrow(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> raiseDispute(
    String id,
    String reason,
    String description,
    List<String> evidenceImagePaths,
  ) async {
    try {
      final evidenceUrls = <String>[];
      for (final path in evidenceImagePaths) {
        evidenceUrls.add(await remoteDataSource.uploadDisputeEvidence(path));
      }
      await remoteDataSource.raiseDispute(
        id,
        reason,
        description,
        evidenceUrls,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> respondToDispute(
    String id,
    String response,
    List<String> evidenceImagePaths,
  ) async {
    try {
      final evidenceUrls = <String>[];
      for (final path in evidenceImagePaths) {
        evidenceUrls.add(await remoteDataSource.uploadDisputeEvidence(path));
      }
      await remoteDataSource.respondToDispute(id, response, evidenceUrls);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTracking(String id, Map<String, dynamic> data) async {
    try {
      await remoteDataSource.updateTracking(id, data);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? orderType,
    String? voucherCode,
  }) async {
    try {
      final data = await remoteDataSource.createDirectOrder(
        items: items,
        shippingAddress: shippingAddress,
        shippingSnapshot: shippingSnapshot,
        shippingSelections: shippingSelections,
        notes: notes,
        orderType: orderType,
        voucherCode: voucherCode,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> previewDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? voucherCode,
  }) async {
    try {
      final data = await remoteDataSource.previewDirectOrder(
        items: items,
        shippingAddress: shippingAddress,
        shippingSnapshot: shippingSnapshot,
        shippingSelections: shippingSelections,
        notes: notes,
        voucherCode: voucherCode,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> validateVoucher({
    required String code,
    required double subtotal,
    List<String>? sellerIds,
  }) async {
    try {
      final data = await remoteDataSource.validateVoucher(
        code: code,
        subtotal: subtotal,
        sellerIds: sellerIds,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getShippingOrigin() async {
    try {
      final data = await remoteDataSource.getShippingOrigin();
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setShippingOrigin({
    required int originId,
    String? originLabel,
  }) async {
    try {
      await remoteDataSource.setShippingOrigin(
        originId: originId,
        originLabel: originLabel,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchShippingDestinations({
    required String search,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final data = await remoteDataSource.searchShippingDestinations(
        search: search,
        limit: limit,
        offset: offset,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> calculateDomesticShipping({
    required int originId,
    required int destinationId,
    int? weightGrams,
    num? weight,
    String weightUnit = 'KG',
    String? courier,
    String? sellerId,
    String? buyerId,
  }) async {
    try {
      final data = await remoteDataSource.calculateDomesticShipping(
        originId: originId,
        destinationId: destinationId,
        weightGrams: weightGrams,
        weight: weight,
        weightUnit: weightUnit,
        courier: courier,
        sellerId: sellerId,
        buyerId: buyerId,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> trackShipment({
    required String awb,
    required String courier,
    String? lastPhoneNumber,
    String? orderId,
  }) async {
    try {
      final data = await remoteDataSource.trackShipment(
        awb: awb,
        courier: courier,
        lastPhoneNumber: lastPhoneNumber,
        orderId: orderId,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> trackBisaExpressAwb(String awb) async {
    try {
      final data = await remoteDataSource.trackBisaExpressAwb(awb);
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPickupVehicles() async {
    try {
      final data = await remoteDataSource.getPickupVehicles();
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getActiveCouriers() async {
    try {
      final data = await remoteDataSource.getActiveCouriers();
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> requestPickup({
    required String pickupDate,
    required String pickupTime,
    required String pickupVehicle,
    required List<String> orderNumbers,
  }) async {
    try {
      final data = await remoteDataSource.requestPickup(
        pickupDate: pickupDate,
        pickupTime: pickupTime,
        pickupVehicle: pickupVehicle,
        orderNumbers: orderNumbers,
      );
      return Right(data);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _mapDioExceptionToFailure(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const TimeoutFailure();
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final rawData = e.response?.data;
      final data = rawData is Map<String, dynamic> ? rawData : null;
      final message = data?['meta']?['message'] ?? data?['message'] ?? 'errors.generic';

      switch (statusCode) {
        case 401:
          return UnauthorizedFailure(message);
        case 403:
          return ForbiddenFailure(message);
        case 404:
          {
            final msg = message?.toString().trim();
            return NotFoundFailure(
              (msg != null && msg.isNotEmpty) ? msg : 'errors.not_found',
            );
          }
        case 422:
          {
            final readiness = ReadinessService.failureFromResponseData(data, message);
            if (readiness != null) return readiness;
            return ValidationFailure(
              message: message,
              errors: (data?['errors'] as Map?)?.map(
                (k, v) => MapEntry(
                  k.toString(),
                  (v as List).map((e) => e.toString()).toList(),
                ),
              ),
            );
          }
        case 400:
          if (message.toLowerCase().contains('daily limit') ||
              message.toLowerCase().contains('limit exceeded')) {
            return const ServerFailure(
              message: 'cart.api_quota_exhausted',
              statusCode: 429,
            );
          }
          return ServerFailure(message: message, statusCode: statusCode);
        case 429:
          return ServerFailure(
            message: message.contains('Kuota') ||
                    message.toLowerCase().contains('quota')
                ? 'cart.api_quota_exhausted'
                : message,
            statusCode: 429,
          );
        default:
          return ServerFailure(message: message, statusCode: statusCode);
      }
    } else if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return const UnexpectedFailure();
  }

  @override
  Future<Either<Failure, void>> uploadPaymentProof(
    String orderId,
    String paymentProofUrl,
  ) async {
    try {
      await remoteDataSource.uploadPaymentProof(orderId, paymentProofUrl);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }
}
