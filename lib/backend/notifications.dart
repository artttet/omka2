import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:omka2/backend/shared_prefs.dart';
import 'package:omka2/values/prefs_keys.dart';

class Notifications {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static var prefs = SharedPrefs.getPrefs();
  static Time notificationTime = Time(
  prefs.getInt(PrefsKey.notificationHour),
    0,
    0
  ); 

  static Future onSelectNotification(String payload){
  print('Payload: $payload');
  }

  static notificationsInit(){
    SharedPrefs.getPrefs().setInt(PrefsKey.notificationHour, TimeOfDay.now().hour);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);
  }

  static showNotification() async{
    
    var time = new Time(18, 30, 0);
    var android = new AndroidNotificationDetails('Channel ID', 'Channel name', 'Channel Description');
    var ios = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    await flutterLocalNotificationsPlugin.showDailyAtTime(0, 'Омск Транспорт', notificationBodyData(), time, platform);
  }

  static String notificationBodyData(){
    
  }

}