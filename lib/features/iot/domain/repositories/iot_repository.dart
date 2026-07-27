import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/iot_device_model.dart';
import '../entities/iot_dashboard_entity.dart';

abstract class IotRepository {
  Future<Either<Failure, List<IotDeviceModel>>> getDevices();
  Future<Either<Failure, IotDeviceModel>> claimDevice(String deviceSecret, String name);
  Future<Either<Failure, List<IotReadingModel>>> getDeviceHistory(String deviceId, {int page = 1, int limit = 20});
  Future<Either<Failure, IotDashboardEntity>> getDeviceDashboard(
    String deviceId, {
    String range = '24h',
  });
  Future<Either<Failure, IotFleetAnalyticsEntity>> getFleetAnalytics({String range = '24h'});
  Future<Either<Failure, IotAlertsPageEntity>> getDeviceAlerts(
    String deviceId, {
    int page = 1,
    int limit = 20,
    bool? isRead,
  });
  Future<Either<Failure, void>> markAlertRead(String alertId);
  Future<Either<Failure, IotStatusSummaryEntity>> getStatusSummary({int page = 1, int limit = 50});
  Future<Either<Failure, String>> exportDeviceReadingsCsv(String deviceId, {String range = '24h'});
  Future<Either<Failure, void>> updateDevice(String deviceId, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteDevice(String deviceId);
  Future<Either<Failure, Map<String, dynamic>>> subscribePro(
    String channelCode,
    String method, {
    String planType = 'rental',
    int durationMonths = 1,
  });
  Future<Either<Failure, Map<String, dynamic>?>> getPyrolysisSession(String deviceId);
  Future<Either<Failure, Map<String, dynamic>>> startPyrolysisSession(
    String deviceId, {
    required String biomassaType,
    required double beratInput,
  });
  Future<Either<Failure, void>> stopPyrolysisSession(String deviceId);
  Future<Either<Failure, Map<String, dynamic>>> analyzeRealtime(
    String deviceId, {
    String? biomassaType,
    double? beratInput,
    int? waktuPembakaranMin,
  });
}
