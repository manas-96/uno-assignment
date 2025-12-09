import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uno_assignment/models/location_data.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final androidPlugin =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }



  Future<void> showNotification(
      LocationData locationData, String title) async {
    try{
      const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'location_tracking',
        'Location Tracking',
        channelDescription: 'Channel for location tracking notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        'Lat: ${locationData.latitude}, '
            'Lng: ${locationData.longitude}\n'
            'Address: ${locationData.address}',
        notificationDetails,
      );
    }catch(e){
      print(e.toString());
    }
  }
}
