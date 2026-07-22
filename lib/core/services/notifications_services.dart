import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';
import '../../presentation/screens/user_interface/notification/notification_screen.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings = InitializationSettings(
      android: android,
    );

    await _local.initialize(
      settings: settings,

      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);

          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => NotificationScreen(data: data)),
          );
        }
      },
    );

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });

    /// app terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNavigation(message.data);
      }
    });

    /// background state
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleNavigation(message.data);
    });
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    // background me bhi handle ho sakta hai
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    final data = message.data;

    BigTextStyleInformation bigText = BigTextStyleInformation(
      "Driver: ${data['driver']}\nOrder: ${data['order']}",
      contentTitle: message.notification?.title ?? "Order Update",
      summaryText: message.notification?.body ?? "Order Update",
    );

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "order_channel",
      "Order Updates",
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigText,
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);

    await _local.show(
      id: 0,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: details,
      payload: jsonEncode(data),
    );
  }

  static void _handleNavigation(Map<String, dynamic> data) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => NotificationScreen(data: data)),
    );
  }

  static Future<String?> getToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission();

      final token = await FirebaseMessaging.instance.getToken();

      print("FCM Token = $token");

      return token;
    } catch (e) {
      print("FCM Error = $e");
      return null;
    }
  }

  /*static Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("Token: $token");
    return token;
  }*/
}
