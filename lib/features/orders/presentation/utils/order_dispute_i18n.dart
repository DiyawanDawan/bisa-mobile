import 'package:easy_localization/easy_localization.dart';

import '../../domain/entities/order_dispute_entity.dart';

String disputeMediationPhaseLabel(OrderDisputeEntity dispute) {
  if (dispute.readyToResolveAt != null) {
    return 'orders.dispute.phase_mediation_done'.tr();
  }
  if (dispute.mediationStartedAt != null) {
    return 'orders.dispute.phase_mediation_active'.tr();
  }
  return 'orders.dispute.phase_waiting_mediation'.tr();
}

String disputeStatusLabel(OrderDisputeEntity dispute) {
  if (dispute.isActive &&
      (dispute.mediationStartedAt != null || dispute.readyToResolveAt != null)) {
    return disputeMediationPhaseLabel(dispute);
  }
  switch (dispute.status.toUpperCase()) {
    case 'UNDER_REVIEW':
      return 'orders.dispute.status_under_review'.tr();
    case 'RESOLVED':
      if (dispute.resolution == 'RELEASE') {
        return 'orders.dispute.status_resolved_release'.tr();
      }
      if (dispute.resolution == 'REFUND') {
        return 'orders.dispute.status_resolved_refund'.tr();
      }
      return 'orders.dispute.status_resolved'.tr();
    case 'OPEN':
    default:
      return 'orders.dispute.status_open'.tr();
  }
}
