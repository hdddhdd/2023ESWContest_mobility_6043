import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'YOUR_VIDEO_URL_HERE'); // Replace with your video URL
    _controller.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var now = DateTime.now();

  // Placeholder data for date, time, location, and weather
  late double latitude2 = 0.0;
  late double longitude2 = 0.0;

  Future<void> getMyCurrentLocation() async {
    // 위치권한을 가지고 있는지 확인
    var status_position = await Permission.location.status;

    // if (status_position.isGranted) {
    //   // 1-2. 권한이 있는 경우 위치정보를 받아와서 변수에 저장합니다.
    //   Position position = await Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.high);

    //   latitude2 = position.latitude;
    //   longitude2 = position.longitude;
    //   print("$latitude2 $longitude2");
    // } else {
    //   // 1-3. 권한이 없는 경우
    //   print("위치 권한이 필요합니다.");
    //   // latitude2=1000.0; //for test
    // }
  } // ...getMyCurrentLocation()

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
              TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                return Text(
                  '${DateFormat('h:mm:s a').format(DateTime.now())}',
                );
              }),
              Image.asset(
                'assets/images/carsample.png',
                width: 700,
                height: 300,
                // fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  // Handle the first button press
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      const Size(350, 70)), // Set the desired size
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.all(10)), // Set padding
                ),
                child: const Text(
                  "실시간 영상 확인하기",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(1, 45, 107, 1)),
                ),
              ),
              const SizedBox(height: 16),
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
              Text("$longitude2 $latitude2"),
            ],
          ),
        ),
      ),
    );
  }
}
