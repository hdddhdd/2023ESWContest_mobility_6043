// import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import '../model/Whycarno.dart';

class DatabaseSvc {
// FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref();


  void deleteDB(){
     final whycarnoKeyRef = FirebaseDatabase.instance
        .ref()
        .child("mydata/2023-10-02/20:12:20"); //모든 정보를 지우고 싶으면 경로를 수정하면 될 것

        whycarnoKeyRef.remove();
  }
  void updateDB() {
    final whycarnoData = {
      'video_Url': "newVideoUrlValue",
    };

    final whycarnoKeyRef = FirebaseDatabase.instance
        .ref()
        .child("mydata/2023-10-02/20:12:20");

    whycarnoKeyRef.update(whycarnoData).then((_) {
      // Data saved successfully!
      print("데이터 업데이트 완료");
    }).catchError((error) {
      // The write failed...
      print("데이터 업데이트 실패");
    });
    ;
  }

  Future<void> writeDB() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("mydata/2023-10-10/19:20:10");

    await ref.set({
      "video_Url": "https://www.youtube.com/watch?v=eJp-A2OBWnw",
      "date_time": "2023-10-10_19:20:10",
      
    }).then((_) {
      // Data saved successfully!
      print("데이터 쓰기 완료");
    }).catchError((error) {
      // The write failed...
      print("데이터 쓰기 실패");
    });
    ;
    ;
  }

  void readDB() {
    DatabaseReference starCountRef = FirebaseDatabase.instance
        .ref('mydata/2023-10-02/'); // 수정된 경로 사용
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>; // list
      if (data.isEmpty) {
        print('no data');
        return;
      }

      final whycarno_data = <Whycarno>[];
      for (final key in data.keys) {
        final value = data[key]; //datum1반환
        final whycarno_singledata = Whycarno.fromMap(value);
        whycarno_data.add(whycarno_singledata);
      }

      print("our data $whycarno_data");
      
      // medium 리스트를 사용하거나 처리할 작업을 추가할 수 있습니다.
    });
  }
}
