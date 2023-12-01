import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whycarno/model/Whycarno.dart';
import 'package:whycarno/pages/rightguide.dart';
import 'package:whycarno/service/databaseSvc.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late VideoPlayerController _controller;
  int notificationCount = 0; // 알림 카운트 변수
 int numberOfFiles = 0;
  List<String> videoUrls = [];

  List<String> videoUploadTimes = [];
  List<String> videoDurations = [];


  List<VideoPlayerController> controllers = [];
  int previousNumberOfFiles = 0;

   Future<void> loadVideoUrls() async {
    // Firebase Storage에서 파일 목록을 가져오는 코드
    final storage = FirebaseStorage.instance;
    final listResult = await storage.ref().listAll();

    // 가져온 파일 목록 중에서 동영상 파일만 선택하여 URL 및 업로드 시간을 저장
    for (final item in listResult.items) {
      if (item.name.endsWith('.mov') || item.name.endsWith('.')) {
        final downloadUrl = await item.getDownloadURL();
        final creationTime = await getUploadTime(item.name);

        videoUrls.add(downloadUrl);
        var controller;
        controller = VideoPlayerController.network(downloadUrl)
          ..initialize().then((_) {
            setState(() {
              // 영상 초기화가 완료된 후에 영상 길이를 가져옴
              final videoDuration = controller.value.duration;
              final formattedDuration =
                  Duration(seconds: videoDuration.inSeconds);

              // 영상 길이를 리스트에 추가
              videoDurations.add(formattedDuration.toString());

              // 개수 가져오기
              numberOfFiles = listResult.items.length;
            });
          });
        controllers.add(controller);

        // 영상 아래에 업로드 시간을 추가
        final formattedTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(creationTime);
        videoUploadTimes.add(formattedTime);
      }
    }
  }

  Future<DateTime> getUploadTime(String storagePath) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child(storagePath);

    try {
      final FullMetadata metadata = await storageRef.getMetadata();
      final DateTime creationTime = metadata.timeCreated!;
      return creationTime;
    } catch (e) {
      print('파일 메타데이터를 가져오는데 실패했습니다: $e');
      return DateTime.now(); // 오류 발생 시 현재 시간을 반환하거나 다른 기본값을 사용할 수 있습니다.
    }
  }



  void showNotification(String? title, String? body) {
    // 예: Flutter의 SnackBar 또는 다른 알림 UI를 사용하여 알림을 표시합니다.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(body ?? "없다없어!"),
      ),
    );

    // 알림 횟수 증가
    setState(() {
      notificationCount++;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'YOUR_VIDEO_URL_HERE'); // Replace with your video URL
    _controller.initialize().then((_) {
      setState(() {});
    });
    super.initState();

    // Firebase Cloud Messaging에서 알림을 받는 리스너를 설정합니다.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // 알림을 화면에 표시하고 알림 횟수를 증가시킵니다.
      showNotification(message.notification!.title, message.notification!.body);
    });

    // loadVideoUrls 함수를 initState에서 호출
    loadVideoUrls();
    previousNumberOfFiles = numberOfFiles;
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  var now = DateTime.now();

  // Placeholder data for date, time, location, and weather
  late double latitude2 = 0.0;
  late double longitude2 = 0.0;

  Future<void> getMyCurrentLocation() async {
    // 위치권한을 가지고 있는지 확인
    var status_position = await Permission.location.status;
  }

  @override
  Widget build(BuildContext context) {
    if (numberOfFiles > previousNumberOfFiles) {
      // "데이터 추가!" 메시지를 화면에 출력
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '충돌이 감지되었습니다.',
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      });

      // previousNumberOfFiles 업데이트
      previousNumberOfFiles = numberOfFiles;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "whyCARno",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
              //   return Text(
              //     '${DateFormat('h:mm:s a').format(DateTime.now())}',
              //     style: TextStyle(fontSize: 30),
              //   );
              // }),
              Image.asset(
                'assets/images/carsample.png',
                width: 700,
                height: 300,
                // fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  // Handle the second button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Rightguide(),
                    ),
                  );
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(350, 70)), // Set the desired size
                  padding: MaterialStateProperty.all(
                      EdgeInsets.all(10)), // Set padding
                ),
                child: const Text(
                  "올바른 우회전 방법 알아보기",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(1, 45, 107, 1)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
