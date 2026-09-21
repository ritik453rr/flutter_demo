import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../../../firebase_options.dart';
import 'local_notification_service.dart';

/// Manages Firebase Cloud Messaging and local notification handling throughout the application.
class NotificationService {
  static String? fcmToken;

  /// Initializes notification services, permissions, message handlers, and the FCM token.
  static Future<void> init() async {
    await LocalNotificationService.initLocalNotification();
    await _initHandlers();
    await getFcmToken();
  }

  /// Configures Firebase Messaging listeners for background, foreground, and notification tap events.
  static Future<void> _initHandlers() async {
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onTapMessage);
    final initialMessage = await LocalNotificationService.messaging
        .getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage.data);
    }
  }

  /// Displays a local notification when an FCM message is received while the app is in the foreground.
  static void _onForegroundMessage(RemoteMessage message) {
    if (message.data.isEmpty && message.notification == null) return;
    LocalNotificationService.show(message);
  }

  /// Handles notification taps when the user opens an FCM notification from the background.
  static void _onTapMessage(RemoteMessage message) {
    _handleNavigation(message.data);
  }

  /// Parses notification data and redirects the user to the appropriate screen.
  static void _handleNavigation(Map<String, dynamic> data) {}

  /// Gets the FCM token after the APNs token is available on iOS.
  static Future<void> getFcmToken() async {
    try {
      fcmToken = await LocalNotificationService.messaging.getToken();
      debugPrint("fcm: $fcmToken");
    } catch (e) {
      log("Error getting FCM token: $e");
    }
  }
}

/// Handles Firebase background messages when the app is in the background or terminated.
@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("Background message: ${message.data}");
}
