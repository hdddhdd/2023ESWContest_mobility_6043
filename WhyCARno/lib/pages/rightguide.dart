import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whycarno/model/Whycarno.dart';
import 'package:whycarno/pages/rightguide.dart';
import 'package:whycarno/service/databaseSvc.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Rightguide extends StatefulWidget {
  const Rightguide({Key? key}) : super(key: key);

  @override
  State<Rightguide> createState() => _FetchDataState();
}

class _FetchDataState extends State<Rightguide> {


  void initState() {
    super.initState();
    testDB();
  }

  void testDB() {
    DatabaseSvc().writeDB();
  }


  @override
  void dispose() {
    // 페이지가 dispose될 때 VideoPlayerController를 해제
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "올바른 우회전 가이드",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로 가기 버튼 아이콘
          onPressed: () {
            Navigator.of(context).pop(); // 현재 페이지에서 뒤로 가기
          },
          color: Colors.black, // 아이콘 색상 설정
        ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("올바른 우회전 방법 페이지",)
              ],
            ),
          ),
        ));
  }
}
