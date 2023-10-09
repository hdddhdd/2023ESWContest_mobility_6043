import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  int notificationCount = 0; // 알림 카운트 변수
  int numberOfFiles = 0;
  List<String> videoUrls = [];

  List<String> videoUploadTimes = [];
  List<String> videoDurations = [];

  late VideoPlayerController _controller;

  List<VideoPlayerController> controllers = [];
  int previousNumberOfFiles = 0;

  Future<void> loadVideoUrls() async {
    // Firebase Storage에서 파일 목록을 가져오는 코드
    final storage = FirebaseStorage.instance;
    final listResult = await storage.ref().listAll();

    // 가져온 파일 목록 중에서 동영상 파일만 선택하여 URL 및 업로드 시간을 저장
    for (final item in listResult.items) {
      if (item.name.endsWith('.mp4') || item.name.endsWith('.')) {
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

  // 알림을 표시하고 알림 횟수를 증가시키는 메서드
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
  Widget build(BuildContext context) {
    // numberOfFiles가 이전보다 1 더 크면 "데이터 추가!" 메시지를 출력
    if (numberOfFiles > previousNumberOfFiles) {
      // "데이터 추가!" 메시지를 화면에 출력
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("충돌이 감지되었습니다."),
          ),
        );
      });

      // previousNumberOfFiles 업데이트
      previousNumberOfFiles = numberOfFiles;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("알림", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 20,),
            Text(
              '⚠︎ 최근 $numberOfFiles건의 충돌이 감지되었습니다.', // 파일 개수 표시
              style: const TextStyle(fontSize: 18),
            ),
            // 텍스트 리스트를 추가합니다.
            Expanded(
              child: ListView.builder(
                itemCount: videoUploadTimes.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                   
                    title: Text('${videoUploadTimes[index]}',style: TextStyle(color: Color.fromRGBO(1, 45, 107, 1)),),
                    subtitle: Text('충돌이 감지되었습니다.', ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
