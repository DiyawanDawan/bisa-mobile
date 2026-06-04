import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
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
        return const NegotiationStatusDisplay(
          label: 'Menunggu Pembayaran',
          color: AppColors.primary,
        );
      case 'PROCESSING':
      case 'PAID':
      case 'CONFIRMED':
        return const NegotiationStatusDisplay(
          label: 'Dibayar · Diproses',
          color: AppColors.secondary,
        );
      case 'SHIPPED':
        return const NegotiationStatusDisplay(
          label: 'Dikirim',
          color: AppColors.secondary,
        );
      case 'DELIVERED':
        return const NegotiationStatusDisplay(
          label: 'Terkirim',
          color: AppColors.secondary,
        );
      case 'COMPLETED':
        return const NegotiationStatusDisplay(
          label: 'Selesai',
          color: AppColors.success,
        );
      case 'DISPUTED':
        return const NegotiationStatusDisplay(
          label: 'Sengketa',
          color: AppColors.error,
        );
      case 'CANCELLED':
        return const NegotiationStatusDisplay(
          label: 'Dibatalkan',
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
        return const NegotiationStatusDisplay(
          label: 'Aktif',
          color: AppColors.warning,
        );
      case 'OFFER_SUBMITTED':
        return const NegotiationStatusDisplay(
          label: 'Menunggu',
          color: AppColors.warning,
        );
      case 'OFFER_ACCEPTED':
        return const NegotiationStatusDisplay(
          label: 'Diterima',
          color: AppColors.secondary,
        );
      case 'OFFER_REJECTED':
        return const NegotiationStatusDisplay(
          label: 'Ditolak',
          color: AppColors.error,
        );
      case 'LOCKED':
      case 'CONTRACT_CREATED':
        return const NegotiationStatusDisplay(
          label: 'Tagihan',
          color: AppColors.primary,
        );
      case 'EXPIRED':
        return const NegotiationStatusDisplay(
          label: 'Kedaluwarsa',
          color: AppColors.textHint,
        );
      case 'CANCELLED':
        return const NegotiationStatusDisplay(
          label: 'Dibatalkan',
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
          label: isSupplier ? 'Tawaran Masuk' : 'Menunggu Konfirmasi',
          color: AppColors.warning,
        );
      case 'OFFER_ACCEPTED':
        return const NegotiationStatusDisplay(
          label: 'Tawaran Diterima',
          color: AppColors.secondary,
        );
      case 'OFFER_REJECTED':
        return const NegotiationStatusDisplay(
          label: 'Tawaran Ditolak',
          color: AppColors.error,
        );
      case 'LOCKED':
      case 'CONTRACT_CREATED':
        return const NegotiationStatusDisplay(
          label: 'Menunggu Pembayaran',
          color: AppColors.primary,
        );
      case 'EXPIRED':
        return const NegotiationStatusDisplay(
          label: 'Kedaluwarsa',
          color: AppColors.textHint,
        );
      case 'CANCELLED':
        return const NegotiationStatusDisplay(
          label: 'Dibatalkan',
          color: AppColors.error,
        );
      case 'OPEN_NEGOTIATION':
      default:
        return const NegotiationStatusDisplay(
          label: 'Tawaran Aktif',
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
        return isSupplier ? 'Anda menolak penawaran' : 'Penawaran ditolak supplier';
      case 'CANCELLED':
        return isSupplier ? 'Negosiasi dibatalkan pembeli' : 'Anda membatalkan negosiasi';
      case 'EXPIRED':
        return 'Negosiasi kedaluwarsa';
      default:
        return 'Negosiasi ditutup';
    }
  }

  static String closureSourceLabel(String? closedBy) {
    switch (closedBy) {
      case 'SUPPLIER':
        return 'Ditolak oleh supplier';
      case 'BUYER':
        return 'Dibatalkan oleh pembeli';
      case 'SYSTEM':
        return 'Kedaluwarsa otomatis';
      default:
        return 'Alasan penutupan';
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

  /// Buka detail sengketa (bukan chat) bila pesanan sedang DISPUTED.
  static void openFromList(
    BuildContext context,
    NegotiationEntity negotiation, {
    String? currentUserId,
  }) {
    if (currentUserId != null &&
        !negotiation.isParticipant(currentUserId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Negosiasi ini bukan milik akun Anda. Tarik untuk memuat ulang daftar.',
          ),
        ),
      );
      return;
    }
    final disputeRoute = disputeOrderRoute(negotiation);
    if (disputeRoute != null) {
      context.push(disputeRoute);
      return;
    }
    if (negotiation.isInquiryChat) {
      context.push('/negotiation/${negotiation.id}?mode=inquiry');
    } else {
      context.push('/negotiation/${negotiation.id}');
    }
  }
}
