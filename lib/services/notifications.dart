import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  // ignore: unused_field
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  //initilize
  Future initilize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  }
}