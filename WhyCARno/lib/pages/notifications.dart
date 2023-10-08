import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:whycarno/service/databaseSvc.dart";
import "package:whycarno/model/Whycarno.dart";

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  //firebase 데이터 부분 코드 추가 1
  Query dbref = FirebaseDatabase.instance.ref().child('mydata/2023-10-02/');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('mydata/');
  List<Whycarno> medium = [];

  ////


 
  void initState(){
    super.initState();
    testDB();
  }

  void testDB(){
    DatabaseSvc().readDB();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: Text("알림", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,

      ),
      body: Center(
        child: Text("알림 페이지"),
      ),
    );
  }
}