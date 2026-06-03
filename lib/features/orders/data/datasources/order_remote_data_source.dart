import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getMyPurchases({int page = 1, int limit = 20, String? search});
  Future<List<OrderModel>> getMySales({int page = 1, int limit = 20, String? search});
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
  });
  Future<Map<String, dynamic>> previewDirectOrder({
    required List<Map<String, dynamic>> items,
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    List<Map<String, dynamic>>? shippingSelections,
    String? notes,
  });
  Future<Map<String, dynamic>?> getShippingOrigin();
  Future<List<Map<String, dynamic>>> searchShippingDestinations({
    required String search,
    int limit,
    int offset,
  });
  Future<List<Map<String, dynamic>>> calculateDomesticShipping({
    required int originId,
    required int destinationId,
    required int weightGrams,
    String? courier,
  });
  Future<Map<String, dynamic>> trackShipment({
    required String awb,
    required String courier,
    String? lastPhoneNumber,
    String? orderId,
  });
  Future<List<Map<String, dynamic>>> getPickupVehicles();
  Future<List<String>> getActiveCouriers();
  Future<List<Map<String, dynamic>>> requestPickup({
    required String pickupDate,
    required String pickupTime,
    required String pickupVehicle,
    required List<String> orderNumbers,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<OrderModel>> getMyPurchases({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final response = await dio.get('/orders/my-purchases', queryParameters: {
      'page': page,
      'limit': limit,
      'productMode': MarketplaceCubit.activeProductMode,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    });
    final List data = response.data['data'] as List? ?? const [];
    return _parseOrderList(data);
  }

  @override
  Future<List<OrderModel>> getMySales({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final response = await dio.get('/orders/my-sales', queryParameters: {
      'page': page,
      'limit': limit,
      'productMode': MarketplaceCubit.activeProductMode,
      if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
    });
    final List data = response.data['data'] as List? ?? const [];
    return _parseOrderList(data);
  }

  List<OrderModel> _parseOrderList(List data) {
    final orders = <OrderModel>[];
    for (final entry in data) {
      if (entry is! Map) continue;
      try {
        orders.add(OrderModel.fromJson(Map<String, dynamic>.from(entry)));
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
    return OrderModel.fromJson(response.data['data']);
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
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split(Platform.pathSeparator).last,
      ),
    });
    final response = await dio.post(
      '/system/upload',
      queryParameters: {'folder': 'disputes'},
      data: formData,
    );
    return response.data['data']['url'] as String;
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
      },
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>?> getShippingOrigin() async {
    final response = await dio.get('/shipping/origin');
    final data = response.data['data'];
    if (data == null) return null;
    return Map<String, dynamic>.from(data as Map);
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
    required int weightGrams,
    String? courier,
  }) async {
    final response = await dio.post(
      '/shipping/calculate-domestic',
      data: {
        'originId': originId,
        'destinationId': destinationId,
        'weightGrams': weightGrams,
        if (courier != null && courier.isNotEmpty) 'courier': courier,
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
}
