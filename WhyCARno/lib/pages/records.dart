import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

class Records extends StatefulWidget {
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  List<String> videoUrls = [];
  List<VideoPlayerController> controllers = [];
  List<String> videoUploadTimes = [];
  List<String> videoDurations = [];
  int numberOfFiles = 0;

  final yourScroller = ScrollController();

  @override
  void initState() {
    super.initState();
    loadVideoUrls();
  }

  Future<void> loadVideoUrls() async {
    final storage = FirebaseStorage.instance;
    final listResult = await storage.ref().listAll();

    for (final item in listResult.items) {
      if (item.name.endsWith('.mp4') || item.name.endsWith('.mov') || item.name.endsWith('.')) {
        final downloadUrl = await item.getDownloadURL();
        final creationTime = await getUploadTime(item.name);

        videoUrls.add(downloadUrl);

        var controller;
        controller = VideoPlayerController.network(downloadUrl)
          ..initialize().then((_) {
            setState(() {
              final videoDuration = controller.value.duration;
              final formattedDuration = Duration(seconds: videoDuration.inSeconds);
              videoDurations.add(formattedDuration.toString());
              numberOfFiles = listResult.items.length;
            });
          });
        controllers.add(controller);

        final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(creationTime);
        videoUploadTimes.add(formattedTime);
      }
    }
  }

  Future<DateTime> getUploadTime(String storagePath) async {
    final Reference storageRef = FirebaseStorage.instance.ref().child(storagePath);

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
          controller: yourScroller,
          child: ListView.builder(
            controller: yourScroller,
            itemCount: videoDurations.length,
            itemBuilder: (context, index) {
              if (yourScroller.position.pixels - 100 <= index &&
                  index <= yourScroller.position.pixels + 100) {
                return Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      '${videoUploadTimes[index][0]}${videoUploadTimes[index][1]}${videoUploadTimes[index][2]}${videoUploadTimes[index][3]}년 ${videoUploadTimes[index][5]}${videoUploadTimes[index][6]}월 ${videoUploadTimes[index][8]}${videoUploadTimes[index][9]}일 ${videoUploadTimes[index][11]}${videoUploadTimes[index][12]}시 ${videoUploadTimes[index][14]}${videoUploadTimes[index][15]}분 ${videoUploadTimes[index][17]}${videoUploadTimes[index][18]}초',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 10),
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
                              color: Colors.white,
                            ),
                            onPressed: () {
                              togglePlayPause(index);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.fromLTRB(0, 5, 50, 0),
                      child: Text(
                        '${videoDurations[index][5]}${videoDurations[index][6]}초',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              } else {
                // Placeholder for non-visible items
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
