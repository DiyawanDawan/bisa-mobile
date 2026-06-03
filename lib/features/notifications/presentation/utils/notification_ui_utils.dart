import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationAction {
  const NotificationAction({
    required this.label,
    required this.route,
  });

  final String label;
  final String route;
}

IconData notificationIcon(String type) {
  switch (type.toUpperCase()) {
    case 'ORDER':
    case 'ORDER_STATUS':
      return LucideIcons.shoppingBag;
    case 'DISPUTE':
    case 'ORDER_DISPUTE':
      return LucideIcons.shieldAlert;
    case 'NEGOTIATION':
      return LucideIcons.messageSquare;
    case 'FORUM':
      return LucideIcons.users;
    case 'WALLET':
    case 'PAYMENT':
    case 'PAYMENT_RECEIVED':
      return LucideIcons.wallet;
    case 'IOT_ALERT':
      return LucideIcons.cpu;
    case 'SYSTEM_ANNOUNCEMENT':
      return LucideIcons.megaphone;
    case 'MARKET':
    case 'MARKET_INSIGHT':
      return LucideIcons.trendingUp;
    default:
      return LucideIcons.bell;
  }
}

Color notificationColor(String type) {
  switch (type.toUpperCase()) {
    case 'ORDER':
    case 'ORDER_STATUS':
      return AppColors.success;
    case 'DISPUTE':
    case 'ORDER_DISPUTE':
      return AppColors.error;
    case 'NEGOTIATION':
      return AppColors.primary;
    case 'FORUM':
      return AppColors.info;
    case 'WALLET':
    case 'PAYMENT':
    case 'PAYMENT_RECEIVED':
      return AppColors.warning;
    case 'IOT_ALERT':
      return AppColors.secondary;
    case 'SYSTEM_ANNOUNCEMENT':
      return AppColors.info;
    case 'MARKET':
    case 'MARKET_INSIGHT':
      return AppColors.success;
    default:
      return AppColors.grey500;
  }
}

String notificationTypeLabel(String type) {
  switch (type.toUpperCase()) {
    case 'ORDER':
    case 'ORDER_STATUS':
      return 'Pesanan';
    case 'DISPUTE':
    case 'ORDER_DISPUTE':
      return 'Sengketa';
    case 'NEGOTIATION':
      return 'Negosiasi';
    case 'FORUM':
      return 'Forum';
    case 'WALLET':
      return 'Dompet';
    case 'PAYMENT':
    case 'PAYMENT_RECEIVED':
      return 'Pembayaran';
    case 'IOT_ALERT':
      return 'IoT Alert';
    case 'SYSTEM_ANNOUNCEMENT':
      return 'Pengumuman';
    case 'MARKET':
    case 'MARKET_INSIGHT':
      return 'Market Insight';
    default:
      return 'Umum';
  }
}

String notificationPriorityLabel(String priority) {
  switch (priority.toUpperCase()) {
    case 'LOW':
      return 'Rendah';
    case 'HIGH':
      return 'Tinggi';
    case 'URGENT':
      return 'Mendesak';
    default:
      return 'Normal';
  }
}

Color notificationPriorityColor(String priority) {
  switch (priority.toUpperCase()) {
    case 'LOW':
      return AppColors.grey500;
    case 'HIGH':
      return AppColors.warning;
    case 'URGENT':
      return AppColors.error;
    default:
      return AppColors.info;
  }
}

bool notificationIsDisputeRelated(NotificationEntity notification) {
  final type = notification.type.toUpperCase();
  if (type == 'DISPUTE' || type == 'ORDER_DISPUTE') return true;
  if (type != 'ORDER_STATUS' && type != 'ORDER') return false;
  return notificationIsDisputeRelatedFromText(
    notification.title,
    notification.body,
  );
}

bool notificationIsDisputeRelatedFromText(String title, String body) {
  final haystack = '$title $body'.toLowerCase();
  return haystack.contains('sengketa') ||
      haystack.contains('dispute') ||
      haystack.contains('komplain');
}

NotificationAction? notificationAction(NotificationEntity notification) {
  final type = notification.type.toUpperCase();
  final refId = notification.refId;

  if (refId != null && refId.isNotEmpty) {
    if (notificationIsDisputeRelated(notification)) {
      return NotificationAction(label: 'Lihat Sengketa', route: '/order/$refId');
    }

    switch (type) {
      case 'ORDER':
      case 'ORDER_STATUS':
        return NotificationAction(label: 'Lihat Pesanan', route: '/order/$refId');
      case 'DISPUTE':
      case 'ORDER_DISPUTE':
        return NotificationAction(label: 'Lihat Sengketa', route: '/order/$refId');
      case 'NEGOTIATION':
        return NotificationAction(label: 'Buka Negosiasi', route: '/negotiation/$refId');
      case 'FORUM':
        return NotificationAction(label: 'Lihat Forum', route: '/forum-detail/$refId');
      case 'MARKET':
      case 'MARKET_INSIGHT':
        return NotificationAction(label: 'Lihat Insight', route: '/market-detail/$refId');
    }
  }

  switch (type) {
    case 'WALLET':
    case 'PAYMENT':
    case 'PAYMENT_RECEIVED':
      return const NotificationAction(label: 'Buka Dompet', route: '/wallet');
    case 'IOT_ALERT':
      return const NotificationAction(label: 'Dashboard IoT', route: '/iot-dashboard');
    case 'SYSTEM_ANNOUNCEMENT':
      return const NotificationAction(label: 'Pusat Bantuan', route: '/help-center');
    default:
      return null;
  }
}
