import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whycarno/model/Whycarno.dart';
import 'package:whycarno/service/databaseSvc.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _FetchDataState();
}

class _FetchDataState extends State<Home> {
  Query dbref = FirebaseDatabase.instance.ref().child('mydata/2023-10-02/');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('mydata/');
  List<Whycarno> medium = [];

  // VideoPlayerController 변수 추가
  late VideoPlayerController _controller;

  void initState() {
    super.initState();
    testDB();
  }

  void testDB() {
    DatabaseSvc().writeDB();
  }

  Widget listItem({required Map mydata}) {
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    );

    // VideoPlayerController의 초기화 완료 여부 확인
    Future<void> initializeVideoPlayerFuture = _controller.initialize();

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mydata['longitude'],
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            mydata['latitude'],
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          FutureBuilder(
            future: _controller.initialize(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return const Text(
                  '영상을 불러오는 중 또는 에러가 발생했습니다.',
                  style: TextStyle(fontSize: 16),
                );
              }
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {
                  if (!_controller.value.isPlaying) {
                    _controller.play();
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.pause),
                onPressed: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 페이지가 dispose될 때 VideoPlayerController를 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "홈",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: dbref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map mydata = snapshot.value as Map;
            mydata['key'] = snapshot.key;

            return listItem(mydata: mydata);
          },
        ),
      ),
    );
  }
}
