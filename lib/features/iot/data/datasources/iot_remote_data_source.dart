import 'package:dio/dio.dart';
import '../models/iot_device_model.dart';
import '../models/iot_dashboard_model.dart';
import '../../domain/entities/iot_dashboard_entity.dart';

abstract class IotRemoteDataSource {
  Future<List<IotDeviceModel>> getDevices();
  Future<IotDeviceModel> claimDevice(String deviceSecret, String name);
  Future<List<IotReadingModel>> getDeviceHistory(String deviceId, {int page = 1, int limit = 20});
  Future<IotDashboardEntity> getDeviceDashboard(
    String deviceId, {
    String range = '24h',
  });
  Future<IotFleetAnalyticsEntity> getFleetAnalytics({String range = '24h'});
  Future<IotAlertsPageEntity> getDeviceAlerts(
    String deviceId, {
    int page = 1,
    int limit = 20,
    bool? isRead,
  });
  Future<void> markAlertRead(String alertId);
  Future<IotStatusSummaryEntity> getStatusSummary({int page = 1, int limit = 50});
  Future<String> exportDeviceReadingsCsv(String deviceId, {String range = '24h'});
  Future<void> updateDevice(String deviceId, Map<String, dynamic> data);
  Future<void> deleteDevice(String deviceId);
  Future<Map<String, dynamic>> getSubscriptionPlans();
  Future<Map<String, dynamic>> subscribePro(
    String channelCode,
    String method, {
    String planType = 'rental',
    int durationMonths = 1,
  });
  Future<Map<String, dynamic>?> getPyrolysisSession(String deviceId);
  Future<Map<String, dynamic>> startPyrolysisSession(
    String deviceId, {
    required String biomassaType,
    required double beratInput,
  });
  Future<void> stopPyrolysisSession(String deviceId);
  Future<Map<String, dynamic>> analyzeRealtime(
    String deviceId, {
    String? biomassaType,
    double? beratInput,
    int? waktuPembakaranMin,
  });
}

class IotRemoteDataSourceImpl implements IotRemoteDataSource {
  final Dio dio;

  IotRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<IotDeviceModel>> getDevices() async {
    final response = await dio.get('/iot/devices');
    final List data = response.data['data'];
    return data.map((e) => IotDeviceModel.fromJson(e)).toList();
  }

  @override
  Future<IotDeviceModel> claimDevice(String deviceSecret, String name) async {
    final response = await dio.post('/iot/devices/claim', data: {
      'deviceSecret': deviceSecret,
      'name': name,
    });
    return IotDeviceModel.fromJson(response.data['data']);
  }

  @override
  Future<List<IotReadingModel>> getDeviceHistory(String deviceId, {int page = 1, int limit = 20}) async {
    final response = await dio.get('/iot/data/$deviceId', queryParameters: {
      'page': page,
      'limit': limit,
    });
    final List data = response.data['data'];
    return data.map((e) => IotReadingModel.fromJson(e)).toList();
  }

  @override
  Future<IotDashboardEntity> getDeviceDashboard(
    String deviceId, {
    String range = '24h',
  }) async {
    final response = await dio.get(
      '/iot/dashboard/$deviceId',
      queryParameters: {'range': range},
    );
    return IotDashboardModel.fromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  @override
  Future<IotFleetAnalyticsEntity> getFleetAnalytics({String range = '24h'}) async {
    final response = await dio.get(
      '/iot/analytics/fleet',
      queryParameters: {'range': range},
    );
    return IotDashboardModel.fleetFromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  @override
  Future<IotAlertsPageEntity> getDeviceAlerts(
    String deviceId, {
    int page = 1,
    int limit = 20,
    bool? isRead,
  }) async {
    final response = await dio.get(
      '/iot/devices/$deviceId/alerts',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (isRead != null) 'isRead': isRead.toString(),
      },
    );
    return IotDashboardModel.alertsPageFromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  @override
  Future<void> markAlertRead(String alertId) async {
    await dio.patch('/iot/alerts/$alertId/read');
  }

  @override
  Future<IotStatusSummaryEntity> getStatusSummary({int page = 1, int limit = 50}) async {
    final response = await dio.get(
      '/iot/status-summary',
      queryParameters: {'page': page, 'limit': limit},
    );
    return IotDashboardModel.statusSummaryFromJson(
      Map<String, dynamic>.from(response.data['data'] as Map),
    );
  }

  @override
  Future<String> exportDeviceReadingsCsv(String deviceId, {String range = '24h'}) async {
    final response = await dio.get(
      '/iot/devices/$deviceId/readings/export',
      queryParameters: {'range': range},
      options: Options(responseType: ResponseType.plain),
    );
    return response.data?.toString() ?? '';
  }

  @override
  Future<void> updateDevice(String deviceId, Map<String, dynamic> data) async {
    await dio.patch('/iot/devices/$deviceId', data: data);
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    await dio.delete('/iot/devices/$deviceId');
  }

  @override
  Future<Map<String, dynamic>> getSubscriptionPlans() async {
    final response = await dio.get('/iot/plans');
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  @override
  Future<Map<String, dynamic>> subscribePro(
    String channelCode,
    String method, {
    String planType = 'rental',
    int durationMonths = 1,
  }) async {
    final response = await dio.post('/iot/subscribe', data: {
      'channel_code': channelCode,
      'method': method,
      'plan_type': planType,
      'duration_months': durationMonths,
    });
    return response.data['data'];
  }

  @override
  Future<Map<String, dynamic>?> getPyrolysisSession(String deviceId) async {
    final response = await dio.get('/iot/devices/$deviceId/pyrolysis-session');
    final session = response.data['data']?['session'];
    if (session == null) return null;
    return Map<String, dynamic>.from(session as Map);
  }

  @override
  Future<Map<String, dynamic>> startPyrolysisSession(
    String deviceId, {
    required String biomassaType,
    required double beratInput,
  }) async {
    final response = await dio.post(
      '/iot/devices/$deviceId/pyrolysis-session/start',
      data: {
        'biomassaType': biomassaType,
        'beratInput': beratInput,
      },
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  @override
  Future<void> stopPyrolysisSession(String deviceId) async {
    await dio.post('/iot/devices/$deviceId/pyrolysis-session/stop');
  }

  @override
  Future<Map<String, dynamic>> analyzeRealtime(
    String deviceId, {
    String? biomassaType,
    double? beratInput,
    int? waktuPembakaranMin,
  }) async {
    final response = await dio.post(
      '/iot/devices/$deviceId/analyze-realtime',
      data: {
        if (biomassaType != null) 'biomassaType': biomassaType,
        if (beratInput != null) 'beratInput': beratInput,
        if (waktuPembakaranMin != null) 'waktuPembakaranMin': waktuPembakaranMin,
      },
    );
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }
}
