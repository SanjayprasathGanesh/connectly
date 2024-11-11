import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// This class is used to handle the local push notifications
class NotificationService{
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('images/expense_manager_logo.png');

  void initialize() async{
    InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(int id, String title, String body) async{
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
        'channelId', 'channelName', importance: Importance.high, priority: Priority.max,
        playSound: true, enableLights: true, enableVibration: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails);
  }

  void scheduleNotificationWithTime(int id, String title, String body, int hr, int mins) async{
    tz.initializeTimeZones();
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'channelId', 'channelName', importance: Importance.high, priority: Priority.max,
      playSound: true, enableLights: true, enableVibration: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, title, body,
        tz.TZDateTime.now(tz.local).add(Duration(hours: hr, minutes: mins)),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  void cancelNotification(int id) async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}

// import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
// class NotificationService{
//   FlutterLocalNotificationsPlatform flutterLocalNotificationsPlatform = FlutterLocalNotificationsPlatform.instance;
//
//   void sendNotification(int id, String title, String body) async{
//     await flutterLocalNotificationsPlatform.show(id, title, body);
//   }
//
//   void scheduleNotification(int id, String title, String body, int hr, int mins) async{
//     await flutterLocalNotificationsPlatform.periodicallyShowWithDuration(
//         id, title, body,
//         Duration(hours: hr, minutes: mins),
//     );
//   }
//
//   void cancleNotification(int id) async{
//     await flutterLocalNotificationsPlatform.cancel(id);
//   }
// }