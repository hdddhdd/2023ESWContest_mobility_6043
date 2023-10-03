import "package:flutter/material.dart";
import "package:whycarno/service/databaseSvc.dart";
import "package:whycarno/model/Whycarno.dart";

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<Whycarno> medium=[];
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
        title: Text("알림"),
      ),
      body: Center(
        child: Text("알림 페이지"),
      ),
    );
  }
}