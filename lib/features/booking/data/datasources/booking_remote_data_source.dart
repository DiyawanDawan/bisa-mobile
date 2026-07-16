import '../models/booking_models.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(Map<String, dynamic> body);
  Future<BookingListModel> listMyBookings({String? status, int page = 1, int limit = 20});
  Future<BookingListModel> listIncomingBookings({String? status, int page = 1, int limit = 20});
  Future<BookingModel> getBooking(String id);
  Future<BookingModel> cancelBooking(String id, {String? reason});
  Future<BookingModel> confirmBooking(String id);
  Future<BookingCheckoutModel> checkoutBooking(String id, {Map<String, dynamic>? body});
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final dynamic dio;

  BookingRemoteDataSourceImpl({required this.dio});

  Map<String, dynamic> _data(dynamic response) =>
      response.data['data'] as Map<String, dynamic>;

  @override
  Future<BookingModel> createBooking(Map<String, dynamic> body) async {
    final response = await dio.post('/bookings', data: body);
    return BookingModel.fromJson(_data(response));
  }

  @override
  Future<BookingListModel> listMyBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/bookings/my',
      queryParameters: {
        if (status != null) 'status': status,
        'page': page,
        'limit': limit,
      },
    );
    return BookingListModel.fromJson(_data(response));
  }

  @override
  Future<BookingListModel> listIncomingBookings({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/bookings/incoming',
      queryParameters: {
        if (status != null) 'status': status,
        'page': page,
        'limit': limit,
      },
    );
    return BookingListModel.fromJson(_data(response));
  }

  @override
  Future<BookingModel> getBooking(String id) async {
    final response = await dio.get('/bookings/$id');
    return BookingModel.fromJson(_data(response));
  }

  @override
  Future<BookingModel> cancelBooking(String id, {String? reason}) async {
    final response = await dio.put(
      '/bookings/$id/cancel',
      data: {if (reason != null) 'reason': reason},
    );
    return BookingModel.fromJson(_data(response));
  }

  @override
  Future<BookingModel> confirmBooking(String id) async {
    final response = await dio.put('/bookings/$id/confirm');
    return BookingModel.fromJson(_data(response));
  }

  @override
  Future<BookingCheckoutModel> checkoutBooking(String id, {Map<String, dynamic>? body}) async {
    final response = await dio.post('/bookings/$id/checkout', data: body ?? {});
    return BookingCheckoutModel.fromJson(_data(response));
  }
}
