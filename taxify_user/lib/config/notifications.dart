import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/cubits/app_cubit.dart';
import 'package:taxify_user/shared/navigation/navigation_router.dart';
import 'package:taxify_user/shared/storage/storage.dart';
import 'package:taxify_user/shared/utils/utils.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  final AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("@mipmap/launcher_icon");
  final DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: darwinInitializationSettings,
  );

  await _flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      if (details.payload != null) {
        final String? redirectUrl =
            jsonDecode(details.payload!)["redirect_url"];

        if (redirectUrl != null) {
          GoRouter.of(
            navigatorKey.currentContext!,
          ).pushNamed(redirectUrl, extra: {"notification_data": details.data});
        }
      }
    },
  );
  await _initAndroidNotificationChannels();
}

Future<void> _initAndroidNotificationChannels() async {
  final androidPlatform =
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
  final AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
        "default-channel-id",
        "default-channel-id",
        importance: Importance.max,
      );

  final AndroidNotificationChannel fcmNotificationChannel =
      AndroidNotificationChannel(
        "fcm-channel-id",
        "fcm-channel-id",
        importance: Importance.max,
      );

  await androidPlatform?.createNotificationChannel(androidNotificationChannel);
  await androidPlatform?.createNotificationChannel(fcmNotificationChannel);
}

Future<void> initPushNotifications() async {
  FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
    final accessToken = await AppStorage.getString(
      key: AppStorageConstants.accessToken,
    );

    if (accessToken != null) {
      await getIt.get<AppCubit>().saveDeviceToken(token);
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
    final androidChannelId =
        remoteMessage.notification?.android?.channelId ?? "fcm-channel-id";

    final redirectUrl = remoteMessage.data["redirect_url"];

    await sendNotification(
      title: remoteMessage.notification?.title as String,
      body: remoteMessage.notification?.body as String,
      redirectUrl: redirectUrl,
      androidChannelId: androidChannelId,
      data: remoteMessage.data,
    );
  });
}
