import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  int notificationCount = 0; // 알림 카운트 변수

  // 알림을 표시하는 메서드
  void showNotification(String? title, String? body) {
    // 예: Flutter의 SnackBar 또는 다른 알림 UI를 사용하여 알림을 표시합니다.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(body ?? "없다없어!"),
      ),
    );
    // 알림이 표시될 때마다 카운트 증가
    setState(() {
      notificationCount++;
    });
  }

  @override
  void initState() {
    super.initState();

    // Firebase Cloud Messaging에서 알림을 받는 리스너를 설정합니다.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // 알림을 화면에 표시하는 등의 작업을 수행합니다.
      showNotification(
          message.notification!.title, message.notification!.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("알림", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("알림 페이지"),
            Text("알림 횟수: $notificationCount"), // 알림 카운트를 표시
          ],
        ),
      ),
    );
  }
}
