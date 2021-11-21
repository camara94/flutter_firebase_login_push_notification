import 'package:firebase_login_push_notification/services/AuthService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'screens/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
//my custom notification
import 'package:firebase_login_push_notification/push_notification/custom_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Notification
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flNotPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      .createNotificationChannel(chanel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthService>.value(value: AuthService())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;

      if (notification != null && android != null) {
        flNotPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(chanel.id, chanel.name,
                    channelDescription: chanel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: '@mipmap/ic_laucher')));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;

      if (notification != null && android != null) {
        showAboutDialog(
            context: context,
            applicationName: notification.title,
            applicationIcon: Icon(Icons.notification_add),
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(notification.body)],
                ),
              )
            ]);
      }
    });
  }

  void showNotification() {
    setState(() {
      _counter++;
    });

    flNotPlugin.show(
        0,
        'Teste de $_counter',
        'Comment allez-vous ?',
        NotificationDetails(
            android: AndroidNotificationDetails(chanel.id, chanel.name,
                channelDescription: chanel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Login(),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        tooltip: 'Incrémenter',
        child: Icon(Icons.add),
      ),
    );
  }
}
