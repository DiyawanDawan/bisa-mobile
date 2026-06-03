import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../negotiation/data/datasources/negotiation_remote_data_source.dart';
import '../../domain/entities/invoice_preview_entity.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_remote_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;
  final NegotiationRemoteDataSource negotiationRemoteDataSource;

  InvoiceRepositoryImpl({
    required this.remoteDataSource,
    required this.negotiationRemoteDataSource,
  });

  @override
  Future<Either<Failure, InvoicePreviewEntity>> getInvoicePreview(
    String negotiationId, {
    Map<String, dynamic>? shippingSelection,
    double? quantity,
    double? pricePerUnit,
  }) async {
    try {
      final preview = await remoteDataSource.getInvoicePreview(
        negotiationId,
        shippingSelection: shippingSelection,
        quantity: quantity,
        pricePerUnit: pricePerUnit,
      );
      return Right(preview.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> issueInvoice(
    String negotiationId, {
    Map<String, dynamic>? shippingSnapshot,
    Map<String, dynamic>? shippingSelection,
    String? specifications,
    double? quantity,
    double? pricePerUnit,
  }) async {
    try {
      await negotiationRemoteDataSource.createContract(
        negotiationId,
        shippingSnapshot: shippingSnapshot,
        shippingSelection: shippingSelection,
        specifications: specifications,
        quantity: quantity,
        pricePerUnit: pricePerUnit,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (_) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updatePendingInvoice(
    String orderId, {
    Map<String, dynamic>? shippingSnapshot,
    String? specifications,
  }) async {
    try {
      await remoteDataSource.updatePendingInvoice(
        orderId,
        shippingSnapshot: shippingSnapshot,
        specifications: specifications,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (_) {
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
      final message =
          data?['meta']?['message'] ?? data?['message'] ?? 'Terjadi kesalahan';

      switch (statusCode) {
        case 401:
          return UnauthorizedFailure(message);
        case 403:
          return ForbiddenFailure(message);
        case 404:
          return NotFoundFailure(message);
        case 422:
          return ValidationFailure(message: message);
        default:
          return ServerFailure(message: message, statusCode: statusCode);
      }
    } else if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return const UnexpectedFailure();
  }
}
