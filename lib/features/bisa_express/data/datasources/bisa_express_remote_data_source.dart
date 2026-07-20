import 'package:dio/dio.dart';
import 'package:mobile_bisa/features/bisa_express/data/models/bisa_express_track.dart';

/// Remote API untuk BISA Express (buyer/seller): track AWB, shipment by order, request pickup.
class BisaExpressRemoteDataSource {
  BisaExpressRemoteDataSource(this._dio);

  final Dio _dio;

  Future<BisaExpressTrackResult> trackByAwb(String awb) async {
    final response = await _dio.get(
      '/bisa-express/track/${Uri.encodeComponent(awb)}',
    );
    final raw = response.data['data'];
    if (raw is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        message: 'Respon track BISA Express kosong',
      );
    }
    return BisaExpressTrackResult.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<BisaExpressTrackResult?> getShipmentByOrderId(String orderId) async {
    final response = await _dio.get(
      '/bisa-express/shipment/${Uri.encodeComponent(orderId)}',
    );
    final raw = response.data['data'];
    if (raw == null) return null;
    if (raw is! Map) return null;
    return BisaExpressTrackResult.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<Map<String, dynamic>> requestPickup({
    required String orderId,
    DateTime? pickupScheduledAt,
    String? sellerNote,
  }) async {
    final response = await _dio.post(
      '/bisa-express/request-pickup',
      data: {
        'orderId': orderId,
        if (pickupScheduledAt != null)
          'pickupScheduledAt': pickupScheduledAt.toIso8601String(),
        if (sellerNote != null && sellerNote.isNotEmpty) 'sellerNote': sellerNote,
      },
    );
    return Map<String, dynamic>.from(response.data['data'] as Map? ?? {});
  }
}
