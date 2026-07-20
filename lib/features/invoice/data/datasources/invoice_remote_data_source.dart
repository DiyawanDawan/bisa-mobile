import 'package:dio/dio.dart';
import '../../domain/entities/invoice_preview_entity.dart';
import '../models/invoice_preview_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<InvoicePreviewEntity> getInvoicePreview(
    String negotiationId, {
    Map<String, dynamic>? shippingSelection,
    Map<String, dynamic>? shippingSnapshot,
    double? quantity,
    double? pricePerUnit,
  });

  Future<Map<String, dynamic>> getBuyerShippingAddresses(String negotiationId);
  Future<void> updatePendingInvoice(
    String orderId, {
    Map<String, dynamic>? shippingSnapshot,
    String? specifications,
    double? quantity,
    double? pricePerUnit,
  });
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio dio;

  InvoiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<InvoicePreviewEntity> getInvoicePreview(
    String negotiationId, {
    Map<String, dynamic>? shippingSelection,
    Map<String, dynamic>? shippingSnapshot,
    double? quantity,
    double? pricePerUnit,
  }) async {
    final hasBody = shippingSelection != null ||
        shippingSnapshot != null ||
        quantity != null ||
        pricePerUnit != null;
    final Response<dynamic> response;
    if (hasBody) {
      response = await dio.post(
        '/negotiations/$negotiationId/invoice-preview',
        data: {
          if (shippingSelection != null) 'shippingSelection': shippingSelection,
          if (shippingSnapshot != null) 'shippingSnapshot': shippingSnapshot,
          if (quantity != null) 'quantity': quantity,
          if (pricePerUnit != null) 'pricePerUnit': pricePerUnit,
        },
      );
    } else {
      response = await dio.get('/negotiations/$negotiationId/invoice-preview');
    }
    final raw = Map<String, dynamic>.from(response.data['data'] as Map);
    return InvoicePreviewModel.fromJson(raw).toEntity(raw: raw);
  }

  @override
  Future<Map<String, dynamic>> getBuyerShippingAddresses(
    String negotiationId,
  ) async {
    final response = await dio.get(
      '/negotiations/$negotiationId/buyer-shipping-addresses',
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  @override
  Future<void> updatePendingInvoice(
    String orderId, {
    Map<String, dynamic>? shippingSnapshot,
    String? specifications,
    double? quantity,
    double? pricePerUnit,
  }) async {
    await dio.put('/orders/$orderId/invoice', data: {
      if (shippingSnapshot != null) 'shippingSnapshot': shippingSnapshot,
      if (specifications != null) 'specifications': specifications,
      if (quantity != null) 'quantity': quantity,
      if (pricePerUnit != null) 'pricePerUnit': pricePerUnit,
    });
  }
}
