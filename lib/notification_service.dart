// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationApi {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   static Future _notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'channel id',
//         'channel name',
//         importance: Importance.max,
//       ),
//     );
//   }

//   static Future showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async =>
//       _notifications.show(
//         id,
//         title,
//         body,
//         await _notificationDetails(),
//         payload: payload,
//       );

//   static void showScheduledNotification({
//     int id = 1,
//     String? title,
//     String? body,
//     String? payload,
//     required DateTime scheduledDate,
//   }) async =>
//       _notifications.zonedSchedule(
//           id, title, body, tz.TZDateTime.from(scheduledDate, tz.local), await _notificationDetails(),
//           uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
// }
