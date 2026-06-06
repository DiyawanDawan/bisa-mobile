import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_bisa/core/media/media_upload_queue.dart';
import 'package:mobile_bisa/features/marketplace/presentation/bloc/marketplace_cubit.dart';
import '../models/negotiation_model.dart';

abstract class NegotiationRemoteDataSource {
  Future<List<NegotiationModel>> getMyOffers({
    int page = 1,
    int limit = 20,
    String? roomType,
    String? status,
  });
  Future<List<NegotiationModel>> getIncomingOffers({
    int page = 1,
    int limit = 20,
    String? roomType,
    String? status,
  });
  Future<NegotiationModel> getNegotiationDetail(String id);
  Future<String?> findRoomByProductId(
    String productId, {
    String purpose = 'negotiation',
  });
  Future<void> sendChatMessage(
    String negotiationId,
    String content, {
    String? attachmentUrl,
  });
  Future<void> updateStatus(
    String id,
    String status, {
    double? quantity,
    double? pricePerUnit,
    String? rejectionReason,
  });
  Future<void> cancelNegotiation(String id, String cancellationReason);
  Future<void> counterOffer(String id, {required double quantity, required double pricePerUnit});
  Future<void> createContract(
    String negotiationId, {
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    Map<String, dynamic>? shippingSelection,
    String? specifications,
    double? quantity,
    double? pricePerUnit,
  });
  Future<NegotiationModel> createOffer({
    required String productId,
    required double quantity,
    required double pricePerUnit,
    String? message,
    String? attachmentUrl,
    String? purpose,
  });
  Future<String> uploadFile(String filePath, {String? contentType});
  Future<void> setTypingStatus(String negotiationId, bool isTyping);
  Future<void> editChatMessage(
    String negotiationId,
    String messageId,
    String content,
  );
  Future<void> deleteChatMessage(String negotiationId, String messageId);
  Future<void> clearChatMessages(String negotiationId);
  Future<void> markMessagesAsRead(String negotiationId);
  Future<List<NegotiationMessageModel>> getChatMessages(
    String negotiationId, {
    required int skip,
    int limit = 50,
  });
}

class NegotiationRemoteDataSourceImpl implements NegotiationRemoteDataSource {
  final Dio dio;
  final MediaUploadQueue uploadQueue;

  NegotiationRemoteDataSourceImpl({
    required this.dio,
    required this.uploadQueue,
  });

