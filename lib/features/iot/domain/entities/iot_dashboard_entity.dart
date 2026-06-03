import '../../data/models/iot_alert_model.dart';

class IotSeriesPoint {
  const IotSeriesPoint({required this.recordedAt, required this.value});

  final DateTime recordedAt;
  final double value;
}

class IotLastReading {
  const IotLastReading({
    required this.temperature,
    this.humidity,
    this.co2Level,
    required this.recordedAt,
  });

  final double temperature;
  final double? humidity;
  final double? co2Level;
  final DateTime recordedAt;
}

class IotSummaryStats {
  const IotSummaryStats({
    required this.maxTemp,
    required this.minTemp,
    required this.avgTemp,
    this.maxHum = 0,
    this.minHum = 0,
    this.avgHum = 0,
    this.maxCo2 = 0,
    this.minCo2 = 0,
    this.avgCo2 = 0,
    required this.totalReadings,
  });

  final double maxTemp;
  final double minTemp;
  final double avgTemp;
  final double maxHum;
  final double minHum;
  final double avgHum;
  final double maxCo2;
  final double minCo2;
  final double avgCo2;
  final int totalReadings;
}

class IotDashboardEntity {
  const IotDashboardEntity({
    required this.deviceId,
    required this.deviceName,
    required this.liveStatus,
    required this.isMonitoringEnabled,
    this.thresholdMin,
    this.thresholdMax,
    required this.range,
    this.lastReading,
    required this.summaryStats,
    required this.series,
    required this.recentAlerts,
    required this.uptimePercent,
    required this.readingsInRange,
  });

  final String deviceId;
  final String deviceName;
  final String liveStatus;
  final bool isMonitoringEnabled;
  final double? thresholdMin;
  final double? thresholdMax;
  final String range;
  final IotLastReading? lastReading;
  final IotSummaryStats summaryStats;
  final Map<String, List<IotSeriesPoint>> series;
  final List<IotAlertModel> recentAlerts;
  final double uptimePercent;
  final int readingsInRange;

  List<IotSeriesPoint> get temperatureSeries => series['temperature'] ?? const [];
  List<IotSeriesPoint> get humiditySeries => series['humidity'] ?? const [];
  List<IotSeriesPoint> get co2Series => series['co2'] ?? const [];
}

class IotFleetDeviceEntity {
  const IotFleetDeviceEntity({
    required this.id,
    required this.name,
    required this.liveStatus,
    this.lastTemp,
    required this.sparkline,
  });

  final String id;
  final String name;
  final String liveStatus;
  final double? lastTemp;
  final List<IotSeriesPoint> sparkline;
}

class IotFleetTotals {
  const IotFleetTotals({
    required this.devices,
    required this.online,
    required this.offline,
    required this.alerting,
    required this.disabled,
  });

  final int devices;
  final int online;
  final int offline;
  final int alerting;
  final int disabled;
}

class IotFleetAnalyticsEntity {
  const IotFleetAnalyticsEntity({
    required this.range,
    required this.totals,
    required this.devices,
  });

  final String range;
  final IotFleetTotals totals;
  final List<IotFleetDeviceEntity> devices;
}

class IotDeviceStatusRow {
  const IotDeviceStatusRow({
    required this.id,
    required this.liveStatus,
    required this.isMonitoringEnabled,
    required this.hasActiveAlert,
    this.lastSeen,
  });

  final String id;
  final String liveStatus;
  final bool isMonitoringEnabled;
  final bool hasActiveAlert;
  final DateTime? lastSeen;
}

class IotStatusSummaryEntity {
  const IotStatusSummaryEntity({
    required this.totalDevices,
    required this.onlineCount,
    required this.alertingCount,
    required this.deviceRows,
  });

  final int totalDevices;
  final int onlineCount;
  final int alertingCount;
  final List<IotDeviceStatusRow> deviceRows;

  IotDeviceStatusRow? rowFor(String deviceId) {
    for (final r in deviceRows) {
      if (r.id == deviceId) return r;
    }
    return null;
  }
}

class IotAlertsPageEntity {
  const IotAlertsPageEntity({
    required this.alerts,
    required this.page,
    required this.totalPages,
    required this.total,
  });

  final List<IotAlertModel> alerts;
  final int page;
  final int totalPages;
  final int total;
}
