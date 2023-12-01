import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:whycarno/pages/records_list.dart';
import 'package:whycarno/pages/rightguide.dart';
import 'package:whycarno/service/databaseSvc.dart';
import 'bottom_nav.dart';
import 'pages/home.dart';
import 'pages/records.dart';
import 'pages/notifications.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // FirebaseOptions 설정이 들어 있는 파일

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("백그라운드 메세지 처리.. ${message.notification!.body!}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // name: 'whycarno',
    // options: DefaultFirebaseOptions.currentPlatform, // FirebaseOptions 설정을 가져옴
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Whycarno App",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
        );
        setState(() {
          String messageString = message.notification!.body!;
          print("Foreground 메세지 수신: $messageString");
        });
      }
    });
  }

  int _currentIndex = 0; // 기본 화면을 선택하세요.

  final List<Widget> _pages = [
    Home(),
    // Records(),
    RecordlistPage(),
    Notifications(),
    Rightguide(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // App Bar를 제거합니다.
      body: _pages[_currentIndex],
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
