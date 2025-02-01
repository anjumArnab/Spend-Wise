import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  //initilize
  Future initilize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings
    );


  }
}