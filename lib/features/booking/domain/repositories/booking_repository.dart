import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';

class BookingCheckoutResult {
  final BookingEntity booking;
  final Map<String, dynamic> checkout;

  const BookingCheckoutResult({required this.booking, required this.checkout});
}

abstract class BookingRepository {
  Future<Either<Failure, BookingEntity>> createBooking(Map<String, dynamic> body);
  Future<Either<Failure, List<BookingEntity>>> listMyBookings({String? status});
  Future<Either<Failure, List<BookingEntity>>> listIncomingBookings({String? status});
  Future<Either<Failure, BookingEntity>> getBooking(String id);
  Future<Either<Failure, BookingEntity>> cancelBooking(String id, {String? reason});
  Future<Either<Failure, BookingEntity>> confirmBooking(String id);
  Future<Either<Failure, BookingCheckoutResult>> checkoutBooking(
    String id, {
    Map<String, dynamic>? body,
  });
}
