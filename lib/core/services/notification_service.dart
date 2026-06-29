import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_bisa/core/constants/app_colors.dart';
import 'package:mobile_bisa/core/navigation/notification_navigation.dart';

class NotificationService {
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // default icon
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: tr('notifications.android_channel_name'),
          channelDescription: tr('notifications.android_channel_desc'),
          defaultColor: AppColors.primary,
          ledColor: AppColors.white,
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
      NotificationNavigation.handle(message.data);
    });

    await _handleColdStartNotification();
  }

  static Future<void> _handleColdStartNotification() async {
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationNavigation.handle(initial.data);
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
        title: message.notification?.title ?? tr('notifications.default_title'),
        body: message.notification?.body ?? '',
        payload: Map<String, String>.from(message.data.map((key, value) => MapEntry(key, value.toString()))),
      ),
    );
  }

  static void _handleNotificationClick(Map<String, dynamic> data) {
    NotificationNavigation.handle(data);
  }

  static Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
}
