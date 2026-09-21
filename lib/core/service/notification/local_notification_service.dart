import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Manages local notifications and handles notification display and routing.
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

  /// Initializes local notification plugin and configures
  /// platform-specific settings.
  static Future<void> initLocalNotification() async {
    await _requestNotificationPermission();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {},
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _localNotificationPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  /// Requests permission to receive notification alerts, badges, and sounds.
  static Future<void> _requestNotificationPermission() async {
    await messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  /// Displays a Firebase push message as a local notification.
  static Future<void> show(RemoteMessage message) async {
    final titleText =
        message.notification?.title ?? message.data['title']?.toString() ?? '';

    final bodyText =
        message.notification?.body ??
        message.data['description']?.toString() ??
        message.data['body']?.toString() ??
        '';

    final notificationId = (message.messageId?.hashCode ?? 0) & 0x7FFFFFFF;

    final bigTextStyleInfo = BigTextStyleInformation(
      bodyText,
      contentTitle: titleText,
      htmlFormatBigText: true,
      htmlFormatContentTitle: true,
    );

    final androidDetails = AndroidNotificationDetails(
      _androidChannel.id,
      _androidChannel.name,
      channelDescription: _androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      styleInformation: bigTextStyleInfo,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _localNotificationPlugin.show(
        id: notificationId,
        title: titleText,
        body: bodyText,
        notificationDetails: notificationDetails,
      );
    } catch (e) {
      debugPrint('Local notification error: $e');
    }
  }
}
