import 'package:easy_localization/easy_localization.dart';
import '../../../../core/i18n/notification_heuristics.dart';
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
    case 'PARTNERSHIP':
      return LucideIcons.handshake;
    case 'BOOKING':
      return LucideIcons.calendarClock;
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
    case 'PARTNERSHIP':
      return AppColors.success;
    case 'BOOKING':
      return AppColors.warning;
    default:
      return AppColors.grey500;
  }
}

String notificationTypeLabel(String type) {
  switch (type.toUpperCase()) {
    case 'ORDER':
    case 'ORDER_STATUS':
      return 'notifications.type_order'.tr();
    case 'DISPUTE':
    case 'ORDER_DISPUTE':
      return 'notifications.type_dispute'.tr();
    case 'NEGOTIATION':
      return 'notifications.type_negotiation'.tr();
    case 'FORUM':
      return 'notifications.type_forum'.tr();
    case 'WALLET':
      return 'notifications.type_wallet'.tr();
    case 'PAYMENT':
    case 'PAYMENT_RECEIVED':
      return 'notifications.type_payment'.tr();
    case 'IOT_ALERT':
      return 'notifications.type_iot_alert'.tr();
    case 'SYSTEM_ANNOUNCEMENT':
      return 'notifications.type_announcement'.tr();
    case 'MARKET':
    case 'MARKET_INSIGHT':
      return 'notifications.type_market'.tr();
    case 'PARTNERSHIP':
      return 'partnership.menu_title'.tr();
    case 'BOOKING':
      return 'booking.menu_title'.tr();
    default:
      return 'notifications.type_general'.tr();
  }
}

String notificationPriorityLabel(String priority) {
  switch (priority.toUpperCase()) {
    case 'LOW':
      return 'notifications.priority_low'.tr();
    case 'HIGH':
      return 'notifications.priority_high'.tr();
    case 'URGENT':
      return 'notifications.priority_urgent'.tr();
    default:
      return 'notifications.priority_normal'.tr();
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

bool notificationIsDisputeRelatedFromText(String title, String body) =>
    NotificationHeuristics.isDisputeRelated(title, body);

NotificationAction? notificationAction(NotificationEntity notification) {
  final type = notification.type.toUpperCase();
  final refId = notification.refId;

  if (refId != null && refId.isNotEmpty) {
    if (notificationIsDisputeRelated(notification)) {
      return NotificationAction(
        label: 'notifications.action_view_dispute'.tr(),
        route: '/order/$refId',
      );
    }

    switch (type) {
      case 'ORDER':
      case 'ORDER_STATUS':
        if (_needsPaymentAction(notification.title, notification.body)) {
          return NotificationAction(
            label: 'notifications.action_pay_now'.tr(),
            route: '/order/$refId?autoPay=1',
          );
        }
        return NotificationAction(
          label: 'notifications.action_view_order'.tr(),
          route: '/order/$refId',
        );
      case 'DISPUTE':
      case 'ORDER_DISPUTE':
        return NotificationAction(
          label: 'notifications.action_view_dispute'.tr(),
          route: '/order/$refId',
        );
      case 'NEGOTIATION':
        return NotificationAction(
          label: 'notifications.action_open_negotiation'.tr(),
          route: '/negotiation/$refId',
        );
      case 'FORUM':
        return NotificationAction(
          label: 'notifications.action_view_forum'.tr(),
          route: '/forum-detail/$refId',
        );
      case 'MARKET':
      case 'MARKET_INSIGHT':
        return NotificationAction(
          label: 'notifications.action_view_insight'.tr(),
          route: '/market-detail/$refId',
        );
      case 'PARTNERSHIP':
        return NotificationAction(
          label: 'partnership.view_existing'.tr(),
          route: '/partnerships/$refId',
        );
      case 'BOOKING':
        return NotificationAction(
          label: 'booking.view_detail'.tr(),
          route: '/bookings/$refId',
        );
    }
  }

  switch (type) {
    case 'WALLET':
    case 'PAYMENT':
    case 'PAYMENT_RECEIVED':
      if (refId != null && refId.isNotEmpty) {
        return NotificationAction(
          label: 'notifications.action_view_order'.tr(),
          route: '/order/$refId',
        );
      }
      return NotificationAction(
        label: 'notifications.action_open_wallet'.tr(),
        route: '/wallet',
      );
    case 'IOT_ALERT':
      return NotificationAction(
        label: 'notifications.action_iot_dashboard'.tr(),
        route: '/iot-dashboard',
      );
    case 'SYSTEM_ANNOUNCEMENT':
      return NotificationAction(
        label: 'notifications.action_help_center'.tr(),
        route: '/help-center',
      );
    default:
      return null;
  }
}

bool _needsPaymentAction(String title, String body) =>
    NotificationHeuristics.needsPaymentAction('', title, body);
