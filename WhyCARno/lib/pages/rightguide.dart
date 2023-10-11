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
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "올바른 우회전 가이드",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF001E5E),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Color(0xFF001E5E),
        child: Scrollbar( // Scrollbar 위젯을 사용하여 스크롤바를 추가합니다.
          child: ListView( // ListView로 감싸서 스크롤 가능한 목록을 생성합니다.
            children: [
              Image.asset(
                'assets/images/guidepage1.png',
                width: double.infinity,
              ),
                // Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.all(20),
                //   child: Text("교차로 주변에는 횡단을 종료하지 못한 보행자, 무단횡단 보행자 등이 있을 수 있어 주의하며 운행해야 합니다.", 
                //   style: TextStyle(color: Colors.white, fontSize: 20),
                //   ),
                // ),
                Image.asset(
                'assets/images/guidepage3.png',
                width: double.infinity,
              ),
              Image.asset(
                'assets/images/guidepage2.png',
                width: double.infinity,
              ),

              SizedBox(height: 100,),
            
            ],
          ),
        ),
      ),
    );
  }
}
