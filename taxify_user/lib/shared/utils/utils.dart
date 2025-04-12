import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

ColorScheme getColorSchema(BuildContext context) {
  return Theme.of(context).colorScheme;
}

bool checkLightMode(BuildContext context) {
  return getColorSchema(context).brightness == Brightness.light;
}

TextTheme getTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

Future<bool> grantPermission(Permission permission) async {
  if (await permission.isGranted ||
      await permission.isLimited ||
      await permission.isProvisional) {
    return true;
  }

  PermissionStatus permissionStatus = await permission.request();

  if (permissionStatus.isGranted ||
      permissionStatus.isLimited ||
      permissionStatus.isProvisional) {
    return true;
  }

  return false;
}

Future<void> requestNotificationPermission() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  await FirebaseMessaging.instance.requestPermission(provisional: true);
}

Future<void> sendNotification({
  required String title,
  required String body,
  String? androidChannelId,
  Map<String, dynamic>? data,
  String? redirectUrl,
}) async {
  final AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        androidChannelId ?? "default-channel-id",
        androidChannelId ?? "default-channel-id",
      );

  final DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails();

  final NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );

  FlutterLocalNotificationsPlugin().show(
    0,
    title,
    body,
    notificationDetails,
    payload: jsonEncode({
      ...(data ?? {}),
      "redirect_url": redirectUrl ?? data?["redirect_url"],
    }),
  );
}
