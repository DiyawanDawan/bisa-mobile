import 'package:dio/dio.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getMyPurchases({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? orderType,
  });
  Future<List<OrderModel>> getMySales({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? orderType,
  });
  Future<Map<String, int>> getMyPurchasesStatusCounts({
    String? search,
    String? orderType,
  });
  Future<Map<String, int>> getMySalesStatusCounts({
    String? search,
    String? orderType,
  });
  Future<OrderModel> getOrderDetail(String id);
  Future<Map<String, dynamic>> getCheckoutBatchDetail(String anchorOrderId);
  Future<Map<String, dynamic>> initializePayment(
    String orderId,
    String channelCode, {
    bool forceNew = false,
  });
  Future<Map<String, dynamic>> initializeBatchPayment(
    List<String> orderIds,
    String channelCode, {
    bool forceNew = false,
  });
  Future<void> mockConfirmPayment(String orderId);
  Future<void> simulatePayment(String orderId);
  Future<void> simulateBatchPayment(List<String> orderIds);
  Future<void> cancelPayment(String orderId);
  Future<Map<String, dynamic>> getSalesStats();
  Future<void> releaseEscrow(String id);
  Future<String> uploadDisputeEvidence(String filePath);
  Future<void> raiseDispute(
    String id,
    String reason,
    String description,
    List<String> evidenceUrls,
  );
  Future<void> respondToDispute(
    String id,
    String response,
    List<String> evidenceUrls,
  );
  Future<void> updateTracking(String id, Map<String, dynamic> data);
  Future<Map<String, dynamic>> createDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? orderType,
    String? voucherCode,
  });
  Future<Map<String, dynamic>> previewDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? voucherCode,
  });
  Future<Map<String, dynamic>> validateVoucher({
    required String code,
    required double subtotal,
    List<String>? sellerIds,
  });
  Future<Map<String, dynamic>?> getShippingOrigin();
  Future<void> setShippingOrigin({
    required int originId,
    String? originLabel,
  });
  Future<List<Map<String, dynamic>>> searchShippingDestinations({
    required String search,
    int limit,
    int offset,
  });
  Future<List<Map<String, dynamic>>> calculateDomesticShipping({
    required int originId,
    required int destinationId,
    int? weightGrams,
    num? weight,
    String weightUnit = 'KG',
    String? courier,
    String? sellerId,
    String? buyerId,
  });
  Future<Map<String, dynamic>> trackShipment({
    required String awb,
    required String courier,
    String? lastPhoneNumber,
    String? orderId,
  });
  Future<Map<String, dynamic>> trackBisaExpressAwb(String awb);
  Future<List<Map<String, dynamic>>> getPickupVehicles();
  Future<List<String>> getActiveCouriers();
  Future<List<Map<String, dynamic>>> requestPickup({
    required String pickupDate,
    required String pickupTime,
    required String pickupVehicle,
    required List<String> orderNumbers,
  });
  Future<void> uploadPaymentProof(String orderId, String paymentProofUrl);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  final MediaUploadQueue uploadQueue;

  OrderRemoteDataSourceImpl({
    required this.dio,
    required this.uploadQueue,
  });

  @override
  Future<List<OrderModel>> getMyPurchases({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? orderType,
  }) async {
    final response = await dio.get('/orders/my-purchases', queryParameters: {
      'page': page,
      'limit': limit,
      'productMode': MarketplaceCubit.activeProductMode,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (status != null && status.isNotEmpty) 'status': status,
      if (orderType != null && orderType.isNotEmpty) 'orderType': orderType,
    });
    final List data = response.data['data'] as List? ?? const [];
    return _parseOrderList(data);
  }

  @override
  Future<List<OrderModel>> getMySales({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? orderType,
  }) async {
    final response = await dio.get('/orders/my-sales', queryParameters: {
      'page': page,
      'limit': limit,
      'productMode': MarketplaceCubit.activeProductMode,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      if (status != null && status.isNotEmpty) 'status': status,
      if (orderType != null && orderType.isNotEmpty) 'orderType': orderType,
    });
    final List data = response.data['data'] as List? ?? const [];
    return _parseOrderList(data);
  }

  @override
  Future<Map<String, int>> getMyPurchasesStatusCounts({
    String? search,
    String? orderType,
  }) async {
    final response = await dio.get(
      '/orders/my-purchases/status-counts',
      queryParameters: {
        'productMode': MarketplaceCubit.activeProductMode,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (orderType != null && orderType.isNotEmpty) 'orderType': orderType,
      },
    );
    return _parseStatusCounts(response.data['data']);
  }

  @override
  Future<Map<String, int>> getMySalesStatusCounts({
    String? search,
    String? orderType,
  }) async {
    final response = await dio.get(
      '/orders/my-sales/status-counts',
      queryParameters: {
        'productMode': MarketplaceCubit.activeProductMode,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (orderType != null && orderType.isNotEmpty) 'orderType': orderType,
      },
    );
    return _parseStatusCounts(response.data['data']);
  }

  Map<String, int> _parseStatusCounts(dynamic raw) {
    if (raw is! Map) return const {};
    return raw.map(
      (key, value) => MapEntry(
        key.toString(),
        value is num ? value.toInt() : int.tryParse(value.toString()) ?? 0,
      ),
    );
  }

  List<OrderModel> _parseOrderList(List data) {
    final orders = <OrderModel>[];
    for (final entry in data) {
      if (entry is! Map) continue;
      try {
        final normalized = Map<String, dynamic>.from(entry);
        final rootPaymentStatus = normalized['paymentStatus']?.toString();
        if (rootPaymentStatus != null && rootPaymentStatus.isNotEmpty) {
          final txRaw = normalized['transaction'];
          if (txRaw is Map) {
            final tx = Map<String, dynamic>.from(txRaw);
            tx['paymentStatus'] ??= rootPaymentStatus;
            normalized['transaction'] = tx;
          } else {
            normalized['transaction'] = {
              'status': normalized['status'] ?? 'PENDING',
              'paymentStatus': rootPaymentStatus,
            };
          }
        }
        orders.add(OrderModel.fromJson(normalized));
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('ORDER LIST: skip invalid row: $e\n$st');
        }
      }
    }
    return orders;
  }

  @override
  Future<OrderModel> getOrderDetail(String id) async {
    final response = await dio.get('/orders/$id');
    // SEC-MOB-006: jangan log full response order (berisi PII buyer/seller + harga).
    if (kDebugMode) debugPrint('ORDER DETAIL status=${response.statusCode}');
    final raw = response.data['data'];
    if (raw is! Map) {
      throw StateError('Response detail pesanan tidak berisi data.');
    }
    return OrderModel.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<Map<String, dynamic>> getCheckoutBatchDetail(String anchorOrderId) async {
    final response = await dio.get('/orders/$anchorOrderId/batch');
    final raw = response.data['data'];
    if (raw is! Map) {
      throw StateError('Response /batch tidak berisi data checkout.');
    }
    return Map<String, dynamic>.from(raw);
  }

  @override
  Future<Map<String, dynamic>> initializePayment(
    String orderId,
    String channelCode, {
    bool forceNew = false,
  }) async {
    final response = await dio.post('/orders/$orderId/pay', data: {
      'channelCode': channelCode,
      if (forceNew) 'forceNew': true,
    });
    final raw = response.data['data'];
    if (raw is! Map) {
      throw StateError('Response /pay tidak berisi data pembayaran.');
    }
    return Map<String, dynamic>.from(raw);
  }

  @override
  Future<Map<String, dynamic>> initializeBatchPayment(
    List<String> orderIds,
    String channelCode, {
    bool forceNew = false,
  }) async {
    final response = await dio.post('/orders/direct/batch-pay', data: {
      'orderIds': orderIds,
      'channelCode': channelCode,
      if (forceNew) 'forceNew': true,
    });
    final raw = response.data['data'];
    if (raw is! Map) {
      throw StateError('Response batch-pay tidak berisi data pembayaran.');
    }
    return Map<String, dynamic>.from(raw);
  }

  @override
  Future<void> mockConfirmPayment(String orderId) async {
    await dio.post('/orders/$orderId/mock-confirm-payment');
  }

  @override
  Future<void> simulatePayment(String orderId) async {
    await dio.post('/orders/$orderId/simulate-payment');
  }

  @override
  Future<void> simulateBatchPayment(List<String> orderIds) async {
    await dio.post('/orders/direct/batch-simulate-payment', data: {
      'orderIds': orderIds,
    });
  }

  @override
  Future<void> cancelPayment(String orderId) async {
    await dio.post('/orders/$orderId/cancel-payment');
  }

  @override
  Future<Map<String, dynamic>> getSalesStats() async {
    final response = await dio.get('/orders/sales-stats');
    return response.data['data'];
  }

  @override
  Future<void> releaseEscrow(String id) async {
    await dio.put('/orders/release-escrow/$id');
  }

  @override
  Future<String> uploadDisputeEvidence(String filePath) async {
    final uploaded = await uploadQueue.uploadFile(
      localPath: filePath,
      folder: 'disputes',
    );
    return uploaded.url ?? uploaded.path;
  }

  @override
  Future<void> raiseDispute(
    String id,
    String reason,
    String description,
    List<String> evidenceUrls,
  ) async {
    await dio.post('/orders/$id/dispute', data: {
      'reason': reason,
      if (description.isNotEmpty) 'description': description,
      if (evidenceUrls.isNotEmpty) 'evidenceUrls': evidenceUrls,
    });
  }

  @override
  Future<void> respondToDispute(
    String id,
    String response,
    List<String> evidenceUrls,
  ) async {
    await dio.post('/orders/$id/dispute/response', data: {
      'response': response,
      if (evidenceUrls.isNotEmpty) 'evidenceUrls': evidenceUrls,
    });
  }

  @override
  Future<void> updateTracking(String id, Map<String, dynamic> data) async {
    await dio.put('/orders/tracking/$id', data: data);
  }

  @override
  Future<Map<String, dynamic>> createDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? orderType,
    String? voucherCode,
  }) async {
    final response = await dio.post(
      '/orders/direct',
      data: {
        'items': items,
        if (shippingAddress != null && shippingAddress.isNotEmpty)
          'shippingAddress': shippingAddress,
        if (shippingSnapshot != null && shippingSnapshot.isNotEmpty)
          'shippingSnapshot': shippingSnapshot,
        if (shippingSelections != null && shippingSelections.isNotEmpty)
          'shippingSelections': shippingSelections,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (orderType != null && orderType.isNotEmpty) 'orderType': orderType,
        if (voucherCode != null && voucherCode.isNotEmpty) 'voucherCode': voucherCode,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> previewDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
    String? voucherCode,
  }) async {
    final response = await dio.post(
      '/orders/direct/preview',
      data: {
        'items': items,
        if (shippingAddress != null && shippingAddress.isNotEmpty)
          'shippingAddress': shippingAddress,
        if (shippingSnapshot != null && shippingSnapshot.isNotEmpty)
          'shippingSnapshot': shippingSnapshot,
        if (shippingSelections != null && shippingSelections.isNotEmpty)
          'shippingSelections': shippingSelections,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (voucherCode != null && voucherCode.isNotEmpty) 'voucherCode': voucherCode,
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> validateVoucher({
    required String code,
    required double subtotal,
    List<String>? sellerIds,
  }) async {
    final response = await dio.post('/commerce/vouchers/validate', data: {
      'code': code,
      'subtotal': subtotal,
      if (sellerIds != null && sellerIds.isNotEmpty) 'sellerIds': sellerIds,
    });
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  @override
  Future<Map<String, dynamic>?> getShippingOrigin() async {
    final response = await dio.get('/shipping/origin');
    final data = response.data['data'];
    if (data == null) return null;
    return Map<String, dynamic>.from(data as Map);
  }

  @override
  Future<void> setShippingOrigin({
    required int originId,
    String? originLabel,
  }) async {
    await dio.put('/shipping/origin', data: {
      'originId': originId,
      if (originLabel != null && originLabel.isNotEmpty)
        'originLabel': originLabel,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> searchShippingDestinations({
    required String search,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await dio.get(
      '/shipping/destinations',
      queryParameters: {
        'search': search,
        'limit': limit,
        'offset': offset,
      },
    );
    final raw = response.data['data'] as List? ?? const [];
    return raw
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> calculateDomesticShipping({
    required int originId,
    required int destinationId,
    int? weightGrams,
    num? weight,
    String weightUnit = 'KG',
    String? courier,
    String? sellerId,
    String? buyerId,
  }) async {
    final qty = weight ??
        (weightGrams != null ? (weightGrams / 1000) : null);
    if (qty == null || qty <= 0) {
      throw ArgumentError('weight atau weightGrams wajib diisi');
    }
    final response = await dio.post(
      '/shipping/calculate-domestic',
      data: {
        'originId': originId,
        'destinationId': destinationId,
        'weight': qty,
        'weightUnit': weightUnit,
        if (courier != null && courier.isNotEmpty) 'courier': courier,
        if (sellerId != null && sellerId.isNotEmpty) 'sellerId': sellerId,
        if (buyerId != null && buyerId.isNotEmpty) 'buyerId': buyerId,
      },
    );
    final raw = response.data['data'] as List? ?? const [];
    return raw
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> trackShipment({
    required String awb,
    required String courier,
    String? lastPhoneNumber,
    String? orderId,
  }) async {
    final response = await dio.post(
      '/shipping/track',
      data: {
        'awb': awb,
        'courier': courier,
        if (lastPhoneNumber != null && lastPhoneNumber.isNotEmpty)
          'lastPhoneNumber': lastPhoneNumber,
        if (orderId != null && orderId.isNotEmpty) 'orderId': orderId,
      },
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  @override
  Future<Map<String, dynamic>> trackBisaExpressAwb(String awb) async {
    final response = await dio.get('/bisa-express/track/${Uri.encodeComponent(awb)}');
    return Map<String, dynamic>.from(response.data['data'] as Map? ?? {});
  }

  @override
  Future<List<Map<String, dynamic>>> getPickupVehicles() async {
    final response = await dio.get('/shipping/pickup/vehicles');
    final raw = response.data['data'] as List? ?? const [];
    return raw
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  @override
  Future<List<String>> getActiveCouriers() async {
    final response = await dio.get('/shipping/couriers');
    final raw = response.data['data'] as List? ?? const [];
    return raw.map((e) => e.toString()).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> requestPickup({
    required String pickupDate,
    required String pickupTime,
    required String pickupVehicle,
    required List<String> orderNumbers,
  }) async {
    final response = await dio.post(
      '/shipping/pickup/request',
      data: {
        'pickupDate': pickupDate,
        'pickupTime': pickupTime,
        'pickupVehicle': pickupVehicle,
        'orders': orderNumbers.map((e) => {'orderNo': e}).toList(),
      },
    );
    final raw = response.data['data'] as List? ?? const [];
    return raw
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  @override
  Future<void> uploadPaymentProof(String orderId, String paymentProofUrl) async {
    await dio.post('/orders/$orderId/payment-proof', data: {
      'paymentProofUrl': paymentProofUrl,
    });
  }
}
