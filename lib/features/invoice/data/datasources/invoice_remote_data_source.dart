import 'package:dio/dio.dart';
import '../models/invoice_preview_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<InvoicePreviewModel> getInvoicePreview(
    String negotiationId, {
    Map<String, dynamic>? shippingSelection,
    double? quantity,
    double? pricePerUnit,
  });
  Future<void> updatePendingInvoice(
    String orderId, {
    Map<String, dynamic>? shippingSnapshot,
    String? specifications,
  });
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio dio;

  InvoiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<InvoicePreviewModel> getInvoicePreview(
    String negotiationId, {
    Map<String, dynamic>? shippingSelection,
    double? quantity,
    double? pricePerUnit,
  }) async {
    final hasBody = shippingSelection != null ||
        quantity != null ||
        pricePerUnit != null;
    final Response<dynamic> response;
    if (hasBody) {
      response = await dio.post(
        '/negotiations/$negotiationId/invoice-preview',
        data: {
          if (shippingSelection != null) 'shippingSelection': shippingSelection,
          if (quantity != null) 'quantity': quantity,
          if (pricePerUnit != null) 'pricePerUnit': pricePerUnit,
        },
      );
    } else {
      response = await dio.get('/negotiations/$negotiationId/invoice-preview');
    }
    return InvoicePreviewModel.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> updatePendingInvoice(
    String orderId, {
    Map<String, dynamic>? shippingSnapshot,
    String? specifications,
  }) async {
    await dio.put('/orders/$orderId/invoice', data: {
      if (shippingSnapshot != null) 'shippingSnapshot': shippingSnapshot,
      if (specifications != null) 'specifications': specifications,
    });
  }
}
