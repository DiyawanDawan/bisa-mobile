class BisaExpressStatusLog {
  final String id;
  final String status;
  final String description;
  final String? location;
  final DateTime? createdAt;

  const BisaExpressStatusLog({
    required this.id,
    required this.status,
    required this.description,
    this.location,
    this.createdAt,
  });

  factory BisaExpressStatusLog.fromJson(Map<String, dynamic> json) {
    return BisaExpressStatusLog(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      location: json['location']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}

class BisaExpressTrackResult {
  final String id;
  final String awbNumber;
  final String status;
  final String? serviceType;
  final List<BisaExpressStatusLog> statusLogs;

  const BisaExpressTrackResult({
    required this.id,
    required this.awbNumber,
    required this.status,
    this.serviceType,
    this.statusLogs = const [],
  });

  factory BisaExpressTrackResult.fromJson(Map<String, dynamic> json) {
    final rawLogs = json['statusLogs'] as List? ?? const [];
    return BisaExpressTrackResult(
      id: json['id']?.toString() ?? '',
      awbNumber: json['awbNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      serviceType: json['serviceType']?.toString(),
      statusLogs: rawLogs
          .whereType<Map>()
          .map(
            (e) => BisaExpressStatusLog.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }
}
