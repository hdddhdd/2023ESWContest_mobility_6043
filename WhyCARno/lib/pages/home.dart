import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whycarno/model/Whycarno.dart';
import 'package:whycarno/pages/rightguide.dart';
import 'package:whycarno/service/databaseSvc.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _FetchDataState();
}

class _FetchDataState extends State<Home> {

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
              
                Image.asset('assets/images/carsample.png',
                width: 700,
                height: 300,
                //  fit: BoxFit.cover, // 이미지를 화면에 맞게 크기 조절
                ),
                // SizedBox(height: 20,),

                OutlinedButton(
                  onPressed: () {
                    // Handle the first button press
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        Size(350, 70)), // Set the desired size
                    padding: MaterialStateProperty.all(
                        EdgeInsets.all(10)), // Set padding
                  ),
                  child: const Text(
                    "실시간 영상 확인하기",
                    style: TextStyle(
                        fontSize: 18, color: Color.fromRGBO(1, 45, 107, 1)),
                  ),
                ),
                const SizedBox(height: 16), // Add some spacing between the buttons
                OutlinedButton(
                  onPressed: () {
                    // Handle the second button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Rightguide()), 
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(
                        Size(350, 70)), // Set the desired size
                    padding: MaterialStateProperty.all(
                        EdgeInsets.all(10)), // Set padding
                  ),
                  child: const Text("올바른 우회전 방법 알아보기",
                      style: TextStyle(
                          fontSize: 18, color: Color.fromRGBO(1, 45, 107, 1))),
                ),
              ],
            ),
          ),
        ));
  }
}
