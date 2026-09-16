import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/app_colors.dart';

// Must be a top-level function — Firebase runs it in a separate isolate.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  // Nothing to do here: FCM shows the notification automatically when the
  // app is in background/terminated and the payload has a "notification" block.
}

const _channelId = 'white_lable_default';
const _channelName = 'white_lable';
const _channelDesc = 'white_lable notifications';
const _androidNotificationIcon = 'ic_stat_notification';

class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    final res =await FirebaseMessaging.instance.getToken();
    print('FCM token: $res');
    await _requestPermissions();
    await _initPlugin();
    await _createAndroidChannel();
    _listenForeground();
  }

  static Future<void> _requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> _initPlugin() async {
    const androidSettings =
        AndroidInitializationSettings(_androidNotificationIcon);

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
  }

  static Future<void> _createAndroidChannel() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
    );
    await androidPlugin?.createNotificationChannel(channel);
  }

  // Foreground messages aren't shown by the OS automatically on Android, so
  // we display them ourselves. iOS handles it natively via
  // setForegroundNotificationPresentationOptions above.
  static void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isIOS) return;

      final notification = message.notification;
      if (notification == null) return;

      _plugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            icon: _androidNotificationIcon,
            color: AppColors.primaryColor.light,
          ),
        ),
      );
    });
  }
}
