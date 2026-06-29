import '../../domain/entities/iot_dashboard_entity.dart';
import 'iot_alert_model.dart';

class IotDashboardModel {
  static IotDashboardEntity fromJson(Map<String, dynamic> json) {
    final statsRaw = json['summaryStats'] as Map<String, dynamic>? ?? {};
    final seriesRaw = json['series'] as Map<String, dynamic>? ?? {};

    final series = <String, List<IotSeriesPoint>>{};
    for (final entry in seriesRaw.entries) {
      final list = entry.value as List? ?? [];
      series[entry.key] = list
          .whereType<Map>()
          .map(_parseSeriesPoint)
          .toList();
    }

    final alertsRaw = json['recentAlerts'] as List? ?? [];
    final lastRaw = json['lastReading'] as Map<String, dynamic>?;

    return IotDashboardEntity(
      deviceId: json['deviceId']?.toString() ?? '',
      deviceName: json['deviceName']?.toString() ?? 'Perangkat',
      liveStatus: json['liveStatus']?.toString() ?? 'OFFLINE',
      isMonitoringEnabled: json['isMonitoringEnabled'] as bool? ?? true,
      thresholdMin: _toDouble(json['thresholdMin']),
      thresholdMax: _toDouble(json['thresholdMax']),
      range: json['range']?.toString() ?? '24h',
      lastReading: lastRaw != null ? _parseLastReading(lastRaw) : null,
      summaryStats: IotSummaryStats(
        maxTemp: _toDouble(statsRaw['maxTemp']) ?? 0,
        minTemp: _toDouble(statsRaw['minTemp']) ?? 0,
        avgTemp: _toDouble(statsRaw['avgTemp']) ?? 0,
        maxHum: _toDouble(statsRaw['maxHum']) ?? 0,
        minHum: _toDouble(statsRaw['minHum']) ?? 0,
        avgHum: _toDouble(statsRaw['avgHum']) ?? 0,
        maxCo2: _toDouble(statsRaw['maxCo2']) ?? 0,
        minCo2: _toDouble(statsRaw['minCo2']) ?? 0,
        avgCo2: _toDouble(statsRaw['avgCo2']) ?? 0,
        totalReadings: (statsRaw['totalReadings'] as num?)?.toInt() ?? 0,
      ),
      series: series,
      recentAlerts: alertsRaw
          .whereType<Map>()
          .map((e) => IotAlertModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      uptimePercent: _toDouble(json['uptimePercent']) ?? 0,
      readingsInRange: (json['readingsInRange'] as num?)?.toInt() ?? 0,
      currentReadingsCount: (json['currentReadingsCount'] as num?)?.toInt(),
      statusWindow: json['statusWindow']?.toString() ?? '30m',
    );
  }

  static IotFleetAnalyticsEntity fleetFromJson(Map<String, dynamic> json) {
    final totalsRaw = json['totals'] as Map<String, dynamic>? ?? {};
    final devicesRaw = json['devices'] as List? ?? [];

    return IotFleetAnalyticsEntity(
      range: json['range']?.toString() ?? '24h',
      totals: IotFleetTotals(
        devices: (totalsRaw['devices'] as num?)?.toInt() ?? 0,
        online: (totalsRaw['online'] as num?)?.toInt() ?? 0,
        offline: (totalsRaw['offline'] as num?)?.toInt() ?? 0,
        alerting: (totalsRaw['alerting'] as num?)?.toInt() ?? 0,
        disabled: (totalsRaw['disabled'] as num?)?.toInt() ?? 0,
      ),
      devices: devicesRaw
          .whereType<Map>()
          .map((d) {
            final spark = d['sparkline'] as List? ?? [];
            return IotFleetDeviceEntity(
              id: d['id']?.toString() ?? '',
              name: d['name']?.toString() ?? 'Perangkat',
              liveStatus: d['liveStatus']?.toString() ?? 'OFFLINE',
              lastTemp: _toDouble(d['lastTemp']),
              sparkline: spark.whereType<Map>().map(_parseSeriesPoint).toList(),
            );
          })
          .toList(),
    );
  }

  static IotStatusSummaryEntity statusSummaryFromJson(Map<String, dynamic> json) {
    final devicesRaw = json['devices'] as List? ?? [];
    return IotStatusSummaryEntity(
      totalDevices: (json['totalDevices'] as num?)?.toInt() ?? 0,
      onlineCount: (json['onlineCount'] as num?)?.toInt() ?? 0,
      alertingCount: (json['alertingCount'] as num?)?.toInt() ?? 0,
      deviceRows: devicesRaw.whereType<Map>().map((d) {
        final lastSeen = d['lastSeen']?.toString();
        return IotDeviceStatusRow(
          id: d['id']?.toString() ?? '',
          liveStatus: d['liveStatus']?.toString() ?? 'OFFLINE',
          isMonitoringEnabled: d['isMonitoringEnabled'] as bool? ?? true,
          hasActiveAlert: d['hasActiveAlert'] as bool? ?? false,
          lastSeen: lastSeen != null ? DateTime.tryParse(lastSeen) : null,
        );
      }).toList(),
    );
  }

  static IotAlertsPageEntity alertsPageFromJson(Map<String, dynamic> json) {
    final alertsRaw = json['alerts'] as List? ?? [];
    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};

    return IotAlertsPageEntity(
      alerts: alertsRaw
          .whereType<Map>()
          .map((e) => IotAlertModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      page: (pagination['page'] as num?)?.toInt() ?? 1,
      totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
      total: (pagination['total'] as num?)?.toInt() ?? 0,
    );
  }

  static IotSeriesPoint _parseSeriesPoint(Map<dynamic, dynamic> raw) {
    final t = raw['t']?.toString();
    return IotSeriesPoint(
      recordedAt: t != null ? DateTime.parse(t) : DateTime.now(),
      value: _toDouble(raw['v']) ?? 0,
    );
  }

  static IotLastReading _parseLastReading(Map<String, dynamic> raw) {
    return IotLastReading(
      temperature: _toDouble(raw['temperature']) ?? 0,
      humidity: _toDouble(raw['humidity']),
      co2Level: _toDouble(raw['co2Level']),
      recordedAt: DateTime.parse(raw['recordedAt']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}
