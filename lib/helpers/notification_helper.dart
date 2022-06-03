// ignore_for_file: prefer_const_constructors

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart';

class NotificationHelper extends GetxController {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('logo');
    var initSetttings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initSetttings, onSelectNotification: onSelectNotification);
  }

  void onSelectNotification(String? payload) {
    print(payload);
  }

  AndroidNotificationDetails androidDetail = AndroidNotificationDetails(
    'ventesid',
    'venteschannel',
    channelDescription: 'channel for ventes notification',
    importance: Importance.max,
  );

  showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    var platform = NotificationDetails(android: androidDetail);
    await flutterLocalNotificationsPlugin.show(id, title, body, platform, payload: payload);
  }

  Future<void> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    DateTime? scheduledDate,
    String? timeZone,
  }) async {
    timeZone ??= await FlutterNativeTimezone.getLocalTimezone();
    scheduledDate ??= DateTime.now();

    var platform = NotificationDetails(android: androidDetail);
    TZDateTime datetime = TZDateTime.from(scheduledDate, getLocation(timeZone));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      datetime,
      platform,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: payload,
    );
  }
}
