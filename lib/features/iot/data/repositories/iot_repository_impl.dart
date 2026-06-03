import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/iot_repository.dart';
import '../../domain/entities/iot_dashboard_entity.dart';
import '../datasources/iot_remote_data_source.dart';
import '../models/iot_device_model.dart';

class IotRepositoryImpl implements IotRepository {
  final IotRemoteDataSource remoteDataSource;

  IotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<IotDeviceModel>>> getDevices() async {
    try {
      final result = await remoteDataSource.getDevices();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, IotDeviceModel>> registerDevice(String deviceId, String name) async {
    try {
      final result = await remoteDataSource.registerDevice(deviceId, name);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<IotReadingModel>>> getDeviceHistory(String deviceId, {int page = 1, int limit = 20}) async {
    try {
      final result = await remoteDataSource.getDeviceHistory(deviceId, page: page, limit: limit);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, IotDashboardEntity>> getDeviceDashboard(
    String deviceId, {
    String range = '24h',
  }) async {
    try {
      final result = await remoteDataSource.getDeviceDashboard(deviceId, range: range);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, IotFleetAnalyticsEntity>> getFleetAnalytics({String range = '24h'}) async {
    try {
      final result = await remoteDataSource.getFleetAnalytics(range: range);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, IotAlertsPageEntity>> getDeviceAlerts(
    String deviceId, {
    int page = 1,
    int limit = 20,
    bool? isRead,
  }) async {
    try {
      final result = await remoteDataSource.getDeviceAlerts(
        deviceId,
        page: page,
        limit: limit,
        isRead: isRead,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> markAlertRead(String alertId) async {
    try {
      await remoteDataSource.markAlertRead(alertId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, IotStatusSummaryEntity>> getStatusSummary({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final result = await remoteDataSource.getStatusSummary(page: page, limit: limit);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, String>> exportDeviceReadingsCsv(
    String deviceId, {
    String range = '24h',
  }) async {
    try {
      final csv = await remoteDataSource.exportDeviceReadingsCsv(deviceId, range: range);
      return Right(csv);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateDevice(String deviceId, Map<String, dynamic> data) async {
    try {
      await remoteDataSource.updateDevice(deviceId, data);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteDevice(String deviceId) async {
    try {
      await remoteDataSource.deleteDevice(deviceId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> subscribePro(String channelCode, String method) async {
    try {
      final result = await remoteDataSource.subscribePro(channelCode, method);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return const Left(UnexpectedFailure());
    }
  }

  Failure _handleDioError(DioException e) {
    final message = e.response?.data?['meta']?['message'] ?? e.message ?? 'Terjadi kesalahan';
    return ServerFailure(message: message);
  }
}
