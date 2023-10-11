import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:whycarno/model/Whycarno.dart';
import 'package:intl/intl.dart'; // DateFormat을 임포트

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  //firebase 데이터 부분 코드 추가 1
  // Query dbref = FirebaseDatabase.instance.ref().child('mydata/2023-10-10/');
  // DatabaseReference reference =
  //     FirebaseDatabase.instance.ref().child('mydata/');
  List<Whycarno> medium = [];

  late VideoPlayerController _controller;
  int numberOfFiles = 0;

  final yourScroller = ScrollController();

  Widget listItem({required Map mydata}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mydata['date_time'],
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  List<String> videoUrls = [];
  List<VideoPlayerController> controllers = [];

  @override
  void initState() {
    super.initState();
    loadVideoUrls();
  }

  List<String> videoUploadTimes = [];
  List<String> videoDurations = [];
final downloadUrl = "";
  Future<void> loadVideoUrls() async {
    // Firebase Storage에서 파일 목록을 가져오는 코드
     final storage = FirebaseStorage.instance;

    final listResult = await storage.ref().listAll(); //여기서 모든걸 가져옴

    

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

              //개수 가져오기
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

  // 영상 재생/일시정지 토글 함수
  void togglePlayPause(int index) {
    if (controllers[index].value.isPlaying) {
      controllers[index].pause();
    } else {
      controllers[index].play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "녹화 영상",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          child: Scrollbar(
              thickness: 4.0,
              radius: Radius.circular(8.0),
              // controller: yourScroller,
              // isAlwaysShown:true,
              child: ListView.builder(
                itemCount: videoDurations.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      const SizedBox(height: 20), //
                      Text(
                        '${videoUploadTimes[index][0]}${videoUploadTimes[index][1]}${videoUploadTimes[index][2]}${videoUploadTimes[index][3]}년 ${videoUploadTimes[index][5]}${videoUploadTimes[index][6]}월 ${videoUploadTimes[index][8]}${videoUploadTimes[index][9]}일 ${videoUploadTimes[index][11]}${videoUploadTimes[index][12]}시 ${videoUploadTimes[index][14]}${videoUploadTimes[index][15]}분 ${videoUploadTimes[index][17]}${videoUploadTimes[index][18]}초',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 10), //
                      Container(
                        width: 352,
                        height: 198,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            VideoPlayer(controllers[index]),
                            IconButton(
                              icon: Icon(
                                controllers[index].value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 50,
                                color: Colors.white, // 버튼 아이콘 색상 설정
                              ),
                              onPressed: () {
                                togglePlayPause(index);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: 8), // Add some spacing between video and text

                      Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.fromLTRB(0, 5, 50, 0),
                        child: Text(
                          '${videoDurations[index][5]}${videoDurations[index][6]}초',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 20), // Ad
                
                    ],
                  );
                },
              )),
        ));
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
