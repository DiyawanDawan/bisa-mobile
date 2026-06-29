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
    this.mediationStartedAt,
    this.readyToResolveAt,
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
  final DateTime? mediationStartedAt;
  final DateTime? readyToResolveAt;
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
      mediationStartedAt: parseDate(json['mediationStartedAt']),
      readyToResolveAt: parseDate(json['readyToResolveAt']),
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
    );
  }

  bool get isActive => status == 'OPEN' || status == 'UNDER_REVIEW';

  bool get isMediationActive =>
      mediationStartedAt != null && status.toUpperCase() != 'RESOLVED';

  bool get isReadyToResolve => readyToResolveAt != null;

  bool get supplierCanRespond =>
      isActive && sellerResponse == null && sellerRespondedAt == null;

  /// i18n keys — call `.tr()` or `order_dispute_i18n` helpers in UI.
  String get mediationPhaseLabel {
    if (readyToResolveAt != null) {
      return 'orders.dispute.phase_mediation_done';
    }
    if (mediationStartedAt != null) {
      return 'orders.dispute.phase_mediation_active';
    }
    return 'orders.dispute.phase_waiting_mediation';
  }

  /// i18n keys — localize at presentation layer.
  String get statusLabel {
    if (isActive && (mediationStartedAt != null || readyToResolveAt != null)) {
      return mediationPhaseLabel;
    }
    switch (status.toUpperCase()) {
      case 'UNDER_REVIEW':
        return 'orders.dispute.status_under_review';
      case 'RESOLVED':
        if (resolution == 'RELEASE') {
          return 'orders.dispute.status_resolved_release';
        }
        if (resolution == 'REFUND') {
          return 'orders.dispute.status_resolved_refund';
        }
        return 'orders.dispute.status_resolved';
      case 'OPEN':
      default:
        return 'orders.dispute.status_open';
    }
  }
}
