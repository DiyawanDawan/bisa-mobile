import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/readiness/readiness_service.dart';
import '../../domain/entities/negotiation_entity.dart';
import '../../domain/enums/negotiation_chat_purpose.dart';
import '../../domain/repositories/negotiation_repository.dart';
import '../datasources/negotiation_remote_data_source.dart';

class NegotiationRepositoryImpl implements NegotiationRepository {
  final NegotiationRemoteDataSource remoteDataSource;

  NegotiationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NegotiationEntity>>> getMyOffers({
    int page = 1,
    int limit = 20,
    NegotiationChatPurpose? roomType,
    String? status,
  }) async {
    try {
      final models = await remoteDataSource.getMyOffers(
        page: page,
        limit: limit,
        roomType: roomType?.apiValue,
        status: status,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<NegotiationEntity>>> getIncomingOffers({
    int page = 1,
    int limit = 20,
    NegotiationChatPurpose? roomType,
    String? status,
  }) async {
    try {
      final models = await remoteDataSource.getIncomingOffers(
        page: page,
        limit: limit,
        roomType: roomType?.apiValue,
        status: status,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, NegotiationEntity>> getNegotiationDetail(String id) async {
    try {
      final model = await remoteDataSource.getNegotiationDetail(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, String?>> findRoomByProductId(
    String productId, {
    NegotiationChatPurpose purpose = NegotiationChatPurpose.negotiation,
  }) async {
    try {
      final roomId = await remoteDataSource.findRoomByProductId(
        productId,
        purpose: purpose.apiValue,
      );
      return Right(roomId);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendChatMessage(
    String negotiationId,
    String content, {
    String? attachmentUrl,
    String? localFilePath,
  }) async {
    try {
      String? finalAttachmentUrl = attachmentUrl;
      if (localFilePath != null) {
        final isPdf = localFilePath.toLowerCase().endsWith('.pdf');
        finalAttachmentUrl = await remoteDataSource.uploadFile(
          localFilePath,
          contentType: isPdf ? 'application/pdf' : null,
        );
      }
      await remoteDataSource.sendChatMessage(
        negotiationId,
        content,
        attachmentUrl: finalAttachmentUrl,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateStatus(
    String id,
    String status, {
    double? quantity,
    double? pricePerUnit,
    String? rejectionReason,
  }) async {
    try {
      await remoteDataSource.updateStatus(
        id,
        status,
        quantity: quantity,
        pricePerUnit: pricePerUnit,
        rejectionReason: rejectionReason,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> cancelNegotiation(
    String id,
    String cancellationReason,
  ) async {
    try {
      await remoteDataSource.cancelNegotiation(id, cancellationReason);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> counterOffer(
    String id, {
    required double quantity,
    required double pricePerUnit,
  }) async {
    try {
      await remoteDataSource.counterOffer(
        id,
        quantity: quantity,
        pricePerUnit: pricePerUnit,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createContract(
    String negotiationId, {
    String? shippingAddress,
  }) async {
    try {
      await remoteDataSource.createContract(
        negotiationId,
        shippingAddress: shippingAddress,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, NegotiationEntity>> createOffer({
    required String productId,
    required double quantity,
    required double pricePerUnit,
    String? message,
    String? attachmentUrl,
    String? localImagePath,
    NegotiationChatPurpose? purpose,
  }) async {
    try {
      String? finalAttachmentUrl = attachmentUrl;
      
      if (localImagePath != null) {
        finalAttachmentUrl = await remoteDataSource.uploadFile(localImagePath);
      }

      final model = await remoteDataSource.createOffer(
        productId: productId,
        quantity: quantity,
        pricePerUnit: pricePerUnit,
        message: message,
        attachmentUrl: finalAttachmentUrl,
        purpose: purpose?.apiValue,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setTypingStatus(String negotiationId, bool isTyping) async {
    try {
      await remoteDataSource.setTypingStatus(negotiationId, isTyping);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editChatMessage(
    String negotiationId,
    String messageId,
    String content,
  ) async {
    try {
      await remoteDataSource.editChatMessage(negotiationId, messageId, content);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteChatMessage(
    String negotiationId,
    String messageId,
  ) async {
    try {
      await remoteDataSource.deleteChatMessage(negotiationId, messageId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearChatMessages(String negotiationId) async {
    try {
      await remoteDataSource.clearChatMessages(negotiationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markMessagesAsRead(String negotiationId) async {
    try {
      await remoteDataSource.markMessagesAsRead(negotiationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioExceptionToFailure(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<NegotiationMessageEntity>>> loadOlderChatMessages(
    String negotiationId, {
    required int skip,
    int limit = 50,
  }) async {
    try {
      final models = await remoteDataSource.getChatMessages(
        negotiationId,
        skip: skip,
        limit: limit,
      );
      return Right(models.map((e) => e.toEntity()).toList());
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
      final message = data?['meta']?['message'] ?? data?['message'] ?? 'Terjadi kesalahan';

      switch (statusCode) {
        case 401:
          return UnauthorizedFailure(message);
        case 403:
          {
            final msg = message.toString();
            final lowered = msg.toLowerCase();
            if (lowered.contains('participant') ||
                lowered.contains('role') ||
                lowered.contains('negotiation') ||
                lowered.contains('forbidden') ||
                msg == 'Terjadi kesalahan') {
              return const ForbiddenFailure(
                'Anda tidak memiliki akses ke ruang negosiasi ini. '
                'Pastikan Anda login sebagai pembeli atau supplier yang terlibat dalam order.',
              );
            }
            return ForbiddenFailure(msg);
          }
        case 404:
          return const NotFoundFailure();
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
        default:
          return ServerFailure(message: message, statusCode: statusCode);
      }
    } else if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return const UnexpectedFailure();
  }
}
