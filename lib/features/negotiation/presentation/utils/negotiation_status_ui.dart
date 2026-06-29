import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_layout.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/app_feedback.dart';
import '../../domain/entities/negotiation_entity.dart';
import '../../domain/entities/negotiation_entity_extensions.dart';

class NegotiationStatusDisplay {
  final String label;
  final Color color;

  const NegotiationStatusDisplay({
    required this.label,
    required this.color,
  });

  /// Status badge berdasarkan status pesanan terkait (setelah tagihan diterbitkan).
  static NegotiationStatusDisplay forLinkedOrder(String orderStatus) {
    switch (orderStatus.toUpperCase()) {
      case 'PENDING':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_order_pending_payment'.tr(),
          color: AppColors.primary,
        );
      case 'PROCESSING':
      case 'PAID':
      case 'CONFIRMED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_order_paid_processing'.tr(),
          color: AppColors.secondary,
        );
      case 'SHIPPED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_order_shipped'.tr(),
          color: AppColors.secondary,
        );
      case 'DELIVERED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_order_delivered'.tr(),
          color: AppColors.secondary,
        );
      case 'COMPLETED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_order_completed'.tr(),
          color: AppColors.success,
        );
      case 'DISPUTED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_order_disputed'.tr(),
          color: AppColors.error,
        );
      case 'CANCELLED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_order_cancelled'.tr(),
          color: AppColors.error,
        );
      default:
        return NegotiationStatusDisplay(
          label: orderStatus.replaceAll('_', ' '),
          color: AppColors.textHint,
        );
    }
  }

  static bool _hasLinkedOrderStatus(String status, String? orderStatus) {
    return (status == 'LOCKED' || status == 'CONTRACT_CREATED') &&
        orderStatus != null &&
        orderStatus.isNotEmpty;
  }

  /// Badge singkat di daftar negosiasi.
  static NegotiationStatusDisplay forList(
    String status, {
    String? orderStatus,
  }) {
    if (_hasLinkedOrderStatus(status, orderStatus)) {
      return forLinkedOrder(orderStatus!);
    }

    switch (status) {
      case 'OPEN_NEGOTIATION':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_active'.tr(),
          color: AppColors.warning,
        );
      case 'OFFER_SUBMITTED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_waiting'.tr(),
          color: AppColors.warning,
        );
      case 'OFFER_ACCEPTED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_accepted'.tr(),
          color: AppColors.secondary,
        );
      case 'OFFER_REJECTED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_rejected'.tr(),
          color: AppColors.error,
        );
      case 'LOCKED':
      case 'CONTRACT_CREATED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_invoice'.tr(),
          color: AppColors.primary,
        );
      case 'EXPIRED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_expired'.tr(),
          color: AppColors.textHint,
        );
      case 'CANCELLED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_cancelled'.tr(),
          color: AppColors.error,
        );
      default:
        return NegotiationStatusDisplay(
          label: status.replaceAll('_', ' '),
          color: AppColors.textHint,
        );
    }
  }

  /// Label di HUD ruang negosiasi (header produk).
  static NegotiationStatusDisplay forRoom(
    String status, {
    required bool isSupplier,
    String? orderStatus,
  }) {
    if (_hasLinkedOrderStatus(status, orderStatus)) {
      return forLinkedOrder(orderStatus!);
    }

    switch (status) {
      case 'OFFER_SUBMITTED':
        return NegotiationStatusDisplay(
          label: isSupplier
              ? 'negotiation.status_room_offer_incoming'.tr()
              : 'negotiation.status_room_waiting_confirmation'.tr(),
          color: AppColors.warning,
        );
      case 'OFFER_ACCEPTED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_room_offer_accepted'.tr(),
          color: AppColors.secondary,
        );
      case 'OFFER_REJECTED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_room_offer_rejected'.tr(),
          color: AppColors.error,
        );
      case 'LOCKED':
      case 'CONTRACT_CREATED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_order_pending_payment'.tr(),
          color: AppColors.primary,
        );
      case 'EXPIRED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_expired'.tr(),
          color: AppColors.textHint,
        );
      case 'CANCELLED':
        return NegotiationStatusDisplay(
          label: 'negotiation.status_list_cancelled'.tr(),
          color: AppColors.error,
        );
      case 'OPEN_NEGOTIATION':
      default:
        return NegotiationStatusDisplay(
          label: 'negotiation.status_room_active_offer'.tr(),
          color: AppColors.warning,
        );
    }
  }

  static bool isTerminal(String status) =>
      status == 'EXPIRED' ||
      status == 'CANCELLED' ||
      status == 'OFFER_REJECTED';

  static String closureTitle(String status, {required bool isSupplier}) {
    switch (status) {
      case 'OFFER_REJECTED':
        return isSupplier
            ? 'negotiation.closure_rejected_by_supplier'.tr()
            : 'negotiation.closure_rejected_by_supplier_buyer'.tr();
      case 'CANCELLED':
        return isSupplier
            ? 'negotiation.closure_cancelled_by_buyer_supplier'.tr()
            : 'negotiation.closure_cancelled_by_buyer'.tr();
      case 'EXPIRED':
        return 'negotiation.closure_expired'.tr();
      default:
        return 'negotiation.closure_default'.tr();
    }
  }

  static String closureSourceLabel(String? closedBy) {
    switch (closedBy) {
      case 'SUPPLIER':
        return 'negotiation.closure_source_supplier'.tr();
      case 'BUYER':
        return 'negotiation.closure_source_buyer'.tr();
      case 'SYSTEM':
        return 'negotiation.closure_source_system'.tr();
      default:
        return 'negotiation.closure_source_default'.tr();
    }
  }

  /// Route detail pesanan bila pesanan terkait berstatus sengketa.
  static String? disputeOrderRoute(NegotiationEntity negotiation) {
    final orderStatus = negotiation.order?.status;
    if (orderStatus == null || orderStatus.toUpperCase() != 'DISPUTED') {
      return null;
    }
    final orderId = negotiation.order?.id ?? negotiation.orderId;
    if (orderId == null || orderId.isEmpty) return null;
    return '/order/$orderId';
  }

  static bool isLinkedOrderDisputed(NegotiationEntity negotiation) =>
      disputeOrderRoute(negotiation) != null;

  /// Sama aturan backend `clearChatMessages`.
  static bool canClearChat(NegotiationEntity negotiation) {
    if (isLinkedOrderDisputed(negotiation)) return false;
    const blocked = {'OFFER_REJECTED', 'EXPIRED', 'CANCELLED'};
    return !blocked.contains(negotiation.status.toUpperCase());
  }

  static String clearChatBlockedReason(NegotiationEntity negotiation) {
    if (isLinkedOrderDisputed(negotiation)) {
      return 'negotiation.clear_chat_blocked_dispute'.tr();
    }
    final status = negotiation.status.toUpperCase();
    if (status == 'OFFER_REJECTED' ||
        status == 'EXPIRED' ||
        status == 'CANCELLED') {
      final label = forList(status).label;
      return 'negotiation.clear_chat_blocked_closed'.tr(
        namedArgs: {'status': label},
      );
    }
    return 'negotiation.clear_chat_blocked_generic'.tr();
  }

  /// Buka ruang negosiasi; saat sengketa tetap ke chat mediasi (bukan hanya detail order).
  static void openFromList(
    BuildContext context,
    NegotiationEntity negotiation, {
    String? currentUserId,
  }) {
    if (currentUserId != null &&
        !negotiation.isParticipant(currentUserId)) {
      showWarningSnackBar(context, 'negotiation.not_your_room');
      return;
    }
    if (negotiation.isInquiryChat) {
      context.push('/negotiation/${negotiation.id}?mode=inquiry');
    } else {
      context.push('/negotiation/${negotiation.id}');
    }
  }
}
