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
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('mydata/');
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
    // VideoPlayerController를 초기화하고 영상을 플레이
    _controller = VideoPlayerController.network(
      mydata['video_Url'],
    );

    // VideoPlayerController의 초기화 완료 여부 확인
    Future<void> initializeVideoPlayerFuture = _controller.initialize();

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      color: Colors.amberAccent,
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
          // 영상 로딩이 성공한 경우에만 비디오 플레이어 위젯 추가
          FutureBuilder(
            future: initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: 4 / 3,
                  child: VideoPlayer(_controller),
                );
              } else {
                // 영상 로딩 중이거나 로딩에 실패한 경우 에러 메시지 표시
                return Text(
                  '영상을 불러오는 중 또는 에러가 발생했습니다.',
                  style: TextStyle(fontSize: 16),
                );
              }
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            mydata['video_runtime'],
            style: TextStyle(fontSize: 16),
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
        title: Text("홈"),
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
