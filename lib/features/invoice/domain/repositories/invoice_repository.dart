import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/invoice_preview_entity.dart';

abstract class InvoiceRepository {
  Future<Either<Failure, InvoicePreviewEntity>> getInvoicePreview(
    String negotiationId, {
    Map<String, dynamic>? shippingSelection,
    double? quantity,
    double? pricePerUnit,
  });
  Future<Either<Failure, void>> issueInvoice(
    String negotiationId, {
    Map<String, dynamic>? shippingSnapshot,
    Map<String, dynamic>? shippingSelection,
    String? specifications,
    double? quantity,
    double? pricePerUnit,
  });
  Future<Either<Failure, void>> updatePendingInvoice(
    String orderId, {
    Map<String, dynamic>? shippingSnapshot,
    String? specifications,
  });
}
