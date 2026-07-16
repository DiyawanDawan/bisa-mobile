import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';
import '../models/booking_models.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  BookingUserEntity _mapUser(BookingUserModel m) => BookingUserEntity(
        id: m.id,
        fullName: m.fullName,
        avatarUrl: m.avatarUrl,
        companyName: m.companyName,
      );

  BookingEntity _map(BookingModel m) => BookingEntity(
        id: m.id,
        bookingNumber: m.bookingNumber,
        buyerId: m.buyerId,
        supplierId: m.supplierId,
        productId: m.productId,
        harvestLotId: m.harvestLotId,
        productMode: m.productMode,
        quantity: m.quantity,
        unit: m.unit,
        priceSnapshot: m.priceSnapshot,
        subtotalSnapshot: m.subtotalSnapshot,
        status: m.status,
        expiresAt: m.expiresAt,
        expectedDeliveryDate: m.expectedDeliveryDate,
        notes: m.notes,
        orderId: m.orderId,
        confirmedAt: m.confirmedAt,
        isExpired: m.isExpired,
        createdAt: m.createdAt,
        buyer: _mapUser(m.buyer),
        supplier: _mapUser(m.supplier),
        product: BookingProductEntity(
          id: m.product.id,
          name: m.product.name,
          thumbnailUrl: m.product.thumbnailUrl,
          productMode: m.product.productMode,
          unit: m.product.unit,
          stock: m.product.stock,
          reservedStock: m.product.reservedStock,
          availableStock: m.product.availableStock,
          pricePerUnit: m.product.pricePerUnit,
          availabilityType: m.product.availabilityType,
        ),
        harvestLot: m.harvestLot != null
            ? BookingHarvestLotEntity(
                id: m.harvestLot!.id,
                seasonLabel: m.harvestLot!.seasonLabel,
                expectedHarvestDate: m.harvestLot!.expectedHarvestDate,
                expectedQuantityTon: m.harvestLot!.expectedQuantityTon,
                reservedQuantityTon: m.harvestLot!.reservedQuantityTon,
                availableQuantityTon: m.harvestLot!.availableQuantityTon,
                status: m.harvestLot!.status,
              )
            : null,
        order: m.order != null
            ? BookingOrderRefEntity(
                id: m.order!.id,
                orderNumber: m.order!.orderNumber,
                status: m.order!.status,
              )
            : null,
      );

  @override
  Future<Either<Failure, BookingEntity>> createBooking(Map<String, dynamic> body) async {
    try {
      return Right(_map(await remoteDataSource.createBooking(body)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> listMyBookings({String? status}) async {
    try {
      final list = await remoteDataSource.listMyBookings(status: status);
      return Right(list.items.map(_map).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> listIncomingBookings({String? status}) async {
    try {
      final list = await remoteDataSource.listIncomingBookings(status: status);
      return Right(list.items.map(_map).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBooking(String id) async {
    try {
      return Right(_map(await remoteDataSource.getBooking(id)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking(String id, {String? reason}) async {
    try {
      return Right(_map(await remoteDataSource.cancelBooking(id, reason: reason)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> confirmBooking(String id) async {
    try {
      return Right(_map(await remoteDataSource.confirmBooking(id)));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingCheckoutResult>> checkoutBooking(
    String id, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final result = await remoteDataSource.checkoutBooking(id, body: body);
      return Right(
        BookingCheckoutResult(booking: _map(result.booking), checkout: result.checkout),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
