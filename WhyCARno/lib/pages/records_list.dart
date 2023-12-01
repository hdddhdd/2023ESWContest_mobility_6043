import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:whycarno/pages/record_play.dart';

// import 'records_page.dart'; // 두 번째 페이지를 import

class RecordlistPage extends StatefulWidget {
  @override
  State<RecordlistPage> createState() => _RecordlistPageState();
}

class _RecordlistPageState extends State<RecordlistPage> {
  List<String> videoUrls = [];
  List<VideoPlayerController> controllers = [];
  List<String> videoUploadTimes = [];
  List<String> videoDurations = [];
  int numberOfFiles = 0;
  void initState() {
    super.initState();
    loadVideoUrls();
  }

  Future<void> loadVideoUrls() async {
    final storage = FirebaseStorage.instance;
    final listResult = await storage.ref().listAll();

    for (final item in listResult.items) {
      if (item.name.endsWith('.mp4') ||
          item.name.endsWith('.mov') ||
          item.name.endsWith('.')) {
        final downloadUrl = await item.getDownloadURL();
        final creationTime = await getUploadTime(item.name);

        videoUrls.add(downloadUrl);

        var controller;
        controller = VideoPlayerController.network(downloadUrl)
          ..initialize().then((_) {
            setState(() {
              final videoDuration = controller.value.duration;
              final formattedDuration =
                  Duration(seconds: videoDuration.inSeconds);
              videoDurations.add(formattedDuration.toString());
              numberOfFiles = listResult.items.length;
            });
          });
        controllers.add(controller);

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
      return DateTime.now();
    }
  }

  void togglePlayPause(int index) {
    if (controllers[index].value.isPlaying) {
      controllers[index].pause();
    } else {
      controllers[index].play();
    }
    setState(() {});
  }

  final yourScroller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "녹화 영상 목록",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(30),
            height: 200,
            child: ListView.builder(
              controller: yourScroller,
              itemCount: videoDurations.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${videoUploadTimes[index][0]}${videoUploadTimes[index][1]}${videoUploadTimes[index][2]}${videoUploadTimes[index][3]}년 ${videoUploadTimes[index][5]}${videoUploadTimes[index][6]}월 ${videoUploadTimes[index][8]}${videoUploadTimes[index][9]}일 ${videoUploadTimes[index][11]}${videoUploadTimes[index][12]}시 ${videoUploadTimes[index][14]}${videoUploadTimes[index][15]}분 ${videoUploadTimes[index][17]}${videoUploadTimes[index][18]}초',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
    // 버튼이 눌렸을 때 수행할 동작 추가
    // 여기에 해당 영상을 재생하는 코드 추가

    // 예시: 레코드 재생 페이지로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordPlayPage(videoUrl: videoUrls[index]),
      ),
    );
  },
                            icon: Icon(Icons.play_arrow, color: Colors.white),
                            label: const Text('재생',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.transparent, backgroundColor: Color.fromRGBO(9, 54, 110, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.grey),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
