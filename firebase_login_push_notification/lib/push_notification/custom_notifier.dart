import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel chanel = AndroidNotificationChannel(
    'hih_importance_chanel', //id
    'High Importance Notifications', //titre
    description: 'This chanel is used for importance notification',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flNotPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("A background message just showed up : ${message.messageId}");
}
