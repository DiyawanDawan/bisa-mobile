class OrderDisputeEntity {
  const OrderDisputeEntity({
    required this.id,
    required this.reason,
    this.description,
    this.evidenceUrls = const [],
    this.sellerResponse,
    this.sellerEvidenceUrls = const [],
    this.sellerRespondedAt,
    required this.status,
    this.resolution,
    this.resolutionNote,
    this.resolvedAt,
    required this.createdAt,
  });

  final String id;
  final String reason;
  final String? description;
  final List<String> evidenceUrls;
  final String? sellerResponse;
  final List<String> sellerEvidenceUrls;
  final DateTime? sellerRespondedAt;
  final String status;
  final String? resolution;
  final String? resolutionNote;
  final DateTime? resolvedAt;
  final DateTime createdAt;

  factory OrderDisputeEntity.fromJson(Map<String, dynamic> json) {
    List<String> parseUrls(dynamic raw) {
      if (raw is! List) return const [];
      return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
    }

    DateTime? parseDate(dynamic raw) {
      if (raw == null) return null;
      return DateTime.tryParse(raw.toString());
    }

    return OrderDisputeEntity(
      id: json['id']?.toString() ?? '',
      reason: json['reason']?.toString() ?? '',
      description: json['description']?.toString(),
      evidenceUrls: parseUrls(json['evidenceUrls']),
      sellerResponse: json['sellerResponse']?.toString(),
      sellerEvidenceUrls: parseUrls(json['sellerEvidenceUrls']),
      sellerRespondedAt: parseDate(json['sellerRespondedAt']),
      status: json['status']?.toString() ?? 'OPEN',
      resolution: json['resolution']?.toString(),
      resolutionNote: json['resolutionNote']?.toString(),
      resolvedAt: parseDate(json['resolvedAt']),
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
    );
  }

  bool get isActive => status == 'OPEN' || status == 'UNDER_REVIEW';

  bool get supplierCanRespond =>
      isActive && sellerResponse == null && sellerRespondedAt == null;

  String get statusLabel {
    switch (status.toUpperCase()) {
      case 'UNDER_REVIEW':
        return 'Sedang Ditinjau Admin';
      case 'RESOLVED':
        if (resolution == 'RELEASE') return 'Selesai — Dana ke Supplier';
        if (resolution == 'REFUND') return 'Selesai — Refund ke Buyer';
        return 'Selesai';
      case 'OPEN':
      default:
        return 'Menunggu Review Admin';
    }
  }
}
