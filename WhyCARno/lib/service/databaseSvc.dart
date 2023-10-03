// import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import '../model/Media_whycarno.dart';

class DatabaseSvc {
// FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref();
  Future<void> writeDB() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data/2023-10-02_19:12:19/");

    await ref.set({
      "longitude": "101",
      "latitude": "90",
      "video_Url": "이건 비디오 url 나중에 추가",
      "video_runtime": "10.01",
      "date_time": "2023-10-02_19:12:19",
    });
  }
  void readDB() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data/2023-10-02_19:12:19/');
    starCountRef.onValue.listen((DatabaseEvent event) { //list
      final data = event.snapshot.value as Map<dynamic, dynamic>; //읽어온 데이터 스냅샷
      if (data.isEmpty){
        print('no data');
        return;
      }
      final medium = <Media_whycarno>[];
      for (final key in data.keys){
        final mediavalue = data[key];
        final media = Media_whycarno.fromMap(mediavalue);
      }
      //updateStarCount(data);
    });
  }
}
