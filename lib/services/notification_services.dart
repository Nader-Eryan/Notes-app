// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:todo/ui/pages/notification_screen.dart'; 

// class NotifyHelper {
//   initializeNotification()
//   {
//     tz.initializeTimeZones();
//     //tz.setLocalLocation(tz.getLocation(timeZoneName));
//   }
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
//     FlutterLocalNotificationsPlugin();
// // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
// final AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings('appicon');

// final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsDarwin,
//     macOS: initializationSettingsDarwin,
//     linux: initializationSettingsLinux);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

// void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//     await Get.to(NotificationScreen(payload: payload!));
// }

// const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//         'repeating channel id', 'repeating channel name',
//         channelDescription: 'repeating description');
// const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
// await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
//     'repeating body', RepeatInterval.everyMinute, notificationDetails,
//     androidAllowWhileIdle: true);

// void onDidReceiveLocalNotification(
//     int id, String title, String body, String payload) async {
//   // display a dialog with the notification details, tap ok to go to another page
//   Get.dialog(Text(body));
// }
// }