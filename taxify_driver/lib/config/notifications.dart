import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  final AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  final DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: darwinInitializationSettings,
  );

  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await _initAndroidNotificationChannels();
}

Future<void> _initAndroidNotificationChannels() async {
  final AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
        "test-channel-id",
        "Test Channel",
        importance: Importance.max,
      );

  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(androidNotificationChannel);
}