  List<NegotiationModel> _parseNegotiationList(List data) {
    final negotiations = <NegotiationModel>[];
    for (final entry in data) {
      if (entry is! Map) continue;
      try {
        negotiations.add(
          NegotiationModel.fromJson(Map<String, dynamic>.from(entry)),
        );
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('NEGOTIATION LIST: skip invalid row: $e\n$st');
        }
      }
    }
    return negotiations;
  }

  List<NegotiationMessageModel> _parseMessageList(List data) {
    final messages = <NegotiationMessageModel>[];
    for (final entry in data) {
      if (entry is! Map) continue;
      try {
        messages.add(
          NegotiationMessageModel.fromJson(Map<String, dynamic>.from(entry)),
        );
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('NEGOTIATION MESSAGES: skip invalid row: $e\n$st');
        }
      }
    }
    return messages;
  }

  @override
  Future<List<NegotiationModel>> getMyOffers({
    int page = 1,
    int limit = 20,
    String? roomType,
    String? status,
  }) async {
    final response = await dio.get('/negotiations/my-offers', queryParameters: {
      'page': page,
      'limit': limit,
      'productMode': MarketplaceCubit.activeProductMode,
      if (roomType != null) 'roomType': roomType,
      if (status != null && status.isNotEmpty) 'status': status,
    });
    final List data = response.data['data'] as List? ?? const [];
    return _parseNegotiationList(data);
  }

  @override
  Future<List<NegotiationModel>> getIncomingOffers({
    int page = 1,
    int limit = 20,
    String? roomType,
    String? status,
  }) async {
    final response = await dio.get('/negotiations/incoming', queryParameters: {
      'page': page,
      'limit': limit,
      'productMode': MarketplaceCubit.activeProductMode,
      if (roomType != null) 'roomType': roomType,
      if (status != null && status.isNotEmpty) 'status': status,
    });
    final List data = response.data['data'] as List? ?? const [];
    return _parseNegotiationList(data);
  }

  @override
  Future<NegotiationModel> getNegotiationDetail(String id) async {
    final response = await dio.get('/negotiations/$id');
    final raw = response.data['data'];
    if (raw is! Map) {
      throw StateError('Response negosiasi tidak berisi data.');
    }
    return NegotiationModel.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<String?> findRoomByProductId(
    String productId, {
    String purpose = 'negotiation',
  }) async {
    final response = await dio.get(
      '/negotiations/by-product/$productId',
      queryParameters: {'purpose': purpose},
    );
    final data = response.data['data'];
    if (data == null) return null;
    if (data is Map && data['id'] != null) {
      return data['id'].toString();
    }
    return null;
  }

  @override
  Future<void> sendChatMessage(
    String negotiationId,
    String content, {
    String? attachmentUrl,
  }) async {
    await dio.post('/negotiations/$negotiationId/messages', data: {
      'content': content,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
    });
  }

  @override
  Future<void> updateStatus(
    String id,
    String status, {
    double? quantity,
    double? pricePerUnit,
    String? rejectionReason,
  }) async {
    await dio.put('/negotiations/$id/status', data: {
      'status': status,
      if (quantity != null) 'quantity': quantity,
      if (pricePerUnit != null) 'pricePerUnit': pricePerUnit,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    });
  }

  @override
  Future<void> cancelNegotiation(String id, String cancellationReason) async {
    await dio.put('/negotiations/$id/cancel', data: {
      'cancellationReason': cancellationReason,
    });
  }

  @override
  Future<void> counterOffer(
    String id, {
    required double quantity,
    required double pricePerUnit,
  }) async {
    await dio.put('/negotiations/$id/counter-offer', data: {
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
    });
  }

  @override
  Future<void> createContract(
    String negotiationId, {
    String? shippingAddress,
    Map<String, dynamic>? shippingSnapshot,
    Map<String, dynamic>? shippingSelection,
    String? specifications,
    double? quantity,
    double? pricePerUnit,
  }) async {
    await dio.post('/orders/contract', data: {
      'negotiationId': negotiationId,
      if (shippingAddress != null && shippingAddress.isNotEmpty)
        'shippingAddress': shippingAddress,
      if (shippingSnapshot != null && shippingSnapshot.isNotEmpty)
        'shippingSnapshot': shippingSnapshot,
      if (shippingSelection != null && shippingSelection.isNotEmpty)
        'shippingSelection': shippingSelection,
      if (specifications != null && specifications.isNotEmpty)
        'specifications': specifications,
      if (quantity != null) 'quantity': quantity,
      if (pricePerUnit != null) 'pricePerUnit': pricePerUnit,
    });
  }

  @override
  Future<NegotiationModel> createOffer({
    required String productId,
    required double quantity,
    required double pricePerUnit,
    String? message,
    String? attachmentUrl,
    String? purpose,
  }) async {
    final response = await dio.post('/negotiations', data: {
      'productId': productId,
      'quantity': quantity,
      'pricePerUnit': pricePerUnit,
      if (message != null) 'message': message,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      if (purpose != null) 'purpose': purpose,
    });
    return NegotiationModel.fromJson(response.data['data']);
  }

  @override
  Future<String> uploadFile(String filePath, {String? contentType}) async {
    final uploaded = await uploadQueue.uploadFile(
      localPath: filePath,
      folder: 'negotiations',
    );
    return uploaded.url ?? uploaded.path;
  }

  @override
  Future<void> setTypingStatus(String negotiationId, bool isTyping) async {
    await dio.post('/negotiations/$negotiationId/typing', data: {
      'isTyping': isTyping,
    });
  }

  @override
  Future<void> editChatMessage(
    String negotiationId,
    String messageId,
    String content,
  ) async {
    await dio.put(
      '/negotiations/$negotiationId/messages/$messageId',
      data: {'content': content},
    );
  }

  @override
  Future<void> deleteChatMessage(
    String negotiationId,
    String messageId,
  ) async {
    await dio.delete('/negotiations/$negotiationId/messages/$messageId');
  }

  @override
  Future<void> clearChatMessages(String negotiationId) async {
    await dio.delete('/negotiations/$negotiationId/messages');
  }

  @override
  Future<void> markMessagesAsRead(String negotiationId) async {
    await dio.put('/negotiations/$negotiationId/read');
  }

  @override
  Future<List<NegotiationMessageModel>> getChatMessages(
    String negotiationId, {
    required int skip,
    int limit = 50,
  }) async {
    final response = await dio.get(
      '/negotiations/$negotiationId/messages',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final List data = response.data['data'] as List? ?? const [];
    return _parseMessageList(data);
  }
}
