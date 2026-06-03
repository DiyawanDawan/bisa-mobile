import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/utils/router.dart';
import 'package:mobile_bisa/features/notifications/presentation/utils/notification_ui_utils.dart';

class NotificationService {
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // default icon
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Notifikasi Utama',
          channelDescription: 'Channel notifikasi untuk pesanan dan pesan',
          defaultColor: AppColors.primary,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );

    // Request permissions
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Handle listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // Handle interaction when app is opened from notification (background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data);
    });
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {}

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {}

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    _handleNotificationClick(receivedAction.payload ?? {});
  }

  static void _showLocalNotification(RemoteMessage message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'basic_channel',
        title: message.notification?.title ?? 'Notifikasi Baru',
        body: message.notification?.body ?? '',
        payload: Map<String, String>.from(message.data.map((key, value) => MapEntry(key, value.toString()))),
      ),
    );
  }

  static void _handleNotificationClick(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    final refId = data['refId']?.toString() ?? data['id']?.toString();
    final title = data['title']?.toString() ?? '';
    final body = data['body']?.toString() ?? '';

    final isDispute = type == 'DISPUTE' ||
        type == 'ORDER_DISPUTE' ||
        ((type == 'ORDER' || type == 'ORDER_STATUS') &&
            notificationIsDisputeRelatedFromText(title, body));

    // Sengketa & pesanan: langsung ke detail order (bukan halaman notifikasi).
    if (isDispute && refId != null && refId.isNotEmpty) {
      goRouter.push('/order/$refId');
      return;
    }
    if ((type == 'ORDER' || type == 'ORDER_STATUS') &&
        refId != null &&
        refId.isNotEmpty) {
      goRouter.push('/order/$refId');
      return;
    }

    final notificationId = data['notificationId']?.toString();
    if (notificationId != null && notificationId.isNotEmpty) {
      goRouter.push('/notifications/$notificationId');
      return;
    }

    if (type == 'NEGOTIATION' && refId != null && refId.isNotEmpty) {
      goRouter.push('/negotiation/$refId');
    } else if (type == 'IOT_ALERT') {
      goRouter.push('/iot-dashboard');
    } else if (type == 'WALLET' || type == 'PAYMENT' || type == 'PAYMENT_RECEIVED') {
      goRouter.push('/wallet');
    } else if (type == 'MARKET' || type == 'MARKET_INSIGHT') {
      goRouter.push('/market-insight');
    }
  }

  static Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
